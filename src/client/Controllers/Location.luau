--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local City = require(Shared:WaitForChild("Data"):WaitForChild("City"))
local Config = require(Shared:WaitForChild("Config"))

local POLL_SECONDS = 0.25
local FADE_IN_SECONDS = 0.2
local FADE_OUT_SECONDS = 0.3

type Zone = {
	Name: string,
	Center: Vector2,
	Radius: number?,
	HalfSize: Vector2?,
	Rotation: number,
	Area: number,
}

local Location = {
	Name = "Location",
}

local function ringPosition(angleDeg: number, radius: number): Vector2
	local angle = math.rad(angleDeg)
	return Vector2.new(math.cos(angle) * radius, math.sin(angle) * radius)
end

local function buildZones(): {Zone}
	local zones: {Zone} = {}
	for _, district in City.Districts do
		local radius = Config.DistrictPadRadius
		table.insert(zones, {
			Name = district.Name,
			Center = ringPosition(district.AngleDeg, Config.DistrictRadius),
			Radius = radius,
			Rotation = 0,
			Area = radius * radius,
		})
	end

	for _, place in City.Places do
		local radius = place.Radius
		table.insert(zones, {
			Name = place.Name,
			Center = place.Position,
			Radius = radius,
			Rotation = 0,
			Area = radius * radius,
		})
	end

	local plazaRadius = City.Plaza.Radius
	table.insert(zones, {
		Name = "Plaza",
		Center = City.Plaza.Position,
		Radius = plazaRadius,
		Rotation = 0,
		Area = plazaRadius * plazaRadius,
	})

	for _, yard in City.Yards do
		local halfExtent = yard.HalfExtent
		table.insert(zones, {
			Name = yard.Name,
			Center = ringPosition(yard.AngleDeg, yard.RadiusScale * Config.DistrictRadius),
			HalfSize = Vector2.new(halfExtent, halfExtent),
			Rotation = math.rad(90 - yard.AngleDeg),
			Area = halfExtent * halfExtent * 4,
		})
	end

	table.sort(zones, function(a, b)
		return a.Area < b.Area
	end)
	return zones
end

local function contains(zone: Zone, position: Vector2): boolean
	local delta = position - zone.Center
	if zone.Radius ~= nil then
		return delta.Magnitude <= zone.Radius
	end
	if zone.HalfSize == nil then
		return false
	end

	local cosine = math.cos(zone.Rotation)
	local sine = math.sin(zone.Rotation)
	local localX = cosine * delta.X - sine * delta.Y
	local localZ = sine * delta.X + cosine * delta.Y
	return math.abs(localX) <= zone.HalfSize.X and math.abs(localZ) <= zone.HalfSize.Y
end

local function findZone(zones: {Zone}, position: Vector2): string?
	for _, zone in zones do
		if contains(zone, position) then
			return zone.Name
		end
	end
	return nil
end

local function createToast(playerGui: PlayerGui): TextLabel
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FTM_LocationGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 10
	screenGui.Parent = playerGui

	local label = Instance.new("TextLabel")
	label.Name = "LocationToast"
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 0, 28)
	label.Size = UDim2.fromOffset(420, 54)
	label.BackgroundColor3 = Color3.fromRGB(29, 33, 32)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.TextTransparency = 1
	label.Visible = false
	label.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = label
	return label
end

local function fade(label: TextLabel, transparency: number, duration: number): Tween
	local tween = TweenService:Create(
		label,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			BackgroundTransparency = transparency,
			TextTransparency = transparency,
		}
	)
	tween:Play()
	return tween
end

function Location.Start()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui
	local label = createToast(playerGui)
	local zones = buildZones()
	local currentZone: string? = nil
	local revision = 0
	local activeTween: Tween? = nil

	local function transition(zoneName: string?)
		if currentZone == zoneName then
			return
		end
		currentZone = zoneName
		revision += 1
		local token = revision
		if activeTween ~= nil then
			activeTween:Cancel()
			activeTween = nil
		end

		if zoneName == nil then
			if label.Visible then
				activeTween = fade(label, 1, FADE_OUT_SECONDS)
				task.delay(FADE_OUT_SECONDS, function()
					if revision == token then
						label.Visible = false
						activeTween = nil
					end
				end)
			end
			return
		end

		label.Text = zoneName
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.Visible = true
		activeTween = fade(label, 0.15, FADE_IN_SECONDS)
		task.delay(Config.LocationToastSeconds, function()
			if revision ~= token then
				return
			end
			activeTween = fade(label, 1, FADE_OUT_SECONDS)
			task.delay(FADE_OUT_SECONDS, function()
				if revision == token then
					label.Visible = false
					activeTween = nil
				end
			end)
		end)
	end

	task.spawn(function()
		while true do
			local character = player.Character
			local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
			if root ~= nil and root:IsA("BasePart") then
				transition(findZone(zones, Vector2.new(root.Position.X, root.Position.Z)))
			else
				transition(nil)
			end
			task.wait(POLL_SECONDS)
		end
	end)
end

return Location

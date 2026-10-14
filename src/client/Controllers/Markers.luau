--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Net = require(Shared.Net)
local Theme = require(script.Parent.Parent.UI.Theme)

local Markers = {Name = "Markers"}
local playerMarkers: PlayerGui? = nil
local active: {[string]: BillboardGui} = {}

local function residentsFolder(): Instance?
	local city = workspace:FindFirstChild("FTM_City")
	return if city ~= nil then city:FindFirstChild("Residents") else nil
end

local function findResident(key: string): Model?
	local folder = residentsFolder()
	if folder == nil then
		return nil
	end
	for _, child in folder:GetChildren() do
		if child:IsA("Model") and (child.Name == key or child:GetAttribute("FTMKey") == "Person." .. key) then
			return child
		end
	end
	return nil
end

local function removeMarker(key: string)
	local marker = active[key]
	if marker ~= nil then
		marker:Destroy()
		active[key] = nil
	end
end

local function addMarker(key: string)
	if active[key] ~= nil or playerMarkers == nil then
		return
	end
	local model = findResident(key)
	local adornee = if model ~= nil then model:FindFirstChild("Head") or model.PrimaryPart else nil
	if adornee == nil or not adornee:IsA("BasePart") then
		return
	end
	local gui = Instance.new("BillboardGui")
	gui.Name = "FTM_Marker_" .. key
	gui.Size = UDim2.fromScale(1.8, 1.8)
	gui.StudsOffset = Vector3.new(0, 1.2, 0)
	gui.MaxDistance = Config.MarkerMaxDistance
	gui.AlwaysOnTop = true
	gui.Adornee = adornee
	gui.Parent = playerMarkers
	local label = Instance.new("TextLabel")
	label.Name = "Marker"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Theme.BoldFont
	label.Text = "!"
	label.TextColor3 = Theme.Colors.Accent
	label.TextScaled = true
	label.TextStrokeColor3 = Theme.Colors.Panel
	label.TextStrokeTransparency = 0.1
	label.Parent = gui
	active[key] = gui
end

local function applyKeys(keys: any)
	if type(keys) ~= "table" then
		return
	end
	local wanted: {[string]: boolean} = {}
	for _, key in keys do
		if type(key) == "string" then
			wanted[key] = true
			addMarker(key)
		end
	end
	for key in active do
		if not wanted[key] then
			removeMarker(key)
		end
	end
end

function Markers.Start()
	local player = Players.LocalPlayer
	if player == nil then
		return
	end
	playerMarkers = player:WaitForChild("PlayerGui") :: PlayerGui
	Net.onEvent("ResidentMarkers", function(payload: any)
		if type(payload) == "table" then
			applyKeys(payload.residentKeys)
		end
	end)
	local hint = Instance.new("TextLabel")
	hint.Name = "FTM_FirstJoinHint"
	hint.AnchorPoint = Vector2.new(0.5, 0)
	hint.Position = UDim2.new(0.5, 0, 0, 92)
	hint.Size = UDim2.new(0.8, 0, 0, 38)
	hint.BackgroundColor3 = Theme.Colors.Panel
	hint.BackgroundTransparency = 1
	hint.BorderSizePixel = 0
	hint.Font = Theme.Font
	hint.TextColor3 = Theme.Colors.Text
	hint.TextSize = 16
	hint.TextTransparency = 1
	hint.Visible = false
	hint.Parent = playerMarkers
	local hintCorner = Instance.new("UICorner")
	hintCorner.CornerRadius = UDim.new(0, 6)
	hintCorner.Parent = hint
	local hintToken = 0
	Net.onEvent("Hint", function(payload: any)
		if type(payload) ~= "table" or type(payload.text) ~= "string" then
			return
		end
		hintToken += 1
		local token = hintToken
		hint.Text = payload.text
		hint.Visible = true
		TweenService:Create(hint, TweenInfo.new(0.25), {BackgroundTransparency = 0.1, TextTransparency = 0}):Play()
		task.delay(8, function()
			if token == hintToken then
				local tween = TweenService:Create(hint, TweenInfo.new(0.45), {BackgroundTransparency = 1, TextTransparency = 1})
				tween:Play()
				tween.Completed:Wait()
				if token == hintToken then
					hint.Visible = false
				end
			end
		end)
	end)
	local ok, state = pcall(function()
		return Net.invoke("GetInitialState")
	end)
	if ok and type(state) == "table" then
		applyKeys(state.markers)
	end
end

return Markers

--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local City = require(Shared.Data.City)
local Log = require(Shared.Log)
local VisualRegistry = require(Shared.Registry.VisualRegistry)
local Roster = require(script.Parent.Parent.Data.Residents)

local Residents = {Name = "Residents"}

local function districtCenter(district: any): Vector2
	local angle = math.rad(district.AngleDeg)
	return Vector2.new(math.cos(angle) * Config.DistrictRadius, math.sin(angle) * Config.DistrictRadius)
end

local function anchorPosition(entry: any, district: any, center: Vector2): Vector2
	local anchor: Vector2? = nil
	if entry.Anchor == "DistrictCenter" then
		anchor = center
	elseif entry.Anchor == "NoticeBoard" then
		anchor = center + district.NoticeBoard.Offset
	else
		for _, landmark in district.Landmarks do
			if landmark.Label == entry.Anchor then
				anchor = center + landmark.Offset
				break
			end
		end
	end
	local base = anchor or center
	return base + Vector2.new(entry.Dx, entry.Dz)
end

local function avoidLandmarks(position: Vector2, district: any, center: Vector2, residentKey: string): Vector2
	local adjusted = position
	for _, landmark in district.Landmarks do
		local landmarkCenter = center + landmark.Offset
		local halfX = landmark.Size.X / 2 + 2
		local halfZ = landmark.Size.Z / 2 + 2
		local dx = adjusted.X - landmarkCenter.X
		local dz = adjusted.Y - landmarkCenter.Y
		if math.abs(dx) < halfX and math.abs(dz) < halfZ then
			if halfX - math.abs(dx) < halfZ - math.abs(dz) then
				adjusted = Vector2.new(landmarkCenter.X + (if dx < 0 then -1 else 1) * (halfX + 2), adjusted.Y)
			else
				adjusted = Vector2.new(adjusted.X, landmarkCenter.Y + (if dz < 0 then -1 else 1) * (halfZ + 2))
			end
			Log.info("Residents", string.format("nudged %s clear of %s", residentKey, landmark.Label))
		end
	end
	return adjusted
end

local function findDistrict(key: string): any?
	for _, district in City.Districts do
		if district.Key == key then
			return district
		end
	end
	return nil
end

local function buildResidents(root: Instance)
	local folder = root:FindFirstChild("Residents")
	if folder ~= nil then
		folder:Destroy()
	end
	folder = Instance.new("Folder")
	folder.Name = "Residents"
	folder.Parent = root
	local count = 0
	for _, resident in Roster do
		local district = findDistrict(resident.DistrictKey)
		if district == nil then
			Log.warn("Residents", string.format("Skipped %s: district '%s' is missing", resident.Key, resident.DistrictKey))
			continue
		end
		local ok, err = pcall(function()
			local center = districtCenter(district)
			local position = avoidLandmarks(anchorPosition(resident, district, center), district, center, resident.Key)
			local model = VisualRegistry.build("Person." .. resident.Key, {
				name = resident.Key,
				label = resident.Name,
				role = resident.Role,
				color = district.Color,
			})
			local groundPosition = Vector3.new(position.X, 3, position.Y)
			local lookAt = Vector3.new(center.X, 3, center.Y)
			model:PivotTo(CFrame.lookAt(groundPosition, lookAt))
			model:SetAttribute("FTMDistrict", resident.DistrictKey)
			model.Parent = folder
			local rootPart = model.PrimaryPart
			if rootPart == nil then
				error("person model has no PrimaryPart")
			end
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = "TalkPrompt"
			prompt.ActionText = "Talk"
			prompt.ObjectText = resident.Name
			prompt.KeyboardKeyCode = Enum.KeyCode.E
			prompt.HoldDuration = 0
			prompt.MaxActivationDistance = Config.TalkDistance
			prompt.Parent = rootPart
			count += 1
		end)
		if not ok then
			Log.warn("Residents", string.format("Could not spawn %s: %s", resident.Key, tostring(err)))
		end
	end
	Log.info("Residents", string.format("spawned %d residents", count))
end

function Residents.Start()
	local root = workspace:WaitForChild("FTM_City", 30)
	if root == nil then
		Log.warn("Residents", "Timed out waiting for FTM_City")
		return
	end
	local deadline = os.clock() + 30
	while root:GetAttribute("Ready") ~= true and os.clock() < deadline do
		task.wait(0.1)
	end
	if root:GetAttribute("Ready") ~= true then
		Log.warn("Residents", "Timed out waiting for FTM_City.Ready")
		return
	end
	buildResidents(root)
end

return Residents

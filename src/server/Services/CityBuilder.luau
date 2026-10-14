--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local City = require(Shared:WaitForChild("Data"):WaitForChild("City"))
local Log = require(Shared:WaitForChild("Log"))
local VisualRegistry = require(Shared:WaitForChild("Registry"):WaitForChild("VisualRegistry"))

local CityBuilder = {
	Name = "CityBuilder",
}

local GROUND_THICKNESS = 1
local PATH_THICKNESS = 0.2
local DISTRICT_PAD_THICKNESS = 0.2
local PLAZA_PAD_THICKNESS = 0.2
local YARD_FENCE_THICKNESS = 0.6

local function worldPosition(position: Vector2, y: number?): Vector3
	return Vector3.new(position.X, y or 0, position.Y)
end

local function pointOnRing(angleDeg: number, radius: number): Vector2
	local angle = math.rad(angleDeg)
	return Vector2.new(math.cos(angle) * radius, math.sin(angle) * radius)
end

local function makeFolder(parent: Instance, name: string): Folder
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function makePart(parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, shape: Enum.PartType?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	if shape ~= nil then
		part.Shape = shape
	end
	part.Parent = parent
	return part
end

local function makeDisc(parent: Instance, name: string, position: Vector2, radius: number, color: Color3, thickness: number)
	makePart(
		parent,
		name,
		Vector3.new(thickness, radius * 2, radius * 2),
		CFrame.new(position.X, -thickness / 2, position.Y) * CFrame.Angles(0, 0, math.pi / 2),
		color,
		Enum.PartType.Cylinder
	)
end

local function runEntry(label: string, callback: () -> ())
	local ok, err = pcall(callback)
	if not ok then
		Log.warn("CityBuilder", string.format("Could not build %s: %s", label, tostring(err)))
	end
end

local function buildVisual(
	key: string,
	params: {[string]: any},
	parent: Instance,
	target: CFrame,
	attributes: {[string]: string}?
): Model?
	local ok, result = pcall(function()
		local model = VisualRegistry.build(key, params)
		model:PivotTo(target)
		if attributes ~= nil then
			for name, value in attributes do
				model:SetAttribute(name, value)
			end
		end
		model.Parent = parent
		return model
	end)
	if not ok then
		Log.warn("CityBuilder", string.format("Could not build visual '%s': %s", key, tostring(result)))
		return nil
	end
	if typeof(result) ~= "Instance" or not result:IsA("Model") then
		Log.warn("CityBuilder", string.format("Visual '%s' did not produce a Model", key))
		return nil
	end
	return result
end

local function spawnProp(spec: any, parent: Instance, base: CFrame, attributes: {[string]: string}?): Model?
	if type(spec.Key) ~= "string" or typeof(spec.Offset) ~= "Vector2" or typeof(spec.Size) ~= "Vector3" then
		Log.warn("CityBuilder", "Skipped a prop with incomplete key, offset, or size data")
		return nil
	end
	local offset = spec.Offset :: Vector2
	local rotation = math.rad(spec.Rotation or 0)
	local target = base * CFrame.new(offset.X, 0, offset.Y) * CFrame.Angles(0, rotation, 0)
	local model = buildVisual(spec.Key, {
		label = spec.Label or spec.Key,
		size = spec.Size,
		color = spec.Color,
	}, parent, target, attributes)
	return model
end

local function placeFrame(position: Vector2, rotationDeg: number): CFrame
	return CFrame.new(position.X, 0, position.Y) * CFrame.Angles(0, math.rad(rotationDeg), 0)
end

local function buildGround(groundFolder: Instance)
	makePart(
		groundFolder,
		"FTM_Ground",
		Vector3.new(City.Ground.Size, GROUND_THICKNESS, City.Ground.Size),
		CFrame.new(0, -GROUND_THICKNESS / 2, 0),
		City.Ground.Color
	)
	makeDisc(groundFolder, "PlazaPad", City.Plaza.Position, City.Plaza.Radius, City.Plaza.Color, PLAZA_PAD_THICKNESS)

	for _, district in City.Districts do
		runEntry("district pad " .. tostring(district.Key), function()
			local center = pointOnRing(district.AngleDeg, Config.DistrictRadius)
			makeDisc(groundFolder, district.Key .. "Pad", center, Config.DistrictPadRadius, district.Color, DISTRICT_PAD_THICKNESS)
		end)
	end

end

local function districtCenter(key: string): Vector2?
	for _, district in City.Districts do
		if district.Key == key then
			return pointOnRing(district.AngleDeg, Config.DistrictRadius)
		end
	end
	return nil
end

local function getPathEnd(path: any): Vector2?
	if path.TargetKind == "DistrictEdge" then
		local district = districtCenter(path.TargetKey)
		if district == nil then
			return nil
		end
		local towardHall = -district.Unit
		return district + towardHall * Config.DistrictPadRadius
	elseif path.TargetKind == "Plaza" then
		local direction = -City.Plaza.Position.Unit
		return City.Plaza.Position + direction * City.Plaza.Radius
	elseif path.TargetKind == "Place" then
		for _, place in City.Places do
			if place.Key == path.TargetKey then
				local frame = placeFrame(place.Position, place.Rotation)
				local localFront = if place.DoorSide == "Back" then Vector3.new(0, 0, 1)
					elseif place.DoorSide == "Left" then Vector3.new(-1, 0, 0)
					elseif place.DoorSide == "Right" then Vector3.new(1, 0, 0)
					else Vector3.new(0, 0, -1)
				local front = frame:VectorToWorldSpace(localFront)
				local depth = if place.DoorSide == "Left" or place.DoorSide == "Right" then place.Size.X / 2 else place.Size.Z / 2
				return place.Position + Vector2.new(front.X, front.Z) * (depth + Config.PathWidth / 2 + 0.5)
			end
		end
	end
	return nil
end

local function buildPaths(pathsFolder: Instance)
	local hallHalfX = City.Places[1].Size.X / 2
	local hallHalfZ = City.Places[1].Size.Z / 2
	for _, path in City.Paths do
		runEntry("path " .. tostring(path.Key), function()
			local finish = getPathEnd(path)
			if finish == nil then
				error("target could not be resolved")
			end
			local direction = finish.Unit
			local absX = math.abs(direction.X)
			local absZ = math.abs(direction.Y)
			local halfWidth = Config.PathWidth / 2
			local xDistance = if absX > 0 then (hallHalfX + halfWidth) / absX else math.huge
			local zDistance = if absZ > 0 then (hallHalfZ + halfWidth) / absZ else math.huge
			local startDistance = math.min(xDistance, zDistance) + 0.5
			local start = direction * startDistance
			local delta = finish - start
			local length = delta.Magnitude
			if length <= 1 then
				error("path is too short")
			end
			local midpoint = (start + finish) / 2
			local yaw = math.atan2(delta.X, delta.Y)
			makePart(
				pathsFolder,
				path.Key,
				Vector3.new(Config.PathWidth, PATH_THICKNESS, length),
				CFrame.new(midpoint.X, PATH_THICKNESS / 2, midpoint.Y) * CFrame.Angles(0, yaw, 0),
				Color3.fromRGB(139, 139, 136)
			)
		end)
	end
end

local function buildDistricts(districtsFolder: Instance, counts: {[string]: number})
	for _, district in City.Districts do
		runEntry("district " .. tostring(district.Key), function()
			local folder = makeFolder(districtsFolder, district.Key)
			folder:SetAttribute("FTMDistrict", district.Key)
			counts.districts += 1
			local center = pointOnRing(district.AngleDeg, Config.DistrictRadius)
			local rotation = district.Gate.Rotation or (90 - district.AngleDeg)
			local base = placeFrame(center, 0)
			if spawnProp(district.Gate, folder, base, {FTMDistrict = district.Key}) then
				counts.props += 1
			end
			local noticeOffset = district.NoticeBoard.Offset :: Vector2
			local noticeTarget = base * CFrame.new(noticeOffset.X, 0, noticeOffset.Y) * CFrame.Angles(0, math.rad(rotation), 0)
			if spawnProp({
				Key = district.NoticeBoard.Key,
				Label = district.Name,
				Size = district.NoticeBoard.Size,
				Offset = Vector2.zero,
			}, folder, noticeTarget, {FTMDistrict = district.Key}) then
				counts.props += 1
			end
			for _, landmark in district.Landmarks do
				runEntry("landmark " .. tostring(landmark.Label), function()
					local target = base * CFrame.new(landmark.Offset.X, 0, landmark.Offset.Y) * CFrame.Angles(0, math.rad(landmark.Rotation or 0), 0)
					local attributes: {[string]: string} = {FTMDistrict = district.Key}
					if landmark.ProblemSite ~= nil then
						attributes.FTMProblemSite = landmark.ProblemSite
					end
					local model = buildVisual(landmark.Key, {
						label = landmark.Label,
						size = landmark.Size,
						color = landmark.Color or district.Color,
					}, folder, target, attributes)
					if model ~= nil and string.sub(landmark.Key, 1, 5) == "Prop." then
						counts.props += 1
					end
				end)
			end
		end)
	end
end

local function buildPlace(place: any, placesFolder: Instance, counts: {[string]: number})
	local folder = makeFolder(placesFolder, place.Key)
	folder:SetAttribute("FTMPlace", place.Key)
	counts.places += 1
	local base = placeFrame(place.Position, place.Rotation)
	local model = buildVisual("Building." .. place.Key, {
		label = place.Name,
		size = place.Size,
		bodyColor = place.Color,
		enterable = place.Enterable,
		doorSide = place.DoorSide,
	}, folder, base * CFrame.new(0, if place.Enterable then -0.1 else 0, 0), {FTMPlace = place.Key})
	if model == nil then
		return
	end
	for _, prop in place.Props do
		runEntry("place prop " .. tostring(prop.Label), function()
			if spawnProp(prop, model, base, {FTMPlace = place.Key}) then
				counts.props += 1
			end
		end)
	end
end

local function buildPlaza(placesFolder: Instance, counts: {[string]: number})
	local folder = makeFolder(placesFolder, "Plaza")
	folder:SetAttribute("FTMPlace", "Plaza")
	counts.places += 1
	local base = placeFrame(City.Plaza.Position, 0)
	for _, prop in City.Plaza.Props do
		runEntry("plaza prop " .. tostring(prop.Label), function()
			if spawnProp(prop, folder, base, {FTMPlace = "Plaza"}) then
				counts.props += 1
			end
		end)
	end
	local spawnPosition = City.Plaza.Position + City.Spawn.Offset
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = City.Spawn.Name
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = worldPosition(spawnPosition, 0.5)
	spawn.Anchored = true
	spawn.Transparency = 1
	spawn.CanCollide = false
	spawn.Neutral = true
	spawn.AllowTeamChangeOnTouch = false
	spawn.Duration = 0
	spawn:SetAttribute("FTMPlace", "Plaza")
	spawn.Parent = folder
end

local function buildYards(placesFolder: Instance, counts: {[string]: number})
	for _, yard in City.Yards do
		runEntry("yard " .. tostring(yard.Key), function()
			local folder = makeFolder(placesFolder, yard.Key)
			folder:SetAttribute("FTMPlace", yard.Key)
			counts.places += 1
			local center = pointOnRing(yard.AngleDeg, yard.RadiusScale * Config.DistrictRadius)
			local yaw = 90 - yard.AngleDeg
			local base = placeFrame(center, yaw)
			local half = yard.HalfExtent
			local height = yard.FenceHeight
			local fenceColor = Color3.fromRGB(111, 102, 84)
			for _, side in {"Front", "Back", "Left", "Right"} do
				local fenceSize = if side == "Front" or side == "Back"
					then Vector3.new(half * 2, height, YARD_FENCE_THICKNESS)
					else Vector3.new(YARD_FENCE_THICKNESS, height, half * 2)
				local offset = if side == "Front" then Vector3.new(0, height / 2, -half)
					elseif side == "Back" then Vector3.new(0, height / 2, half)
					elseif side == "Left" then Vector3.new(-half, height / 2, 0)
					else Vector3.new(half, height / 2, 0)
				makePart(folder, side .. "Fence", fenceSize, base * CFrame.new(offset), fenceColor)
			end
			local officePosition = yard.OfficeOffset :: Vector2
			local officeFrame = base * CFrame.new(officePosition.X, 0, officePosition.Y)
			local office = buildVisual("Building.YardOffice", {
				label = "Yard Office",
				size = yard.OfficeSize,
				bodyColor = yard.OfficeColor,
				doorSide = "Front",
			}, folder, officeFrame, {FTMPlace = yard.Key})
			local sign = spawnProp(yard.EntranceSign, folder, base, {FTMPlace = yard.Key})
			if sign ~= nil then
				counts.props += 1
			end
			for _, prop in yard.Props do
				if spawnProp(prop, folder, base, {FTMPlace = yard.Key}) then
					counts.props += 1
				end
			end
			if office == nil then
				Log.warn("CityBuilder", string.format("Yard '%s' was missing its office model", yard.Key))
			end
		end)
	end
end

local function hideDefaultBaseplate()
	for _, descendant in workspace:GetDescendants() do
		if descendant.Name == "Baseplate" and descendant:IsA("BasePart") then
			descendant.Transparency = 1
			descendant.CanCollide = false
			descendant.CanQuery = false
		end
	end
end

function CityBuilder.Start()
	local existing = workspace:FindFirstChild("FTM_City")
	if existing ~= nil then
		existing:Destroy()
	end

	hideDefaultBaseplate()
	local root = makeFolder(workspace, "FTM_City")
	local groundFolder = makeFolder(root, "Ground")
	local pathsFolder = makeFolder(root, "Paths")
	local districtsFolder = makeFolder(root, "Districts")
	local placesFolder = makeFolder(root, "Places")
	local counts = {districts = 0, places = 0, props = 0}

	runEntry("ground", function()
		buildGround(groundFolder)
	end)
	runEntry("paths", function()
		buildPaths(pathsFolder)
	end)
	buildDistricts(districtsFolder, counts)
	for _, place in City.Places do
		runEntry("place " .. tostring(place.Key), function()
			buildPlace(place, placesFolder, counts)
		end)
	end
	buildPlaza(placesFolder, counts)
	buildYards(placesFolder, counts)
	Log.info("CityBuilder", string.format("built %d districts, %d places, %d props", counts.districts, counts.places, counts.props))
end

return CityBuilder

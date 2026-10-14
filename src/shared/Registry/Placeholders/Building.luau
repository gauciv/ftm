--!strict

local Sign = require(script.Parent.Sign)

local Building = {}

local DEFAULT_SIZE = Vector3.new(32, 18, 28)
local DEFAULT_BODY_COLOR = Color3.fromRGB(190, 190, 190)
local DEFAULT_ROOF_COLOR = Color3.fromRGB(92, 68, 88)
local WALL_COLOR = Color3.fromRGB(190, 190, 190)
local WALL_THICKNESS = 1
local DOOR_WIDTH = 6
local DOOR_HEIGHT = 9

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3, canCollide: boolean?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Anchored = true
	part.CanCollide = canCollide ~= false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function makeModel(key: string, label: string): Model
	local model = Instance.new("Model")
	model.Name = key:gsub("%.", "_")
	model:SetAttribute("FTMKey", key)
	model:SetAttribute("FTMLabel", label)
	local pivot = makePart(model, "Pivot", Vector3.new(0.2, 0.2, 0.2), Vector3.zero, Color3.new(1, 1, 1), false)
	pivot.Transparency = 1
	model.PrimaryPart = pivot
	return model
end

local function getSide(side: string, size: Vector3): (Vector3, number, number)
	if side == "Back" then
		return Vector3.new(0, 0, size.Z / 2), math.pi, size.X
	elseif side == "Left" then
		return Vector3.new(-size.X / 2, 0, 0), math.pi / 2, size.Z
	elseif side == "Right" then
		return Vector3.new(size.X / 2, 0, 0), -math.pi / 2, size.Z
	end
	return Vector3.new(0, 0, -size.Z / 2), 0, size.X
end

local function addSign(model: Model, label: string, size: Vector3, doorSide: string)
	local wallOffset, yaw, wallLength = getSide(doorSide, size)
	local signWidth = math.min(wallLength * 0.72, 24)
	local signPosition = Vector3.new(wallOffset.X, DOOR_HEIGHT + 0.35 + 1.25, wallOffset.Z)
	local outward = if doorSide == "Back" then 1 elseif doorSide == "Left" then -1 elseif doorSide == "Right" then 1 else -1
	if doorSide == "Left" or doorSide == "Right" then
		signPosition += Vector3.new(outward * 0.18, 0, 0)
	else
		signPosition += Vector3.new(0, 0, outward * 0.18)
	end
	Sign.create(
		model,
		label,
		Vector3.new(signWidth, 2.5, 0.25),
		CFrame.new(signPosition) * CFrame.Angles(0, yaw, 0)
	)
end

local function buildSolid(model: Model, label: string, size: Vector3, bodyColor: Color3, roofColor: Color3, doorSide: string)
	makePart(model, "Body", size, Vector3.new(0, size.Y / 2, 0), bodyColor)
	makePart(model, "Roof", Vector3.new(size.X + 2, 1, size.Z + 2), Vector3.new(0, size.Y + 0.5, 0), roofColor)
	local wallOffset, yaw, _wallLength = getSide(doorSide, size)
	local doorSize = if doorSide == "Left" or doorSide == "Right" then Vector3.new(0.5, DOOR_HEIGHT, DOOR_WIDTH) else Vector3.new(DOOR_WIDTH, DOOR_HEIGHT, 0.5)
	local doorPosition = wallOffset + Vector3.new(0, DOOR_HEIGHT / 2, 0)
	local outward = if doorSide == "Back" or doorSide == "Right" then 0.3 else -0.3
	if doorSide == "Left" or doorSide == "Right" then
		doorPosition += Vector3.new(outward, 0, 0)
	else
		doorPosition += Vector3.new(0, 0, outward)
	end
	local door = makePart(model, "Door", doorSize, doorPosition, Color3.fromRGB(76, 54, 42))
	door.CFrame = CFrame.new(doorPosition) * CFrame.Angles(0, yaw, 0)
	addSign(model, label, size, doorSide)
end

local function addFullWall(model: Model, side: string, size: Vector3, wallHeight: number, centerY: number)
	if side == "Front" then
		makePart(model, side .. "Wall", Vector3.new(size.X, wallHeight, WALL_THICKNESS), Vector3.new(0, centerY, -size.Z / 2 + WALL_THICKNESS / 2), WALL_COLOR)
	elseif side == "Back" then
		makePart(model, side .. "Wall", Vector3.new(size.X, wallHeight, WALL_THICKNESS), Vector3.new(0, centerY, size.Z / 2 - WALL_THICKNESS / 2), WALL_COLOR)
	elseif side == "Left" then
		makePart(model, side .. "Wall", Vector3.new(WALL_THICKNESS, wallHeight, size.Z), Vector3.new(-size.X / 2 + WALL_THICKNESS / 2, centerY, 0), WALL_COLOR)
	else
		makePart(model, side .. "Wall", Vector3.new(WALL_THICKNESS, wallHeight, size.Z), Vector3.new(size.X / 2 - WALL_THICKNESS / 2, centerY, 0), WALL_COLOR)
	end
end

local function addDoorWall(model: Model, side: string, size: Vector3, wallHeight: number, centerY: number)
	local isFrontBack = side == "Front" or side == "Back"
	local wallLength = if isFrontBack then size.X else size.Z
	local segmentLength = (wallLength - DOOR_WIDTH) / 2
	local edge = if side == "Front" then -size.Z / 2 + WALL_THICKNESS / 2 elseif side == "Back" then size.Z / 2 - WALL_THICKNESS / 2 elseif side == "Left" then -size.X / 2 + WALL_THICKNESS / 2 else size.X / 2 - WALL_THICKNESS / 2
	for _, sign in {-1, 1} do
		local along = sign * (DOOR_WIDTH / 2 + segmentLength / 2)
		local position = if isFrontBack then Vector3.new(along, centerY, edge) else Vector3.new(edge, centerY, along)
		local partSize = if isFrontBack then Vector3.new(segmentLength, wallHeight, WALL_THICKNESS) else Vector3.new(WALL_THICKNESS, wallHeight, segmentLength)
		makePart(model, side .. "WallSegment", partSize, position, WALL_COLOR)
	end

	local lintelHeight = wallHeight + 0.2 - DOOR_HEIGHT
	if lintelHeight > 0 then
		local lintelY = 0.1 + DOOR_HEIGHT + lintelHeight / 2
		local position = if isFrontBack then Vector3.new(0, lintelY, edge) else Vector3.new(edge, lintelY, 0)
		local partSize = if isFrontBack then Vector3.new(DOOR_WIDTH, lintelHeight, WALL_THICKNESS) else Vector3.new(WALL_THICKNESS, lintelHeight, DOOR_WIDTH)
		makePart(model, side .. "Lintel", partSize, position, WALL_COLOR)
	end
end

local function buildEnterable(model: Model, label: string, size: Vector3, bodyColor: Color3, roofColor: Color3, doorSide: string)
	local floor = makePart(model, "Floor", Vector3.new(size.X, 0.2, size.Z), Vector3.new(0, 0.1, 0), bodyColor)
	floor.Transparency = 0.15
	local wallHeight = size.Y - 0.2
	local centerY = 0.1 + wallHeight / 2
	for _, side in {"Front", "Back", "Left", "Right"} do
		if side == doorSide then
			addDoorWall(model, side, size, wallHeight, centerY)
		else
			addFullWall(model, side, size, wallHeight, centerY)
		end
	end
	makePart(model, "Roof", Vector3.new(size.X + 2, 1, size.Z + 2), Vector3.new(0, size.Y + 0.5, 0), roofColor)
	model.PrimaryPart = floor
	addSign(model, label, size, doorSide)
end

function Building.build(key: string, params: {[string]: any}?): Model
	local options = params or {}
	local size: Vector3 = options.size or DEFAULT_SIZE
	local bodyColor: Color3 = options.bodyColor or options.color or DEFAULT_BODY_COLOR
	local roofColor: Color3 = options.roofColor or DEFAULT_ROOF_COLOR
	local label: string = options.label or key
	local doorSide: string = options.doorSide or "Front"
	local enterable: boolean = options.enterable == true
	local model = makeModel(key, label)

	if enterable then
		buildEnterable(model, label, size, bodyColor, roofColor, doorSide)
	else
		buildSolid(model, label, size, bodyColor, roofColor, doorSide)
	end

	return model
end

return Building

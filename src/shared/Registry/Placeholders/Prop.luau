--!strict

local Sign = require(script.Parent.Sign)

local Prop = {}

local function makeModel(key: string, label: string): Model
	local model = Instance.new("Model")
	model.Name = key:gsub("%.", "_")
	model:SetAttribute("FTMKey", key)
	model:SetAttribute("FTMLabel", label)
	local pivot = Instance.new("Part")
	pivot.Name = "Pivot"
	pivot.Size = Vector3.new(0.2, 0.2, 0.2)
	pivot.Transparency = 1
	pivot.Anchored = true
	pivot.CanCollide = false
	pivot.CanTouch = false
	pivot.CanQuery = false
	pivot.Parent = model
	model.PrimaryPart = pivot
	return model
end

local function makePart(model: Model, name: string, size: Vector3, position: Vector3, color: Color3, canCollide: boolean?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Anchored = true
	part.CanCollide = canCollide ~= false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = model
	return part
end

local function addSign(model: Model, label: string, width: number, height: number, position: Vector3)
	Sign.create(model, label, Vector3.new(width, height, 0.25), CFrame.new(position))
end

local function buildBoard(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(6, 5, 0.5)
	local model = makeModel(key, label)
	local color: Color3 = options.color or Color3.fromRGB(115, 84, 55)
	makePart(model, "Board", size, Vector3.new(0, size.Y, 0), color)
	local postHeight = size.Y
	for _, x in {-size.X / 2 + 0.4, size.X / 2 - 0.4} do
		makePart(model, "Post", Vector3.new(0.5, postHeight, 0.5), Vector3.new(x, postHeight / 2, 0), Color3.fromRGB(83, 61, 42))
	end
	addSign(model, label, size.X * 0.8, math.min(2.5, size.Y * 0.55), Vector3.new(0, size.Y + 0.1, -size.Z / 2 - 0.16))
	return model
end

local function buildNoticeBoard(key: string, label: string, options: {[string]: any}): Model
	return buildBoard(key, label, options)
end

local function buildDistrictGate(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(16, 7, 1)
	local model = makeModel(key, label)
	local postColor = Color3.fromRGB(86, 76, 60)
	for _, x in {-size.X / 2, size.X / 2} do
		makePart(model, "GatePost", Vector3.new(1, size.Y, 1), Vector3.new(x, size.Y / 2, 0), postColor)
	end
	makePart(model, "GateBeam", Vector3.new(size.X, 1, 1), Vector3.new(0, size.Y - 0.5, 0), postColor)
	addSign(model, label, size.X - 2, 2.5, Vector3.new(0, size.Y - 2.5, -0.6))
	return model
end

local function buildPodium(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(6, 4, 4)
	local model = makeModel(key, label)
	local color: Color3 = options.color or Color3.fromRGB(120, 96, 71)
	makePart(model, "Base", Vector3.new(size.X, 0.6, size.Z), Vector3.new(0, 0.3, 0), color)
	makePart(model, "Column", Vector3.new(size.X * 0.65, size.Y - 1, size.Z * 0.65), Vector3.new(0, (size.Y - 1) / 2 + 0.6, 0), color)
	makePart(model, "Top", Vector3.new(size.X + 1, 0.6, size.Z + 1), Vector3.new(0, size.Y - 0.1, 0), color)
	addSign(model, label, size.X * 0.8, 1.5, Vector3.new(0, size.Y / 2, -size.Z / 2 - 0.2))
	return model
end

local function buildStall(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(16, 9, 12)
	local model = makeModel(key, label)
	local color: Color3 = options.color or Color3.fromRGB(190, 126, 66)
	local counterHeight = math.min(3, size.Y * 0.4)
	makePart(model, "Counter", Vector3.new(size.X, counterHeight, size.Z * 0.55), Vector3.new(0, counterHeight / 2, size.Z * 0.1), color)
	makePart(model, "Canopy", Vector3.new(size.X + 1, 0.6, size.Z + 1), Vector3.new(0, size.Y, 0), color:Lerp(Color3.new(1, 1, 1), 0.2))
	for _, x in {-size.X / 2 + 0.5, size.X / 2 - 0.5} do
		for _, z in {-size.Z / 2 + 0.5, size.Z / 2 - 0.5} do
			makePart(model, "CanopyPost", Vector3.new(0.5, size.Y, 0.5), Vector3.new(x, size.Y / 2, z), color)
		end
	end
	addSign(model, label, size.X * 0.65, 1.5, Vector3.new(0, size.Y - 1.2, -size.Z / 2 - 0.2))
	return model
end

local function buildDrainGrate(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(22, 1, 8)
	local model = makeModel(key, label)
	local gutterColor = Color3.fromRGB(69, 76, 76)
	makePart(model, "Gutter", Vector3.new(size.X, 0.45, size.Z), Vector3.new(0, 0.22, 0), Color3.fromRGB(80, 91, 91))
	for x = -size.X / 2 + 1, size.X / 2 - 1, 2 do
		makePart(model, "GrateBar", Vector3.new(0.35, 0.35, size.Z - 0.5), Vector3.new(x, 0.62, 0), gutterColor)
	end
	makePart(model, "DrainMarker", Vector3.new(1, 3, 1), Vector3.new(size.X / 2 + 1, 1.5, 0), Color3.fromRGB(91, 76, 56))
	addSign(model, label, 7, 2, Vector3.new(size.X / 2 + 1, 3.5, -0.6))
	return model
end

local function buildCrate(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(8, 8, 8)
	local model = makeModel(key, label)
	local color: Color3 = options.color or Color3.fromRGB(137, 103, 67)
	makePart(model, "Crate", size, Vector3.new(0, size.Y / 2, 0), color)
	for y = 1, math.max(1, math.floor(size.Y / 2)), 2 do
		makePart(model, "CrateSlat", Vector3.new(size.X + 0.05, 0.2, size.Z + 0.05), Vector3.new(0, y, 0), color:Lerp(Color3.new(0, 0, 0), 0.2))
	end
	addSign(model, label, math.min(size.X * 0.75, 5), 1.5, Vector3.new(0, size.Y + 1, -size.Z / 2 - 0.2))
	return model
end

local function buildFence(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(12, 4, 1)
	local model = makeModel(key, label)
	local color: Color3 = options.color or Color3.fromRGB(105, 91, 69)
	for _, x in {-size.X / 2 + 0.5, size.X / 2 - 0.5} do
		makePart(model, "FencePost", Vector3.new(1, size.Y, 1), Vector3.new(x, size.Y / 2, 0), color)
	end
	makePart(model, "FenceRail", Vector3.new(size.X, 0.6, 0.6), Vector3.new(0, size.Y * 0.65, 0), color)
	makePart(model, "FenceRail", Vector3.new(size.X, 0.6, 0.6), Vector3.new(0, size.Y * 0.3, 0), color)
	if label ~= "" then
		addSign(model, label, math.min(size.X * 0.7, 8), 1.5, Vector3.new(0, size.Y + 1, -0.6))
	end
	return model
end

local function buildFootbridge(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(36, 4, 12)
	local model = makeModel(key, label)
	local wood = options.color or Color3.fromRGB(131, 97, 64)
	for x = -size.X / 2, size.X / 2 - 3, 3 do
		makePart(model, "BridgePlank", Vector3.new(2.8, 0.5, size.Z - 2), Vector3.new(x, 0.25, 0), wood)
	end
	for _, z in {-size.Z / 2 + 0.5, size.Z / 2 - 0.5} do
		makePart(model, "RailPost", Vector3.new(0.6, size.Y - 0.5, 0.6), Vector3.new(0, size.Y / 2 + 0.25, z), wood)
		makePart(model, "BridgeRail", Vector3.new(size.X, 0.6, 0.6), Vector3.new(0, size.Y - 0.05, z), wood)
	end
	addSign(model, label, math.min(size.X * 0.6, 16), 2, Vector3.new(0, size.Y + 1.2, -size.Z / 2 - 0.7))
	return model
end

local function buildDisplay(key: string, label: string, options: {[string]: any}, kind: string): Model
	local size: Vector3 = options.size or Vector3.new(10, 6, 1)
	local model = makeModel(key, label)
	local wood = options.color or Color3.fromRGB(115, 84, 55)
	makePart(model, kind, size, Vector3.new(0, size.Y / 2, 0), wood)
	for _, x in {-size.X / 2, size.X / 2} do
		makePart(model, "Frame", Vector3.new(0.4, size.Y + 0.4, 0.5), Vector3.new(x, size.Y / 2, 0), wood:Lerp(Color3.new(0, 0, 0), 0.2))
	end
	addSign(model, label, size.X * 0.78, math.min(2.5, size.Y * 0.55), Vector3.new(0, size.Y / 2, -size.Z / 2 - 0.16))
	if kind == "TreasuryWindow" then
		makePart(model, "Counter", Vector3.new(size.X + 3, 1, 4), Vector3.new(0, 0.5, 2), wood)
	end
	return model
end

local function buildDesk(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(8, 3, 5)
	local model = makeModel(key, label)
	local wood = options.color or Color3.fromRGB(119, 87, 57)
	makePart(model, "Desktop", Vector3.new(size.X, 0.5, size.Z), Vector3.new(0, size.Y, 0), wood)
	for _, x in {-size.X / 2 + 0.4, size.X / 2 - 0.4} do
		for _, z in {-size.Z / 2 + 0.4, size.Z / 2 - 0.4} do
			makePart(model, "DeskLeg", Vector3.new(0.5, size.Y, 0.5), Vector3.new(x, size.Y / 2, z), wood)
		end
	end
	addSign(model, label, size.X * 0.7, 1.4, Vector3.new(0, size.Y + 1.5, -size.Z / 2 - 0.2))
	return model
end

local function buildShelf(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(5, 10, 3)
	local model = makeModel(key, label)
	local wood = options.color or Color3.fromRGB(114, 82, 55)
	for _, x in {-size.X / 2 + 0.25, size.X / 2 - 0.25} do
		makePart(model, "ShelfSide", Vector3.new(0.5, size.Y, size.Z), Vector3.new(x, size.Y / 2, 0), wood)
	end
	for y = 0, size.Y, size.Y / 3 do
		makePart(model, "ShelfBoard", Vector3.new(size.X, 0.4, size.Z), Vector3.new(0, y, 0), wood)
	end
	addSign(model, label, size.X * 0.8, 1.5, Vector3.new(0, size.Y + 1, -size.Z / 2 - 0.2))
	return model
end

local function buildBench(key: string, label: string, options: {[string]: any}): Model
	local size: Vector3 = options.size or Vector3.new(12, 2, 3)
	local model = makeModel(key, label)
	local wood = options.color or Color3.fromRGB(122, 91, 61)
	makePart(model, "Seat", size, Vector3.new(0, size.Y + 0.3, 0), wood)
	makePart(model, "Back", Vector3.new(size.X, size.Y * 2, 0.4), Vector3.new(0, size.Y * 2, size.Z / 2 - 0.2), wood)
	for _, x in {-size.X / 2 + 0.6, size.X / 2 - 0.6} do
		makePart(model, "BenchLeg", Vector3.new(0.6, size.Y + 0.3, size.Z), Vector3.new(x, (size.Y + 0.3) / 2, 0), wood)
	end
	addSign(model, label, math.min(size.X * 0.5, 6), 1.3, Vector3.new(0, size.Y * 3 + 1, -size.Z / 2 - 0.5))
	return model
end

local builders: {[string]: (string, string, {[string]: any}) -> Model} = {
	NoticeBoard = buildNoticeBoard,
	DistrictGate = buildDistrictGate,
	Podium = buildPodium,
	Stall = buildStall,
	DrainGrate = buildDrainGrate,
	Crate = buildCrate,
	Fence = buildFence,
	Footbridge = buildFootbridge,
	RosterBoard = function(key, label, options)
		return buildDisplay(key, label, options, "RosterBoard")
	end,
	TreasuryWindow = function(key, label, options)
		return buildDisplay(key, label, options, "TreasuryWindow")
	end,
	PriceBoard = function(key, label, options)
		return buildDisplay(key, label, options, "PriceBoard")
	end,
	Desk = buildDesk,
	Shelf = buildShelf,
	Bench = buildBench,
}

function Prop.build(key: string, params: {[string]: any}?): Model?
	local kind = string.match(key, "^Prop%.(.+)$")
	if kind == nil then
		return nil
	end
	local builder = builders[kind]
	if builder == nil then
		return nil
	end
	local options = params or {}
	local label: string = options.label or key
	return builder(key, label, options)
end

return Prop

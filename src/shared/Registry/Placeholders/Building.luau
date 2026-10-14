--!strict

local Building = {}

local DEFAULT_SIZE = Vector3.new(32, 18, 28)
local DEFAULT_BODY_COLOR = Color3.fromRGB(190, 190, 190)
local DEFAULT_ROOF_COLOR = Color3.fromRGB(92, 68, 88)

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

function Building.build(key: string, params: {[string]: any}?): Model
	local options = params or {}
	local size = options.size or DEFAULT_SIZE
	local bodyColor = options.bodyColor or DEFAULT_BODY_COLOR
	local roofColor = options.roofColor or DEFAULT_ROOF_COLOR
	local label = options.label or key
	local origin = options.position or Vector3.zero
	local roofHeight = 2

	local model = Instance.new("Model")
	model.Name = key:gsub("%.", "_")
	model:SetAttribute("FTMKey", key)
	model:SetAttribute("FTMLabel", label)

	local body = makePart(model, "Body", size, origin + Vector3.new(0, size.Y / 2, 0), bodyColor)
	model.PrimaryPart = body
	makePart(model, "Roof", Vector3.new(size.X + 4, roofHeight, size.Z + 4), origin + Vector3.new(0, size.Y + roofHeight / 2, 0), roofColor)
	makePart(model, "Door", Vector3.new(4, 8, 0.5), origin + Vector3.new(0, 4, -size.Z / 2 - 0.3), Color3.fromRGB(76, 54, 42))

	local sign = makePart(
		model,
		"Sign",
		Vector3.new(math.min(size.X - 4, 22), 2, 0.5),
		origin + Vector3.new(0, size.Y - 3, -size.Z / 2 - 0.35),
		Color3.fromRGB(54, 52, 48)
	)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "BuildingSign"
	billboard.Adornee = sign
	billboard.Size = UDim2.fromOffset(600, 120)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.MaxDistance = 300
	billboard.AlwaysOnTop = true
	billboard.Parent = sign

	local text = Instance.new("TextLabel")
	text.Name = "Label"
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Text = label
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	return model
end

return Building

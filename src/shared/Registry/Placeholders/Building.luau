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
	local doorHeight = 8
	local frontZ = origin.Z - size.Z / 2
	makePart(model, "Door", Vector3.new(4, doorHeight, 0.5), Vector3.new(origin.X, origin.Y + doorHeight / 2, frontZ - 0.3), Color3.fromRGB(76, 54, 42))

	local signHeight = 2.5
	local sign = makePart(
		model,
		"Sign",
		Vector3.new(size.X * 0.72, signHeight, 0.25),
		Vector3.new(origin.X, origin.Y + doorHeight + 0.25 + signHeight / 2, frontZ - 0.18),
		Color3.fromRGB(54, 52, 48)
	)
	sign.Anchored = true
	sign.CanCollide = false
	sign.CanTouch = false
	sign.CanQuery = false
	local weld = Instance.new("WeldConstraint")
	weld.Name = "SignWeld"
	weld.Part0 = body
	weld.Part1 = sign
	weld.Parent = sign

	local surface = Instance.new("SurfaceGui")
	surface.Name = "BuildingSign"
	surface.Face = Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 50
	surface.Parent = sign

	local text = Instance.new("TextLabel")
	text.Name = "Label"
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundColor3 = Color3.fromRGB(36, 34, 32)
	text.BackgroundTransparency = 0
	text.Text = label
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = surface

	return model
end

return Building

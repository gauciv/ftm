--!strict

local Sign = {}

function Sign.create(parent: Instance, label: string, size: Vector3, cframe: CFrame): Part
	local part = Instance.new("Part")
	part.Name = "Sign"
	part.Size = size
	part.CFrame = cframe
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Color = Color3.fromRGB(38, 36, 34)
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent

	local surface = Instance.new("SurfaceGui")
	surface.Name = "WorldSign"
	surface.Face = Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 50
	surface.LightInfluence = 0
	surface.Parent = part

	local text = Instance.new("TextLabel")
	text.Name = "Label"
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundColor3 = Color3.fromRGB(38, 36, 34)
	text.BackgroundTransparency = 0
	text.Text = label
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = surface

	return part
end

return Sign

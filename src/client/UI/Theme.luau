--!strict

local Theme = {
	Colors = {
		Panel = Color3.fromRGB(31, 34, 38),
		PanelAlt = Color3.fromRGB(44, 48, 53),
		Accent = Color3.fromRGB(217, 158, 78),
		Text = Color3.fromRGB(245, 243, 236),
		Muted = Color3.fromRGB(184, 187, 188),
		Danger = Color3.fromRGB(196, 79, 69),
	},
	Font = Enum.Font.Gotham,
	BoldFont = Enum.Font.GothamBold,
}

function Theme.panel(): Frame
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Theme.Colors.Panel
	frame.BackgroundTransparency = 0.08
	frame.BorderSizePixel = 0
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Colors.Accent
	stroke.Transparency = 0.25
	stroke.Thickness = 1
	stroke.Parent = frame
	return frame
end

return Theme

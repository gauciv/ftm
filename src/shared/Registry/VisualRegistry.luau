--!strict

local Log = require(script.Parent.Parent.Log)
local Overrides = require(script.Parent.Overrides)
local Building = require(script.Parent.Placeholders.Building)

local VisualRegistry = {}

local function buildUnknown(key: string, params: {[string]: any}?): Model
	local options = params or {}
	local label = options.label or key
	local position = options.position or Vector3.zero
	local size = options.size or Vector3.new(8, 8, 8)
	local model = Instance.new("Model")
	model.Name = "UnknownVisual"
	model:SetAttribute("FTMKey", key)
	model:SetAttribute("FTMLabel", label)
	local box = Instance.new("Part")
	box.Name = "Placeholder"
	box.Size = size
	box.Position = position + Vector3.new(0, size.Y / 2, 0)
	box.Anchored = true
	box.Color = Color3.fromRGB(255, 0, 255)
	box.Parent = model
	model.PrimaryPart = box
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "UnknownSign"
	billboard.Adornee = box
	billboard.Size = UDim2.fromOffset(400, 100)
	billboard.StudsOffset = Vector3.new(0, size.Y / 2 + 1, 0)
	billboard.MaxDistance = 300
	billboard.AlwaysOnTop = true
	billboard.Parent = box
	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Text = label
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard
	return model
end

function VisualRegistry.build(key: string, params: {[string]: any}?): Model
	local override = (Overrides :: {[string]: any})[key]
	if override ~= nil then
		return override(key, params)
	end

	local prefix = string.match(key, "^([^%.]+)") or key
	if prefix == "Building" then
		return Building.build(key, params)
	end

	Log.warn("VisualRegistry", string.format("Unknown visual key '%s'; using magenta placeholder", key))
	return buildUnknown(key, params)
end

return VisualRegistry

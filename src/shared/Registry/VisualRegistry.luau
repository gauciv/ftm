--!strict

local Log = require(script.Parent.Parent.Log)
local Overrides = require(script.Parent.Overrides)
local Building = require(script.Parent.Placeholders.Building)
local Prop = require(script.Parent.Placeholders.Prop)
local Sign = require(script.Parent.Placeholders.Sign)

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
	Sign.create(model, label, Vector3.new(math.min(size.X, 8), 2, 0.25), CFrame.new(position + Vector3.new(0, size.Y + 1, 0)))
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
	elseif prefix == "Prop" then
		local prop = Prop.build(key, params)
		if prop ~= nil then
			return prop
		end
	end

	Log.warn("VisualRegistry", string.format("Unknown visual key '%s'; using magenta placeholder", key))
	return buildUnknown(key, params)
end

return VisualRegistry

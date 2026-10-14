--!strict

local Players = game:GetService("Players")

local Person = {}

local function makePart(model: Model, name: string, size: Vector3, color: Color3, position: Vector3, transparency: number?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Color = color
	part.Position = position
	part.Transparency = transparency or 0
	part.Anchored = false
	part.CanCollide = false
	part.Parent = model
	return part
end

local function fallbackRig(color: Color3): Model
	local model = Instance.new("Model")
	model.Name = "Person"
	local root = makePart(model, "HumanoidRootPart", Vector3.new(2, 2, 1), color, Vector3.new(0, 3, 0), 1)
	local torso = makePart(model, "Torso", Vector3.new(2, 2, 1), color, Vector3.new(0, 3, 0))
	local head = makePart(model, "Head", Vector3.new(2, 1, 1), Color3.fromRGB(220, 185, 150), Vector3.new(0, 4.5, 0))
	local leftArm = makePart(model, "Left Arm", Vector3.new(1, 2, 1), color, Vector3.new(-1.5, 3, 0))
	local rightArm = makePart(model, "Right Arm", Vector3.new(1, 2, 1), color, Vector3.new(1.5, 3, 0))
	local leftLeg = makePart(model, "Left Leg", Vector3.new(1, 2, 1), Color3.fromRGB(52, 60, 68), Vector3.new(-0.5, 1, 0))
	local rightLeg = makePart(model, "Right Leg", Vector3.new(1, 2, 1), Color3.fromRGB(52, 60, 68), Vector3.new(0.5, 1, 0))
	for _, part in {torso, head, leftArm, rightArm, leftLeg, rightLeg} do
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = part
		weld.Parent = root
	end
	local humanoid = Instance.new("Humanoid")
	humanoid.Parent = model
	model.PrimaryPart = root
	return model
end

function Person.build(key: string, params: {[string]: any}?): Model
	local options = params or {}
	local label: string = options.label or key
	local role: string = options.role or "Resident"
	local districtColor: Color3 = options.color or Color3.fromRGB(135, 148, 128)
	local ok, result = pcall(function()
		return Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	end)
	local model = if ok and typeof(result) == "Instance" and result:IsA("Model") then result else fallbackRig(districtColor)
	model.Name = tostring(options.name or key:gsub("^Person%.", ""))
	model:SetAttribute("FTMKey", key)
	model:SetAttribute("FTMLabel", label)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid ~= nil then
		humanoid.DisplayName = string.format("%s (%s)", label, role)
		humanoid.NameDisplayDistance = 40
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	end
	local root = model:FindFirstChild("HumanoidRootPart")
	if root == nil or not root:IsA("BasePart") then
		model:Destroy()
		model = fallbackRig(districtColor)
		model.Name = tostring(options.name or key:gsub("^Person%.", ""))
		model:SetAttribute("FTMKey", key)
		model:SetAttribute("FTMLabel", label)
		humanoid = model:FindFirstChildOfClass("Humanoid")
		if humanoid ~= nil then
			humanoid.DisplayName = string.format("%s (%s)", label, role)
			humanoid.NameDisplayDistance = 40
			humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		end
		root = model:FindFirstChild("HumanoidRootPart")
	end
	local rootPart = root :: BasePart
	rootPart.Anchored = true
	model.PrimaryPart = rootPart
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			if descendant.Name ~= "HumanoidRootPart" and descendant.Name ~= "Head" then
				descendant.Color = districtColor
			end
		end
	end
	return model
end

return Person

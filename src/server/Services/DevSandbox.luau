--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local VisualRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Registry"):WaitForChild("VisualRegistry"))

local DevSandbox = {
	Name = "DevSandbox",
}

function DevSandbox.Start()
	if not Config.DevSandbox then
		return
	end

	local hasBaseplate = false
	for _, descendant in workspace:GetDescendants() do
		if descendant.Name == "Baseplate" and descendant:IsA("BasePart") then
			hasBaseplate = true
			break
		end
	end
	if not hasBaseplate then
		local ground = Instance.new("Part")
		ground.Name = "FTM_DevGround"
		ground.Size = Vector3.new(512, 1, 512)
		ground.Position = Vector3.new(0, -0.5, 0)
		ground.Anchored = true
		ground.Color = Color3.fromRGB(118, 118, 118)
		ground.Parent = workspace
	end

	local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
	local position = if spawn then spawn.Position + Vector3.new(0, 0, -40) else Vector3.new(0, 0, -30)
	local building = VisualRegistry.build("Building.CouncilHall", {
		label = "Council Hall",
		position = position,
	})
	building.Parent = workspace
end

return DevSandbox

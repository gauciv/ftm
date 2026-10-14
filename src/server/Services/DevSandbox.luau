--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local DevSandbox = {
	Name = "DevSandbox",
}

function DevSandbox.Start()
	if not Config.DevSandbox then
		return
	end
end

return DevSandbox

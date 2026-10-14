--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))

local DevSandbox = {
	Name = "DevSandbox",
}

function DevSandbox.Start()
	if not Config.DevSandbox then
		return
	end
	if not RunService:IsStudio() then
		return
	end
	local clock = require(script.Parent.CycleClock)
	local problems = require(script.Parent.Problems)
	local dev = {
		advance = function(count: number)
			if type(count) ~= "number" or count % 1 ~= 0 or count < 1 or count > 1000 then
				error("FTMDev.advance expects an integer from 1 to 1000", 2)
			end
			clock.advance(count)
		end,
		state = function()
			problems.debugState()
		end,
	}
	(shared :: any).FTMDev = dev
	Log.info("DevSandbox", "Studio commands ready: shared.FTMDev.advance(n), shared.FTMDev.state()")
end

return DevSandbox

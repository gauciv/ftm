--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Log = require(ReplicatedStorage.Shared.Log)

local CycleClock = {Name = "CycleClock"}
local cycle = 0
local listeners: {((number) -> ())} = {}

function CycleClock.getCycle(): number
	return cycle
end

function CycleClock.onCycle(callback: (number) -> ())
	table.insert(listeners, callback)
end

function CycleClock.advance(count: number)
	if count % 1 ~= 0 or count < 1 or count > 1000 then
		error("advance count must be an integer from 1 to 1000", 2)
	end
	for _ = 1, count do
		cycle += 1
		for _, callback in listeners do
			local ok, err = pcall(callback, cycle)
			if not ok then
				Log.error("CycleClock", string.format("Cycle listener failed: %s", tostring(err)))
			end
		end
	end
end

function CycleClock.Start()
	local timeScale = math.max(Config.DevTimeScale, 0.01)
	local seconds = Config.CycleSeconds / timeScale
	task.spawn(function()
		while true do
			task.wait(seconds)
			CycleClock.advance(1)
		end
	end)
end

return CycleClock

--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))
local Net = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Net"))

local Diagnostics = {
	Name = "Diagnostics",
}

function Diagnostics.Start()
	Log.info("Diagnostics", "server ready")
	Net.onInvoke("Ping", function(_player: Player)
		return {
			reply = "pong",
			serverTime = os.time(),
		}
	end)
end

return Diagnostics

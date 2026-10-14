--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))
local Net = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Net"))

local PING_TIMEOUT_SECONDS = 8

local Diagnostics = {
	Name = "Diagnostics",
}

function Diagnostics.Start()
	local completed = false
	local result: any = nil
	local failure: any = nil

	task.spawn(function()
		local packed = table.pack(pcall(function()
			return Net.invoke("Ping")
		end))
		if packed[1] then
			result = packed[2]
		else
			failure = packed[2]
		end
		completed = true
	end)

	local deadline = os.clock() + PING_TIMEOUT_SECONDS
	while not completed and os.clock() < deadline do
		task.wait(0.1)
	end

	if not completed then
		Log.warn("Diagnostics", "Ping timed out waiting for the server")
	elseif failure ~= nil then
		Log.warn("Diagnostics", string.format("Ping failed: %s", tostring(failure)))
	elseif type(result) ~= "table" or result.reply ~= "pong" then
		Log.warn("Diagnostics", "Ping returned no valid pong reply")
	else
		Log.info("Diagnostics", string.format("client ping reply: %s", result.reply))
	end
end

return Diagnostics

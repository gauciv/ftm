--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Names = require(script.Names)
local Log = require(script.Parent.Log)

local FOLDER_NAME = "FTMRemotes"
local WAIT_TIMEOUT = 5
local Net = {}

local function getKind(name: string): string
	local kind = (Names :: {[string]: string})[name]
	if kind == nil then
		error(string.format("Unknown remote name '%s'", name), 3)
	end
	return kind
end

local function getRemote(name: string, expectedKind: string): Instance?
	getKind(name)
	if not RunService:IsClient() then
		error("Client remote access is only available on the client", 3)
	end

	local deadline = os.clock() + WAIT_TIMEOUT
	local folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	while folder == nil and os.clock() < deadline do
		task.wait(0.1)
		folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	end
	if folder == nil then
		Log.warn("Net", string.format("Remote folder '%s' was not found before timeout", FOLDER_NAME))
		return nil
	end

	local remote = folder:FindFirstChild(name)
	while remote == nil and os.clock() < deadline do
		task.wait(0.1)
		remote = folder:FindFirstChild(name)
	end
	if remote == nil then
		Log.warn("Net", string.format("Remote '%s' was not found before timeout", name))
		return nil
	end

	local expectedClass = if expectedKind == "Event" then "RemoteEvent" else "RemoteFunction"
	if not remote:IsA(expectedClass) then
		error(string.format("Remote '%s' must be a %s", name, expectedClass), 3)
	end
	return remote
end

function Net.setup()
	if not RunService:IsServer() then
		error("Net.setup() is server-only", 2)
	end

	local folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if folder == nil then
		folder = Instance.new("Folder")
		folder.Name = FOLDER_NAME
		folder.Parent = ReplicatedStorage
	elseif not folder:IsA("Folder") then
		error(string.format("'%s' exists but is not a Folder", FOLDER_NAME), 2)
	end

	for name, kind in Names do
		local remote = folder:FindFirstChild(name)
		local className = if kind == "Event" then "RemoteEvent" else "RemoteFunction"
		if remote == nil then
			remote = Instance.new(className)
			remote.Name = name
			remote.Parent = folder
		elseif not remote:IsA(className) then
			error(string.format("Remote '%s' exists but is not a %s", name, className), 2)
		end
	end
end

function Net.onInvoke(name: string, handler: (Player, ...any) -> ...any)
	if not RunService:IsServer() then
		error("Net.onInvoke() is server-only", 2)
	end
	if getKind(name) ~= "Function" then
		error(string.format("Remote '%s' is not a Function", name), 2)
	end
	local remote = ReplicatedStorage:WaitForChild(FOLDER_NAME):WaitForChild(name)
	if not remote:IsA("RemoteFunction") then
		error(string.format("Remote '%s' is not a RemoteFunction", name), 2)
	end
	remote.OnServerInvoke = function(player: Player, ...: any): ...any
		local packed = table.pack(pcall(handler, player, ...))
		if not packed[1] then
			Log.error("Net", string.format("Handler '%s' failed: %s", name, tostring(packed[2])))
			return nil
		end
		return table.unpack(packed, 2, packed.n)
	end
end

function Net.onEvent(name: string, handler: any)
	if getKind(name) ~= "Event" then
		error(string.format("Remote '%s' is not an Event", name), 2)
	end
	if RunService:IsServer() then
		local remote = ReplicatedStorage:WaitForChild(FOLDER_NAME):WaitForChild(name)
		if not remote:IsA("RemoteEvent") then
			error(string.format("Remote '%s' is not a RemoteEvent", name), 2)
		end
		remote.OnServerEvent:Connect(function(player: Player, ...: any)
			local ok, err = pcall(handler, player, ...)
			if not ok then
				Log.error("Net", string.format("Handler '%s' failed: %s", name, tostring(err)))
			end
		end)
	else
		local remote = getRemote(name, "Event")
		if remote ~= nil then
			(remote :: RemoteEvent).OnClientEvent:Connect(function(...: any)
				local ok, err = pcall(handler, ...)
				if not ok then
					Log.error("Net", string.format("Client callback '%s' failed: %s", name, tostring(err)))
				end
			end)
		end
	end
end

function Net.fireClient(player: Player, name: string, ...: any)
	if not RunService:IsServer() then
		error("Net.fireClient() is server-only", 2)
	end
	if getKind(name) ~= "Event" then
		error(string.format("Remote '%s' is not an Event", name), 2)
	end
	local remote = ReplicatedStorage:WaitForChild(FOLDER_NAME):WaitForChild(name)
	if not remote:IsA("RemoteEvent") then
		error(string.format("Remote '%s' is not a RemoteEvent", name), 2)
	end
	remote:FireClient(player, ...)
end

function Net.fireAllClients(name: string, ...: any)
	if not RunService:IsServer() then
		error("Net.fireAllClients() is server-only", 2)
	end
	if getKind(name) ~= "Event" then
		error(string.format("Remote '%s' is not an Event", name), 2)
	end
	local remote = ReplicatedStorage:WaitForChild(FOLDER_NAME):WaitForChild(name)
	if not remote:IsA("RemoteEvent") then
		error(string.format("Remote '%s' is not a RemoteEvent", name), 2)
	end
	remote:FireAllClients(...)
end

function Net.invoke(name: string, ...: any): ...any
	if getKind(name) ~= "Function" then
		error(string.format("Remote '%s' is not a Function", name), 2)
	end
	local remote = getRemote(name, "Function")
	if remote == nil then
		return nil
	end
	return (remote :: RemoteFunction):InvokeServer(...)
end

function Net.fire(name: string, ...: any)
	if getKind(name) ~= "Event" then
		error(string.format("Remote '%s' is not an Event", name), 2)
	end
	local remote = getRemote(name, "Event")
	if remote ~= nil then
		(remote :: RemoteEvent):FireServer(...)
	end
end

return Net

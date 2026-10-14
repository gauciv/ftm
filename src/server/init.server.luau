--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))
local Net = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Net"))
local servicesFolder = script:WaitForChild("Services")

type Service = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

Net.setup()

local serviceModules = {}
for _, child in servicesFolder:GetChildren() do
	if child:IsA("ModuleScript") then
		table.insert(serviceModules, child)
	end
end
table.sort(serviceModules, function(a, b)
	return a.Name < b.Name
end)

local services: {Service} = {}
for _, moduleScript in serviceModules do
	local ok, service = pcall(require, moduleScript)
	if ok and type(service) == "table" and type(service.Name) == "string" then
		table.insert(services, service :: Service)
	else
		Log.error("Bootstrap", string.format("Could not load service '%s': %s", moduleScript.Name, tostring(service)))
	end
end

for _, service in services do
	if service.Init ~= nil then
		local ok, err = pcall(service.Init)
		if not ok then
			Log.error("Bootstrap", string.format("Service '%s' Init failed: %s", service.Name, tostring(err)))
		end
	end
end

for _, service in services do
	if service.Start ~= nil then
		task.spawn(function()
			local ok, err = pcall(service.Start :: () -> ())
			if not ok then
				Log.error("Bootstrap", string.format("Service '%s' Start failed: %s", service.Name, tostring(err)))
			end
		end)
	end
end

Log.info("Bootstrap", string.format("Loaded %d services", #services))

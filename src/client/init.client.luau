--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Log = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Log"))
local controllersFolder = script:WaitForChild("Controllers")

type Controller = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

while Players.LocalPlayer == nil do
	task.wait()
end

local controllerModules = {}
for _, child in controllersFolder:GetChildren() do
	if child:IsA("ModuleScript") then
		table.insert(controllerModules, child)
	end
end
table.sort(controllerModules, function(a, b)
	return a.Name < b.Name
end)

local controllers: {Controller} = {}
for _, moduleScript in controllerModules do
	local ok, controller = pcall(require, moduleScript)
	if ok and type(controller) == "table" and type(controller.Name) == "string" then
		table.insert(controllers, controller :: Controller)
	else
		Log.error("Bootstrap", string.format("Could not load controller '%s': %s", moduleScript.Name, tostring(controller)))
	end
end

for _, controller in controllers do
	if controller.Init ~= nil then
		local ok, err = pcall(controller.Init)
		if not ok then
			Log.error("Bootstrap", string.format("Controller '%s' Init failed: %s", controller.Name, tostring(err)))
		end
	end
end

for _, controller in controllers do
	if controller.Start ~= nil then
		task.spawn(function()
			local ok, err = pcall(controller.Start :: () -> ())
			if not ok then
				Log.error("Bootstrap", string.format("Controller '%s' Start failed: %s", controller.Name, tostring(err)))
			end
		end)
	end
end

Log.info("Bootstrap", string.format("Loaded %d controllers", #controllers))

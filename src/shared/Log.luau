--!strict

local Config = require(script.Parent.Config)

local Log = {}

local function write(level: string, tag: string, ...: any)
	local prefix = string.format("[FTM][%s]", tag)
	if level == "warn" then
		warn(prefix, ...)
	elseif level == "error" then
		warn(prefix, ...)
	else
		print(prefix, ...)
	end
end

function Log.info(tag: string, ...: any)
	if Config.DebugLogging then
		write("info", tag, ...)
	end
end

function Log.warn(tag: string, ...: any)
	write("warn", tag, ...)
end

function Log.error(tag: string, ...: any)
	write("error", tag, ...)
end

return Log

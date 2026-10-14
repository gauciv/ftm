--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Log = require(ReplicatedStorage.Shared.Log)
local Types = require(ReplicatedStorage.Shared.Types)
local Definitions: {Types.ProblemSpec} = require(script.Parent.Parent.Data.Problems)

type ProblemState = {definition: Types.ProblemSpec, value: number?, erupted: boolean}

local Problems = {Name = "Problems"}
local states: {[string]: ProblemState} = {}
local Clock: any

local function updateForCycle(cycle: number)
	local lines = {}
	for _, state in states do
		local definition = state.definition
		if cycle >= definition.SurfaceCycle then
			if state.value == nil then
				state.value = math.clamp(definition.StartValue, 0, 100)
			elseif cycle > definition.SurfaceCycle then
				state.value = math.min(100, state.value + definition.RisePerCycle)
			end
			if state.value >= 100 and not state.erupted then
				state.erupted = true
				Log.warn("Problems", string.format("%s erupted in %s", definition.Label, definition.DistrictKey))
			end
			table.insert(lines, string.format("%s=%d%%", definition.Key, state.value))
		end
	end
	if Config.DebugLogging then
		Log.info("Problems", string.format("cycle %d: %s", cycle, table.concat(lines, ", ")))
	end
end

function Problems.Start()
	Clock = require(script.Parent.CycleClock)
	for _, definition in Definitions do
		if type(definition.Key) == "string" and type(definition.SurfaceCycle) == "number" then
			states[definition.Key] = {definition = definition, value = nil, erupted = false}
		else
			Log.warn("Problems", "Skipped invalid problem definition")
		end
	end
	Clock.onCycle(updateForCycle)
	updateForCycle(Clock.getCycle())
end

function Problems.getBoard(districtKey: string): {Types.BoardEntry}
	local entries: {Types.BoardEntry} = {}
	for _, state in states do
		if state.definition.DistrictKey == districtKey and state.value ~= nil then
			table.insert(entries, {
				label = state.definition.Label,
				percent = math.floor(state.value),
				erupted = state.erupted,
			})
		end
	end
	return entries
end

function Problems.getAllLabelsByDistrict(): {[string]: {string}}
	local result: {[string]: {string}} = {}
	for _, state in states do
		local districtKey = state.definition.DistrictKey
		result[districtKey] = result[districtKey] or {}
		table.insert(result[districtKey], state.definition.Label)
	end
	return result
end

function Problems.getCycle(): number
	return if Clock ~= nil then Clock.getCycle() else 0
end

return Problems

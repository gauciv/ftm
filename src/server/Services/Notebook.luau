--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local City = require(Shared.Data.City)
local Config = require(Shared.Config)
local Log = require(Shared.Log)
local Net = require(Shared.Net)
local Roster = require(script.Parent.Parent.Data.Residents)

type Entry = {kind: "Heard" | "Board" | "Note", cycle: number, text: string}
type PlayerState = {
	home: string,
	learned: {[string]: boolean},
	entries: {Entry},
	boardSnapshots: {[string]: number},
}

local Notebook = {Name = "Notebook"}
local states: {[Player]: PlayerState} = {}
local lastTalk: {[Player]: number} = {}
local nextHomeIndex = 1
local currentCycle = 0

local function districtName(key: string): string
	for _, district in City.Districts do
		if district.Key == key then
			return district.Name
		end
	end
	return key
end

local function markersFor(state: PlayerState): {string}
	local markers = {}
	for _, resident in Roster do
		if resident.DistrictKey == state.home then
			for _, teaching in resident.Teaches or {} do
				if not state.learned[teaching.ProblemKey] then
					table.insert(markers, resident.Key)
					break
				end
			end
		end
	end
	return markers
end

local function sendNotebook(player: Player, state: PlayerState)
	Net.fireClient(player, "NotebookSync", {entries = state.entries})
end

local function sendMarkers(player: Player, state: PlayerState)
	Net.fireClient(player, "ResidentMarkers", {residentKeys = markersFor(state)})
end

local function getOrCreate(player: Player): PlayerState
	local state = states[player]
	if state ~= nil then
		return state
	end
	local district = City.Districts[nextHomeIndex]
	nextHomeIndex = nextHomeIndex % #City.Districts + 1
	state = {home = district.Key, learned = {}, entries = {}, boardSnapshots = {}}
	states[player] = state
	return state
end

local function addEntry(player: Player, state: PlayerState, kind: "Heard" | "Board" | "Note", text: string)
	table.insert(state.entries, {kind = kind, cycle = currentCycle, text = text})
	while #state.entries > Config.NotebookMaxEntries do
		table.remove(state.entries, 1)
	end
	sendNotebook(player, state)
end

local function playerPosition(player: Player): Vector3?
	local character = player.Character
	local root = if character ~= nil then character:FindFirstChild("HumanoidRootPart") else nil
	return if root ~= nil and root:IsA("BasePart") then root.Position else nil
end

local function onTalk(player: Player, model: Model)
	local state = states[player]
	if state == nil or model.Parent == nil then
		return
	end
	local rootPosition = playerPosition(player)
	local residentRoot = model.PrimaryPart
	if rootPosition == nil or residentRoot == nil or (rootPosition - residentRoot.Position).Magnitude > Config.TalkDistance + 1 then
		return
	end
	local now = os.clock()
	if now - (lastTalk[player] or 0) < Config.TalkCooldownSeconds then
		return
	end
	lastTalk[player] = now
	local key = model:GetAttribute("FTMKey")
	local residentKey = if type(key) == "string" then string.gsub(key, "^Person%.", "") else model.Name
	local resident = nil
	for _, entry in Roster do
		if entry.Key == residentKey then
			resident = entry
			break
		end
	end
	if resident == nil then
		Log.warn("Notebook", string.format("No dialogue data for resident '%s'", residentKey))
		return
	end
	local text: string? = nil
	for _, teaching in resident.Teaches or {} do
		if not state.learned[teaching.ProblemKey] then
			state.learned[teaching.ProblemKey] = true
			text = teaching.Text
			addEntry(player, state, "Heard", teaching.Text)
			sendMarkers(player, state)
			break
		end
	end
	if text == nil then
		local lines = {}
		for _, line in resident.Greet do
			table.insert(lines, line)
		end
		for _, line in resident.Gossip or {} do
			table.insert(lines, line)
		end
		if #lines > 0 then
			text = lines[math.random(1, #lines)]
		else
			text = "Nothing to report today."
		end
	end
	Net.fireClient(player, "Dialogue", {name = resident.Name, role = resident.Role, text = text})
end

local function initializePlayer(player: Player)
	local state = getOrCreate(player)
	task.delay(1, function()
		if states[player] == state and player.Parent == Players then
			sendMarkers(player, state)
			Net.fireClient(player, "Hint", {text = string.format("Someone in %s may want a word with you.", districtName(state.home))})
		end
	end)
end

function Notebook.Start()
	local clock = require(script.Parent.CycleClock)
	currentCycle = clock.getCycle()
	clock.onCycle(function(cycle: number)
		currentCycle = cycle
	end)
	for _, player in Players:GetPlayers() do
		initializePlayer(player)
	end
	Players.PlayerAdded:Connect(initializePlayer)
	Players.PlayerRemoving:Connect(function(player)
		states[player] = nil
		lastTalk[player] = nil
	end)
	Net.onInvoke("GetInitialState", function(player: Player, ...: any)
		if select("#", ...) > 0 then
			return nil
		end
		local state = getOrCreate(player)
		return {home = districtName(state.home), entries = state.entries, markers = markersFor(state)}
	end)
	local residentsService = require(script.Parent.Residents)
	residentsService.bindTalkHandler(onTalk)
end

function Notebook.getHomeDistrict(player: Player): string?
	local state = states[player]
	return if state ~= nil then state.home else nil
end

function Notebook.hasLearned(player: Player, problemKey: string): boolean
	local state = states[player]
	return state ~= nil and state.learned[problemKey] == true
end

function Notebook.addBoardEntry(player: Player, problemKey: string, percent: number, label: string)
	local state = states[player]
	if state == nil then
		return
	end
	if state.boardSnapshots[problemKey] == percent then
		return
	end
	state.boardSnapshots[problemKey] = percent
	addEntry(player, state, "Board", string.format("%s: %d%%", label, percent))
end

function Notebook.getCycle(): number
	return currentCycle
end

return Notebook

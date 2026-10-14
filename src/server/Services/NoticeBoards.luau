--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local City = require(Shared.Data.City)
local Config = require(Shared.Config)
local Log = require(Shared.Log)
local Net = require(Shared.Net)

local NoticeBoards = {Name = "NoticeBoards"}

local function playerPosition(player: Player): Vector3?
	local character = player.Character
	local root = if character ~= nil then character:FindFirstChild("HumanoidRootPart") else nil
	return if root ~= nil and root:IsA("BasePart") then root.Position else nil
end

local function findBoard(districtFolder: Instance): (Model?, BasePart?)
	for _, descendant in districtFolder:GetDescendants() do
		if descendant:IsA("Model") and descendant:GetAttribute("FTMKey") == "Prop.NoticeBoard" then
			local boardPart = descendant:FindFirstChild("Board")
			if boardPart ~= nil and boardPart:IsA("BasePart") then
				return descendant, boardPart
			end
		end
	end
	return nil, nil
end

local function bindBoard(boardPart: BasePart, district: any, notebook: any, problems: any, clock: any)
	if boardPart:FindFirstChild("ReadBoardPrompt") ~= nil then
		return
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "ReadBoardPrompt"
	prompt.ActionText = "Read board"
	prompt.ObjectText = district.Name
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = Config.BoardReadDistance
	prompt.Parent = boardPart
	prompt.Triggered:Connect(function(player: Player)
		local position = playerPosition(player)
		if position == nil or (position - boardPart.Position).Magnitude > Config.BoardReadDistance + 1 then
			return
		end
		local entries = problems.getBoard(district.Key)
		Net.fireClient(player, "BoardData", {
			districtName = district.Name,
			cycle = clock.getCycle(),
			entries = entries,
		})
		local keysByLabel = problems.getKeysByDistrict(district.Key)
		for _, entry in entries do
			local problemKey = keysByLabel[entry.label]
			if problemKey ~= nil then
				notebook.addBoardEntry(player, problemKey, entry.percent, entry.label)
			end
		end
	end)
end

function NoticeBoards.Start()
	local root = workspace:WaitForChild("FTM_City", 30)
	if root == nil then
		Log.warn("NoticeBoards", "Timed out waiting for FTM_City")
		return
	end
	local deadline = os.clock() + 30
	while root:GetAttribute("Ready") ~= true and os.clock() < deadline do
		task.wait(0.1)
	end
	if root:GetAttribute("Ready") ~= true then
		Log.warn("NoticeBoards", "Timed out waiting for FTM_City.Ready")
		return
	end
	local districtsFolder = root:FindFirstChild("Districts")
	if districtsFolder == nil then
		Log.warn("NoticeBoards", "FTM_City.Districts is missing")
		return
	end
	local notebook = require(script.Parent.Notebook)
	local problems = require(script.Parent.Problems)
	local clock = require(script.Parent.CycleClock)
	for _, district in City.Districts do
		local districtFolder = districtsFolder:FindFirstChild(district.Key)
		local model: Model? = nil
		local part: BasePart? = nil
		if districtFolder ~= nil then
			model, part = findBoard(districtFolder)
		end
		if model == nil or part == nil then
			Log.warn("NoticeBoards", string.format("Notice board missing for district '%s'", district.Key))
		else
			bindBoard(part, district, notebook, problems, clock)
		end
	end
end

return NoticeBoards

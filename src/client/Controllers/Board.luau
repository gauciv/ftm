--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local City = require(Shared.Data.City)
local Config = require(Shared.Config)
local Net = require(Shared.Net)
local Theme = require(script.Parent.Parent.UI.Theme)

local Board = {Name = "Board"}

local function findBoardPosition(districtName: string): Vector3?
	for _, district in City.Districts do
		if district.Name == districtName then
			local city = workspace:FindFirstChild("FTM_City")
			local districts = if city ~= nil then city:FindFirstChild("Districts") else nil
			local folder = if districts ~= nil then districts:FindFirstChild(district.Key) else nil
			if folder ~= nil then
				for _, descendant in folder:GetDescendants() do
					if descendant:IsA("Model") and descendant:GetAttribute("FTMKey") == "Prop.NoticeBoard" then
						local part = descendant:FindFirstChild("Board")
						if part ~= nil and part:IsA("BasePart") then
							return part.Position
						end
					end
				end
			end
			local angle = math.rad(district.AngleDeg)
			local center = Vector2.new(math.cos(angle) * Config.DistrictRadius, math.sin(angle) * Config.DistrictRadius)
			local board = center + district.NoticeBoard.Offset
			return Vector3.new(board.X, 5, board.Y)
		end
	end
	return nil
end

local function characterPosition(player: Player): Vector3?
	local character = player.Character
	local root = if character ~= nil then character:FindFirstChild("HumanoidRootPart") else nil
	return if root ~= nil and root:IsA("BasePart") then root.Position else nil
end

function Board.Start()
	local player = Players.LocalPlayer
	if player == nil then
		return
	end
	local screen = Instance.new("ScreenGui")
	screen.Name = "FTM_BoardGui"
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 25
	screen.Parent = player:WaitForChild("PlayerGui")
	local panel = Theme.panel()
	panel.Name = "BoardPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.new(0.82, 0, 0, 390)
	panel.Visible = false
	panel.Parent = screen
	local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(340, 310)
	sizeConstraint.MaxSize = Vector2.new(620, 390)
	sizeConstraint.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(20, 15)
	title.Size = UDim2.new(1, -92, 0, 36)
	title.Font = Theme.BoldFont
	title.TextColor3 = Theme.Colors.Text
	title.TextSize = 21
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.AnchorPoint = Vector2.new(1, 0)
	close.Position = UDim2.new(1, -14, 0, 12)
	close.Size = UDim2.fromOffset(42, 34)
	close.BackgroundColor3 = Theme.Colors.PanelAlt
	close.BorderSizePixel = 0
	close.Font = Theme.BoldFont
	close.Text = "×"
	close.TextColor3 = Theme.Colors.Text
	close.TextSize = 24
	close.Parent = panel
	close.Activated:Connect(function()
		panel.Visible = false
	end)

	local cycleLabel = Instance.new("TextLabel")
	cycleLabel.Name = "Cycle"
	cycleLabel.BackgroundTransparency = 1
	cycleLabel.Position = UDim2.fromOffset(20, 53)
	cycleLabel.Size = UDim2.new(1, -40, 0, 24)
	cycleLabel.Font = Theme.Font
	cycleLabel.TextColor3 = Theme.Colors.Muted
	cycleLabel.TextSize = 14
	cycleLabel.TextXAlignment = Enum.TextXAlignment.Left
	cycleLabel.Parent = panel

	local list = Instance.new("ScrollingFrame")
	list.Name = "Problems"
	list.Position = UDim2.fromOffset(18, 86)
	list.Size = UDim2.new(1, -36, 1, -104)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.CanvasSize = UDim2.new()
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.ScrollBarThickness = 5
	list.Parent = panel
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local activePosition: Vector3? = nil
	local generation = 0
	local function render(payload: any)
		for _, child in list:GetChildren() do
			if child:IsA("GuiObject") and child ~= layout then
				child:Destroy()
			end
		end
		local districtName = payload.districtName
		title.Text = districtName .. " Notice Board"
		cycleLabel.Text = string.format("Cycle %d", math.max(0, math.floor(payload.cycle)))
		activePosition = findBoardPosition(districtName)
		generation += 1
		local token = generation
		panel.Visible = true
		local entries = payload.entries
		if #entries == 0 then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -8, 0, 64)
			empty.BackgroundColor3 = Theme.Colors.PanelAlt
			empty.BorderSizePixel = 0
			empty.Font = Theme.Font
			empty.Text = "Nothing posted."
			empty.TextColor3 = Theme.Colors.Muted
			empty.TextSize = 17
			empty.Parent = list
		else
			for index, entry in entries do
				if type(entry) == "table" and type(entry.label) == "string" and type(entry.percent) == "number" and type(entry.erupted) == "boolean" then
					local row = Instance.new("Frame")
					row.Name = "Problem_" .. tostring(index)
					row.LayoutOrder = index
					row.Size = UDim2.new(1, -8, 0, 82)
					row.BackgroundColor3 = Theme.Colors.PanelAlt
					row.BorderSizePixel = 0
					row.Parent = list
					local label = Instance.new("TextLabel")
					label.BackgroundTransparency = 1
					label.Position = UDim2.fromOffset(12, 8)
					label.Size = UDim2.new(1, -24, 0, 24)
					label.Font = Theme.BoldFont
					label.Text = entry.label
					label.TextColor3 = Theme.Colors.Text
					label.TextSize = 16
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.Parent = row
					local bar = Instance.new("Frame")
					bar.Position = UDim2.fromOffset(12, 42)
					bar.Size = UDim2.new(1, -104, 0, 18)
					bar.BackgroundColor3 = Theme.Colors.Panel
					bar.BorderSizePixel = 0
					bar.ClipsDescendants = true
					bar.Parent = row
					local fill = Instance.new("Frame")
					fill.Size = UDim2.fromScale(math.clamp(entry.percent, 0, 100) / 100, 1)
					fill.BackgroundColor3 = if entry.erupted then Theme.Colors.Danger else Theme.Colors.Accent
					fill.BorderSizePixel = 0
					fill.Parent = bar
					local percent = Instance.new("TextLabel")
					percent.BackgroundTransparency = 1
					percent.AnchorPoint = Vector2.new(1, 0)
					percent.Position = UDim2.new(1, -12, 0, 40)
					percent.Size = UDim2.fromOffset(82, 22)
					percent.Font = Theme.BoldFont
					percent.Text = if entry.erupted then "ERUPTED" else string.format("%d%%", math.floor(entry.percent))
					percent.TextColor3 = if entry.erupted then Theme.Colors.Danger else Theme.Colors.Text
					percent.TextSize = 13
					percent.TextXAlignment = Enum.TextXAlignment.Right
					percent.Parent = row
				end
			end
		end
		task.spawn(function()
			while token == generation and panel.Visible do
				local position = characterPosition(player)
				if position == nil or activePosition == nil or (position - activePosition).Magnitude > Config.BoardReadDistance + 2 then
					panel.Visible = false
					break
				end
				task.wait(0.25)
			end
		end)
	end

	Net.onEvent("BoardData", function(payload: any)
		if type(payload) == "table" and type(payload.districtName) == "string" and type(payload.cycle) == "number" and type(payload.entries) == "table" then
			render(payload)
		end
	end)
end

return Board

--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Net = require(Shared.Net)
local Theme = require(script.Parent.Parent.UI.Theme)

local Notebook = {Name = "Notebook"}
local entries: {any} = {}

function Notebook.Start()
	local player = Players.LocalPlayer
	if player == nil then
		return
	end
	local playerGui = player:WaitForChild("PlayerGui")
	local screen = Instance.new("ScreenGui")
	screen.Name = "FTM_NotebookGui"
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 15
	screen.Parent = playerGui

	local button = Instance.new("TextButton")
	button.Name = "NotebookButton"
	button.AnchorPoint = Vector2.new(0, 1)
	button.Position = UDim2.new(0, 18, 1, -18)
	button.Size = UDim2.fromOffset(142, 42)
	button.BackgroundColor3 = Theme.Colors.Panel
	button.BorderSizePixel = 0
	button.Font = Theme.BoldFont
	button.Text = "Notebook  [N]"
	button.TextColor3 = Theme.Colors.Text
	button.TextSize = 15
	button.Visible = false
	button.Parent = screen
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 7)
	buttonCorner.Parent = button

	local panel = Theme.panel()
	panel.Name = "NotebookPanel"
	panel.AnchorPoint = Vector2.new(0, 1)
	panel.Position = UDim2.new(0, 18, 1, -70)
	panel.Size = UDim2.new(0, 380, 0.55, 0)
	panel.Visible = false
	panel.Parent = screen

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(16, 10)
	title.Size = UDim2.new(1, -32, 0, 30)
	title.Font = Theme.BoldFont
	title.Text = "Field Notebook"
	title.TextColor3 = Theme.Colors.Text
	title.TextSize = 19
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	local list = Instance.new("ScrollingFrame")
	list.Name = "Entries"
	list.Position = UDim2.fromOffset(12, 48)
	list.Size = UDim2.new(1, -24, 1, -60)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.CanvasSize = UDim2.new()
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.ScrollBarThickness = 5
	list.Parent = panel
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local function render()
		button.Visible = #entries > 0
		if #entries == 0 then
			panel.Visible = false
		end
		for _, child in list:GetChildren() do
			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
		for order = #entries, 1, -1 do
			local entry = entries[order]
			if type(entry) == "table" and type(entry.kind) == "string" and type(entry.cycle) == "number" and type(entry.text) == "string" then
				local row = Instance.new("TextLabel")
				row.Name = "Entry_" .. tostring(order)
				row.LayoutOrder = #entries - order
				row.Size = UDim2.new(1, -4, 0, 54)
				row.BackgroundColor3 = Theme.Colors.PanelAlt
				row.BorderSizePixel = 0
				row.Font = Theme.Font
				row.Text = string.format("%s  [%d]  %s", entry.kind, entry.cycle, entry.text)
				row.TextColor3 = Theme.Colors.Text
				row.TextSize = 14
				row.TextWrapped = true
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.Parent = list
				local padding = Instance.new("UIPadding")
				padding.PaddingLeft = UDim.new(0, 9)
				padding.PaddingRight = UDim.new(0, 6)
				padding.Parent = row
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 5)
				corner.Parent = row
			end
		end
	end

	local function toggle()
		if #entries > 0 then
			panel.Visible = not panel.Visible
		end
	end
	button.Activated:Connect(toggle)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == Enum.KeyCode.N then
			toggle()
		end
	end)
	Net.onEvent("NotebookSync", function(payload: any)
		if type(payload) == "table" and type(payload.entries) == "table" then
			entries = payload.entries
			render()
		end
	end)
	local ok, state = pcall(function()
		return Net.invoke("GetInitialState")
	end)
	if ok and type(state) == "table" and type(state.entries) == "table" then
		entries = state.entries
		render()
	end
end

return Notebook

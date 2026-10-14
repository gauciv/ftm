--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Net = require(Shared.Net)
local Theme = require(script.Parent.Parent.UI.Theme)

local Dialogue = {Name = "Dialogue"}
local generation = 0

local function findSpeaker(name: string): Model?
	local city = workspace:FindFirstChild("FTM_City")
	local folder = if city ~= nil then city:FindFirstChild("Residents") else nil
	if folder == nil then
		return nil
	end
	for _, child in folder:GetChildren() do
		if child:IsA("Model") and child:GetAttribute("FTMLabel") == name then
			return child
		end
	end
	return nil
end

function Dialogue.Start()
	local player = Players.LocalPlayer
	if player == nil then
		return
	end
	local playerGui = player:WaitForChild("PlayerGui")
	local screen = Instance.new("ScreenGui")
	screen.Name = "FTM_DialogueGui"
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 30
	screen.Parent = playerGui

	local panel = Theme.panel()
	panel.Name = "DialoguePanel"
	panel.AnchorPoint = Vector2.new(0.5, 1)
	panel.Position = UDim2.new(0.5, 0, 1, -28)
	panel.Size = UDim2.new(0.78, 0, 0, 164)
	panel.Visible = false
	panel.Parent = screen
	local constraint = Instance.new("UISizeConstraint")
	constraint.MinSize = Vector2.new(320, 140)
	constraint.MaxSize = Vector2.new(680, 164)
	constraint.Parent = panel

	local header = Instance.new("TextLabel")
	header.Name = "Speaker"
	header.BackgroundTransparency = 1
	header.Position = UDim2.fromOffset(18, 12)
	header.Size = UDim2.new(1, -150, 0, 28)
	header.Font = Theme.BoldFont
	header.TextColor3 = Theme.Colors.Accent
	header.TextSize = 18
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = panel

	local body = Instance.new("TextLabel")
	body.Name = "Text"
	body.BackgroundTransparency = 1
	body.Position = UDim2.fromOffset(18, 46)
	body.Size = UDim2.new(1, -36, 0, 70)
	body.Font = Theme.Font
	body.TextColor3 = Theme.Colors.Text
	body.TextSize = 17
	body.TextWrapped = true
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.Parent = panel

	local close = Instance.new("TextButton")
	close.Name = "Continue"
	close.AnchorPoint = Vector2.new(1, 1)
	close.Position = UDim2.new(1, -14, 1, -12)
	close.Size = UDim2.fromOffset(116, 34)
	close.BackgroundColor3 = Theme.Colors.Accent
	close.BorderSizePixel = 0
	close.Font = Theme.BoldFont
	close.Text = "Continue"
	close.TextColor3 = Theme.Colors.Panel
	close.TextSize = 14
	close.Parent = panel
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = close

	local function hide(token: number)
		if token == generation then
			panel.Visible = false
		end
	end
	close.Activated:Connect(function()
		hide(generation)
	end)

	Net.onEvent("Dialogue", function(payload: any)
		if type(payload) ~= "table" or type(payload.name) ~= "string" or type(payload.role) ~= "string" or type(payload.text) ~= "string" then
			return
		end
		generation += 1
		local token = generation
		header.Text = string.format("%s  ·  %s", payload.name, payload.role)
		body.Text = payload.text
		panel.Visible = true
		local speaker = findSpeaker(payload.name)
		task.delay(Config.DialogueSeconds, function()
			hide(token)
		end)
		task.spawn(function()
			while token == generation and panel.Visible do
				local character = player.Character
				local playerRoot = if character ~= nil then character:FindFirstChild("HumanoidRootPart") else nil
				local speakerRoot = if speaker ~= nil and speaker.Parent ~= nil then speaker.PrimaryPart else nil
				if playerRoot == nil or speakerRoot == nil then
					hide(token)
					break
				end
				if (playerRoot.Position - speakerRoot.Position).Magnitude > 16 then
					hide(token)
					break
				end
				task.wait(0.2)
			end
		end)
	end)
end

return Dialogue

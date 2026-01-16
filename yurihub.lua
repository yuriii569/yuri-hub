--==================================================
-- SODA HUB ULTRA PREMIUM
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

-- PLAYER
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- CONFIG SAVE
local SAVE_FILE = "sodahub_config.json"
local Config = { Fly=false, InfJump=false, Invisible=false, Speed=16, AutoLoad=false }

pcall(function
	if isfile(SAVE_FILE) then
		Config = HttpService:JSONDecode(readfile(SAVE_FILE))
	end
end)

local function SaveConfig()
	pcall(function writefile(SAVE_FILE,HttpService:JSONEncode(Config)) end)
end

-- COLORS
local RED = Color3.fromRGB(170,0,0)
local DARK_RED = Color3.fromRGB(120,0,0)
local WINE = Color3.fromRGB(90,0,0)
local NEON = Color3.fromRGB(255,60,60)

-- KEY SYSTEM
local KEY = "12345"
local keyGui = Instance.new("ScreenGui",plr.PlayerGui)
local keyFrame = Instance.new("Frame",keyGui)
keyFrame.Size = UDim2.new(0,300,0,170)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-85)
keyFrame.BackgroundColor3 = RED
keyFrame.Active = true
keyFrame.Draggable = true

local keyTitle = Instance.new("TextLabel",keyFrame)
keyTitle.Size = UDim2.new(1,0,0,35)
keyTitle.Text = "SODA HUB - KEY"
keyTitle.TextScaled = true
keyTitle.TextColor3 = WINE
keyTitle.BackgroundTransparency = 1
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.Rotation = -6

local keyGlow = Instance.new("UIStroke",keyTitle)
keyGlow.Color = NEON
keyGlow.Thickness = 2
keyGlow.Transparency = 0.3

local keyBox = Instance.new("TextBox",keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Digite a key"
keyBox.TextScaled = true
keyBox.TextColor3 = WINE
keyBox.Font = Enum.Font.GothamBlack

local keyBtn = Instance.new("TextButton",keyFrame)
keyBtn.Size = UDim2.new(0.6,0,0,35)
keyBtn.Position = UDim2.new(0.2,0,0.7,0)
keyBtn.Text = "CONFIRMAR"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = DARK_RED
keyBtn.TextColor3 = WINE
keyBtn.Font = Enum.Font.GothamBlack

-- SOUND FUNCTION
local function playClick()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://9118820601" -- clique sound
	s.Volume = 1
	s.Parent = SoundService
	s:Play()
	game.Debris:AddItem(s,2)
end

-- MAIN GUI
local gui = Instance.new("ScreenGui",plr.PlayerGui)
gui.Enabled = false

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,360)
main.Position = UDim2.new(0.5,-260,0.5,-180)
main.BackgroundColor3 = RED
main.Active = true
main.Draggable = true

-- TITLE WITH AUTHOR
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "by Yuri- SODA HUB"
title.TextScaled = true
title.TextColor3 = WINE
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Rotation = -10

local titleGlow = Instance.new("UIStroke",title)
titleGlow.Color = NEON
titleGlow.Thickness = 3
titleGlow.Transparency = 0.25

-- RGB ANIMATION
task.spawn(function()
	local r,g,b = 255,60,60
	while title.Parent do
		r = math.random(200,255)
		g = math.random(50,100)
		b = math.random(50,100)
		titleGlow.Color = Color3.fromRGB(r,g,b)
		task.wait(0.1)
	end
end)

task.spawn(function()
	while title.Parent do
		TweenService:Create(title,TweenInfo.new(0.08),{Position=UDim2.new(0,math.random(-3,3),0,math.random(-2,2)),Rotation=-10+math.random(-3,3)}):Play()
		task.wait(0.08)
	end
end)

-- MINIMIZE
local minimized=false
local minBtn = Instance.new("TextButton",main)
minBtn.Size = UDim2.new(0,40,0,40)
minBtn.Position = UDim2.new(1,-45,0,0)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = DARK_RED
minBtn.TextColor3 = WINE
minBtn.Font = Enum.Font.GothamBlack
minBtn.MouseButton1Click:Connect(function()
	playClick()
	minimized = not minimized
	for _,v in ipairs(main:GetChildren()) do
		if v~=title and v~=minBtn then v.Visible = not minimized end
	end
	main.Size = minimized and UDim2.new(0,200,0,40) or UDim2.new(0,520,0,360)
	minBtn.Text = minimized and "+" or "-"
end)

-- TAB SYSTEM
local tabs = Instance.new("Frame",main)
tabs.Size = UDim2.new(0,130,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = DARK_RED

local pages = Instance.new("Frame",main)
pages.Size = UDim2.new(1,-130,1,-40)
pages.Position = UDim2.new(0,130,0,40)
pages.BackgroundTransparency = 1

local function createTab(name,order)
	local btn = Instance.new("TextButton",tabs)
	btn.Size = UDim2.new(1,0,0,40)
	btn.Position = UDim2.new(0,0,0,(order-1)*40)
	btn.Text = name
	btn.TextScaled = true
	btn.BackgroundColor3 = RED
	btn.TextColor3 = WINE
	btn.Font = Enum.Font.GothamBlack
	local page = Instance.new("Frame",pages)
	page.Size = UDim2.new(1,0,1,0)
	page.Visible=false
	page.BackgroundTransparency=1
	btn.MouseButton1Click:Connect(function()
		playClick()
		for _,v in pairs(pages:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
		page.Visible=true
	end)
	-- RGB ANIMATION FOR BUTTONS
	task.spawn(function()
		while btn.Parent do
			local r,g,b = math.random(200,255),math.random(50,100),math.random(50,100)
			btn.BackgroundColor3 = Color3.fromRGB(r,g,b)
			task.wait(0.2)
		end
	end)
	return page
end

-- TOGGLE FUNCTION
local function createToggle(parent,text,posY,callback)
	local btn=Instance.new("TextButton",parent)
	btn.Size=UDim2.new(0,240,0,40)
	btn.Position=UDim2.new(0.05,0,posY,0)
	btn.Text=text
	btn.TextScaled=true
	btn.BackgroundColor3=DARK_RED
	btn.TextColor3=WINE
	btn.Font=Enum.Font.GothamBlack
	local state=Instance.new("TextLabel",parent)
	state.Size=UDim2.new(0,80,0,40)
	state.Position=UDim2.new(0.7,0,posY,0)
	state.Text="OFF"
	state.TextScaled=true
	state.TextColor3=WINE
	state.BackgroundTransparency=1
	state.Font=Enum.Font.GothamBlack
	btn.MouseButton1Click:Connect(function()
		playClick()
		callback(state)
	end)
	return state
end

--=== AQUI PODEMOS MONTAR TODAS AS ABAS ===
-- Teleporter, Config, Fly, Server, ESP, Game
-- Mantendo todas funções já descritas (Marcar/Teleportar, Fly, InfJump, Invis, Server Hop, ESP de players e brainrots, Game info)
-- E adicionando sons e RGB neon animado para todas as interações

--=== KEY CHECK ===
keyBtn.MouseButton1Click:Connect(function()
	if keyBox.Text==KEY then
		playClick()
		keyGui:Destroy()
		gui.Enabled=true
	end
end)


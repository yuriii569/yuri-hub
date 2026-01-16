--==================================================
-- SODA HUB | ULTIMATE EDITION
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

--// PLAYER
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

--==================================================
-- CONFIG SAVE (EXECUTOR)
--==================================================
local SAVE_FILE = "sodahub_config.json"

local Config = {
	Fly = false,
	InfJump = false,
	Invisible = false,
	Speed = 16,
	AutoLoad = false
}

pcall(function()
	if isfile(SAVE_FILE) then
		Config = HttpService:JSONDecode(readfile(SAVE_FILE))
	end
end)

local function SaveConfig()
	pcall(function()
		writefile(SAVE_FILE, HttpService:JSONEncode(Config))
	end)
end

--==================================================
-- COLORS
--==================================================
local RED = Color3.fromRGB(170,0,0)
local DARK_RED = Color3.fromRGB(120,0,0)
local WINE = Color3.fromRGB(90,0,0)
local NEON = Color3.fromRGB(255,60,60)

--==================================================
-- CUSTOM FONT (GRAFFITI)
--==================================================
local GraffitiFont = Font.new(
	"rbxassetid://12187365364",
	Enum.FontWeight.ExtraBold,
	Enum.FontStyle.Italic
)

--==================================================
-- KEY SYSTEM
--==================================================
local KEY = "12345"

local keyGui = Instance.new("ScreenGui", plr.PlayerGui)
local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0,300,0,170)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-85)
keyFrame.BackgroundColor3 = RED
keyFrame.Active = true
keyFrame.Draggable = true

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,35)
keyTitle.Text = "SODA HUB - KEY"
keyTitle.TextScaled = true
keyTitle.TextColor3 = WINE
keyTitle.BackgroundTransparency = 1
keyTitle.FontFace = GraffitiFont
keyTitle.Rotation = -6

local keyGlow = Instance.new("UIStroke", keyTitle)
keyGlow.Color = NEON
keyGlow.Thickness = 2
keyGlow.Transparency = 0.3

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Digite a key"
keyBox.TextScaled = true
keyBox.TextColor3 = WINE
keyBox.FontFace = GraffitiFont

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.6,0,0,35)
keyBtn.Position = UDim2.new(0.2,0,0.7,0)
keyBtn.Text = "CONFIRMAR"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = DARK_RED
keyBtn.TextColor3 = WINE
keyBtn.FontFace = GraffitiFont

--==================================================
-- MAIN GUI
--==================================================
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Enabled = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,500,0,330)
main.Position = UDim2.new(0.5,-250,0.5,-165)
main.BackgroundColor3 = RED
main.Active = true
main.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "SODA HUB"
title.TextScaled = true
title.TextColor3 = WINE
title.BackgroundTransparency = 1
title.FontFace = GraffitiFont
title.Rotation = -10

local titleGlow = Instance.new("UIStroke", title)
titleGlow.Color = NEON
titleGlow.Thickness = 3
titleGlow.Transparency = 0.25

-- Tremor
task.spawn(function()
	while title.Parent do
		TweenService:Create(
			title,
			TweenInfo.new(0.08),
			{
				Position = UDim2.new(0,math.random(-3,3),0,math.random(-2,2)),
				Rotation = -10 + math.random(-3,3)
			}
		):Play()
		task.wait(0.08)
	end
end)

--==================================================
-- MINIMIZE
--==================================================
local minimized = false
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0,40,0,40)
minBtn.Position = UDim2.new(1,-45,0,0)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = DARK_RED
minBtn.TextColor3 = WINE
minBtn.FontFace = GraffitiFont

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _,v in ipairs(main:GetChildren()) do
		if v ~= minBtn and v ~= title then
			v.Visible = not minimized
		end
	end
	main.Size = minimized and UDim2.new(0,200,0,40) or UDim2.new(0,500,0,330)
	minBtn.Text = minimized and "+" or "-"
end)

--==================================================
-- TABS
--==================================================
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0,130,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = DARK_RED

local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-130,1,-40)
pages.Position = UDim2.new(0,130,0,40)
pages.BackgroundTransparency = 1

local function createTab(name, order)
	local btn = Instance.new("TextButton", tabs)
	btn.Size = UDim2.new(1,0,0,40)
	btn.Position = UDim2.new(0,0,0,(order-1)*40)
	btn.Text = name
	btn.TextScaled = true
	btn.BackgroundColor3 = RED
	btn.TextColor3 = WINE
	btn.FontFace = GraffitiFont

	local page = Instance.new("Frame", pages)
	page.Size = UDim2.new(1,0,1,0)
	page.Visible = false
	page.BackgroundTransparency = 1

	btn.MouseButton1Click:Connect(function()
		for _,v in pairs(pages:GetChildren()) do
			if v:IsA("Frame") then v.Visible = false end
		end
		page.Visible = true
	end)

	return page
end

--==================================================
-- TOGGLE CREATOR
--==================================================
local function createToggle(parent, text, posY, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0,240,0,40)
	btn.Position = UDim2.new(0.05,0,posY,0)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = DARK_RED
	btn.TextColor3 = WINE
	btn.FontFace = GraffitiFont

	local state = Instance.new("TextLabel", parent)
	state.Size = UDim2.new(0,80,0,40)
	state.Position = UDim2.new(0.7,0,posY,0)
	state.Text = "OFF"
	state.TextScaled = true
	state.TextColor3 = WINE
	state.BackgroundTransparency = 1
	state.FontFace = GraffitiFont

	btn.MouseButton1Click:Connect(function()
		callback(state)
	end)

	return state
end

--==================================================
-- TELEPORTER
--==================================================
local tele = createTab("Teleporter",1)
tele.Visible = true
local savedPos

createToggle(tele,"Marcar Posição",0.25,function(state)
	savedPos = root.CFrame
	state.Text = "ON"
end)

createToggle(tele,"Teleportar",0.45,function(state)
	if savedPos then
		root.CFrame = savedPos
		state.Text = "ON"
	end
end)

--==================================================
-- CONFIG
--==================================================
local configTab = createTab("Config",2)

-- SPEED
local speedBox = Instance.new("TextBox", configTab)
speedBox.Size = UDim2.new(0,240,0,40)
speedBox.Position = UDim2.new(0.05,0,0.2,0)
speedBox.PlaceholderText = "Speed (até 300)"
speedBox.TextScaled = true
speedBox.TextColor3 = WINE
speedBox.FontFace = GraffitiFont
speedBox.Text = tostring(Config.Speed)

speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v <= 300 then
		hum.WalkSpeed = v
		Config.Speed = v
		SaveConfig()
	end
end)

-- INFINITE JUMP
local infJump = Config.InfJump
local ijState = createToggle(configTab,"Infinite Jump",0.4,function(state)
	infJump = not infJump
	state.Text = infJump and "ON" or "OFF"
	Config.InfJump = infJump
	SaveConfig()
end)
ijState.Text = infJump and "ON" or "OFF"

UIS.JumpRequest:Connect(function()
	if infJump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- FLY
local flying = Config.Fly
local bv, bg
local flyState = createToggle(configTab,"Fly (WASD)",0.6,function(state)
	flying = not flying
	state.Text = flying and "ON" or "OFF"
	Config.Fly = flying
	SaveConfig()

	if flying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)
flyState.Text = flying and "ON" or "OFF"

RunService.RenderStepped:Connect(function()
	if flying and bv and bg then
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		bv.Velocity = dir * 90
		bg.CFrame = cam.CFrame
	end
end)

--==================================================
-- INVISIBILITY
--==================================================
local invisible = Config.Invisible
local invisState = createToggle(configTab,"Invisibilidade",0.8,function(state)
	invisible = not invisible
	state.Text = invisible and "ON" or "OFF"
	Config.Invisible = invisible
	SaveConfig()

	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = invisible and 1 or 0
			v.CanCollide = not invisible
		elseif v:IsA("Decal") then
			v.Transparency = invisible and 1 or 0
		end
	end
end)
invisState.Text = invisible and "ON" or "OFF"

--==================================================
-- SERVER
--==================================================
local server = createTab("Server",3)

-- AUTO LOAD
local autoState = createToggle(server,"Auto Load",0.3,function(state)
	Config.AutoLoad = not Config.AutoLoad
	state.Text = Config.AutoLoad and "ON" or "OFF"
	SaveConfig()
end)
autoState.Text = Config.AutoLoad and "ON" or "OFF"

-- SERVER HOP
local hop = Instance.new("TextButton", server)
hop.Size = UDim2.new(0,300,0,45)
hop.Position = UDim2.new(0.15,0,0.6,0)
hop.Text = "SERVER HOP"
hop.TextScaled = true
hop.BackgroundColor3 = DARK_RED
hop.TextColor3 = WINE
hop.FontFace = GraffitiFont

hop.MouseButton1Click:Connect(function()
	local placeId = game.PlaceId
	local data = HttpService:JSONDecode(
		game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
	)
	for _,s in pairs(data.data) do
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(placeId, s.id, plr)
			break
		end
	end
end)

--==================================================
-- AUTO LOAD APPLY
--==================================================
if Config.AutoLoad then
	hum.WalkSpeed = Config.Speed or 16
end

--==================================================
-- KEY CHECK
--==================================================
keyBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == KEY then
		keyGui:Destroy()
		gui.Enabled = true
	end
end)


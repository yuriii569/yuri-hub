--==============================
-- YURI HUB | FINAL ESTÁVEL
--==============================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- CONFIG
local KEY = "12345"
local AUTOLOAD = false
local savedPos
local fly, infJump, noclip, esp = false,false,false,false

-- AUTOLOAD
if getgenv().YuriAutoLoad then
	getgenv().YuriAutoLoad()
end

-- LIMPAR GUI
if game.CoreGui:FindFirstChild("YuriHub") then
	game.CoreGui.YuriHub:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "YuriHub"
gui.ResetOnSpawn = false

-- BOTÃO ABRIR
local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(140,40)
open.Position = UDim2.fromOffset(40,200)
open.Text = "Yuri Hub"
open.BackgroundColor3 = Color3.new(0,0,0)
open.TextColor3 = Color3.new(1,1,1)
open.Active = true
open.Draggable = true

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(560,360)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.new(0,0,0)
main.Visible = false

-- BORDA RGB
RunService.RenderStepped:Connect(function()
	local c = Color3.fromHSV(tick()%5/5,1,1)
	main.BorderColor3 = c
	open.BorderColor3 = c
end)

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "YURI HUB"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- FECHAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(40,40)
close.Position = UDim2.new(1,-40,0,0)
close.Text = "X"
close.TextColor3 = Color3.new(1,0,0)
close.BackgroundColor3 = Color3.new(0,0,0)

-- KEY
local keyFrame = Instance.new("Frame", main)
keyFrame.Size = UDim2.new(1,0,1,-40)
keyFrame.Position = UDim2.fromOffset(0,40)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromOffset(240,40)
keyBox.Position = UDim2.fromScale(0.5,0.45)
keyBox.AnchorPoint = Vector2.new(0.5,0.5)
keyBox.PlaceholderText = "Digite a key"
keyBox.BackgroundColor3 = Color3.new(0,0,0)
keyBox.TextColor3 = Color3.new(1,1,1)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.fromOffset(240,40)
keyBtn.Position = UDim2.fromScale(0.5,0.6)
keyBtn.AnchorPoint = Vector2.new(0.5,0.5)
keyBtn.Text = "Entrar"
keyBtn.BackgroundColor3 = Color3.new(0,0,0)
keyBtn.TextColor3 = Color3.new(1,1,1)

-- CONTEÚDO
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.fromOffset(0,40)
content.Visible = false

-- ABAS EM CIMA
local tabBar = Instance.new("Frame", content)
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.BackgroundColor3 = Color3.new(0,0,0)

local pages = {}

local function createTab(name, x)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.fromOffset(140,40)
	btn.Position = UDim2.fromOffset(x,0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.new(0,0,0)
	btn.TextColor3 = Color3.new(1,1,1)

	local page = Instance.new("Frame", content)
	page.Size = UDim2.fromOffset(560,280)
	page.Position = UDim2.fromOffset(0,40)
	page.Visible = false

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible=false end
		page.Visible=true
	end)

	table.insert(pages,page)
	return page
end

-- TELEPORT
local tp = createTab("Teleport",0)

-- CONFIG
local cfg = createTab("Config",140)

-- ESP
local espTab = createTab("ESP",280)

-- SERVER
local server = createTab("Server",420)

-- TELEPORT BOTÕES
local mark = Instance.new("TextButton", tp)
mark.Size = UDim2.fromOffset(260,40)
mark.Position = UDim2.fromOffset(150,40)
mark.Text = "Marcar Posição"
mark.BackgroundColor3 = Color3.new(0,0,0)
mark.TextColor3 = Color3.new(1,1,1)

mark.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then savedPos = hrp.CFrame end
end)

local tpBtn = mark:Clone()
tpBtn.Parent = tp
tpBtn.Position = UDim2.fromOffset(150,90)
tpBtn.Text = "Teleportar"

tpBtn.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp and savedPos then hrp.CFrame = savedPos end
end)

-- GO BASE
local base = mark:Clone()
base.Parent = tp
base.Position = UDim2.fromOffset(150,140)
base.Text = "Go Base"

base.MouseButton1Click:Connect(function()
	player.Character:BreakJoints()
end)

-- CONFIG BOTÕES
local speed = Instance.new("TextBox", cfg)
speed.Size = UDim2.fromOffset(260,40)
speed.Position = UDim2.fromOffset(150,40)
speed.PlaceholderText = "Velocidade (max 200)"
speed.BackgroundColor3 = Color3.new(0,0,0)
speed.TextColor3 = Color3.new(1,1,1)

speed.FocusLost:Connect(function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	local v = tonumber(speed.Text)
	if hum and v and v <= 200 then hum.WalkSpeed = v end
end)

-- SERVER BOTÕES
local hop = Instance.new("TextButton", server)
hop.Size = UDim2.fromOffset(260,40)
hop.Position = UDim2.fromOffset(150,40)
hop.Text = "Server Hop"
hop.BackgroundColor3 = Color3.new(0,0,0)
hop.TextColor3 = Color3.new(1,1,1)

hop.MouseButton1Click:Connect(function()
	if AUTOLOAD then
		getgenv().YuriAutoLoad = function()
			loadstring(game:HttpGet("SEU_LINK_RAW_AQUI"))()
		end
	end
	TeleportService:Teleport(game.PlaceId, player)
end)

local auto = hop:Clone()
auto.Parent = server
auto.Position = UDim2.fromOffset(150,90)
auto.Text = "Auto Load : OFF"

auto.MouseButton1Click:Connect(function()
	AUTOLOAD = not AUTOLOAD
	auto.Text = "Auto Load : "..(AUTOLOAD and "ON" or "OFF")
end)

-- KEY CHECK
keyBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == KEY then
		keyFrame.Visible = false
		content.Visible = true
		pages[1].Visible = true
	end
end)

-- OPEN / CLOSE
open.MouseButton1Click:Connect(function()
	main.Visible = true
end)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

--====================================
-- YURI HUB | ESTILO ANTIGO ESTÁVEL
--====================================

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

-- AUTOLOAD REEXEC
if getgenv().YuriAutoLoad then
	getgenv().YuriAutoLoad()
end

-- RESET GUI
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
main.Size = UDim2.fromOffset(520,340)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.new(0,0,0)
main.Visible = false

-- RGB BORDA
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
keyFrame.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromOffset(220,40)
keyBox.Position = UDim2.fromScale(0.5,0.45)
keyBox.AnchorPoint = Vector2.new(0.5,0.5)
keyBox.PlaceholderText = "Digite a key"
keyBox.BackgroundColor3 = Color3.new(0,0,0)
keyBox.TextColor3 = Color3.new(1,1,1)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.fromOffset(220,40)
keyBtn.Position = UDim2.fromScale(0.5,0.6)
keyBtn.AnchorPoint = Vector2.new(0.5,0.5)
keyBtn.Text = "Entrar"
keyBtn.BackgroundColor3 = Color3.new(0,0,0)
keyBtn.TextColor3 = Color3.new(1,1,1)

-- CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.fromOffset(0,40)
content.Visible = false
content.BackgroundTransparency = 1

-- ABAS EM CIMA
local tabBar = Instance.new("Frame", content)
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.BackgroundColor3 = Color3.new(0,0,0)

local pages = {}

local function newTab(name,x)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.fromOffset(120,40)
	b.Position = UDim2.fromOffset(x,0)
	b.Text = name
	b.BackgroundColor3 = Color3.new(0,0,0)
	b.TextColor3 = Color3.new(1,1,1)

	local p = Instance.new("Frame", content)
	p.Size = UDim2.fromOffset(520,220)
	p.Position = UDim2.fromOffset(0,40)
	p.Visible = false
	p.BackgroundTransparency = 1

	b.MouseButton1Click:Connect(function()
		for _,v in pairs(pages) do v.Visible=false end
		p.Visible=true
	end)

	table.insert(pages,p)
	return p
end

-- TELEPORT
local tp = newTab("Teleport",0)

local mark = Instance.new("TextButton", tp)
mark.Size = UDim2.fromOffset(260,40)
mark.Position = UDim2.fromOffset(130,30)
mark.Text = "Marcar Posição"
mark.BackgroundColor3 = Color3.new(0,0,0)
mark.TextColor3 = Color3.new(1,1,1)

mark.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then savedPos = hrp.CFrame end
end)

local tpBtn = mark:Clone()
tpBtn.Parent = tp
tpBtn.Position = UDim2.fromOffset(130,80)
tpBtn.Text = "Teleportar"

tpBtn.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp and savedPos then hrp.CFrame = savedPos end
end)

-- SERVER
local server = newTab("Server",120)

local hop = Instance.new("TextButton", server)
hop.Size = UDim2.fromOffset(260,40)
hop.Position = UDim2.fromOffset(130,40)
hop.Text = "Server Hop"
hop.BackgroundColor3 = Color3.new(0,0,0)
hop.TextColor3 = Color3.new(1,1,1)

hop.MouseButton1Click:Connect(function()
	if AUTOLOAD then
		getgenv().YuriAutoLoad = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/yuriii569/yuri-hub/main/yurihub.lua"))()
		end
	end
	TeleportService:Teleport(game.PlaceId, player)
end)

local auto = hop:Clone()
auto.Parent = server
auto.Position = UDim2.fromOffset(130,90)
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


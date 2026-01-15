--====================================================
-- YURI HUB PREMIUM FINAL | ALL IN ONE
--====================================================

local SCRIPT_URL = "COLE_AQUI_SEU_LINK_RAW_DO_GITHUB"

--================ SERVICES ================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local char, hum, hrp

--================ CHARACTER SAFE =================
local function loadChar(c)
	char = c
	hum = c:WaitForChild("Humanoid")
	hrp = c:WaitForChild("HumanoidRootPart")
	hum.WalkSpeed = state and state.Speed or 16
end
if player.Character then loadChar(player.Character) end
player.CharacterAdded:Connect(loadChar)

--================ STATE =================
local state = {
	Fly=false,
	InfJump=false,
	NoClip=false,
	AntiRagdoll=false,
	ESP=false,
	AutoLoad=false,
	Speed=16
}

local savedPos
local cons = {}

--================ CONFIG SAVE =================
local FILE = "YuriHubConfig.json"

local function saveConfig()
	if writefile then
		writefile(FILE, HttpService:JSONEncode(state))
	end
end

local function loadConfig()
	if readfile and isfile and isfile(FILE) then
		local data = HttpService:JSONDecode(readfile(FILE))
		for k,v in pairs(data) do
			state[k]=v
		end
	end
end
loadConfig()

--================ AUTO LOAD REAL =================
local function setupAutoLoad()
	if state.AutoLoad and queue_on_teleport then
		queue_on_teleport([[
			repeat task.wait() until game:IsLoaded()
			loadstring(game:HttpGet("]]..SCRIPT_URL..[["))()
		]])
	end
end

--================ FEATURES =================

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if state.InfJump and hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Fly
local bv,bg
local function toggleFly()
	state.Fly = not state.Fly
	if state.Fly then
		bv = Instance.new("BodyVelocity",hrp)
		bg = Instance.new("BodyGyro",hrp)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
		cons.fly = RunService.RenderStepped:Connect(function()
			bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
			bg.CFrame = workspace.CurrentCamera.CFrame
		end)
	else
		if cons.fly then cons.fly:Disconnect() end
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
	saveConfig()
end

-- NoClip
local function toggleNoClip()
	state.NoClip = not state.NoClip
	if state.NoClip then
		cons.nc = RunService.Stepped:Connect(function()
			for _,p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide=false end
			end
		end)
	else
		if cons.nc then cons.nc:Disconnect() end
	end
	saveConfig()
end

-- Anti Ragdoll
local function toggleAntiRagdoll()
	state.AntiRagdoll = not state.AntiRagdoll
	if state.AntiRagdoll then
		cons.ar = hum.StateChanged:Connect(function(_,s)
			if s==Enum.HumanoidStateType.Ragdoll then
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end)
	else
		if cons.ar then cons.ar:Disconnect() end
	end
	saveConfig()
end

-- ESP
local function toggleESP()
	state.ESP = not state.ESP
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local h = plr.Character:FindFirstChild("YuriESP")
			if state.ESP and not h then
				h = Instance.new("Highlight",plr.Character)
				h.Name="YuriESP"
				h.FillColor=Color3.fromRGB(255,0,0)
				h.OutlineColor=h.FillColor
				h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
			elseif not state.ESP and h then
				h:Destroy()
			end
		end
	end
	saveConfig()
end

-- Server Hop
local function serverHop()
	setupAutoLoad()
	local servers = HttpService:JSONDecode(
		game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
	)
	for _,s in ipairs(servers.data) do
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(game.PlaceId,s.id,player)
			break
		end
	end
end

--================ GUI =================
local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

local open = Instance.new("TextButton",gui)
open.Size=UDim2.new(0,140,0,40)
open.Position=UDim2.new(0,20,0.5,0)
open.Text="YURI HUB"
open.BackgroundColor3=Color3.new(0,0,0)
open.TextColor3=Color3.new(1,1,1)
open.Active=true
open.Draggable=true

local main = Instance.new("Frame",gui)
main.Size=UDim2.new(0,600,0,420)
main.Position=UDim2.new(0.5,-300,0.5,-210)
main.BackgroundColor3=Color3.new(0,0,0)
main.Visible=false
main.Active=true
main.Draggable=true

open.MouseButton1Click:Connect(function()
	main.Visible=not main.Visible
end)

-- TITLE RGB
local title = Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,40)
title.Text="YURI HUB PREMIUM"
title.TextColor3=Color3.new(1,1,1)
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.TextSize=20

task.spawn(function()
	while true do
		for h=0,1,0.01 do
			title.TextColor3=Color3.fromHSV(h,1,1)
			task.wait()
		end
	end
end)

--================ BOTÕES =================
local function btn(text,y,func)
	local b=Instance.new("TextButton",main)
	b.Size=UDim2.new(0,260,0,40)
	b.Position=UDim2.new(0,20,0,y)
	b.Text=text
	b.BackgroundColor3=Color3.fromRGB(20,20,20)
	b.TextColor3=Color3.new(1,1,1)
	b.MouseButton1Click:Connect(func)
end

btn("MARCAR POSIÇÃO",60,function() savedPos=hrp.CFrame end)
btn("TELEPORTAR",110,function() if savedPos then hrp.CFrame=savedPos end end)
btn("FLY",160,toggleFly)
btn("INFINITE JUMP",210,function() state.InfJump=not state.InfJump saveConfig() end)
btn("NO CLIP",260,toggleNoClip)
btn("ANTI RAGDOLL",310,toggleAntiRagdoll)
btn("ESP VERMELHO",360,toggleESP)

btn("AUTO LOAD",60,function() state.AutoLoad=not state.AutoLoad saveConfig() end)
btn("SERVER HOP",110,serverHop)


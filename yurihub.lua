--==================================================
-- SODA HUB FINAL COMPLETO | CARREGAMENTO + RGB + ABAS
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local cam = Workspace.CurrentCamera

local RED = Color3.fromRGB(170,0,0)
local DARK_RED = Color3.fromRGB(120,0,0)
local WINE = Color3.fromRGB(90,0,0)

local function playClick()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://9118820601"
	s.Volume = 1
	s.Parent = plr:WaitForChild("PlayerGui")
	s:Play()
	game.Debris:AddItem(s,2)
end

-- GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,360)
main.Position = UDim2.new(0.5,-260,0.5,-180)
main.BackgroundColor3 = RED
main.Active = true
main.Draggable = true

-- TITLE + LOADING
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Loading 0%"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = WINE
title.Font = Enum.Font.GothamBlack

-- Loading animation
local progress = 0
local loadingComplete = false

spawn(function()
	while progress < 100 do
		progress = progress + math.random(1,3)
		if progress > 100 then progress = 100 end
		title.Text = "Loading "..progress.."%"
		wait(0.05)
	end
	loadingComplete = true
	title.Text = "by Yuri- SODA HUB"
end)

-- RGB neon animation
RunService.RenderStepped:Connect(function()
	if loadingComplete then
		local t = tick()
		title.TextColor3 = Color3.fromHSV((t%5)/5,1,1)
		title.Rotation = math.sin(t*8)*5
		title.Position = UDim2.new(0,math.random(-2,2),0,0)
	end
end)

-- Minimize button
local minimized=false
local minBtn = Instance.new("TextButton", main)
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
		if v ~= title and v ~= minBtn then v.Visible = not minimized end
	end
	main.Size = minimized and UDim2.new(0,200,0,40) or UDim2.new(0,520,0,360)
	minBtn.Text = minimized and "+" or "-"
end)

-- Tabs
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0,130,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = DARK_RED

local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-130,1,-40)
pages.Position = UDim2.new(0,130,0,40)
pages.BackgroundTransparency = 1

local function createTab(name,order)
	local btn = Instance.new("TextButton", tabs)
	btn.Size = UDim2.new(1,0,0,40)
	btn.Position = UDim2.new(0,0,0,(order-1)*40)
	btn.Text = name
	btn.TextScaled = true
	btn.BackgroundColor3 = RED
	btn.TextColor3 = WINE
	btn.Font = Enum.Font.GothamBlack

	local page = Instance.new("Frame", pages)
	page.Size = UDim2.new(1,0,1,0)
	page.Visible = false
	page.BackgroundTransparency = 1

	btn.MouseButton1Click:Connect(function()
		playClick()
		for _,v in pairs(pages:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
		page.Visible = true
	end)
	return page
end

-- Toggle helper
local function createToggle(parent,text,posY,callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0,240,0,40)
	btn.Position = UDim2.new(0.05,0,posY,0)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = DARK_RED
	btn.TextColor3 = WINE
	btn.Font = Enum.Font.GothamBlack

	local state = Instance.new("TextLabel", parent)
	state.Size = UDim2.new(0,80,0,40)
	state.Position = UDim2.new(0.7,0,posY,0)
	state.Text = "OFF"
	state.TextScaled = true
	state.BackgroundTransparency = 1
	state.TextColor3 = WINE
	state.Font = Enum.Font.GothamBlack

	btn.MouseButton1Click:Connect(function()
		playClick()
		callback(state)
	end)
	return state
end

--==================== ABAS ====================
local tele = createTab("Teleporter",1)
tele.Visible = true
local savedPos
createToggle(tele,"Marcar Posição",0.25,function(state)
	savedPos = root.CFrame
	state.Text = "ON"
end)
createToggle(tele,"Teleportar",0.45,function(state)
	if savedPos then root.CFrame = savedPos state.Text = "ON" end
end)

local configTab = createTab("Config",2)
local speedBox = Instance.new("TextBox", configTab)
speedBox.Size = UDim2.new(0,240,0,40)
speedBox.Position = UDim2.new(0.05,0,0.2,0)
speedBox.PlaceholderText = "Speed (até 300)"
speedBox.TextScaled = true
speedBox.TextColor3 = WINE
speedBox.Font = Enum.Font.GothamBlack
speedBox.Text = tostring(hum.WalkSpeed)
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v and v <= 300 then hum.WalkSpeed = v end
end)

local infJump = false
local ijState = createToggle(configTab,"Infinite Jump",0.4,function(state)
	infJump = not infJump
	state.Text = infJump and "ON" or "OFF"
end)

UIS.JumpRequest:Connect(function()
	if infJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local flying = false
local bv,bg
local flyState = createToggle(configTab,"Fly (WASD)",0.6,function(state)
	flying = not flying
	state.Text = flying and "ON" or "OFF"
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

-- Server Tab
local serverTab = createTab("Server",3)
local hopBtn = Instance.new("TextButton", serverTab)
hopBtn.Size = UDim2.new(0,300,0,45)
hopBtn.Position = UDim2.new(0.1,0,0.6,0)
hopBtn.Text = "SERVER HOP"
hopBtn.TextScaled = true
hopBtn.BackgroundColor3 = DARK_RED
hopBtn.TextColor3 = WINE
hopBtn.Font = Enum.Font.GothamBlack
hopBtn.MouseButton1Click:Connect(function()
	playClick()
	local placeId = game.PlaceId
	local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100"))
	for _,s in pairs(data.data) do
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(placeId,s.id,plr)
			break
		end
	end
end)

-- ESP Tab
local espTab = createTab("ESP",4)
local playerESP, brainrotESP = {}, {}
local espPlayersOn, espBrainOn = false, false

createToggle(espTab,"ESP Jogadores",0.2,function(state)
	espPlayersOn = not espPlayersOn
	state.Text = espPlayersOn and "ON" or "OFF"
end)
createToggle(espTab,"ESP Brainrot",0.4,function(state)
	espBrainOn = not espBrainOn
	state.Text = espBrainOn and "ON" or "OFF"
end)

local function createESP(target)
	local highlight = Instance.new("Highlight", target)
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	local billboard = Instance.new("BillboardGui", target)
	billboard.Adornee = target
	billboard.Size = UDim2.new(0,100,0,50)
	local nameLabel = Instance.new("TextLabel", billboard)
	nameLabel.Size = UDim2.new(1,0,1,0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextScaled = true
	nameLabel.TextColor3 = WINE
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.Text = target.Name
	return highlight, billboard
end

RunService.RenderStepped:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= plr and p.Character and not playerESP[p] then
			local hl, bb = createESP(p.Character)
			hl.Enabled = espPlayersOn
			bb.Enabled = espPlayersOn
			playerESP[p] = {hl,bb}
		elseif playerESP[p] then
			playerESP[p][1].Enabled = espPlayersOn
			playerESP[p][2].Enabled = espPlayersOn
		end
	end
	for _,v in pairs(Workspace:GetChildren()) do
		if v.Name:lower():find("brainrot") and not brainrotESP[v] then
			local hl, bb = createESP(v)
			hl.Enabled = espBrainOn
			bb.Enabled = espBrainOn
			brainrotESP[v] = {hl,bb}
		elseif brainrotESP[v] then
			brainrotESP[v][1].Enabled = espBrainOn
			brainrotESP[v][2].Enabled = espBrainOn
		end
	end
end)

-- Game Info Tab
local gameTab = createTab("Game",5)
local infoLabel = Instance.new("TextLabel", gameTab)
infoLabel.Size = UDim2.new(1,0,1,0)
infoLabel.TextScaled = true
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = WINE
infoLabel.Font = Enum.Font.GothamBlack

RunService.RenderStepped:Connect(function()
	local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
	infoLabel.Text = string.format("Players: %d\nPing: %d\nGame Name: %s", #Players:GetPlayers(), plr:GetNetworkPing()*1000, gameName)
end)

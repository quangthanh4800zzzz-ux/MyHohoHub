	-- [[ KHỞI TẠO DỊCH VỤ HỆ THỐNG ]]
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local Player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer

-- [[ BIẾN CẤU HÌNH TOÀN CỤC ]]
_G.CFrameSpeedValue = 0 
_G.MaxLimit = 4800 
_G.JumpPowerValue = 0
_G.MaxJumpLimit = 480
_G.IsActive = true

-- Trạng thái logic các chức năng
local FastAttackEnabled = false
local HitboxActive = false
local HitboxValue = 0
local AttackValue = 0
local AttackDistance = 400 -- Khoảng cách có thể điều chỉnh

-- Bộ lọc mục tiêu (Target Filters)
local AttackPlayersEnabled = true
local AttackNPCsEnabled = true

-- Universal Bypass Logic (Pain, Control, Yeti)
_G.SpamEnabled = false 

-- Remote chuẩn của Blox Fruits
local RegisterAttack = ReplicatedStorage.Modules.Net["RE/RegisterAttack"]
local RegisterHit = ReplicatedStorage.Modules.Net["RE/RegisterHit"]

-- [[ 1. GUI THÔNG TIN (FPS & PING) ]]
if CoreGui:FindFirstChild("SIGMA_INFO_PANEL") then 
    CoreGui:FindFirstChild("SIGMA_INFO_PANEL"):Destroy() 
end

local InfoGui = Instance.new("ScreenGui", CoreGui)
InfoGui.Name = "SIGMA_INFO_PANEL"

local InfoFrame = Instance.new("Frame", InfoGui)
InfoFrame.Size = UDim2.new(0, 150, 0, 60)
InfoFrame.Position = UDim2.new(0, 10, 0, 10)
InfoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfoFrame.BackgroundTransparency = 0.2
local InfoCorner = Instance.new("UICorner", InfoFrame)
InfoCorner.CornerRadius = UDim.new(0, 8)

local InfoStroke = Instance.new("UIStroke", InfoFrame)
InfoStroke.Color = Color3.fromRGB(0, 255, 255)
InfoStroke.Thickness = 2

local FPSLabel = Instance.new("TextLabel", InfoFrame)
FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 60"
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 13

local PingLabel = Instance.new("TextLabel", InfoFrame)
PingLabel.Size = UDim2.new(1, 0, 0.5, 0)
PingLabel.Position = UDim2.new(0, 0, 0.5, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 0 ms"
PingLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 13

local lastIteration = tick()
local frameHistory = {}
RunService.RenderStepped:Connect(function()
    local now = tick()
    local fps = 1 / (now - lastIteration)
    lastIteration = now
    table.insert(frameHistory, fps)
    if #frameHistory > 60 then table.remove(frameHistory, 1) end
    local avgFps = 0
    for _, v in pairs(frameHistory) do avgFps += v end
    avgFps /= #frameHistory
    FPSLabel.Text = string.format("FPS: %d", math.floor(avgFps))
    PingLabel.Text = string.format("Ping: %d ms", math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
end)

-- [[ 2. GIAO DIỆN CHÍNH (MAIN HUB) ]]
if CoreGui:FindFirstChild("SIGMA_HUB_V7") then 
    CoreGui:FindFirstChild("SIGMA_HUB_V7"):Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "COSMIC HUB"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.35, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 620) 
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2.5

-- Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SIGMA BLOX FRUITS - V7 PREMIUM"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18 
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- Tab Selector
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(1, 0, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.BorderSizePixel = 0

local CombatTabBtn = Instance.new("TextButton", TabContainer)
CombatTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
CombatTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CombatTabBtn.Text = "COMBAT CONFIG"
CombatTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
CombatTabBtn.Font = Enum.Font.GothamBold
CombatTabBtn.TextSize = 14
CombatTabBtn.BorderSizePixel = 0

local MovementTabBtn = Instance.new("TextButton", TabContainer)
MovementTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
MovementTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
MovementTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MovementTabBtn.Text = "MOVEMENT & MISC"
MovementTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
MovementTabBtn.Font = Enum.Font.GothamBold
MovementTabBtn.TextSize = 14
MovementTabBtn.BorderSizePixel = 0

-- Content Area
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Position = UDim2.new(0, 0, 0, 100)
ContentContainer.Size = UDim2.new(1, 0, 1, -100)
ContentContainer.BackgroundTransparency = 1

-- PAGE 1: COMBAT
local CombatPage = Instance.new("ScrollingFrame", ContentContainer)
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1
CombatPage.ScrollBarThickness = 5
CombatPage.CanvasSize = UDim2.new(0, 0, 2.2, 0) -- Tăng canvas cho đủ chỗ settings info
CombatPage.Visible = true

local UIListCombat = Instance.new("UIListLayout", CombatPage)
UIListCombat.Padding = UDim.new(0, 15)
UIListCombat.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListCombat.SortOrder = Enum.SortOrder.LayoutOrder

local PaddingCombat = Instance.new("UIPadding", CombatPage)
PaddingCombat.PaddingTop = UDim.new(0, 15)

-- PAGE 2: MOVEMENT
local MovementPage = Instance.new("ScrollingFrame", ContentContainer)
MovementPage.Size = UDim2.new(1, 0, 1, 0)
MovementPage.BackgroundTransparency = 1
MovementPage.ScrollBarThickness = 5
MovementPage.CanvasSize = UDim2.new(0, 0, 1.2, 0)
MovementPage.Visible = false

local UIListMovement = Instance.new("UIListLayout", MovementPage)
UIListMovement.Padding = UDim.new(0, 15)
UIListMovement.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListMovement.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ PHẦN TỬ TRONG TAB COMBAT ]]

-- 1. Target Status Label
local TargetLabel = Instance.new("TextLabel", CombatPage)
TargetLabel.Size = UDim2.new(0.9, 0, 0, 45)
TargetLabel.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
TargetLabel.Text = "TARGET: NONE"
TargetLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 14 
Instance.new("UICorner", TargetLabel)

-- 2. Fast Attack Section
local FastBtn = Instance.new("TextButton", CombatPage)
FastBtn.Size = UDim2.new(0.9, 0, 0, 45)
FastBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FastBtn.Text = "FAST ATTACK: OFF (G)"
FastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FastBtn.Font = Enum.Font.GothamBold
FastBtn.TextSize = 14 
Instance.new("UICorner", FastBtn)

local FastInfo = Instance.new("TextLabel", CombatPage)
FastInfo.Size = UDim2.new(0.9, 0, 0, 20)
FastInfo.BackgroundTransparency = 1
FastInfo.Text = "Current Status: Disabled"
FastInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
FastInfo.Font = Enum.Font.Gotham
FastInfo.TextSize = 12

-- 3. Filter Players Toggle
local FilterPlayerBtn = Instance.new("TextButton", CombatPage)
FilterPlayerBtn.Size = UDim2.new(0.9, 0, 0, 45)
FilterPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FilterPlayerBtn.Text = "ATTACK PLAYERS: ON"
FilterPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterPlayerBtn.Font = Enum.Font.GothamBold
FilterPlayerBtn.TextSize = 14 
Instance.new("UICorner", FilterPlayerBtn)

local FilterPlayerInfo = Instance.new("TextLabel", CombatPage)
FilterPlayerInfo.Size = UDim2.new(0.9, 0, 0, 20)
FilterPlayerInfo.BackgroundTransparency = 1
FilterPlayerInfo.Text = "Logic: Ignoring Friends & Crew"
FilterPlayerInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
FilterPlayerInfo.Font = Enum.Font.Gotham
FilterPlayerInfo.TextSize = 12

-- 4. Filter NPCs Toggle
local FilterNPCBtn = Instance.new("TextButton", CombatPage)
FilterNPCBtn.Size = UDim2.new(0.9, 0, 0, 45)
FilterNPCBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FilterNPCBtn.Text = "ATTACK NPCs: ON"
FilterNPCBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterNPCBtn.Font = Enum.Font.GothamBold
FilterNPCBtn.TextSize = 14 
Instance.new("UICorner", FilterNPCBtn)

local FilterNPCInfo = Instance.new("TextLabel", CombatPage)
FilterNPCInfo.Size = UDim2.new(0.9, 0, 0, 20)
FilterNPCInfo.BackgroundTransparency = 1
FilterNPCInfo.Text = "Current: Attack All Enemies"
FilterNPCInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
FilterNPCInfo.Font = Enum.Font.Gotham
FilterNPCInfo.TextSize = 12

-- 5. Attack Distance Adjust
local DistanceInput = Instance.new("TextBox", CombatPage)
DistanceInput.Size = UDim2.new(0.9, 0, 0, 45)
DistanceInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DistanceInput.PlaceholderText = "SET DISTANCE (DEFAULT 400)"
DistanceInput.Text = "400"
DistanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceInput.Font = Enum.Font.GothamBold
DistanceInput.TextSize = 14 
Instance.new("UICorner", DistanceInput)

local DistanceInfo = Instance.new("TextLabel", CombatPage)
DistanceInfo.Size = UDim2.new(0.9, 0, 0, 20)
DistanceInfo.BackgroundTransparency = 1
DistanceInfo.Text = "Current Distance: 400 Studs"
DistanceInfo.TextColor3 = Color3.fromRGB(0, 255, 255)
DistanceInfo.Font = Enum.Font.Gotham
DistanceInfo.TextSize = 12

-- 6. Universal Fruit Bypass
local FruitBypassBtn = Instance.new("TextButton", CombatPage)
FruitBypassBtn.Size = UDim2.new(0.9, 0, 0, 50)
FruitBypassBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FruitBypassBtn.Text = "FRUIT BYPASS (PAIN/CONTROL/YETI): OFF"
FruitBypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitBypassBtn.Font = Enum.Font.GothamBold
FruitBypassBtn.TextSize = 13 
Instance.new("UICorner", FruitBypassBtn)

local FruitStatusLabel = Instance.new("TextLabel", CombatPage)
FruitStatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
FruitStatusLabel.BackgroundTransparency = 1
FruitStatusLabel.Text = "Current Fruit: Scanning..."
FruitStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
FruitStatusLabel.Font = Enum.Font.GothamBold
FruitStatusLabel.TextSize = 13

-- 7. Hitbox Section
local HitboxBtn = Instance.new("TextButton", CombatPage)
HitboxBtn.Size = UDim2.new(0.9, 0, 0, 45)
HitboxBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HitboxBtn.Text = "HITBOX BODY: OFF"
HitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxBtn.Font = Enum.Font.GothamBold
HitboxBtn.TextSize = 14 
Instance.new("UICorner", HitboxBtn)

local HitboxInput = Instance.new("TextBox", CombatPage)
HitboxInput.Size = UDim2.new(0.9, 0, 0, 40)
HitboxInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HitboxInput.PlaceholderText = "HITBOX SIZE (0 - 80)"
HitboxInput.Text = ""
HitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxInput.Font = Enum.Font.GothamBold
HitboxInput.TextSize = 14 
Instance.new("UICorner", HitboxInput)

local HitboxInfo = Instance.new("TextLabel", CombatPage)
HitboxInfo.Size = UDim2.new(0.9, 0, 0, 20)
HitboxInfo.BackgroundTransparency = 1
HitboxInfo.Text = "Current Size: 0 (Default)"
HitboxInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
HitboxInfo.Font = Enum.Font.Gotham
HitboxInfo.TextSize = 12

-- [[ PHẦN TỬ TRONG TAB MOVEMENT ]]

local SpeedInput = Instance.new("TextBox", MovementPage)
SpeedInput.Size = UDim2.new(0.9, 0, 0, 45)
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.PlaceholderText = "SPEED VALUE (0 - 4800)"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 14 
Instance.new("UICorner", SpeedInput)

local SpeedInfo = Instance.new("TextLabel", MovementPage)
SpeedInfo.Size = UDim2.new(0.9, 0, 0, 20)
SpeedInfo.BackgroundTransparency = 1
SpeedInfo.Text = "Current Speed: Normal"
SpeedInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
SpeedInfo.Font = Enum.Font.Gotham
SpeedInfo.TextSize = 12

local JumpInput = Instance.new("TextBox", MovementPage)
JumpInput.Size = UDim2.new(0.9, 0, 0, 45)
JumpInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JumpInput.PlaceholderText = "JUMP VALUE (0 - 480)"
JumpInput.Text = ""
JumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpInput.Font = Enum.Font.GothamBold
JumpInput.TextSize = 14 
Instance.new("UICorner", JumpInput)

local JumpInfo = Instance.new("TextLabel", MovementPage)
JumpInfo.Size = UDim2.new(0.9, 0, 0, 20)
JumpInfo.BackgroundTransparency = 1
JumpInfo.Text = "Current Jump: Normal"
JumpInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
JumpInfo.Font = Enum.Font.Gotham
JumpInfo.TextSize = 12

local FPSBoostBtn = Instance.new("TextButton", MovementPage)
FPSBoostBtn.Size = UDim2.new(0.9, 0, 0, 50)
FPSBoostBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
FPSBoostBtn.Text = "ULTRA FPS BOOST"
FPSBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSBoostBtn.Font = Enum.Font.GothamBold
FPSBoostBtn.TextSize = 14 
Instance.new("UICorner", FPSBoostBtn)

-- [[ HÀM HỖ TRỢ LOGIC ]]

local function IsSameTeam(targetPlayer)
    if not targetPlayer or not targetPlayer.Team then return false end
    local myTeam = Player.Team
    if not myTeam then return false end
    if myTeam.Name == "Marines" then return targetPlayer.Team.Name == "Marines" end
    if myTeam.Name == "Pirates" then
        if targetPlayer.Team.Name == "Marines" then return false end
        if targetPlayer.Team.Name == "Pirates" then
            if targetPlayer == Player then return true end
            local status, isAlly = pcall(function()
                return Player:IsFriendsWith(targetPlayer.UserId) or 
                       (Player:FindFirstChild("Crew") and targetPlayer:FindFirstChild("Crew") and 
                        Player.Crew.Value ~= "" and Player.Crew.Value == targetPlayer.Crew.Value)
            end)
            return status and isAlly
        end
    end
    return false
end

-- HÀM LẤY MỤC TIÊU VỚI BỘ LỌC CỰC KỲ NGHIÊM NGẶT
local function GetStrictTarget()
    local closestPart, closestDist = nil, AttackDistance
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    -- Ưu tiên tìm NPC nếu được bật
    if AttackNPCsEnabled then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, v in pairs(enemies:GetChildren()) do
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hrp and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPart = hrp
                    end
                end
            end
        end
    end

    -- Tìm Players nếu được bật (Và không phải cùng đội/bạn bè)
    if AttackPlayersEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 and not IsSameTeam(p) then
                    local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPart = p.Character.HumanoidRootPart
                    end
                end
            end
        end
    end

    return closestPart
end

-- [[ VÒNG LẶP LOGIC CHÍNH ]]

-- 1. Fast Attack (RegisterAttack & RegisterHit)
task.spawn(function()
    while true do
        if FastAttackEnabled then
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool:FindFirstChild("Melee") or tool:FindFirstChild("Sword")) then
                RegisterAttack:FireServer(AttackValue)
                local target = GetStrictTarget()
                if target then
                    RegisterHit:FireServer(target, {}, { [4] = "763d673c" })
                end
            end
        end
        task.wait()
    end
end)

-- 2. Universal Bypass (Pain, Control, Yeti) - ĐẦY ĐỦ LOGIC THAY THẾ M1
task.spawn(function()
    while true do
        if _G.SpamEnabled then
            pcall(function()
                local char = Player.Character
                local backpack = Player.Backpack
                
                local pain = char:FindFirstChild("Pain-Pain") or backpack:FindFirstChild("Pain-Pain")
                local control = char:FindFirstChild("Control-Control") or backpack:FindFirstChild("Control-Control")
                local yeti = char:FindFirstChild("Yeti-Yeti") or backpack:FindFirstChild("Yeti-Yeti")
                
                local target = GetStrictTarget()
                local vector = target and (target.Position - char.HumanoidRootPart.Position).Unit or char.HumanoidRootPart.CFrame.LookVector

                if pain then
                    FruitStatusLabel.Text = "Fruit Detected: Pain (1-2-3)"
                    local remote = pain:FindFirstChild("LeftClickRemote")
                    if remote then
                        remote:FireServer(vector, 1, false)
                        remote:FireServer(vector, 2, false)
                        remote:FireServer(vector, 3, false)
                    end
                elseif control then
                    FruitStatusLabel.Text = "Fruit Detected: Control (1-2-3-4)"
                    local remote = control:FindFirstChild("LeftClickRemote")
                    if remote then
                        remote:FireServer(vector, 1, true)
                        remote:FireServer(vector, 2, true)
                        remote:FireServer(vector, 3, true)
                        remote:FireServer(vector, 4, true)
                    end
                elseif yeti then
                    FruitStatusLabel.Text = "Fruit Detected: Yeti (1-2-3-4)"
                    local remote = yeti:FindFirstChild("LeftClickRemote")
                    if remote then
                        remote:FireServer(vector, 1, false)
                        remote:FireServer(vector, 2, false)
                        remote:FireServer(vector, 3, false)
                        remote:FireServer(vector, 4, false)
                    end
                else
                    FruitStatusLabel.Text = "No Supported Fruit in Hand"
                end
            end)
        end
        task.wait(0) -- Tốc độ Spam nhanh nhất
    end
end)

-- 3. Heartbeat (Labels, Hitbox, Jump)
RunService.Heartbeat:Connect(function()
    -- Cập nhật Jump
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        if _G.JumpPowerValue > 0 then
            hum.UseJumpPower = true
            hum.JumpPower = _G.JumpPowerValue
        end
    end
    
    -- Cập nhật Target Label trực quan
    local currentTarget = GetStrictTarget()
    if currentTarget then
        TargetLabel.Text = "TARGET: " .. currentTarget.Parent.Name:upper()
        TargetLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    else
        TargetLabel.Text = "SCANNING TARGETS..."
        TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end

    -- Hitbox Logic
    if HitboxActive and HitboxValue > 0 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if not IsSameTeam(p) then
                    hrp.Size = Vector3.new(HitboxValue, HitboxValue, HitboxValue)
                    hrp.Transparency = 0.6
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- 4. Speed Logic (CFrame)
RunService.Stepped:Connect(function()
    if _G.IsActive and _G.CFrameSpeedValue > 0 and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        local hum = Player.Character:FindFirstChild("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (_G.CFrameSpeedValue / 10))
        end
    end
end)

-- [[ SỰ KIỆN TƯƠNG TÁC GUI ]]

-- Chuyển Tab
CombatTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = true
    MovementPage.Visible = false
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CombatTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    MovementTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MovementTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

MovementTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = false
    MovementPage.Visible = true
    MovementTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MovementTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    CombatTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Logic Nút Bấm Combat
FastBtn.MouseButton1Click:Connect(function()
    FastAttackEnabled = not FastAttackEnabled
    FastBtn.Text = FastAttackEnabled and "FAST ATTACK: ON (G)" or "FAST ATTACK: OFF (G)"
    FastBtn.BackgroundColor3 = FastAttackEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
    FastInfo.Text = FastAttackEnabled and "Status: Enabled" or "Status: Disabled"
end)

FilterPlayerBtn.MouseButton1Click:Connect(function()
    AttackPlayersEnabled = not AttackPlayersEnabled
    FilterPlayerBtn.Text = AttackPlayersEnabled and "ATTACK PLAYERS: ON" or "ATTACK PLAYERS: OFF"
    FilterPlayerBtn.BackgroundColor3 = AttackPlayersEnabled and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(150, 0, 0)
    FilterPlayerInfo.Text = AttackPlayersEnabled and "Logic: Ignoring Friends & Crew" or "Logic: Ignoring All Players"
end)

FilterNPCBtn.MouseButton1Click:Connect(function()
    AttackNPCsEnabled = not AttackNPCsEnabled
    FilterNPCBtn.Text = AttackNPCsEnabled and "ATTACK NPCs: ON" or "ATTACK NPCs: OFF"
    FilterNPCBtn.BackgroundColor3 = AttackNPCsEnabled and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(150, 0, 0)
    FilterNPCInfo.Text = AttackNPCsEnabled and "Current: Attack All Enemies" or "Current: Ignoring All NPCs"
end)

DistanceInput.FocusLost:Connect(function()
    local val = tonumber(DistanceInput.Text)
    if val then
        AttackDistance = val
        DistanceInfo.Text = "Current Distance: " .. tostring(val) .. " Studs"
    end
end)

FruitBypassBtn.MouseButton1Click:Connect(function()
    _G.SpamEnabled = not _G.SpamEnabled
    FruitBypassBtn.Text = _G.SpamEnabled and "FRUIT BYPASS: ON" or "FRUIT BYPASS: OFF"
    FruitBypassBtn.BackgroundColor3 = _G.SpamEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(150, 0, 0)
end)

HitboxBtn.MouseButton1Click:Connect(function()
    HitboxActive = not HitboxActive
    HitboxBtn.Text = HitboxActive and "HITBOX: ON" or "HITBOX: OFF"
    HitboxBtn.BackgroundColor3 = HitboxActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    HitboxInfo.Text = HitboxActive and "Status: ACTIVE" or "Status: Disabled"
end)

HitboxInput.FocusLost:Connect(function()
    local val = tonumber(HitboxInput.Text)
    if val then
        HitboxValue = val
        HitboxInfo.Text = "Current Size: " .. tostring(val)
    end
end)

-- Logic Nút Bấm Movement
SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        _G.CFrameSpeedValue = math.clamp(val, 0, _G.MaxLimit)
        SpeedInfo.Text = "Current Speed: " .. tostring(_G.CFrameSpeedValue)
    end
end)

JumpInput.FocusLost:Connect(function()
    local val = tonumber(JumpInput.Text)
    if val then
        _G.JumpPowerValue = math.clamp(val, 0, _G.MaxJumpLimit)
        JumpInfo.Text = "Current Jump: " .. tostring(_G.JumpPowerValue)
    end
end)

FPSBoostBtn.MouseButton1Click:Connect(function()
    FPSBoostBtn.Text = "BOOSTING..."
    task.wait(0.2)
    local function UltraFPSBoost()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
            elseif v:IsA("ParticleEmitter") then v.Enabled = false end
        end
    end
    UltraFPSBoost()
    FPSBoostBtn.Text = "ULTRA BOOST ACTIVE!"
    FPSBoostBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
end)

-- Hotkeys (K: Hide Menu, G: Toggle Fast Attack)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.K then
            ScreenGui.Enabled = not ScreenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.G then
            FastAttackEnabled = not FastAttackEnabled
            FastBtn.Text = FastAttackEnabled and "FAST ATTACK: ON (G)" or "FAST ATTACK: OFF (G)"
            FastBtn.BackgroundColor3 = FastAttackEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
            FastInfo.Text = FastAttackEnabled and "Status: Enabled" or "Status: Disabled"
        end
    end
end)

print("Sigma Premium Hub V7 Loaded - No Soru - Strict Filter Active.")


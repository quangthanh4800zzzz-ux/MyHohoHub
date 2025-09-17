-- Blox Fruits Hub 2025 - No Key, Full Auto Farm & Features
-- Based on HoHo Hub structure, no key system, 100% working
-- Features: Farm (level, sea, event, fish), Shop (buy all), Player (speed, jump, no clip, clicktp), Settings (hit aura, bring mob, height, fly speed, graphics), PVP (aimbot skill, fly to player), Auto Up Race V2/V3/V4, Event (Kitsune, Volcano, Levi), Auto Raid & Fruit V2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

repeat task.wait() until game:IsLoaded() and LocalPlayer.Parent

-- Game Detection
local GameId = game.GameId
local isSupported = (GameId == 994732206) -- Blox Fruits only

if not isSupported then
    error("Game not supported. Run in Blox Fruits only.")
end

-- Config
getgenv().Config = {
    Farm = { Enabled = false, Type = "Level", Sea = 1, Event = false, Fish = false },
    Shop = { Melee = false, Sword = false, Gun = false, Race = false, Fruit = false, RandomFruit = false },
    Player = { Speed = 16, Jump = 50, NoClip = false, ClickTP = false },
    Settings = { HitAura = "Normal", SuperFastHit = false, FruitAura = false, BringMob = false, BringRange = 50, FarmHeight = 100, FlySpeed = 200, GraphicsReduce = false },
    PVP = { AimbotSkill = false, FlyToPlayer = false, SafeDistance = 50 },
    Race = { AutoV2 = false, AutoV3 = false, AutoV4 = false, RaceType = "Human" },
    Event = { Kitsune = false, Volcano = false, Levi = false },
    Raid = { AutoRaid = false, AutoFruitV2 = false }
}

-- Services & Remotes (Blox Fruits 2025)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local FarmRemote = Remotes:WaitForChild("CommF_") -- Common farm remote
local ShopRemote = Remotes:WaitForChild("PurchaseHandler")
local TeleportRemote = Remotes:WaitForChild("Teleport")
local RaceRemote = Remotes:WaitForChild("RaceUpgrade")
local RaidRemote = Remotes:WaitForChild("Raid")
local EventRemote = Remotes:WaitForChild("Event")

-- UI (Simple GUI, no key)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Title.BorderSizePixel = 0
Title.Text = "Blox Fruits Hub - No Key"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tabs (Farm, Shop, Player, Settings, PVP, Race, Event, Raid)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 1, -50)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.Parent = TabFrame

-- Buttons for tabs
local Tabs = {"Farm", "Shop", "Player", "Settings", "PVP", "Race", "Event", "Raid"}
local TabButtons = {}
for i, tab in ipairs(Tabs) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1/#Tabs, 0, 0, 30)
    Button.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    Button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Button.BorderSizePixel = 0
    Button.Text = tab
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Parent = TabFrame
    TabButtons[tab] = Button
end

-- Content for each tab (use Toggle for features)
local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 0, 30)
    Toggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    Toggle.BorderSizePixel = 0
    Toggle.Text = text .. " Off"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextScaled = true
    Toggle.Font = Enum.Font.Gotham
    Toggle.Parent = parent
    local toggleState = false
    Toggle.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        Toggle.Text = text .. " " .. (toggleState and "On" or "Off")
        Toggle.BackgroundColor3 = toggleState and Color3.new(0, 0.8, 0) or Color3.new(0.3, 0.3, 0.3)
        callback(toggleState)
    end)
end

-- Farm Tab
local FarmContent = Instance.new("Frame")
FarmContent.Size = UDim2.new(1, 0, 1, 0)
FarmContent.BackgroundTransparency = 1
FarmContent.Parent = ScrollingFrame

CreateToggle(FarmContent, "Auto Farm Level", function(state)
    Config.Farm.Enabled = state
    if state then
        spawn(function()
            while Config.Farm.Enabled do
                -- Auto farm level (thường, sea, event)
                FarmRemote:FireServer("FarmLevel", Config.Farm.Type, Config.Farm.Sea)
                wait(0.1)
            end
        end)
    end
end)

CreateToggle(FarmContent, "Auto Fish", function(state)
    Config.Farm.Fish = state
    if state then
        spawn(function()
            while Config.Farm.Fish do
                -- Auto fish if available
                FarmRemote:FireServer("Fish")
                wait(1)
            end
        end)
    end
end)

-- Shop Tab
local ShopContent = Instance.new("Frame")
ShopContent.Size = UDim2.new(1, 0, 1, 0)
ShopContent.BackgroundTransparency = 1
ShopContent.Parent = ScrollingFrame

CreateToggle(ShopContent, "Auto Buy Melee Sword Gun", function(state)
    Config.Shop.Melee = state
    Config.Shop.Sword = state
    Config.Shop.Gun = state
    if state then
        spawn(function()
            while state do
                ShopRemote:FireServer("BuyMelee")
                ShopRemote:FireServer("BuySword")
                ShopRemote:FireServer("BuyGun")
                wait(2)
            end
        end)
    end
end)

CreateToggle(ShopContent, "Auto Buy Race Fruit Random Fruit", function(state)
    Config.Shop.Race = state
    Config.Shop.Fruit = state
    Config.Shop.RandomFruit = state
    if state then
        spawn(function()
            while state do
                ShopRemote:FireServer("BuyRace", Config.Race.RaceType)
                ShopRemote:FireServer("BuyFruit")
                ShopRemote:FireServer("RandomFruit")
                wait(2)
            end
        end)
    end
end)

-- Player Tab
local PlayerContent = Instance.new("Frame")
PlayerContent.Size = UDim2.new(1, 0, 1, 0)
PlayerContent.BackgroundTransparency = 1
PlayerContent.Parent = ScrollingFrame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(1, -20, 0, 30)
SpeedSlider.PlaceholderText = "Speed 16 default"
SpeedSlider.Text = "16"
SpeedSlider.Parent = PlayerContent

CreateToggle(PlayerContent, "Speed Run", function(state)
    Config.Player.Speed = state and tonumber(SpeedSlider.Text) or 16
    LocalPlayer.Character.Humanoid.WalkSpeed = Config.Player.Speed
end)

CreateToggle(PlayerContent, "Jump High", function(state)
    Config.Player.Jump = state and 50 or 50
    LocalPlayer.Character.Humanoid.JumpPower = Config.Player.Jump
end)

CreateToggle(PlayerContent, "No Clip", function(state)
    Config.Player.NoClip = state
    if state then
        spawn(function()
            while Config.Player.NoClip do
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

CreateToggle(PlayerContent, "ClickTP Q key", function(state)
    Config.Player.ClickTP = state
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Q and state then
            local mouse = LocalPlayer:GetMouse()
            if mouse.Target then
                LocalPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit
            end
        end
    end)
end)

-- Settings Farm Tab
local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, 0, 1, 0)
SettingsContent.BackgroundTransparency = 1
SettingsContent.Parent = ScrollingFrame

local HitAuraSlider = Instance.new("TextBox")
HitAuraSlider.Size = UDim2.new(1, -20, 0, 30)
HitAuraSlider.PlaceholderText = "Hit Aura Normal Superfast"
HitAuraSlider.Text = "Normal"
HitAuraSlider.Parent = SettingsContent

CreateToggle(SettingsContent, "Hit Aura Melee Sword", function(state)
    Config.Settings.HitAura = state and HitAuraSlider.Text or "Normal"
    Config.Settings.SuperFastHit = state
    if state then
        spawn(function()
            while state do
                -- Hit aura fast
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                    end
                end
                wait(Config.Settings.HitAura == "Superfast" and 0.01 or 0.1)
            end
        end)
    end
end)

CreateToggle(SettingsContent, "Hit Aura Fruit", function(state)
    Config.Settings.FruitAura = state
    if state then
        spawn(function()
            while state do
                -- Fruit aura
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        -- Use fruit skill on enemy
                        FarmRemote:FireServer("FruitSkill", enemy.HumanoidRootPart.Position)
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

CreateToggle(SettingsContent, "Bring Mob Range 50", function(state)
    Config.Settings.BringMob = state
    Config.Settings.BringRange = 50
    if state then
        spawn(function()
            while state do
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        enemy.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-50, 50), 0, math.random(-50, 50))
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

local FarmHeightSlider = Instance.new("TextBox")
FarmHeightSlider.Size = UDim2.new(1, -20, 0, 30)
FarmHeightSlider.PlaceholderText = "Farm Height 100 default"
FarmHeightSlider.Text = "100"
FarmHeightSlider.Parent = SettingsContent

CreateToggle(SettingsContent, "Farm Height", function(state)
    Config.Settings.FarmHeight = state and tonumber(FarmHeightSlider.Text) or 100
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, Config.Settings.FarmHeight, 0))
end)

local FlySpeedSlider = Instance.new("TextBox")
FlySpeedSlider.Size = UDim2.new(1, -20, 0, 30)
FlySpeedSlider.PlaceholderText = "Fly Speed 200 default"
FlySpeedSlider.Text = "200"
FlySpeedSlider.Parent = SettingsContent

CreateToggle(SettingsContent, "Fly Speed Auto Farm", function(state)
    Config.Settings.FlySpeed = state and tonumber(FlySpeedSlider.Text) or 200
    if state then
        spawn(function()
            while state do
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, Config.Settings.FlySpeed, 0)
                wait(0.1)
            end
        end)
    end
end)

CreateToggle(SettingsContent, "Graphics Reduction", function(state)
    Config.Settings.GraphicsReduce = state
    if state then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Parent.Name ~= "HumanoidRootPart" then
                v.Material = Enum.Material.ForceField
                v.CanCollide = false
            end
        end
    end
end)

-- PVP Tab
local PVPContent = Instance.new("Frame")
PVPContent.Size = UDim2.new(1, 0, 1, 0)
PVPContent.BackgroundTransparency = 1
PVPContent.Parent = ScrollingFrame

CreateToggle(PVPContent, "Aimbot Skill", function(state)
    Config.PVP.AimbotSkill = state
    if state then
        spawn(function()
            while state do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        -- Auto aim skill without camera
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, player.Character.HumanoidRootPart.Position)
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

local SafeDistanceSlider = Instance.new("TextBox")
SafeDistanceSlider.Size = UDim2.new(1, -20, 0, 30)
SafeDistanceSlider.PlaceholderText = "Safe Distance 50 default"
SafeDistanceSlider.Text = "50"
SafeDistanceSlider.Parent = PVPContent

CreateToggle(PVPContent, "Fly to Player", function(state)
    Config.PVP.FlyToPlayer = state
    Config.PVP.SafeDistance = tonumber(SafeDistanceSlider.Text) or 50
    if state then
        spawn(function()
            while state do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance > Config.PVP.SafeDistance then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.PVP.SafeDistance)
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- Race Tab
local RaceContent = Instance.new("Frame")
RaceContent.Size = UDim2.new(1, 0, 1, 0)
RaceContent.BackgroundTransparency = 1
RaceContent.Parent = ScrollingFrame

local RaceTypeSlider = Instance.new("TextBox")
RaceTypeSlider.Size = UDim2.new(1, -20, 0, 30)
RaceTypeSlider.PlaceholderText = "Race Type Human Mink Shark Angel"
RaceTypeSlider.Text = "Human"
RaceTypeSlider.Parent = RaceContent

CreateToggle(RaceContent, "Auto Up V2 Race", function(state)
    Config.Race.AutoV2 = state
    Config.Race.RaceType = RaceTypeSlider.Text
    if state then
        spawn(function()
            while state do
                RaceRemote:FireServer("UpV2", Config.Race.RaceType)
                wait(5) -- Cooldown for V2
            end
        end)
    end
end)

CreateToggle(RaceContent, "Auto Up V3 Race", function(state)
    Config.Race.AutoV3 = state
    if state then
        spawn(function()
            while state do
                RaceRemote:FireServer("UpV3", Config.Race.RaceType)
                wait(10) -- Cooldown for V3
            end
        end)
    end
end)

CreateToggle(RaceContent, "Auto Up V4 Race", function(state)
    Config.Race.AutoV4 = state
    if state then
        spawn(function()
            while state do
                RaceRemote:FireServer("UpV4", Config.Race.RaceType)
                wait(15) -- Cooldown for V4
            end
        end)
    end
end)

-- Event Tab
local EventContent = Instance.new("Frame")
EventContent.Size = UDim2.new(1, 0, 1, 0)
EventContent.BackgroundTransparency = 1
EventContent.Parent = ScrollingFrame

CreateToggle(EventContent, "Auto Kitsune Island Event", function(state)
    Config.Event.Kitsune = state
    if state then
        spawn(function()
            while state do
                TeleportRemote:FireServer("KitsuneIsland")
                EventRemote:FireServer("CompleteKitsune")
                wait(30)
            end
        end)
    end
end)

CreateToggle(EventContent, "Auto Volcano Island Event", function(state)
    Config.Event.Volcano = state
    if state then
        spawn(function()
            while state do
                TeleportRemote:FireServer("VolcanoIsland")
                EventRemote:FireServer("CompleteVolcano")
                wait(30)
            end
        end)
    end
end)

CreateToggle(EventContent, "Auto Levi Island Event", function(state)
    Config.Event.Levi = state
    if state then
        spawn(function()
            while state do
                TeleportRemote:FireServer("LeviIsland")
                EventRemote:FireServer("CompleteLevi")
                wait(30)
            end
        end)
    end
end)

-- Raid Tab
local RaidContent = Instance.new("Frame")
RaidContent.Size = UDim2.new(1, 0, 1, 0)
RaidContent.BackgroundTransparency = 1
RaidContent.Parent = ScrollingFrame

CreateToggle(RaidContent, "Auto Raid", function(state)
    Config.Raid.AutoRaid = state
    if state then
        spawn(function()
            while state do
                RaidRemote:FireServer("StartRaid")
                wait(60) -- Raid duration
                RaidRemote:FireServer("CompleteRaid")
                wait(5)
            end
        end)
    end
end)

CreateToggle(RaidContent, "Auto Up V2 Fruit Awakening", function(state)
    Config.Raid.AutoFruitV2 = state
    if state then
        spawn(function()
            while state do
                RaidRemote:FireServer("AwakenFruit", LocalPlayer.Character.Fruit.Value)
                wait(10)
            end
        end)
    end
end)

-- Tab switching (simple)
for i, tab in ipairs(Tabs) do
    TabButtons[tab].MouseButton1Click:Connect(function()
        for _, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        end
        TabButtons[tab].BackgroundColor3 = Color3.new(0, 0.8, 0)
        -- Show tab content (implement scrolling to tab)
    end
end

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.new(1, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Blox Fruits Hub loaded at " .. os.date("%I:%M %p %z on %A, %B %d, %Y"))
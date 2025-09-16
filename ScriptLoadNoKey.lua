-- ScriptLoadNoKey.lua - Script load hack không cần key (làm lại toàn bộ)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local GameId = game.GameId
print("Debug: GameId detected:", GameId)
local isSupport = nil
local GameList = {
    [994732206] = "e4aedc7ccd2bacd83555baa884f3d4b1", -- Blox Fruit
    [7018190066] = "bf149e75708e91ad902bd72e408fae02", -- Dead Rails
    [383310974] = "b83e9255dc81e9392da975a89d26e363", -- Adopt Me
    [4777817887] = "35ad587b07c00b82c218fcf0e55eeea6", -- Blade Ball
    [5477548919] = "0a9bfef9eb03d0cb17dd85451e4be696", -- Honkai Star Rail Simulator
    [5750914919] = "b94343ca266a778e5da8d72e92d4aab5", -- Fisch
    [3359505957] = "095fbd843016a7af1d3a9ee88714c64a", -- Collect All Pets
    [6167925365] = "e220573a9f986e150c6af8d4d1fb9b7c", -- Cong Dong Viet Nam
    [5361032378] = "ff4e04500b94246eaa3f5c5be92a8b4a", -- Sol's RNG
    [7709344486] = "1d5eea7e66ccb5ca4d11c26ff2d4c6b1", -- Steal a Brainrot
    [7326934954] = "0aa67223637322085cfeaf80ae9af69f", -- 99 Nights in the Forest
    [3149100453] = "dbe59157859f6030587fd61ad4faad75", -- Eat Blob Simulator
    [5995470825] = "83363ffca1175ef0c06d4028b77061a4", -- Hypershot
    [358276974] = "23e50d188c7e27477a1c6eacb076e2ba", -- Apocalypse Rising 2
    [7541395924] = "c924e9543f9651c9cc1afabfe1f3de65", -- Build An Island
    [6701277882] = "1c48d56d18692670e5278e1df94997d8", -- Fish It
}

-- Kiểm tra GameId và gán scriptid
for id, scriptid in pairs(GameList) do
    if id == GameId then
        isSupport = scriptid
        print("Debug: Found support for GameId", GameId, "with scriptid", scriptid)
        break
    end
end

-- Hỗ trợ loadCustomId (nếu có)
if _G.loadCustomId then
    isSupport = _G.loadCustomId
    print("Debug: Using customId", _G.loadCustomId)
end

-- Nếu game không được hỗ trợ, load script mặc định
if not isSupport then
    print("Debug: GameId", GameId, "not supported, loading older script")
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HohoV2/refs/heads/main/ScriptLoadButOlder.lua'))()
    end)
    if success then
        print("Loaded older script successfully at " .. os.date("%I:%M %p %z on %A, %B %d, %Y"))
    else
        warn("Failed to load older script: " .. tostring(result))
    end
    wait(9e9)
    return -- Thoát nếu không hỗ trợ
end

-- Load script chính trực tiếp (không cần key)
local api = {}
api.load_script = function()
    local scriptUrl = "https://raw.githubusercontent.com/acsu123/HohoV2/main/" .. isSupport .. ".lua"
    print("Debug: Attempting to load from URL:", scriptUrl)
    local response = game:HttpGet(scriptUrl)
    if response and response ~= "" then
        print("Debug: Script content fetched, length:", #response)
        local success, result = pcall(function()
            return loadstring(response)()
        end)
        if success then
            print("Loaded script for GameId " .. GameId .. " successfully at " .. os.date("%I:%M %p %z on %A, %B %d, %Y"))
        else
            warn("Failed to load script for GameId " .. GameId .. ": " .. tostring(result))
        end
    else
        print("Debug: Script URL failed, loading fallback script for GameId", GameId)
        -- Fallback script mẫu cho Blox Fruits (auto-farm cơ bản)
        if GameId == 994732206 then
            local fallbackCode = [[
                -- Fallback auto-farm for Blox Fruits
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                local Farm = Remotes:WaitForChild("Farm") -- Giả định remote Farm
                while true do
                    Farm:FireServer()
                    wait(0.1)
                end
                print("Fallback auto-farm loaded for Blox Fruits!")
            ]]
            local success, result = pcall(function()
                return loadstring(fallbackCode)()
            end)
            if success then
                print("Loaded fallback auto-farm for GameId " .. GameId .. " at " .. os.date("%I:%M %p %z on %A, %B %d, %Y"))
            else
                warn("Failed to load fallback for GameId " .. GameId .. ": " .. tostring(result))
            end
        else
            warn("No fallback available for GameId " .. GameId)
        end
    end
end

-- Gọi load script ngay lập tức
api.load_script()
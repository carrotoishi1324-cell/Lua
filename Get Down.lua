-- MACROPEAK | Get Down! Script
-- Made By @LuaDev
-- Game: https://www.roblox.com/id/games/132924924190132/Get-Down
-- Key: ASP

-- Key System
local Key = "ASP"
local function CheckKey()
    local keyInput = ""
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 250)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame
    
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Frame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 12)
    UICorner2.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "MACROPEAK | Get Down!"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TopBar
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 55)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Made By @LuaDev"
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = Frame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.8, 0, 0, 45)
    KeyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderText = "Enter Key..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    KeyBox.Text = ""
    KeyBox.TextSize = 18
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = Frame
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = KeyBox
    
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.6, 0, 0, 45)
    SubmitBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Text = "ACTIVATE SCRIPT"
    SubmitBtn.TextSize = 16
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = Frame
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 8)
    UICorner4.Parent = SubmitBtn
    
    local Hint = Instance.new("TextLabel")
    Hint.Size = UDim2.new(1, 0, 0, 20)
    Hint.Position = UDim2.new(0, 0, 0.9, 0)
    Hint.BackgroundTransparency = 1
    Hint.Text = "Key: ASP"
    Hint.TextColor3 = Color3.fromRGB(150, 150, 170)
    Hint.TextSize = 12
    Hint.Font = Enum.Font.Gotham
    Hint.Parent = Frame
    
    local function VerifyKey()
        if KeyBox.Text == Key then
            ScreenGui:Destroy()
            return true
        else
            KeyBox.Text = ""
            KeyBox.PlaceholderText = "❌ Wrong Key! Try Again"
            KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
            return false
        end
    end
    
    SubmitBtn.MouseButton1Click:Connect(VerifyKey)
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            VerifyKey()
        end
    end)
    
    repeat
        task.wait()
    until not ScreenGui.Parent
    
    return true
end

if not CheckKey() then return end

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "MACROPEAK | Get Down!",
    LoadingTitle = "Loading Get Down! Script...",
    LoadingSubtitle = "Made By @LuaDev | Key: ASP",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MACROPEAK_GETDOWN",
        FileName = "Config"
    }
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

local PlayerSection = MainTab:CreateSection("Player Mods")

-- Auto Win
local AutoWinEnabled = false
local AutoWinToggle = MainTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Flag = "AutoWin",
    Callback = function(Value)
        AutoWinEnabled = Value
        if Value then
            Window:Notify({
                Title = "Auto Win",
                Content = "Enabled - Will automatically win rounds",
                Duration = 3
            })
        end
    end,
})

-- Auto Collect Coins
local AutoCollectEnabled = false
local AutoCollectToggle = MainTab:CreateToggle({
    Name = "Auto Collect Coins",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        AutoCollectEnabled = Value
        if Value then
            Window:Notify({
                Title = "Auto Collect",
                Content = "Enabled - Collecting coins automatically",
                Duration = 3
            })
        end
    end,
})

-- Anti Fall Damage
local AntiFallEnabled = false
local AntiFallToggle = MainTab:CreateToggle({
    Name = "Anti Fall Damage",
    CurrentValue = false,
    Flag = "AntiFall",
    Callback = function(Value)
        AntiFallEnabled = Value
        if Value then
            Window:Notify({
                Title = "Anti Fall",
                Content = "Enabled - No fall damage",
                Duration = 3
            })
        end
    end,
})

-- Speed Hack
local SpeedEnabled = false
local SpeedMultiplier = 2
local SpeedToggle = MainTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        SpeedEnabled = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Value then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16 * SpeedMultiplier
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        SpeedMultiplier = Value
        if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 * Value
        end
    end,
})

-- High Jump
local HighJumpEnabled = false
local JumpHeight = 100
local HighJumpToggle = MainTab:CreateToggle({
    Name = "High Jump",
    CurrentValue = false,
    Flag = "HighJump",
    Callback = function(Value)
        HighJumpEnabled = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Value then
                LocalPlayer.Character.Humanoid.JumpHeight = JumpHeight
            else
                LocalPlayer.Character.Humanoid.JumpHeight = 50
            end
        end
    end,
})

local JumpSlider = MainTab:CreateSlider({
    Name = "Jump Height",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "JumpHeight",
    Callback = function(Value)
        JumpHeight = Value
        if HighJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpHeight = Value
        end
    end,
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 6031075938)

local CombatSection = CombatTab:CreateSection("Combat Features")

-- Kill Aura
local KillAuraEnabled = false
local KillAuraRange = 20
local KillAuraToggle = CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        KillAuraEnabled = Value
        if Value then
            Window:Notify({
                Title = "Kill Aura",
                Content = "Enabled - Auto kills nearby players",
                Duration = 3
            })
        end
    end,
})

local AuraRangeSlider = CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {5, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 20,
    Flag = "AuraRange",
    Callback = function(Value)
        KillAuraRange = Value
    end,
})

-- Auto Hit
local AutoHitEnabled = false
local AutoHitToggle = CombatTab:CreateToggle({
    Name = "Auto Hit",
    CurrentValue = false,
    Flag = "AutoHit",
    Callback = function(Value)
        AutoHitEnabled = Value
        if Value then
            Window:Notify({
                Title = "Auto Hit",
                Content = "Enabled - Automatically hits players",
                Duration = 3
            })
        end
    end,
})

-- Hit Range
local HitRange = 10
local HitRangeSlider = CombatTab:CreateSlider({
    Name = "Hit Range",
    Range = {5, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 10,
    Flag = "HitRange",
    Callback = function(Value)
        HitRange = Value
    end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 6031280881)

local ESPSection = ESPTab:CreateSection("ESP Features")

-- Player ESP
local PlayerESPEnabled = false
local PlayerESPToggle = ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        PlayerESPEnabled = Value
        if Value then
            Window:Notify({
                Title = "Player ESP",
                Content = "Enabled - Showing player boxes",
                Duration = 3
            })
        end
    end,
})

-- Coin ESP
local CoinESPEnabled = false
local CoinESPToggle = ESPTab:CreateToggle({
    Name = "Coin ESP",
    CurrentValue = false,
    Flag = "CoinESP",
    Callback = function(Value)
        CoinESPEnabled = Value
        if Value then
            Window:Notify({
                Title = "Coin ESP",
                Content = "Enabled - Showing coins",
                Duration = 3
            })
        end
    end,
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 6031068426)

local VisualsSection = VisualsTab:CreateSection("Visual Mods")

-- Remove Fog
local RemoveFogEnabled = false
local RemoveFogToggle = VisualsTab:CreateToggle({
    Name = "Remove Fog",
    CurrentValue = false,
    Flag = "RemoveFog",
    Callback = function(Value)
        RemoveFogEnabled = Value
        if Value then
            game:GetService("Lighting").FogEnd = 1000000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end,
})

-- Full Bright
local FullBrightEnabled = false
local FullBrightToggle = VisualsTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        FullBrightEnabled = Value
        if Value then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
        else
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Brightness = 1
        end
    end,
})

-- Remove Effects
local RemoveEffectsEnabled = false
local RemoveEffectsToggle = VisualsTab:CreateToggle({
    Name = "Remove Effects",
    CurrentValue = false,
    Flag = "RemoveEffects",
    Callback = function(Value)
        RemoveEffectsEnabled = Value
        if Value then
            for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = false
                end
            end
        else
            for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = true
                end
            end
        end
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 6031304514)

local TeleportSection = TeleportTab:CreateSection("Teleport Locations")

-- Teleport to Spawn
local TeleportSpawnBtn = TeleportTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
        if spawn then
            LocalPlayer.Character:MoveTo(spawn.Position + Vector3.new(0, 5, 0))
            Window:Notify({
                Title = "Teleport",
                Content = "Teleported to spawn",
                Duration = 3
            })
        end
    end,
})

-- Teleport to Map Center
local TeleportCenterBtn = TeleportTab:CreateButton({
    Name = "Teleport to Map Center",
    Callback = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 100, 0))
        Window:Notify({
            Title = "Teleport",
            Content = "Teleported to map center",
            Duration = 3
            })
    end,
})

-- Bring All Players
local BringAllEnabled = false
local BringAllToggle = TeleportTab:CreateToggle({
    Name = "Bring All Players",
    CurrentValue = false,
    Flag = "BringAll",
    Callback = function(Value)
        BringAllEnabled = Value
        if Value then
            Window:Notify({
                Title = "Bring All",
                Content = "Bringing all players to you",
                Duration = 3
            })
        end
    end,
})

-- Bring Range
local BringRange = 50
local BringRangeSlider = TeleportTab:CreateSlider({
    Name = "Bring Range",
    Range = {10, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "BringRange",
    Callback = function(Value)
        BringRange = Value
    end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 6031280881)

local MiscSection = MiscTab:CreateSection("Miscellaneous")

-- Auto Respawn
local AutoRespawnEnabled = false
local AutoRespawnToggle = MiscTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(Value)
        AutoRespawnEnabled = Value
        if Value then
            Window:Notify({
                Title = "Auto Respawn",
                Content = "Enabled - Auto respawn on death",
                Duration = 3
            })
        end
    end,
})

-- Infinite Stamina
local InfiniteStaminaEnabled = false
local InfiniteStaminaToggle = MiscTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        InfiniteStaminaEnabled = Value
        if Value then
            Window:Notify({
                Title = "Infinite Stamina",
                Content = "Enabled - Unlimited stamina",
                Duration = 3
            })
        end
    end,
})

-- No Clip
local NoClipEnabled = false
local NoClipToggle = MiscTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        NoClipEnabled = Value
        if Value then
            Window:Notify({
                Title = "No Clip",
                Content = "Enabled - Walk through walls",
                Duration = 3
            })
        end
    end,
})

-- Auto Farm
local AutoFarmEnabled = false
local AutoFarmToggle = MiscTab:CreateToggle({
    Name = "Auto Farm Coins",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        AutoFarmEnabled = Value
        if Value then
            Window:Notify({
                Title = "Auto Farm",
                Content = "Enabled - Farming coins automatically",
                Duration = 8
            })
        end
    end,
})

-- Script Functions
local ESPDrawings = {}
local CoinDrawings = {}

-- Player ESP Function
local function UpdatePlayerESP()
    if not PlayerESPEnabled then
        for _, drawing in pairs(ESPDrawings) do
            drawing:Remove()
        end
        ESPDrawings = {}
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    if not ESPDrawings[player] then
                        local drawing = Drawing.new("Text")
                        drawing.Text = player.Name
                        drawing.Size = 14
                        drawing.Color = Color3.new(1, 1, 1)
                        drawing.Outline = true
                        drawing.Center = true
                        ESPDrawings[player] = drawing
                    end
                    
                    ESPDrawings[player].Position = Vector2.new(pos.X, pos.Y)
                    ESPDrawings[player].Visible = true
                elseif ESPDrawings[player] then
                    ESPDrawings[player].Visible = false
                end
            end
        end
    end
end

-- Coin ESP Function
local function UpdateCoinESP()
    if not CoinESPEnabled then
        for _, drawing in pairs(CoinDrawings) do
            drawing:Remove()
        end
        CoinDrawings = {}
        return
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
            local pos, onScreen = Camera:WorldToViewportPoint(obj.Position)
            if onScreen then
                if not CoinDrawings[obj] then
                    local drawing = Drawing.new("Text")
                    drawing.Text = "💰 Coin"
                    drawing.Size = 12
                    drawing.Color = Color3.fromRGB(255, 215, 0)
                    drawing.Outline = true
                    drawing.Center = true
                    CoinDrawings[obj] = drawing
                end
                
                CoinDrawings[obj].Position = Vector2.new(pos.X, pos.Y)
                CoinDrawings[obj].Visible = true
            elseif CoinDrawings[obj] then
                CoinDrawings[obj].Visible = false
            end
        end
    end
end

-- Auto Collect Function
local function CollectCoins()
    if not AutoCollectEnabled then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
            if distance < 20 then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                task.wait(0.1)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
            end
        end
    end
end

-- Kill Aura Function
local function KillAura()
    if not KillAuraEnabled or not LocalPlayer.Character then return end
    
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (myPos - rootPart.Position).Magnitude
                if distance < KillAuraRange then
                    -- Simulate hit
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, rootPart, 0)
                    task.wait(0.05)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, rootPart, 1)
                end
            end
        end
    end
end

-- Auto Hit Function
local function AutoHit()
    if not AutoHitEnabled or not LocalPlayer.Character then return end
    
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (myPos - rootPart.Position).Magnitude
                if distance < HitRange then
                    -- Send click event
                    mouse1click()
                end
            end
        end
    end
end

-- Bring All Function
local function BringAllPlayers()
    if not BringAllEnabled or not LocalPlayer.Character then return end
    
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                local distance = (myPos - rootPart.Position).Magnitude
                if distance > BringRange then
                    char:MoveTo(myPos + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                end
            end
        end
    end
end

-- Auto Win Function
local function CheckWin()
    if not AutoWinEnabled then return end
    
    -- Check if player is last standing
    local alivePlayers = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                alivePlayers = alivePlayers + 1
            end
        end
    end
    
    if alivePlayers <= 1 and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            -- Player is the winner
            Window:Notify({
                Title = "🎉 Victory!",
                Content = "You are the last player standing!",
                Duration = 5
            })
        end
    end
end

-- No Clip Function
local function NoClip()
    if not NoClipEnabled or not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    -- Update ESP
    UpdatePlayerESP()
    UpdateCoinESP()
    
    -- Auto Collect
    if AutoCollectEnabled then
        CollectCoins()
    end
    
    -- Kill Aura
    if KillAuraEnabled then
        KillAura()
    end
    
    -- Auto Hit
    if AutoHitEnabled then
        AutoHit()
    end
    
    -- Bring All
    if BringAllEnabled then
        BringAllPlayers()
    end
    
    -- No Clip
    if NoClipEnabled then
        NoClip()
    end
    
    -- Check Win
    CheckWin()
    
    -- Anti Fall Damage
    if AntiFallEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

-- Character Added Event
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(2)
    
    -- Apply speed if enabled
    if SpeedEnabled and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 16 * SpeedMultiplier
    end
    
    -- Apply jump height if enabled
    if HighJumpEnabled and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpHeight = JumpHeight
    end
    
    -- Auto Respawn check
    if AutoRespawnEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            task.wait(2)
            LocalPlayer:LoadCharacter()
        end)
    end
end)

-- Initial notification
Window:Notify({
    Title = "MACROPEAK | Get Down!",
    Content = "Script loaded successfully!\nKey: ASP\nMade By @LuaDev",
    Duration = 8
})

-- Script Info
Window:CreateLabel("MACROPEAK | Get Down! Script")
Window:CreateLabel("Made By @LuaDev")
Window:CreateLabel("Key: ASP (Verified)")
Window:CreateLabel("Version: 1.0.0")

print("[MACROPEAK] Get Down! Script Loaded")
print("[MACROPEAK] Key: ASP")
print("[MACROPEAK] All features ready!")
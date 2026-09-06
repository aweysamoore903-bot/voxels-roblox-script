-- Ramzi GodMode - Voxels Script
-- Features: GodMode, GodMode Pro, KillAura, OP KillAura V2, Fly, Fly Speed, SpeedWalk
-- Custom UI for Delta and Xeno

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local config = {
    godMode = false,
    godModePro = false,
    killAura = false,
    opKillAura = false,
    fly = false,
    flySpeed = 50,
    speedWalkEnabled = false,
    speedWalkMultiplier = 2,
    killAuraRange = 50,
    killAuraSpeed = 0.1,
    uiVisible = true,
}

-- Check if player is Delta or Xeno
local playerName = player.Name
local isAuthorizedUser = (playerName == "Delta" or playerName == "Xeno" or playerName == "aweysamoore903-bot")

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RamziGodModeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 300, 0, 40)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleLabel.BorderColor3 = Color3.fromRGB(0, 255, 150)
titleLabel.BorderSizePixel = 2
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ RAMZI GODMODE"
titleLabel.Parent = screenGui

-- Status Frame
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0, 300, 0, 280)
statusFrame.Position = UDim2.new(0, 20, 0, 70)
statusFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
statusFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
statusFrame.BorderSizePixel = 2
statusFrame.Parent = screenGui

-- Status Labels
local statusLabels = {}
local features = {
    "GodMode (G)",
    "GodMode Pro (H)",
    "KillAura (K)",
    "OP KillAura V2 (J)",
    "Fly (F)",
    "SpeedWalk (V)"
}

for i, feature in ipairs(features) do
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = feature
    statusLabel.Size = UDim2.new(0, 280, 0, 35)
    statusLabel.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 40)
    statusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    statusLabel.BorderColor3 = Color3.fromRGB(100, 100, 150)
    statusLabel.BorderSizePixel = 1
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "  ◯ " .. feature .. " [OFF]"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    
    table.insert(statusLabels, {
        label = statusLabel,
        feature = feature,
        key = string.sub(feature, -3, -2) -- Extract key from (X)
    })
end

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(0, 300, 0, 60)
infoLabel.Position = UDim2.new(0, 20, 0, 370)
infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
infoLabel.BorderColor3 = Color3.fromRGB(0, 200, 100)
infoLabel.BorderSizePixel = 2
infoLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "UP/DOWN ▲▼ - Adjust Fly Speed\nPress H to hide/show UI"
infoLabel.Parent = screenGui

-- Fly Speed Display
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Name = "FlySpeed"
flySpeedLabel.Size = UDim2.new(0, 300, 0, 30)
flySpeedLabel.Position = UDim2.new(0, 20, 0, 440)
flySpeedLabel.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
flySpeedLabel.BorderColor3 = Color3.fromRGB(0, 150, 200)
flySpeedLabel.BorderSizePixel = 2
flySpeedLabel.TextColor3 = Color3.fromRGB(0, 150, 200)
flySpeedLabel.TextSize = 14
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.Text = "🚀 Fly Speed: " .. config.flySpeed
flySpeedLabel.Parent = screenGui

-- User Info (Only for Delta and Xeno)
if isAuthorizedUser then
    local userLabel = Instance.new("TextLabel")
    userLabel.Name = "UserInfo"
    userLabel.Size = UDim2.new(0, 300, 0, 25)
    userLabel.Position = UDim2.new(0, 20, 0, 475)
    userLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
    userLabel.BorderColor3 = Color3.fromRGB(255, 100, 0)
    userLabel.BorderSizePixel = 2
    userLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
    userLabel.TextSize = 12
    userLabel.Font = Enum.Font.GothamBold
    userLabel.Text = "👤 User: " .. playerName .. " [AUTHORIZED]"
    userLabel.Parent = screenGui
end

-- Update UI function
local function updateUI()
    for i, statusData in ipairs(statusLabels) do
        local isEnabled = false
        if i == 1 then isEnabled = config.godMode
        elseif i == 2 then isEnabled = config.godModePro
        elseif i == 3 then isEnabled = config.killAura
        elseif i == 4 then isEnabled = config.opKillAura
        elseif i == 5 then isEnabled = config.fly
        elseif i == 6 then isEnabled = config.speedWalkEnabled
        end
        
        if isEnabled then
            statusData.label.TextColor3 = Color3.fromRGB(0, 255, 150)
            statusData.label.Text = "  ● " .. statusData.feature .. " [ON]"
            statusData.label.BorderColor3 = Color3.fromRGB(0, 255, 150)
        else
            statusData.label.TextColor3 = Color3.fromRGB(200, 200, 200)
            statusData.label.Text = "  ◯ " .. statusData.feature .. " [OFF]"
            statusData.label.BorderColor3 = Color3.fromRGB(100, 100, 150)
        end
    end
    
    flySpeedLabel.Text = "🚀 Fly Speed: " .. config.flySpeed
end

-- GodMode
local function toggleGodMode()
    config.godMode = not config.godMode
    if config.godMode then
        print("✓ GodMode ENABLED")
        humanoid.HealthChanged:Connect(function()
            if config.godMode then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        print("✗ GodMode DISABLED")
    end
    updateUI()
end

-- GodMode Pro
local function toggleGodModePro()
    config.godModePro = not config.godModePro
    if config.godModePro then
        print("✓ GodMode Pro ENABLED")
        humanoid.HealthChanged:Connect(function()
            if config.godModePro then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Damaged, false)
    else
        print("✗ GodMode Pro DISABLED")
        character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Damaged, true)
    end
    updateUI()
end

-- KillAura
local function toggleKillAura()
    config.killAura = not config.killAura
    if config.killAura then
        print("✓ KillAura ENABLED")
        spawn(function()
            while config.killAura do
                for _, targetPlayer in pairs(Players:GetPlayers()) do
                    if targetPlayer ~= player and targetPlayer.Character then
                        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if targetHumanoid and targetRoot then
                            local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                            if distance < config.killAuraRange then
                                targetHumanoid:TakeDamage(10)
                            end
                        end
                    end
                end
                wait(config.killAuraSpeed)
            end
        end)
    else
        print("✗ KillAura DISABLED")
    end
    updateUI()
end

-- OP KillAura V2
local function toggleOpKillAura()
    config.opKillAura = not config.opKillAura
    if config.opKillAura then
        print("✓ OP KillAura V2 ENABLED")
        spawn(function()
            while config.opKillAura do
                for _, targetPlayer in pairs(Players:GetPlayers()) do
                    if targetPlayer ~= player and targetPlayer.Character then
                        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if targetHumanoid and targetRoot then
                            local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                            if distance < config.killAuraRange then
                                targetHumanoid.Health = 0
                            end
                        end
                    end
                end
                wait(0.05)
            end
        end)
    else
        print("✗ OP KillAura V2 DISABLED")
    end
    updateUI()
end

-- Fly
local flying = false
local bodyVelocity

local function startFly()
    config.fly = true
    flying = true
    print("✓ Fly ENABLED (Speed: " .. config.flySpeed .. ")")
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Parent = humanoidRootPart
    
    RunService.RenderStepped:Connect(function()
        if config.fly and flying then
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (humanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (humanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - humanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + humanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            bodyVelocity.Velocity = moveDirection * config.flySpeed
        end
    end)
    updateUI()
end

local function stopFly()
    config.fly = false
    flying = false
    print("✗ Fly DISABLED")
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    updateUI()
end

local function toggleFly()
    if config.fly then
        stopFly()
    else
        startFly()
    end
end

-- SpeedWalk
local function toggleSpeedWalk()
    config.speedWalkEnabled = not config.speedWalkEnabled
    if config.speedWalkEnabled then
        print("✓ SpeedWalk ENABLED (Multiplier: " .. config.speedWalkMultiplier .. "x)")
    else
        print("✗ SpeedWalk DISABLED")
        humanoid.WalkSpeed = 16
    end
    updateUI()
end

-- Toggle UI
local function toggleUI()
    config.uiVisible = not config.uiVisible
    screenGui.Enabled = config.uiVisible
    if config.uiVisible then
        print("✓ UI SHOWN")
    else
        print("✗ UI HIDDEN")
    end
end

-- Input Bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleGodMode()
    elseif input.KeyCode == Enum.KeyCode.H then
        if isAuthorizedUser then
            toggleUI()
        else
            toggleGodModePro()
        end
    elseif input.KeyCode == Enum.KeyCode.K then
        toggleKillAura()
    elseif input.KeyCode == Enum.KeyCode.J then
        toggleOpKillAura()
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.V then
        toggleSpeedWalk()
    elseif input.KeyCode == Enum.KeyCode.Up then
        config.flySpeed = math.min(config.flySpeed + 10, 200)
        updateUI()
    elseif input.KeyCode == Enum.KeyCode.Down then
        config.flySpeed = math.max(config.flySpeed - 10, 10)
        updateUI()
    end
end)

-- SpeedWalk Implementation
humanoid.StateChanged:Connect(function(oldState, newState)
    if config.speedWalkEnabled and newState == Enum.HumanoidStateType.Running then
        humanoid.WalkSpeed = 16 * config.speedWalkMultiplier
    elseif newState == Enum.HumanoidStateType.Running and not config.speedWalkEnabled then
        humanoid.WalkSpeed = 16
    end
end)

-- Initial UI Update
updateUI()

-- Startup Message
print("========================================")
print("🔥 RAMZI GODMODE - VOXELS SCRIPT LOADED")
print("========================================")
print("Authorized User: " .. (isAuthorizedUser and playerName or "NO"))
print("")
print("KEY BINDINGS:")
print("G - Toggle GodMode")
print("H - Toggle GodMode Pro" .. (isAuthorizedUser and " / Toggle UI" or ""))
print("K - Toggle KillAura")
print("J - Toggle OP KillAura V2")
print("F - Toggle Fly")
print("V - Toggle SpeedWalk")
print("UP/DOWN - Adjust Fly Speed")
print("========================================")
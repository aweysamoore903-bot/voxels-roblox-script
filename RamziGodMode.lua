-- Ramzi GodMode - Voxels Script (Mobile Compatible)
-- Features: GodMode, GodMode Pro, KillAura, OP KillAura V2, Fly, Fly Speed, SpeedWalk
-- Custom UI for Delta and Xeno with Mobile Support

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
    uiVisible = false, -- Start hidden
}

-- Check if player is Delta or Xeno
local playerName = player.Name
local isAuthorizedUser = (playerName == "Delta" or playerName == "Xeno" or playerName == "aweysamoore903-bot")

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RamziGodModeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- TOGGLE BUTTON (Always Visible)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggleButton.BorderColor3 = Color3.fromRGB(0, 255, 150)
toggleButton.BorderSizePixel = 3
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
toggleButton.TextSize = 32
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "⚡"
toggleButton.Parent = screenGui

-- Add rounded corners effect
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Main Content Frame (Hidden by default)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(0, 320, 0, 550)
contentFrame.Position = UDim2.new(0, 20, 0, 20)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
contentFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
contentFrame.BorderSizePixel = 2
contentFrame.Visible = config.uiVisible
contentFrame.Parent = screenGui

-- Add corner to content frame
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- Title with Close Button
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = contentFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 250, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ RAMZI GODMODE"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.Parent = titleFrame

-- Status Frame
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 280)
statusFrame.Position = UDim2.new(0, 10, 0, 60)
statusFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

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
    local statusLabel = Instance.new("TextButton")
    statusLabel.Name = feature
    statusLabel.Size = UDim2.new(1, -10, 0, 40)
    statusLabel.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 45)
    statusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    statusLabel.BorderColor3 = Color3.fromRGB(100, 100, 150)
    statusLabel.BorderSizePixel = 1
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "  ◯ " .. feature .. " [OFF]"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    
    -- Add corner to button
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = statusLabel
    
    table.insert(statusLabels, {
        label = statusLabel,
        feature = feature,
        key = string.sub(feature, -3, -2),
        index = i
    })
end

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(1, -20, 0, 60)
infoLabel.Position = UDim2.new(0, 10, 0, 360)
infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
infoLabel.BorderColor3 = Color3.fromRGB(0, 200, 100)
infoLabel.BorderSizePixel = 2
infoLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "UP/DOWN ▲▼ - Adjust Fly Speed\nTap buttons to toggle features"
infoLabel.Parent = contentFrame

-- Fly Speed Display
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Name = "FlySpeed"
flySpeedLabel.Size = UDim2.new(1, -20, 0, 35)
flySpeedLabel.Position = UDim2.new(0, 10, 0, 430)
flySpeedLabel.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
flySpeedLabel.BorderColor3 = Color3.fromRGB(0, 150, 200)
flySpeedLabel.BorderSizePixel = 2
flySpeedLabel.TextColor3 = Color3.fromRGB(0, 150, 200)
flySpeedLabel.TextSize = 13
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.Text = "🚀 Fly Speed: " .. config.flySpeed
flySpeedLabel.Parent = contentFrame

-- Speed Control Buttons
local speedDownBtn = Instance.new("TextButton")
speedDownBtn.Name = "SpeedDown"
speedDownBtn.Size = UDim2.new(0, 50, 0, 35)
speedDownBtn.Position = UDim2.new(0, 10, 0, 475)
speedDownBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
speedDownBtn.BorderSizePixel = 1
speedDownBtn.BorderColor3 = Color3.fromRGB(150, 100, 100)
speedDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownBtn.TextSize = 20
speedDownBtn.Font = Enum.Font.GothamBold
speedDownBtn.Text = "▼"
speedDownBtn.Parent = contentFrame

local speedUpBtn = Instance.new("TextButton")
speedUpBtn.Name = "SpeedUp"
speedUpBtn.Size = UDim2.new(0, 50, 0, 35)
speedUpBtn.Position = UDim2.new(1, -60, 0, 475)
speedUpBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
speedUpBtn.BorderSizePixel = 1
speedUpBtn.BorderColor3 = Color3.fromRGB(100, 150, 100)
speedUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpBtn.TextSize = 20
speedUpBtn.Font = Enum.Font.GothamBold
speedUpBtn.Text = "▲"
speedUpBtn.Parent = contentFrame

-- User Info (Only for Delta and Xeno)
if isAuthorizedUser then
    local userLabel = Instance.new("TextLabel")
    userLabel.Name = "UserInfo"
    userLabel.Size = UDim2.new(1, -20, 0, 25)
    userLabel.Position = UDim2.new(0, 10, 0, 520)
    userLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
    userLabel.BorderColor3 = Color3.fromRGB(255, 100, 0)
    userLabel.BorderSizePixel = 2
    userLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
    userLabel.TextSize = 11
    userLabel.Font = Enum.Font.GothamBold
    userLabel.Text = "👤 User: " .. playerName .. " [AUTHORIZED]"
    userLabel.Parent = contentFrame
end

-- Update UI function
local function updateUI()
    for i, statusData in ipairs(statusLabels) do
        local isEnabled = false
        if statusData.index == 1 then isEnabled = config.godMode
        elseif statusData.index == 2 then isEnabled = config.godModePro
        elseif statusData.index == 3 then isEnabled = config.killAura
        elseif statusData.index == 4 then isEnabled = config.opKillAura
        elseif statusData.index == 5 then isEnabled = config.fly
        elseif statusData.index == 6 then isEnabled = config.speedWalkEnabled
        end
        
        if isEnabled then
            statusData.label.TextColor3 = Color3.fromRGB(0, 255, 150)
            statusData.label.Text = "  ● " .. statusData.feature .. " [ON]"
            statusData.label.BorderColor3 = Color3.fromRGB(0, 255, 150)
            statusData.label.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
        else
            statusData.label.TextColor3 = Color3.fromRGB(200, 200, 200)
            statusData.label.Text = "  ◯ " .. statusData.feature .. " [OFF]"
            statusData.label.BorderColor3 = Color3.fromRGB(100, 100, 150)
            statusData.label.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
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

-- Toggle UI Visibility
local function toggleUIVisibility()
    config.uiVisible = not config.uiVisible
    contentFrame.Visible = config.uiVisible
    if config.uiVisible then
        print("✓ UI SHOWN")
    else
        print("✗ UI HIDDEN")
    end
end

-- Button Click Events
toggleButton.MouseButton1Click:Connect(function()
    toggleUIVisibility()
end)

closeButton.MouseButton1Click:Connect(function()
    toggleUIVisibility()
end)

speedUpBtn.MouseButton1Click:Connect(function()
    config.flySpeed = math.min(config.flySpeed + 10, 200)
    updateUI()
    print("Fly Speed: " .. config.flySpeed)
end)

speedDownBtn.MouseButton1Click:Connect(function()
    config.flySpeed = math.max(config.flySpeed - 10, 10)
    updateUI()
    print("Fly Speed: " .. config.flySpeed)
end)

-- Connect button toggles
for i, statusData in ipairs(statusLabels) do
    statusData.label.MouseButton1Click:Connect(function()
        if statusData.index == 1 then
            toggleGodMode()
        elseif statusData.index == 2 then
            toggleGodModePro()
        elseif statusData.index == 3 then
            toggleKillAura()
        elseif statusData.index == 4 then
            toggleOpKillAura()
        elseif statusData.index == 5 then
            toggleFly()
        elseif statusData.index == 6 then
            toggleSpeedWalk()
        end
    end)
end

-- Keyboard Input Bindings (for desktop)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleGodMode()
    elseif input.KeyCode == Enum.KeyCode.H then
        toggleUIVisibility()
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
print("Platform: Mobile Compatible ✓")
print("")
print("FEATURES:")
print("✓ Tap ⚡ button to open/close UI")
print("✓ Tap feature buttons to toggle")
print("✓ Tap ▲▼ to adjust fly speed")
print("")
print("KEYBOARD BINDINGS (Desktop):")
print("G - Toggle GodMode")
print("H - Toggle UI")
print("K - Toggle KillAura")
print("J - Toggle OP KillAura V2")
print("F - Toggle Fly")
print("V - Toggle SpeedWalk")
print("UP/DOWN - Adjust Fly Speed")
print("========================================")
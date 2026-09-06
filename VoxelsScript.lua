-- Voxels Roblox Script
-- Features: GodMode, GodMode Pro, KillAura, OP KillAura V2, Fly, Fly Speed, SpeedWalk

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
}

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
end

-- GodMode Pro (+ damage immunity)
local function toggleGodModePro()
    config.godModePro = not config.godModePro
    if config.godModePro then
        print("✓ GodMode Pro ENABLED")
        -- Invincibility
        humanoid.HealthChanged:Connect(function()
            if config.godModePro then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        -- Disable all damage
        character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Damaged, false)
    else
        print("✗ GodMode Pro DISABLED")
        character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Damaged, true)
    end
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
end

-- OP KillAura V2 (Instant Kill)
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
                                -- Instant kill
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
end

-- Fly
local flying = false
local flySpeed = config.flySpeed
local bodyVelocity

local function startFly()
    config.fly = true
    flying = true
    print("✓ Fly ENABLED (Speed: " .. flySpeed .. ")")
    
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
            
            bodyVelocity.Velocity = moveDirection * flySpeed
        end
    end)
end

local function stopFly()
    config.fly = false
    flying = false
    print("✗ Fly DISABLED")
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
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
    end
end

-- Input Bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleGodMode()
    elseif input.KeyCode == Enum.KeyCode.H then
        toggleGodModePro()
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
        print("Fly Speed: " .. config.flySpeed)
    elseif input.KeyCode == Enum.KeyCode.Down then
        config.flySpeed = math.max(config.flySpeed - 10, 10)
        print("Fly Speed: " .. config.flySpeed)
    end
end)

-- SpeedWalk Implementation
local humanoidStateConnection
humanoidStateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
    if config.speedWalkEnabled and newState == Enum.HumanoidStateType.Running then
        humanoid.WalkSpeed = 16 * config.speedWalkMultiplier
    elseif newState == Enum.HumanoidStateType.Running then
        humanoid.WalkSpeed = 16
    end
end)

-- UI/Help Menu
print("=== VOXELS SCRIPT LOADED ===")
print("Key Bindings:")
print("G - Toggle GodMode")
print("H - Toggle GodMode Pro")
print("K - Toggle KillAura")
print("J - Toggle OP KillAura V2")
print("F - Toggle Fly")
print("V - Toggle SpeedWalk")
print("UP ARROW - Increase Fly Speed")
print("DOWN ARROW - Decrease Fly Speed")
print("==========================")
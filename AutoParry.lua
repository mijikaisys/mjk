getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local function initializeParry()
    local stats = { successfulParries = 0, failedParries = 0 }
    local baseDetectionRadius = 20
    local spherePart = Instance.new("Part", workspace)
    
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.5

    local textLabel = Instance.new("TextLabel", Player.PlayerGui:FindFirstChildOfClass("ScreenGui"))
    textLabel.Size = UDim2.new(0, 200, 0, 100)
    textLabel.Position = UDim2.new(0.8, 0, 0, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://7108607217"

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then return end
        
        local targetBall = parry_helper.FindTargetBall()
        if not targetBall then return end

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = targetBall.Position
        local distance = (targetPos - playerPos).Magnitude
        local velocity = targetBall.AssemblyLinearVelocity.Magnitude
        local adjustedDetectionRadius = math.clamp(baseDetectionRadius + (velocity / 2), baseDetectionRadius, baseDetectionRadius + 50)

        if distance <= adjustedDetectionRadius and parry_helper.IsPlayerTarget(targetBall) then
            local directionToBall = (targetPos - playerPos).Unit
            local playerForward = Player.Character.PrimaryPart.CFrame.LookVector
            local angle = math.acos(directionToBall:Dot(playerForward)) * (180 / math.pi)

            if angle < 45 and targetBall.AssemblyLinearVelocity.Y < 0 then
                VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                parrySound:Play()
                stats.successfulParries = stats.successfulParries + 1
                spherePart.Color = Color3.new(0, 1, 0)
            else
                stats.failedParries = stats.failedParries + 1
                spherePart.Color = Color3.new(1, 0, 0)
            end
        end

        textLabel.Text = string.format("Parrys réussis: %d\nParrys échoués: %d", stats.successfulParries, stats.failedParries)
    end)
end

Player.CharacterAdded:Connect(function()
    wait(1)
    initializeParry()  
end)

initializeParry()

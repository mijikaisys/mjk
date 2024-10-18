getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local function initializeParry()
    local stats = {
        successfulParries = 0,
        failedParries = 0,
    }

    local baseDetectionRadius = 20
    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.5
    spherePart.Parent = workspace

    local screenGui = Instance.new("ScreenGui")
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 100)
    textLabel.Position = UDim2.new(0.8, 0, 0, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    screenGui.Parent = Player.PlayerGui
    textLabel.Parent = screenGui

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://7108607217"

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local targetBall = parry_helper.FindTargetBall()
        if not targetBall then 
            return 
        end

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = targetBall.Position
        local distance = (targetPos - playerPos).Magnitude
        local velocity = targetBall.AssemblyLinearVelocity.Magnitude

        -- Ajustement de la portée de détection
        local adjustedDetectionRadius = math.clamp(baseDetectionRadius + (velocity / 2), baseDetectionRadius, baseDetectionRadius + 50)

        if distance <= adjustedDetectionRadius and parry_helper.IsPlayerTarget(targetBall) then
            local directionToBall = (targetPos - playerPos).Unit
            local playerForward = Player.Character.PrimaryPart.CFrame.LookVector
            local angle = math.acos(directionToBall:Dot(playerForward)) * (180 / math.pi)

            -- Vérification si la balle vient d'en haut
            if angle < 45 and targetBall.AssemblyLinearVelocity.Y < 0 then
                VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                parrySound:Play()
                stats.successfulParries = stats.successfulParries + 1
                spherePart.Color = Color3.new(0, 1, 0)  -- Couleur de succès
            else
                stats.failedParries = stats.failedParries + 1
                spherePart.Color = Color3.new(1, 0, 0)  -- Couleur d'échec
            end
        end

        textLabel.Text = string.format("Parrys réussis: %d\nParrys échoués: %d", stats.successfulParries, stats.failedParries)
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait(1)  -- Attendre pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry à la première exécution
initializeParry()

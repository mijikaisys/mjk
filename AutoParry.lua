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

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end
        
        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position
        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        -- Ajustement de la taille de la sphère de détection
        local maxDetectionRadius = math.clamp(velocity / 0.3 + baseDetectionRadius, baseDetectionRadius, baseDetectionRadius + 50)
        spherePart.Size = Vector3.new(maxDetectionRadius * 2, maxDetectionRadius * 2, maxDetectionRadius * 2)
        spherePart.Position = playerPos
        
        -- Vérification de la distance et de la direction du projectile
        if distance <= maxDetectionRadius then
            local directionToBall = (targetPos - playerPos).Unit
            local playerForward = Player.Character.PrimaryPart.CFrame.LookVector
            local angle = math.acos(directionToBall:Dot(playerForward)) * (180 / math.pi)

            if angle < 45 then  -- Ajuste cet angle pour être plus strict si nécessaire
                local hitDirection = par.AssemblyLinearVelocity.Unit
                if hitDirection.Y < 0 then  -- Vérifie si le projectile vient d'en haut
                    VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    parrySound:Play()
                    stats.successfulParries = stats.successfulParries + 1
                    spherePart.Color = Color3.new(0, 1, 0)  -- Couleur de succès
                else
                    stats.failedParries = stats.failedParries + 1
                    spherePart.Color = Color3.new(1, 0, 0)  -- Couleur d'échec
                end
            end
        end

        -- Mise à jour des statistiques à l'écran
        textLabel.Text = string.format("Parrys réussis: %d\nParrys échoués: %d", stats.successfulParries, stats.failedParries)
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait(1)  -- Attendre un moment pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry à la première exécution
initializeParry()

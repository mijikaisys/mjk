getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local function initializeParry()
    local ero = false
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

    local proximityIndicator = Instance.new("Part")
    proximityIndicator.Size = Vector3.new(5, 5, 5)
    proximityIndicator.Shape = Enum.PartType.Ball
    proximityIndicator.Anchored = true
    proximityIndicator.CanCollide = false 
    proximityIndicator.Color = Color3.new(0, 0, 0)
    proximityIndicator.Parent = workspace

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            proximityIndicator.Position = Vector3.new(0, -1000, 0)  -- Cacher l'indicateur si aucune balle n'est trouvée
            return 
        end

        spherePart.Position = Player.Character.PrimaryPart.Position

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        -- Ajustement de la taille de la sphère de détection
        local maxDetectionRadius = math.clamp(velocity / 0.3, baseDetectionRadius, baseDetectionRadius + 50)
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius)

        if distance <= adjustedBaseDetectionRadius then
            spherePart.Size = Vector3.new(adjustedBaseDetectionRadius * 2, adjustedBaseDetectionRadius * 2, adjustedBaseDetectionRadius * 2)

            local hat = par.AssemblyLinearVelocity
            if par:FindFirstChild('zoomies') then 
                hat = par.zoomies.VectorVelocity
            end

            local hitDirection = (playerPos - targetPos).Unit
            local isTargetValid = parry_helper.IsPlayerTarget(par)

            if isTargetValid and hitDirection.Y < 0 then  -- Vérifie si le projectile vient en haut
                VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                parrySound:Play()
                stats.successfulParries = stats.successfulParries + 1
                spherePart.Color = Color3.new(0, 1, 0)  -- Couleur de succès
                ero = true
            else
                if not ero then
                    stats.failedParries = stats.failedParries + 1
                    spherePart.Color = Color3.new(1, 0, 0)  -- Couleur d'échec
                end
            end
        end

        proximityIndicator.Position = Player.Character.PrimaryPart.Position

        local ping = Player:GetNetworkPing()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        textLabel.Text = string.format("Ping: %d ms\nFPS: %d\nVitesse: %.2f\nParrys réussis: %d\nParrys échoués: %d", ping, fps, velocity, stats.successfulParries, stats.failedParries)
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait(1)  -- Attendre un moment pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry à la première exécution
initializeParry()

getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

-- Fonction pour mettre à jour la taille de la sphère
local function updateSphereSize(spherePart, targetPos, playerPos)
    local distance = (targetPos - playerPos).Magnitude
    local baseSize = 10 -- Taille de base de la sphère
    local maxSize = 20 -- Taille maximale de la sphère
    local velocityFactor = 0.2 -- Facteur d'ajustement basé sur la vélocité

    -- Calculer la taille en fonction de la distance et de la vélocité
    local velocity = (targetPos - playerPos).Magnitude / RunService.RenderStepped:Wait() -- Vitesse approximative
    local sizeAdjustment = math.clamp(baseSize + (velocity * velocityFactor), baseSize, maxSize)

    -- Ajuster la taille de la sphère
    spherePart.Size = Vector3.new(sizeAdjustment, sizeAdjustment, sizeAdjustment)
end

local function initializeParry()
    local ero = false
    local baseDetectionRadius = 20

    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.95 -- Rend la sphère presque invisible
    spherePart.Parent = workspace

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
            return 
        end

        spherePart.Position = Player.Character.PrimaryPart.Position
        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        -- Mettre à jour la taille de la sphère
        updateSphereSize(spherePart, targetPos, playerPos)

        -- Reste de ton code de détection de parry...
        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        local maxDetectionRadius = velocity / 0.3
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

        if distance <= adjustedBaseDetectionRadius then
            -- Logique de parry
            -- ...
        else
            proximityIndicator.Position = Vector3.new(0, -1000, 0)
        end
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait(1)  -- Attendre un moment pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry à la première exécution
initializeParry()

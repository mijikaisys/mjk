getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

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
    spherePart.Transparency = 0.95
    spherePart.Parent = workspace

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://5433158470"

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

        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        local maxDetectionRadius = velocity / 0.15
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

        if distance <= adjustedBaseDetectionRadius then
            local newSize = math.clamp(adjustedBaseDetectionRadius - (distance * 0.3), baseDetectionRadius, adjustedBaseDetectionRadius)
            spherePart.Size = Vector3.new(newSize * 2.5, newSize * 2.5, newSize * 2.5)

            local hat = par.AssemblyLinearVelocity
            if par:FindFirstChild('zoomies') then 
                hat = par.zoomies.VectorVelocity
            end

            local i = par.Position
            local j = Player.Character.PrimaryPart.Position
            local kil = (j - i).Unit
            local l = Player:DistanceFromCharacter(i)
            local m = kil:Dot(hat.Unit)
            local n = hat.Magnitude

            -- Calculer le seuil basé sur la vitesse
            local thresholdP = 0.55 * (1 + 0.5 * velocity)

            -- Vérifier si le personnage du joueur existe et est vivant
            if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                -- Vérifier si le joueur n'est plus visé par la balle
                if not parry_helper.IsPlayerTarget(par) then
                    return -- Si le joueur n'est pas visé, ne pas tenter de parry
                end

                if m > 0 then
                    local o = l - 5
                    local p = o / n

                    if p <= thresholdP and not ero then
                        VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        parrySound:Play()
                        spherePart.Color = Color3.new(0, 1, 0) -- Indicate parry successful
                        ero = true
                    else
                        spherePart.Color = Color3.new(1, 0, 0) -- Indicate parry failed
                    end
                else
                    ero = false
                end

                proximityIndicator.Position = Player.Character.PrimaryPart.Position
            else
                proximityIndicator.Position = Vector3.new(0, -1000, 0) -- Si le joueur est mort, cacher l'indicateur
            end
        else
            proximityIndicator.Position = Vector3.new(0, -1000, 0)
        end
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait()  -- Attendre un moment pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry à la première exécution
initializeParry()

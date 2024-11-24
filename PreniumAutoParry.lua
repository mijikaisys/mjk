getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

-- Détection du RemoteEvent
local hitremote
for _, v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local function initializeParry()
    local ero = false
    local baseDetectionRadius = 20
    local lastParryTime = 0
    local parryInterval = 0.252 -- Intervalle en secondes entre chaque parry
    local autoSpamActive = false
    local spamStartTime = 0
    local spamDuration = 0.255 -- Durée pendant laquelle l'autospam est actif

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://5433158470"

    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.95 -- Rend la sphère presque invisible
    spherePart.Parent = workspace

    local proximityIndicator = Instance.new("Part")
    proximityIndicator.Size = Vector3.new(5, 5, 5)
    proximityIndicator.Shape = Enum.PartType.Ball
    proximityIndicator.Anchored = true
    proximityIndicator.CanCollide = false 
    proximityIndicator.Color = Color3.new(0, 0, 0)
    proximityIndicator.Parent = workspace

    local camera = workspace.CurrentCamera
    local mouse = Player:GetMouse()

    local function getClosestEntity()
        local closest_Entity = nil
        local shortestDistance = math.huge

        for _, entity in pairs(workspace.Alive:GetChildren()) do
            if entity:IsA("Model") and entity:FindFirstChild("HumanoidRootPart") then
                local screenPoint = camera:WorldToViewportPoint(entity.HumanoidRootPart.Position)
                local distanceToMouse = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if distanceToMouse < shortestDistance then
                    closest_Entity = entity
                    shortestDistance = distanceToMouse
                end
            end
        end

        return closest_Entity
    end

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
            spherePart.Size = Vector3.new(newSize * 1115.5, newSize * 1115.5, newSize * 1115.5) -- Augmenter le facteur d'échelle ici

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
            local thresholdP = 0.50 * (1 + 0.15 * velocity)

            if m > 0 then
                local o = l - 5
                local p = o / n

                local closest_Entity = getClosestEntity()
                if closest_Entity and parry_helper.IsPlayerTarget(par) and p <= thresholdP and not ero then
                    local currentTime = tick()
                    if currentTime - lastParryTime < parryInterval then
                        -- Activer l'autospam si la fréquence est rapide
                        autoSpamActive = true
                        spamStartTime = currentTime
                    end

                    -- Utiliser le RemoteEvent pour le parry
                    local cf = camera.CFrame
                    local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:GetComponents()

                    hitremote:FireServer(
                        0,
                        CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22),
                        {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},
                        {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},
                        false
                    )
                    spherePart.Color = Color3.new(0, 1, 0) -- Indicate parry successful
                    ero = true
                    lastParryTime = currentTime
                else
                    spherePart.Color = Color3.new(1, 0, 0) -- Indicate parry failed
                end
            else
                if ero then
                    parrySound:Play()
                    ero = false -- Réinitialiser ero pour permettre un nouveau parry
                end
            end

            proximityIndicator.Position = Player.Character.PrimaryPart.Position
        else
            proximityIndicator.Position = Vector3.new(0, -1000, 0)
        end

        -- Gestion de l'autospam
        if autoSpamActive then
            local currentTime = tick()
            if currentTime - spamStartTime < spamDuration then
                -- Effectuer un parry automatique
                local closest_Entity = getClosestEntity()
                if closest_Entity then
                    local cf = camera.CFrame
                    local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:GetComponents()

                    hitremote:FireServer(
                        0,
                        CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22),
                        {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},
                        {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},
                        false
                    )
                    wait()
                end
            else
                autoSpamActive = false -- Désactiver l'autospam après la durée spécifiée
                ero = false 
            end
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

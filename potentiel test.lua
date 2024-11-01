local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

local baseSphereRadius = 5 -- Rayon de base de la sphère de détection
local detectionSphere
local alertSound = Instance.new("Sound") -- Créer un son
alertSound.SoundId = "rbxassetid://507771019" -- Son d'alerte simple
alertSound.Parent = Workspace

-- Fonction pour créer la sphère de détection
local function createDetectionSphere()
    if detectionSphere then
        detectionSphere:Destroy() -- Supprimez la sphère précédente si elle existe
    end

    detectionSphere = Instance.new("Part")
    detectionSphere.Size = Vector3.new(baseSphereRadius * 2, baseSphereRadius * 2, baseSphereRadius * 2) -- Taille de la sphère
    detectionSphere.Shape = Enum.PartType.Ball
    detectionSphere.Position = localPlayer.Character.HumanoidRootPart.Position -- Position initiale à la position du joueur
    detectionSphere.Anchored = true
    detectionSphere.Transparency = 0.5
    detectionSphere.Color = Color3.new(1, 0, 0) -- Couleur rouge
    detectionSphere.CanCollide = false -- Désactiver la collision
    detectionSphere.Parent = Workspace

    print("Sphère de détection créée") -- Message de débogage
end

-- Fonction pour trouver la balle ciblée
local function findTargetBall()
    for _, ball in pairs(Workspace:WaitForChild("Balls"):GetChildren()) do
        if ball:IsA("BasePart") and ball:GetAttribute("realBall") then
            return ball
        end
    end
end

-- Fonction pour vérifier si la balle vise le joueur
local function isPlayerTarget(ball)
    return ball:GetAttribute("target") == localPlayer.Name
end

-- Fonction pour vérifier si la balle est dans la sphère
local function isBallInSphere(ballPosition, spherePosition, sphereRadius)
    local distance = (ballPosition - spherePosition).magnitude
    return distance <= sphereRadius
end

-- Créer la sphère de détection au début
createDetectionSphere()

-- Fonction principale
while true do
    wait(0.1) -- Délai pour éviter une boucle trop rapide

    local ball = findTargetBall() -- Trouver la balle ciblée

    if ball then
        local ballPosition = ball.Position
        local ballVelocity = ball.Velocity

        detectionSphere.Position = localPlayer.Character.HumanoidRootPart.Position -- Mettre à jour la position de la sphère

        if isPlayerTarget(ball) then
            local distanceToBall = (ballPosition - detectionSphere.Position).magnitude
            local dynamicRadius = baseSphereRadius + (ballVelocity.magnitude * 0.2 - distanceToBall) -- Calculer le rayon dynamique

            -- Mettre à jour la taille de la sphère
            detectionSphere.Size = Vector3.new(dynamicRadius * 2, dynamicRadius * 2, dynamicRadius * 2)

            if isBallInSphere(ballPosition, detectionSphere.Position, dynamicRadius) then
                print("La balle est dans la sphère de détection et vise le joueur !")
                alertSound:Play() 
                -- Jouer le son si ce n'est pas déjà joué
                if not alertSound.IsPlaying then
                    alertSound:Play()
                    print("Son joué") -- Message de débogage
                end
            else
                -- Arrêter le son si la balle sort de la portée
                if alertSound.IsPlaying then
                    alertSound:Stop()
                    print("Son arrêté") -- Message de débogage
                end
            end
        end
    else
        print("Aucune balle ciblée trouvée") -- Message de débogage
    end
end

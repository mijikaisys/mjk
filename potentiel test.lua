local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

local baseSphereRadius = 5 -- Rayon de base de la sphère de détection
local detectionSphere
local alertSound = Instance.new("Sound") -- Créer un son
alertSound.SoundId = "rbxassetid://5433158470" -- Nouveau son d'alerte
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

-- Variable pour suivre l'état du son
local soundPlayed = false
local wasBallInSphere = false -- Suivre si la balle était dans la sphère

-- Facteur d'atténuation pour le rayon dynamique
local attenuationFactor = 0.7 -- Augmenté pour un meilleur ajustement

-- Fonction principale
while true do
    wait(0.05) -- Délai réduit pour une meilleure réactivité

    local ball = findTargetBall() -- Trouver la balle ciblée

    if ball then
        local ballPosition = ball.Position
        local ballVelocity = ball.Velocity

        detectionSphere.Position = localPlayer.Character.HumanoidRootPart.Position -- Mettre à jour la position de la sphère

        if isPlayerTarget(ball) then
            local distanceToBall = (ballPosition - detectionSphere.Position).magnitude
            local percentageSpeed = ballVelocity.magnitude * attenuationFactor -- Utiliser le facteur d'atténuation
            local dynamicRadius = baseSphereRadius + percentageSpeed -- Calculer le rayon dynamique

            -- Mettre à jour la taille de la sphère
            detectionSphere.Size = Vector3.new(dynamicRadius * 2, dynamicRadius * 2, dynamicRadius * 2)

            local ballInSphere = isBallInSphere(ballPosition, detectionSphere.Position, dynamicRadius)

            if ballInSphere then
                if not wasBallInSphere then
                    print("La balle est entrée dans la sphère de détection et vise le joueur !")
                    alertSound:Play() -- Jouer le son à l'entrée
                    soundPlayed = true -- Marquer que le son a été joué
                end
            else
                -- Vérifier si la balle était dans la sphère
                if wasBallInSphere then
                    print("La balle est sortie de la sphère de détection.")
                end
            end

            -- Mettre à jour l'état de la balle
            wasBallInSphere = ballInSphere
        end
    else
        print("Aucune balle ciblée trouvée") -- Message de débogage
    end
end

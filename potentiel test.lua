local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local baseSphereRadius = 20 -- Rayon de base de la sphère de détection
local detectionSphere = createDetectionSphere()
local alertSound = Instance.new("Sound") -- Créer un son
alertSound.SoundId = "rbxassetid://7128958209" -- Remplacez par l'ID de votre son
alertSound.Parent = Workspace

-- Fonction pour créer la sphère de détection
local function createDetectionSphere()
    local sphere = Instance.new("Part")
    sphere.Size = Vector3.new(baseSphereRadius * 2, baseSphereRadius * 2, baseSphereRadius * 2) -- Taille de la sphère
    sphere.Shape = Enum.PartType.Ball
    sphere.Position = localPlayer.Character.HumanoidRootPart.Position -- Position initiale à la position du joueur
    sphere.Anchored = true
    sphere.Transparency = 0.5
    sphere.Color = Color3.new(1, 0, 0) -- Couleur rouge
    sphere.Parent = Workspace

    return sphere
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
            local dynamicRadius = baseSphereRadius + (ballVelocity.magnitude - distanceToBall) -- Calculer le rayon dynamique

            if isBallInSphere(ballPosition, detectionSphere.Position, dynamicRadius) then
                print("La balle est dans la sphère de détection et vise le joueur !")
                
                -- Jouer le son si ce n'est pas déjà joué
                if not alertSound.IsPlaying then
                    alertSound:Play()
                end
            else
                -- Arrêter le son si la balle sort de la portée
                if alertSound.IsPlaying then
                    alertSound:Stop()
                end
            end
        end
    end
end

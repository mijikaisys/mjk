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
    detectionSphere.Transparency = 0.9
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

-- Fonction principale
while true do
    wait(0.05) -- Délai réduit pour une meilleure réactivité

    -- Vérifier si le personnage est vivant
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health > 0 then
        local ball = findTargetBall() -- Trouver la balle ciblée

        if ball then
            local ballPosition = ball.Position
            local ballVelocity = ball.Velocity.magnitude -- Obtenir la vitesse de la balle

            -- Mettre à jour la position de la sphère
            detectionSphere.Position = localPlayer.Character.HumanoidRootPart.Position -- Mettre à jour la position de la sphère

            if isPlayerTarget(ball) then
                local distanceToBall = (ballPosition - detectionSphere.Position).magnitude
                
                -- Calculer le rayon dynamique : base + (vitesse / 10)
                local dynamicRadius = baseSphereRadius + math.floor(ballVelocity / 9.5) -- S'agrandit de 1 toutes les 10 unités de vitesse

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
            else
                -- Réinitialiser la taille de la sphère si la balle ne vise plus le joueur
                detectionSphere.Size = Vector3.new(baseSphereRadius * 2, baseSphereRadius * 2, baseSphereRadius * 2)
                wasBallInSphere = false -- Réinitialiser l'état de la balle
            end
        else
            print("Aucune balle ciblée trouvée") -- Message de débogage
        end
    else
        -- Si le personnage est mort, ne pas mettre à jour la sphère
        print("Le personnage est mort. La sphère ne sera pas mise à jour.")
    end
end

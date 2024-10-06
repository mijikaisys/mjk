getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Rayon de détection de base
local baseDetectionRadius = 20  -- Augmenté pour une sphère de départ plus grande
local spamActive = false -- Indicateur pour le spam

task.spawn(function()
    -- Création de la sphère de détection principale
    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2) -- Taille de la sphère
    spherePart.Shape = Enum.PartType.Ball -- Forme sphérique
    spherePart.Anchored = true -- Ne pas bouger avec la physique
    spherePart.CanCollide = false -- Ne pas interagir avec d'autres objets
    spherePart.Material = Enum.Material.Neon -- Matériau de la sphère
    spherePart.Color = Color3.new(0.2, 0.2, 0.5) -- Couleur sombre (bleu foncé)
    spherePart.Transparency = 0.5 -- Transparence
    spherePart.Parent = workspace -- Ajouter la sphère au workspace

    -- Création de la sphère de spam
    local spamSpherePart = Instance.new("Part")
    spamSpherePart.Size = Vector3.new(30, 30, 30) -- Taille fixe pour la sphère de spam
    spamSpherePart.Shape = Enum.PartType.Ball -- Forme sphérique
    spamSpherePart.Anchored = true -- Ne pas bouger avec la physique
    spamSpherePart.CanCollide = false -- Ne pas interagir avec d'autres objets
    spamSpherePart.Material = Enum.Material.Neon -- Matériau de la sphère
    spamSpherePart.Color = Color3.new(1, 0.75, 0.8) -- Couleur saumon
    spamSpherePart.Transparency = 0.5 -- Transparence
    spamSpherePart.Parent = workspace -- Ajouter la sphère au workspace

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end

        -- Mettre à jour la position de la sphère autour du joueur
        spherePart.Position = Player.Character.PrimaryPart.Position -- Centrer la sphère sur le joueur
        spamSpherePart.Position = Player.Character.PrimaryPart.Position -- Centrer la sphère de spam sur le joueur

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        -- Calculer la distance et la vitesse de la cible
        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        -- Définir maxDetectionRadius égal à la vitesse de la balle
        local maxDetectionRadius = velocity 

        -- Ajuster la baseDetectionRadius en fonction de la vitesse (avec une limite)
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

        -- Vérifier si la cible est dans la sphère principale
        if distance <= adjustedBaseDetectionRadius then
            -- Si le joueur est visé, ajuster la taille de la sphère
            local newSize = math.clamp(adjustedBaseDetectionRadius - (distance * 0.3), baseDetectionRadius, adjustedBaseDetectionRadius) -- Facteur de réduction ajusté
            spherePart.Size = Vector3.new(newSize * 2, newSize * 2, newSize * 2) -- Ajuster la taille

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

            if m > 0 then
                local o = l - 5
                local p = o / n

                if parry_helper.IsPlayerTarget(par) and p <= 0.495 and not ero then
                    -- Envoyer l'événement de parry uniquement quand la balle est dans la sphère
                    VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    wait(0.01)
                    ero = true
                end
            else
                ero = false
            end
        else
            -- Si le joueur n'est pas visé, réinitialiser la taille de la sphère
            spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2) -- Retour à la taille de base
            ero = false -- Réinitialiser ero si la balle sort de la sphère
        end

        -- Vérification de la sphère de spam pour d'autres joueurs
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local otherPlayerPosition = otherPlayer.Character.HumanoidRootPart.Position
                local spamDistance = (otherPlayerPosition - spamSpherePart.Position).Magnitude
                
                if spamDistance <= spamSpherePart.Size.X / 2 then
                    -- Un autre joueur est à l'intérieur de la sphère de spam
                    spamActive = true
                    break
                else
                    spamActive = false
                end
            end
        end

        -- Boucle pour spammer SendMouseButtonEvent
        if spamActive then
            while spamActive do
                VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01) -- Petite pause pour éviter un crash
                -- Vérifier à nouveau si un autre joueur est dans la sphère de spam
                spamActive = false
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local otherPlayerPosition = otherPlayer.Character.HumanoidRootPart.Position
                        local spamDistance = (otherPlayerPosition - spamSpherePart.Position).Magnitude
                        
                        if spamDistance <= spamSpherePart.Size.X / 2 then
                            spamActive = true
                            break
                        end
                    end
                end
            end
        end
    end)
end)

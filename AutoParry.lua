getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Rayon de détection de base
local baseDetectionRadius = 10 
local maxDetectionRadius = 20 -- Taille maximale de la sphère

task.spawn(function()
    -- Création d'une sphère de détection
    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2) -- Taille de la sphère
    spherePart.Shape = Enum.PartType.Ball -- Forme sphérique
    spherePart.Anchored = true -- Ne pas bouger avec la physique
    spherePart.CanCollide = false -- Ne pas interagir avec d'autres objets
    spherePart.Material = Enum.Material.Neon -- Matériau de la sphère
    spherePart.Color = Color3.new(0.2, 0.2, 0.5) -- Couleur sombre (bleu foncé)
    spherePart.Transparency = 0.5 -- Transparence
    spherePart.Parent = workspace -- Ajouter la sphère au workspace

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

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        -- Calculer la distance et la vitesse de la cible
        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        -- Ajuster la baseDetectionRadius en fonction de la vitesse (avec une limite)
        baseDetectionRadius = math.clamp(10 + (velocity * 0.5), 10, maxDetectionRadius) -- Ajuster la taille en fonction de la vitesse

        -- Vérifier si la cible est dans la sphère
        if distance <= baseDetectionRadius then
            -- Si le joueur est visé, ajuster la taille de la sphère
            local newSize = math.clamp(baseDetectionRadius - (distance * 0.5), 5, baseDetectionRadius) -- Taille minimale de 5
            spherePart.Size = Vector3.new(newSize * 1.5, newSize * 1.5, newSize * 1.5) -- Ajuster la taille

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

                if parry_helper.IsPlayerTarget(par) and p <= 0.50 and not ero then
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
    end)
end)

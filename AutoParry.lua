getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Rayon de détection de base
local baseDetectionRadius = 27
local maxDetectionRadius = baseDetectionRadius -- Taille maximale de la sphère

task.spawn(function()
    -- Création d'une sphère de détection
    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(maxDetectionRadius * 2, maxDetectionRadius * 2, maxDetectionRadius * 2) -- Taille de la sphère
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

        -- Calculer la distance entre le joueur et la cible
        local distance = (targetPos - playerPos).Magnitude

        -- Ajuster la taille de la sphère en fonction de la distance
        local newSize = math.clamp(maxDetectionRadius - (distance * 0.5), 5, maxDetectionRadius) -- Taille minimale de 5
        spherePart.Size = Vector3.new(newSize * 2, newSize * 2, newSize * 2) -- Ajuster la taille

        -- Vérifier si la cible est dans la sphère
        if distance <= maxDetectionRadius then
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
                    VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    wait(0.01)
                    ero = true
                end
            else
                ero = false
            end
        end
    end)
end)

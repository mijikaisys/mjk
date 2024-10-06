getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Création d'un cercle (Part) autour du joueur
local detectionRadius = 10 -- Rayon du cercle de détection
local circlePart = Instance.new("Part")
circlePart.Size = Vector3.new(detectionRadius * 2, 0.1, detectionRadius * 2) -- Taille du cercle (plat)
circlePart.Shape = Enum.PartType.Cylinder -- Forme circulaire
circlePart.Anchored = true -- Ne pas bouger avec la physique
circlePart.CanCollide = false -- Ne pas interagir avec d'autres objets
circlePart.Material = Enum.Material.Neon -- Matériau du cercle
circlePart.Color = Color3.new(0, 1, 0) -- Couleur verte
circlePart.Transparency = 0.5 -- Transparence
circlePart.Parent = workspace -- Ajouter le cercle au workspace

task.spawn(function()
    RunService.PreRender:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end

        -- Mettre à jour la position du cercle autour du joueur
        circlePart.Position = Player.Character.PrimaryPart.Position + Vector3.new(0, 0.1, 0) -- Élever légèrement le cercle au-dessus du joueur

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        -- Vérifier si la cible est dans le cercle
        if (targetPos - playerPos).Magnitude <= detectionRadius then
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

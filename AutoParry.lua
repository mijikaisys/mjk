getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Rayon de détection de base
local baseDetectionRadius = 20  -- Rayon de la sphère de détection

-- Création de la sphère de détection principale
local spherePart = Instance.new("Part")
spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2) -- Taille de la sphère
spherePart.Shape = Enum.PartType.Ball -- Forme sphérique
spherePart.Anchored = true -- Ne pas bouger avec la physique
spherePart.CanCollide = false -- Ne pas interagir avec d'autres objets
spherePart.Material = Enum.Material.Glass -- Matériau de la sphère
spherePart.Color = Color3.new(0.2, 0.2, 0.5) -- Couleur sombre (bleu foncé)
spherePart.Transparency = 0.5 -- Transparence
spherePart.Parent = workspace -- Ajouter la sphère au workspace

-- Création d'un texte GUI pour afficher les informations
local screenGui = Instance.new("ScreenGui")
local textLabel = Instance.new("TextLabel")

screenGui.Parent = Player.PlayerGui
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 200, 0, 100)
textLabel.Position = UDim2.new(0.8, 0, 0, 0)
textLabel.BackgroundTransparency = 0.5
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextScaled = true

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

    -- Définir maxDetectionRadius égal à la vitesse de la balle divisée par 30%
    local maxDetectionRadius = velocity / 0.3

    -- Ajuster la baseDetectionRadius en fonction de la vitesse (avec une limite)
    local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

    -- Vérifier si la cible est dans la sphère principale
    if distance <= adjustedBaseDetectionRadius then
        -- Si le joueur est visé, ajuster la taille de la sphère
        local newSize = math.clamp(adjustedBaseDetectionRadius - (distance * 0.3), baseDetectionRadius, adjustedBaseDetectionRadius)
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

    -- Mettre à jour le texte à l'écran
    local ping = Player:GetNetworkPing() -- Obtenir le ping du joueur
    local fps = math.floor(1 / RunService.RenderStepped:Wait()) -- Calculer les FPS
    textLabel.Text = string.format("Ping: %d ms\nFPS: %d\nVitesse: %.2f", ping, fps, velocity)
end)

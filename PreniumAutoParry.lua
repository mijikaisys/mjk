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

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position
        local distance = (targetPos - playerPos).Magnitude

        if distance <= baseDetectionRadius then
            local currentTime = tick() -- Obtenir le temps actuel

            if parry_helper.IsPlayerTarget(par) and not ero then
                -- Vérifier si le temps écoulé depuis le dernier parry est supérieur ou égal à parryInterval
                if currentTime - lastParryTime >= parryInterval then
                    -- Appel à hitremote
                    local args = {
                        0.5, -- Délai ou paramètre
                        CFrame.new(playerPos), -- Utiliser la position du joueur
                        {}, -- Remplir avec les joueurs cibles ou autres
                        {math.random(200, 500), math.random(100, 200)}, -- Valeurs aléatoires
                        false
                    }
                    hitremote:FireServer(unpack(args)) -- Appeler hitremote
                    spherePart.Color = Color3.new(0, 1, 0) -- Indicate parry successful
                    ero = true
                    lastParryTime = currentTime
                end
            else
                spherePart.Color = Color3.new(1, 0, 0) -- Indicate parry failed
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

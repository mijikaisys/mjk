getgenv().autospam = false
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

local function startAutoSpam()
    local playerPos = Player.Character.PrimaryPart.Position
    local autoSpamActive = true
    local spamStartTime = tick()
    local spamDuration = 0.2 -- Durée pendant laquelle l'autospam est actif

    while autoSpamActive do
        local par = parry_helper.FindTargetBall()
        if par then
            local args = {
                0.5, -- Délai ou paramètre
                CFrame.new(playerPos), -- Utiliser la position du joueur
                {}, -- Remplir avec les joueurs cibles ou autres
                {math.random(200, 500), math.random(100, 200)}, -- Valeurs aléatoires
                false
            }
            hitremote:FireServer(unpack(args)) -- Appeler hitremote 
            wait()
        end

        if tick() - spamStartTime >= spamDuration then
            autoSpamActive = false -- Désactiver l'autospam après la durée spécifiée
        end
    end
end

-- Exemple d'activation de l'autospam
startAutoSpam()

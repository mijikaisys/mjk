getgenv().autoparry = true
getgenv().antiCurveEnabled = true -- Activer l'anti-curve

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

-- Résolution du RemoteEvent pour le parry
local parry_remote = nil
local function resolveParryRemote()
    for _, v in pairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("RemoteEvent") and v.Name:find("\n") then
            parry_remote = v
            break
        end
    end
end

-- Fonction pour détecter la balle la plus proche
local function getClosestBall()
    return workspace:FindFirstChild("Balls"):FindFirstChildOfClass("Part")
end

-- Anti-curve
local function preventCurve(ball)
    local previousPosition = ball.Position
    RunService.Heartbeat:Connect(function()
        if getgenv().antiCurveEnabled then
            local currentPosition = ball.Position
            local velocity = ball.Velocity

            if (currentPosition - previousPosition).Magnitude > 0.1 and velocity.Magnitude > 0 then
                ball.Velocity = (currentPosition - previousPosition).Unit * velocity.Magnitude
            end

            previousPosition = currentPosition
        end
    end)
end

local function initializeParry()
    local ero = false
    local baseDetectionRadius = 20
    local lastParryTime = 0
    local parryInterval = 0.252 -- Intervalle en secondes entre chaque parry
    local autoSpamActive = false
    local spamStartTime = 0
    local spamDuration = 0.2 -- Durée pendant laquelle l'autospam est actif

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://5433158470"

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
        local velocity = par.AssemblyLinearVelocity.Magnitude

        local maxDetectionRadius = velocity / 0.15
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

        if distance <= adjustedBaseDetectionRadius then
            -- Appel à hitremote
            local targetCFrame = CFrame.new(playerPos, targetPos) -- Utiliser le CFrame orienté vers la cible
            local args = {
                0.5, -- Délai ou paramètre
                targetCFrame, -- Utiliser le CFrame orienté vers la cible
                {}, -- Remplir avec les joueurs cibles ou autres
                {math.random(200, 500), math.random(100, 200)}, -- Valeurs aléatoires
                false
            }
            hitremote:FireServer(unpack(args)) -- Appeler hitremote
            spherePart.Color = Color3.new(0, 1, 0) -- Indicate parry successful
            ero = true
            lastParryTime = tick() -- Met à jour le temps du dernier parry
        else
            spherePart.Color = Color3.new(1, 0, 0) -- Indicate parry failed
        end

        -- Gestion de l'autospam
        if autoSpamActive then
            local currentTime = tick()
            if currentTime - spamStartTime < spamDuration then
                local args = {
                    0.5, -- Délai ou paramètre
                    CFrame.new(playerPos), -- Utiliser la position du joueur
                    {}, -- Remplir avec les joueurs cibles ou autres
                    {math.random(200, 500), math.random(100, 200)}, -- Valeurs aléatoires
                    false
                }
                hitremote:FireServer(unpack(args)) -- Appeler hitremote 
                wait()
            else
                autoSpamActive = false -- Désactiver l'autospam après la durée spécifiée
                ero = false 
            end
        end
    end)

    -- Écoute des ajouts de balles
    workspace.Balls.ChildAdded:Connect(function(ball)
        if ball:IsA("BasePart") then
            preventCurve(ball)
        end
    end)
end

-- Écoute des événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait()  -- Attendre un moment pour s'assurer que le personnage est complètement chargé
    initializeParry()  -- Réinitialiser le parry à chaque respawn
end)

-- Initialiser le parry au démarrage
resolveParryRemote()
initializeParry()

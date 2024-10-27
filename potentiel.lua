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

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            ero = false -- Réinitialiser si aucune cible n'est trouvée
            return 
        end

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude
        local maxDetectionRadius = velocity / 0.15

        if distance <= maxDetectionRadius then
            local currentTime = tick()

            -- Vérifier si le dernier parry a été fait assez loin dans le temps
            if currentTime - lastParryTime >= parryInterval and not ero then
                -- Appel à hitremote
                local args = {
                    0.5, -- Délai ou paramètre
                    CFrame.new(playerPos, targetPos), -- Utiliser le CFrame orienté vers la cible
                    {}, -- Remplir avec les joueurs cibles ou autres
                    {math.random(200, 500), math.random(100, 200)}, -- Valeurs aléatoires
                    false
                }
                hitremote:FireServer(unpack(args)) -- Appeler hitremote
                lastParryTime = currentTime -- Met à jour le temps du dernier parry
                ero = true -- Marquer que le parry a été effectué
            end
        else
            if ero then
                ero = false -- Réinitialiser ero si la distance dépasse le seuil
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
initializeParry()

getgenv().autoparry = true

local a = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local function initializeParry()
    local ero = false
    local baseDetectionRadius = 20
    local lastParryTime = 0
    local parryInterval = 0.252 -- Intervalle en secondes entre chaque parry
    local autoSpamActive = false
    local spamStartTime = 0
    local spamDuration = 0.260 -- Durée pendant laquelle l'autospam est actif

    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.95 -- Rend la sphère presque invisible
    spherePart.Parent = workspace

    local function getClosestEntity()
        local closest_Entity = nil
        local shortestDistance = math.huge
        for _, entity in pairs(workspace.Alive:GetChildren()) do
            if entity:IsA("Model") and entity:FindFirstChild("HumanoidRootPart") then
                local distance = (Player.Character.PrimaryPart.Position - entity.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closest_Entity = entity
                    shortestDistance = distance
                end
            end
        end
        return closest_Entity
    end

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then return end

        local par = parry_helper.FindTargetBall()
        if not par then return end

        local distance = (par.Position - Player.Character.PrimaryPart.Position).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        local maxDetectionRadius = velocity / 0.15
        local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

        if distance <= adjustedBaseDetectionRadius then
            local closest_Entity = getClosestEntity()
            if closest_Entity and parry_helper.IsPlayerTarget(par) and not ero then
                local currentTime = tick()
                if currentTime - lastParryTime < parryInterval then
                    autoSpamActive = true
                    spamStartTime = currentTime
                end

                -- **Effectuer le parry sans bloquer les contrôles**
                task.spawn(function()
                    a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait()
                    a:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end)

                ero = true
                lastParryTime = currentTime
            end
        else
            ero = false -- Réinitialiser pour permettre un nouveau parry
        end

        -- **Gestion de l'autospam**
        if autoSpamActive then
            local currentTime = tick()
            if currentTime - spamStartTime < spamDuration then
                local closest_Entity = getClosestEntity()
                if closest_Entity then
                    task.spawn(function()
                        a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait()
                        a:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end)
                end
            else
                autoSpamActive = false -- Désactiver l'autospam après la durée spécifiée
            end
        end
    end)
end

-- Écouter les événements de changement de personnage
Player.CharacterAdded:Connect(function()
    wait()  
    initializeParry()
end)

-- Initialiser le parry à la première exécution
initializeParry()

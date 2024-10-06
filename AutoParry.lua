getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Rayon de détection de base
local baseDetectionRadius = 20  -- Augmenté pour une sphère de départ plus grande

-- Création de la sphère de détection principale
local spherePart = Instance.new("Part")
spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
spherePart.Shape = Enum.PartType.Ball
spherePart.Anchored = true
spherePart.CanCollide = false
spherePart.Material = Enum.Material.Neon
spherePart.Color = Color3.new(0.2, 0.2, 0.5)
spherePart.Transparency = 0.5
spherePart.Parent = workspace

-- Création de la sphère de spam avec une taille fixe de 20
local spamSphereSize = 40
local spamSpherePart = Instance.new("Part")
spamSpherePart.Size = Vector3.new(spamSphereSize, spamSphereSize, spamSphereSize)
spamSpherePart.Shape = Enum.PartType.Ball
spamSpherePart.Anchored = true
spamSpherePart.CanCollide = false
spamSpherePart.Material = Enum.Material.Neon
spamSpherePart.Color = Color3.new(1, 0.75, 0.8)
spamSpherePart.Transparency = 0.5
spamSpherePart.Parent = workspace

local function isHumanoidNear()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local otherPlayerPosition = otherPlayer.Character.HumanoidRootPart.Position
            local distance = (otherPlayerPosition - spamSpherePart.Position).Magnitude
            
            if distance <= spamSpherePart.Size.X / 2 then
                return true
            end
        end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if not getgenv().autoparry then 
        return 
    end

    local par = parry_helper.FindTargetBall()
    if not par then 
        return 
    end

    spherePart.Position = Player.Character.PrimaryPart.Position
    spamSpherePart.Position = Player.Character.PrimaryPart.Position

    local playerPos = Player.Character.PrimaryPart.Position
    local targetPos = par.Position

    local distance = (targetPos - playerPos).Magnitude
    local velocity = par.AssemblyLinearVelocity.Magnitude
    local maxDetectionRadius = velocity 
    local adjustedBaseDetectionRadius = math.clamp(baseDetectionRadius + (velocity * 0.2), baseDetectionRadius, maxDetectionRadius) 

    if distance <= adjustedBaseDetectionRadius then
        local newSize = math.clamp(adjustedBaseDetectionRadius - (distance * 0.3), baseDetectionRadius, adjustedBaseDetectionRadius)
        spherePart.Size = Vector3.new(newSize * 2, newSize * 2, newSize * 2)

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
    else
        spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
        ero = false
    end

    if isHumanoidNear() then
        VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        wait(0.01)
    end
end)

getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local ero = false

-- Création d'un ScreenGui et d'un cercle
local screenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local circle = Instance.new("Frame")

-- Paramètres du cercle
circle.Size = UDim2.new(0, 100, 0, 100) -- Taille du cercle
circle.Position = UDim2.new(0.5, -50, 0.5, -50) -- Position initiale au centre de l'écran
circle.BackgroundColor3 = Color3.new(1, 1, 1) -- Couleur blanche
circle.BackgroundTransparency = 0.5 -- Transparence
circle.AnchorPoint = Vector2.new(0.5, 0.5) -- Centrer l'ancre du cercle
circle.Parent = screenGui

-- Fonction pour mettre à jour la position et la taille du cercle
local function updateCircle(target)
    if target then
        local targetPos = target.Position
        local targetVelocity = target.AssemblyLinearVelocity
        local screenPos = workspace.CurrentCamera:WorldToScreenPoint(targetPos)

        circle.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)

        -- Ajuster la taille en fonction de la vitesse
        local velocityMagnitude = targetVelocity.Magnitude
        circle.Size = UDim2.new(0, 100 + velocityMagnitude, 0, 100 + velocityMagnitude)
    end
end

task.spawn(function()
    RunService.PreRender:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end

        updateCircle(par) -- Met à jour la position du cercle en fonction de la cible

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
    end)
end)

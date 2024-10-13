getgenv().autoparry = true

local VirtualManager = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService('RunService')
local parry_helper = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleScript/TripleHub/main/helper_.lua"))()

local function initializeParry()
    local ero = false
    local stats = {
        successfulParries = 0,
        failedParries = 0,
    }

    local baseDetectionRadius = 20
    local spamTimer = 0
    local isSpamming = false

    local spherePart = Instance.new("Part")
    spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
    spherePart.Shape = Enum.PartType.Ball
    spherePart.Anchored = true
    spherePart.CanCollide = false
    spherePart.Material = Enum.Material.ForceField
    spherePart.Color = Color3.new(0.2, 0.2, 0.5)
    spherePart.Transparency = 0.5
    spherePart.Parent = workspace

    local screenGui = Instance.new("ScreenGui")
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 100)
    textLabel.Position = UDim2.new(0.8, 0, 0, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    screenGui.Parent = Player.PlayerGui
    textLabel.Parent = screenGui

    local parrySound = Instance.new("Sound", Player.Character)
    parrySound.SoundId = "rbxassetid://7108607217"

    local proximityIndicator = Instance.new("Part")
    proximityIndicator.Size = Vector3.new(5, 5, 5)
    proximityIndicator.Shape = Enum.PartType.Ball
    proximityIndicator.Anchored = true
    proximityIndicator.CanCollide = false 
    proximityIndicator.Color = Color3.new(1, 1, 0)
    proximityIndicator.Parent = workspace

    RunService.RenderStepped:Connect(function()
        if not getgenv().autoparry then 
            return 
        end

        local par = parry_helper.FindTargetBall()
        if not par then 
            return 
        end

        spherePart.Position = Player.Character.PrimaryPart.Position

        local playerPos = Player.Character.PrimaryPart.Position
        local targetPos = par.Position

        local distance = (targetPos - playerPos).Magnitude
        local velocity = par.AssemblyLinearVelocity.Magnitude

        if velocity > 205 then
            baseDetectionRadius = math.min(150, baseDetectionRadius * 2)
        end

        local maxDetectionRadius = velocity / 0.3
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

            local thresholdP = 0.50

            if velocity > 205 then
                thresholdP = 0.55
            end

            if velocity > 500 then
                thresholdP = 0.56
            end

            if m > 0 then
                local o = l - 5
                local p = o / n

                if parry_helper.IsPlayerTarget(par) and p <= thresholdP and not ero then
                    VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    parrySound:Play()
                    stats.successfulParries = stats.successfulParries + 1
                    spherePart.Color = Color3.new(0, 1, 0)
                    ero = true
                    spamTimer = 0 -- Réinitialiser le timer lorsque le parry est réussi
                else
                    stats.failedParries = stats.failedParries + 1
                    spherePart.Color = Color3.new(1, 0, 0)
                end
            else
                ero = false
            end

            -- Gestion de l'auto-spam
            if distance <= 20 then
                spamTimer = spamTimer + RunService.RenderStepped:Wait() -- Incrémenter le timer
                if spamTimer >= 3 then
                    isSpamming = true
                end
            else
                spamTimer = 0 -- Réinitialiser le timer si la balle s'éloigne
                isSpamming = false
            end

            if isSpamming then
                -- Spam des événements de clic
                for i = 1, 5 do -- Modifier le nombre de répétitions si nécessaire
                    VirtualManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                end
            end

            proximityIndicator.Position = Player.Character.PrimaryPart.Position
        else
            spherePart.Size = Vector3.new(baseDetectionRadius * 2, baseDetectionRadius * 2, baseDetectionRadius * 2)
            ero = false
            proximityIndicator.Position = Vector3.new(0, -1000, 0)
            spamTimer = 0 -- Réinitialiser le timer si la balle s'éloigne
            isSpamming = false -- Arrêter le spam
        end

        local ping = Player:GetNetworkPing()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        textLabel.Text = string.format("Ping: %d ms\nFPS: %d\nVitesse: %.2f\nParrys réussis: %d\nParrys échoués: %d", ping, fps, velocity, stats.successfulParries, stats.failedParries)
    end)
end

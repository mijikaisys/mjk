local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/DenDenZYT/DenDenZ-s-Open-Source-Collection/main/Component"))()

local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local closest_Entity = nil
local parry_remote = nil

-- Paramètres par défaut
getgenv().aura_Enabled = true 
getgenv().AutoParry = true
getgenv().DistanceToParry = 0.4355 -- Distance par défaut


frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fonction pour trouver la balle
local function FindBall()
    local RealBall
    for _, v in pairs(workspace:WaitForChild("Balls", 9e9):GetChildren()) do
        if v:GetAttribute("realBall") == true then
            RealBall = v
            break
        end
    end
    return RealBall
end

-- Résoudre le remote de parry
local function resolve_parry_Remote()
    for _, service in pairs({game:GetService("AdService"), game:GetService("SocialService")}) do
        local temp_remote = service:FindFirstChildOfClass("RemoteEvent")
        if temp_remote and temp_remote.Name:find("\n") then
            parry_remote = temp_remote
            break
        end
    end
end

local isClicking = false -- Variable pour contrôler l'état du clic

spawn(function()
    b.PreRender:Connect(function()
        if not getgenv().AutoParry then return end

        local g = d.FindTargetBall()
        if not g then return end

        local h = g.AssemblyLinearVelocity
        if g:FindFirstChild('zoomies') then 
            h = g.zoomies.VectorVelocity
        end

        local i = g.Position
        local j = c.Character.PrimaryPart.Position
        local k = (j - i).Unit
        local l = c:DistanceFromCharacter(i)
        local m = k:Dot(h.Unit)
        local n = h.Magnitude

        if m > 0 then
            local o = l - 5
            local p = o / n

            -- Vérification de la distance avant d'envoyer le clic
            if d.IsPlayerTarget(g) and p <= getgenv().DistanceToParry and not isClicking then
                isClicking = true -- Indiquer qu'un clic est en cours
                a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01)
                a:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                isClicking = false -- Réinitialiser l'état après le clic
            end
        end
    end)
end)

initialize("venox_temp")

-- Événements de succès de parry
ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if getgenv().hit_sound_Enabled then
        hit_Sound:Play()
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()
    aura_table.hit_Count += 1
    task.delay(0.010, function()
        aura_table.hit_Count -= 1
    end)
end)
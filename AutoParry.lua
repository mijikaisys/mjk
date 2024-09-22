local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/DenDenZYT/DenDenZ-s-Open-Source-Collection/main/Component"))()

local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local closest_Entity = nil
local parry_remote = nil

-- Paramètres par défaut
getgenv().aura_Enabled = false
getgenv().AutoParry = true
getgenv().DistanceToParry = 0.47 -- Distance par défaut

-- Création de l'UI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local distanceInput = Instance.new("TextBox")

screenGui.Parent = c:WaitForChild("PlayerGui")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.Parent = screenGui

toggleButton.Size = UDim2.new(1, 0, 0, 50)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.Text = "Activer Autoparry"
toggleButton.Parent = frame

distanceInput.Size = UDim2.new(1, 0, 0, 50)
distanceInput.Position = UDim2.new(0, 0, 0, 50)
distanceInput.PlaceholderText = "Distance"
distanceInput.Text = tostring(getgenv().DistanceToParry)
distanceInput.Parent = frame

toggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoParry = not getgenv().AutoParry
    toggleButton.Text = getgenv().AutoParry and "Désactiver Autoparry" or "Activer Autoparry"
end)

distanceInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newDistance = tonumber(distanceInput.Text)
        if newDistance then
            getgenv().DistanceToParry = newDistance
        end
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

            if d.IsPlayerTarget(g) and p <= getgenv().DistanceToParry then
                a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01)
            end
        end
    end)
end)

initialize("venox_temp")
resolve_parry_Remote()

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

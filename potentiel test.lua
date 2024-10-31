local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera -- Assurez-vous que cela pointe vers la caméra actuelle

-- Fonction pour résoudre le parry_remote
function resolve_parry_Remote()
    for _, value in pairs(ReplicatedStorage:GetChildren()) do
        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')
        if not temp_remote then
            continue
        end
        if not temp_remote.Name:find('\n') then
            continue
        end
        return temp_remote -- Retourne le parry_remote trouvé
    end
end

local parry_remote = resolve_parry_Remote()

-- Créer un bouton
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Parry"
button.Parent = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui") -- Assurez-vous qu'un ScreenGui existe

-- Fonction pour le clic du bouton
button.MouseButton1Click:Connect(function()
    if parry_remote then
        local closest_Entity = --[[ logiques pour trouver l'entité la plus proche ]]
        local target_Position = --[[ logiques pour définir la position cible ]]
        
        parry_remote:FireServer(
            0.5,
            CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),
            {[closest_Entity.Name] = target_Position},
            {target_Position.X, target_Position.Y},
            false
        )
    else
        warn("Parry remote non trouvé")
    end
end)


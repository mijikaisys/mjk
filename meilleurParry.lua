local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

-- Configuration du ScreenGui
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Configuration du bouton
Button.Size = UDim2.new(0, 100, 0, 50) -- Taille du bouton
Button.Position = UDim2.new(0.5, 200, 0.5, -25) -- Position du bouton
Button.Text = "Fire Hit Remote"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Couleur de fond
Button.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte
Button.Parent = ScreenGui

-- Fonction pour trouver le RemoteEvent
local hitremote
for p,v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local debounce = false
local manualspamspeed = 5 -- Nombre de fois que le RemoteEvent sera appelé

-- Fonction pour déclencher le RemoteEvent
local function fireHitRemote()
    if debounce then return end
    debounce = true
    delay(0.05, function() debounce = false end)
    
    for p = 1, manualspamspeed do
        local args = {
            [1] = 0.5,
            [2] = CFrame.new(math.random(-10, 10), 0, math.random(-10, 10)), -- Exemple de CFrame aléatoire
            [3] = {}, -- Remplir avec les joueurs cibles ou autres
            [4] = {
                [1] = math.random(200, 500),
                [2] = math.random(100, 200)
            },
            [5] = false
        }
        hitremote:FireServer(unpack(args))
    end
end

-- Connecter la fonction au clic du bouton
Button.MouseButton1Click:Connect(fireHitRemote)

-- Détection de l'appui sur le bouton B de la manette Xbox
local UserInputService = game:GetService("UserInputService")

local function onInputBegan(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonB then
        fireHitRemote() -- Appeler la fonction lorsque le bouton B est pressé
    end
end

-- Connecter l'événement d'entrée
UserInputService.InputBegan:Connect(onInputBegan)

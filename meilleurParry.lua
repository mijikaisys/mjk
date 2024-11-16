game:GetService("Players").LocalPlayer:WaitForChild("PlayIt")
local Players = game:GetService("Players")

-- Assurez-vous que le RemoteEvent "PlayIt" existe déjà dans les objets du joueur
local function onPlayItEvent(player, action)
    if action == "Howl" then
        print(player.Name .. " a exécuté Howl !") -- Remplacer par l'action que vous voulez réaliser
        -- Ajoutez ici le code pour effectuer l'action Howl
    end
end

-- Connectez le RemoteEvent aux joueurs
local playItEvent = Players.PlayerAdded:Wait():WaitForChild("PlayIt")
playItEvent.OnServerEvent:Connect(onPlayItEvent)
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Configuration du bouton
Button.Size = UDim2.new(0, 100, 0, 30) -- Taille du bouton
Button.Position = UDim2.new(0.8, -50, 0.5, -15) -- Positionné à droite de l'écran
Button.Text = "Jouer Howl"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Couleur de fond
Button.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte
Button.Parent = ScreenGui

-- Fonction pour exécuter l'action sur le clic du bouton
Button.MouseButton1Click:Connect(function()
    local args = {
        [1] = "Howl"
    }

    print("Tentative d'envoi de l'action Howl...")
    Player:WaitForChild("PlayIt"):FireServer(unpack(args)) -- Utiliser le RemoteEvent existant
end)

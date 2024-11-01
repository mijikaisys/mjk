local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local hitremote

-- Fonction pour trouver le RemoteEvent
for p, v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local debounce = false
local manualspamspeed = 5 -- Nombre de fois que le RemoteEvent sera appelé
local isBPressed = false
local Button

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

-- Fonction pour créer le bouton
local function createButton()
    -- Vérifiez si le bouton existe déjà et le supprimez si c'est le cas
    if Button then
        Button:Destroy()
    end

    -- Créez un nouveau ScreenGui et un bouton
    local ScreenGui = Instance.new("ScreenGui")
    Button = Instance.new("TextButton")

    -- Configuration du ScreenGui
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")

    -- Configuration du bouton
    Button.Size = UDim2.new(0, 100, 0, 50) -- Taille du bouton
    Button.Position = UDim2.new(0.5, 200, 0.5, -25) -- Position du bouton
    Button.Text = "Fire Hit Remote"
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Couleur de fond
    Button.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte
    Button.Parent = ScreenGui

    -- Connecter la fonction au clic du bouton
    Button.MouseButton1Click:Connect(fireHitRemote)
end

-- Détection de l'appui sur les boutons de la manette Xbox
local function onInputBegan(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonB then
            isBPressed = true
            while isBPressed do
                fireHitRemote()
                wait(0.05) -- Délai pour spammer rapidement
            end
        elseif input.KeyCode == Enum.KeyCode.ButtonL2 then -- LT est généralement ButtonL2
            fireHitRemote() -- Appeler une seule fois pour LT
        end
    end
end

local function onInputEnded(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonB then
            isBPressed = false
        end
    end
end

-- Événement pour recréer le bouton lorsque le personnage est réapparu
Player.CharacterAdded:Connect(function()
    createButton() -- Recrée le bouton lorsque le personnage est réapparu
end)

-- Créez le bouton pour la première fois
createButton()

-- Connecter les événements d'entrée
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

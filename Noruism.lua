-- Chargement de la librairie Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Création de la fenêtre principale
local Window = Fluent:CreateWindow({
    Title = "Fluent GUI",
    SubTitle = "by You",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Création de l'onglet Main
local MainTab = Window:AddTab({ Title = "Main", Icon = "" })

-- **Bouton qui exécute un loadstring et affiche une notification**
MainTab:AddButton({
    Title = "Exécuter le script",
    Description = "Cliquez pour charger le script",
    Callback = function()
        Fluent:Notify({
            Title = "Script",
            Content = "Exécution du script...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://your-script-url.com/script.lua"))()
    end
})

-- **Toggle avec notifications**
local Toggle = MainTab:AddToggle("NotifToggle", {Title = "Activer Notifications", Default = false })

Toggle:OnChanged(function()
    if Toggle.Value then
        Fluent:Notify({
            Title = "Toggle",
            Content = "Le toggle est activé",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Toggle",
            Content = "Le toggle est désactivé",
            Duration = 3
        })
    end
end)

-- **Slider fonctionnel**
local Slider = MainTab:AddSlider("MySlider", {
    Title = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 1, -- Pour éviter les nombres à virgule si non voulu
    Callback = function(Value)
        Fluent:Notify({
            Title = "Slider",
            Content = "Valeur du slider : " .. Value,
            Duration = 2
        })
    end
})

Slider:OnChanged(function(Value)
    print("Slider modifié :", Value)
end)

Slider:SetValue(50) -- Définit une valeur initiale correcte

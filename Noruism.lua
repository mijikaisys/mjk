local AP = loadstring(game:HttpGet("https://raw.githubusercontent.com/mijikaisys/mjk/refs/heads/main/NoruismAp.lua"))()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Création de la fenêtre principale
local Window = Fluent:CreateWindow({
    Title = "Noruism",
    SubTitle = " by drpon63",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Création de l'onglet Main
local MainTab = Window:AddTab({ Title = "Main", Icon = "" })

-- **Bouton qui exécute un loadstring et affiche une notification**
MainTab:AddButton({
    Title = "AutoParry Click Once!",
    Description = "AutoParry can't be truned off (for now)",
    Callback = function()
        Fluent:Notify({
            Title = "AutoParry",
            Content = "AutoParry is ON...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mijikaisys/mjk/refs/heads/main/PreniumAutoParry.lua"))()
    end
})

-- **Toggle avec notifications**
local Toggle = MainTab:AddToggle("NotifToggle", {Title = "AutoSpam", Default = false })

Toggle:OnChanged(function()
    if Toggle.Value then
        Fluent:Notify({
            Title = "AutoSpam",
            Content = "AutoSpam activated",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "AutoSpam",
            Content = "AutoSpam OFF",
            Duration = 3
        })
    end
end)

-- **Slider fonctionnel**
local Slider = MainTab:AddSlider("MySlider", {
    Title = "AutoSpam Speed",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1
})

Slider:OnChanged(function(Value)
    print("Slider modifié :", Value)
end)

Slider:SetValue(3) -- Définit une valeur initiale correcte

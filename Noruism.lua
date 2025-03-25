local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
 
 
 local Window = Fluent:CreateWindow({
     Title = "Noruism",
     SubTitle = "by drpon63",
     TabWidth = 160,
     Size = UDim2.fromOffset(580, 460),
     Acrylic = false,
     Theme = "Aqua",
     MinimizeKey = Enum.KeyCode.LeftControl
 })
 
 
 local MainTab = Window:AddTab({ Title = "Main", Icon = "" })
 
 MainTab:AddButton({
     Title = "AutoParry",
     Description = "Can't turn off AutoParry after ( for now )",
     Callback = function()
         Fluent:Notify({
             Title = "AutoParry",
             Content = "Exexuting script...",
             Duration = 3
         })
         loadstring(game:HttpGet("https://raw.githubusercontent.com/mijikaisys/mjk/refs/heads/main/PreniumAutoParry.lua"))()
   
         
         end
     end
 })
 
 
 local Toggle = MainTab:AddToggle("NotifToggle", {Title = "AutoSpam", Default = false })
 
 Toggle:OnChanged(function()
     if Toggle.Value then
         Fluent:Notify({
             Title = "Toggle",
             Content = "AutoSpam activated",
             Duration = 3
         })
     else
         Fluent:Notify({
             Title = "Toggle",
             Content = "AutoSpam OFF",
             Duration = 3
         })
     end
 end)
 
 
 local Slider = MainTab:AddSlider("MySlider", {
     Title = "AutoSpam Speed",
     Min = 0,
     Max = 10,
     Default = 3,
     Rounding = 1, 
     Callback = function(Value)
         Fluent:Notify({
             Title = "Slider",
             Content = "Valeur du slider : " .. Value,
             Duration = 0
         })
     end
 })
 
 Slider:OnChanged(function(Value)
     print("Slider modifié :", Value)
 end)
 
 Slider:SetValue(3)

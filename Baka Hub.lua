local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Baka Hub BETA", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Baka",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Combat"
})

OrionLib:MakeNotification({
	Name = "Merci ^^",
	Content = "Merci d'utiliser la version BETA!!! UwU",
	Image = "rbxassetid://4483345998",
	Time = 5
})

OrionLib:MakeNotification({
	Name = "Bientôt...",
	Content = "Il y aura bientôt plus de choses!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

OrionLib:MakeNotification({
	Name = "Créatrice",
	Content = "Made by Asuna_0nO",
	Image = "rbxassetid://4483345998",
	Time = 5
})

Tab:AddButton({
	Name = "Auto Parry",
	Callback = function()
			
			loadstring(game:HttpGet("https://raw.githubusercontent.com/mijikaisys/mjk/refs/heads/main/AutoParry.lua"))()
  	end    
})

Tab:AddButton({
    Name = "AutoSpam",
    Callback = function()
      while true do
         task.wait()
         local ball = workspace.Balls:FindFirstChildWhichIsA("BasePart")
         local hum = game.Players.LocalPlayer.Character
         local balldist = 6
         if ball then
         local dist = (ball.Position - hum.HumanoidRootPart.position).Magnitude
         if dist <= balldist and hum:FindFirstChild("Highlight") then
         keypress(0x46)
         end
				end			
Tab:AddButton({
	Name = "Il y aura bientôt plus de choses!",
	Callback = function()
      		print("Il y aura bientôt plus de choses!")
  	end    
})

Tab:AddButton({
	Name = "Sript fait par Asuna_0nO",
	Callback = function()
      		print("Sript fait par Asuna_0nO")
  	end    
})

local NiceTab = Window:MakeTab({
	Name = "Status",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local NiceSection = NiceTab:AddSection({
	Name = "SRIPTS STATUS"
})

NiceTab:AddButton({
	Name = "Auto Parry (fonctionne)",
	Callback = function()
      		print("Auto Parry (fonctionne)")
  	end    
})


--[[local NowTab = Window:MakeTab({
	Name = "Official Links",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local NowSection = NowTab:AddSection({
	Name = "OFFICIAL LINKS"
})

NowTab:AddButton({
	Name = "Copy PasteDrop Link",
	Callback = function()
      		setclipboard("https://paste-drop.com") --This Will Copy The Link Of The Key
  	end    
})

NowTab:AddButton({
	Name = "Copy Twitter/X Link",
	Callback = function()
      		setclipboard("https://x.com/ThePasteDrop") --This Will Copy The Link Of The Key
  	end    
})

NowTab:AddButton({
	Name = "Copy YouTube Link",
	Callback = function()
      		setclipboard("www.youtube.com/@pastedrop") --This Will Copy The Link Of The Key
  	end    
})

NowTab:AddButton({
	Name = "Copy YouTube Link 2",
	Callback = function()
      		setclipboard("https://youtube.com/@bxnksscripts?si=plzEJJC2HaajFSL7") --This Will Copy The Link Of The Key
  	end    
})
]]--

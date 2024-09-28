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
      end

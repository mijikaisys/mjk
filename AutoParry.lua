local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/DenDenZYT/DenDenZ-s-Open-Source-Collection/main/Component"))() 

local e = false

spawn(function()
    b.PreRender:Connect(function()
        if not getgenv().f then return end

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

            if d.IsPlayerTarget(g) and p <= 0.35 and not e then
                a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01)
                e = true
            end
        else
            e = false
        end
    end)
end)

local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/mijikaisys/mjk/refs/heads/main/AutoParryHelper.lua"))() 

local hitremote
for _, v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

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

            if d.IsPlayerTarget(g) and p <= 0.55 and not e then
                parry_remote:FireServer(
                            0.5,
                            CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),
                            {[closest_Entity.Name] = target_Position},
                            {target_Position.X, target_Position.Y},
                            false
                        )
                wait(0.01)
                e = true
            end
        else
            e = false
        end
    end)
end)

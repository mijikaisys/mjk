if not game:IsLoaded() then
    game.Loaded:Wait()
end

local v = game:GetService("VirtualInputManager")
local Players = game:GetService('Players')
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local hitremote

-- Détection du RemoteEvent
for _, v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local s = Instance.new("ScreenGui")
s.Parent = game.CoreGui

local b = Instance.new("TextButton")
b.Size = UDim2.new(0, 200, 0, 50)
b.Position = UDim2.new(0.5, -100, 0.5, -25)
b.AnchorPoint = Vector2.new(0.5, 0.5)
b.BackgroundColor3 = Color3.new(0, 0, 0)
b.BorderSizePixel = 2
b.BorderColor3 = Color3.new(1, 1, 1)
b.Text = "MODE BAKA!"
b.TextColor3 = Color3.new(1, 1, 1)
b.TextScaled = true
b.Font = Enum.Font.LuckiestGuy
b.TextXAlignment = Enum.TextXAlignment.Center
b.TextYAlignment = Enum.TextYAlignment.Center
b.Parent = s

local t = false
b.MouseButton1Click:Connect(function()
    t = not t
    b.Text = t and "BAKAAAAA" or "UnU"
    
    local playerPos = Player.Character.PrimaryPart.Position
    while t do
        -- Appel à hitremote avec des paramètres fictifs
        local args = {
            0.5,
            CFrame.new(playerPos),
            {},
            {math.random(200, 500), math.random(100, 200)},
            false
        }
        hitremote:FireServer(unpack(args)) -- Utilisation de hitremote
        wait() -- Ajuste ce délai pour contrôler la fréquence des appels
    end
end)

local d
local i
local ds
local sp

local function u(input)
    local delta = input.Position - ds
    b.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end

b.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        d = true
        ds = input.Position
        sp = b.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                d = false
            end
        end)
    end
end)

b.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        i = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if d and input == i then
        u(input)
    end
end)


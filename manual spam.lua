if not game:IsLoaded() then
    game.Loaded:Wait()
end

local v = game:GetService("VirtualInputManager")
local s = Instance.new("ScreenGui")
s.Parent = game.CoreGui

local b = Instance.new("TextButton")
b.Size = UDim2.new(0, 100, 0, 50)
b.Position = UDim2.new(0.5, -200, 0.5, -50)
b.AnchorPoint = Vector2.new(0.5, 0.5)
b.BackgroundColor3 = Color3.new(0, 0, 0)
b.BorderSizePixel = 2
b.BorderColor3 = Color3.new(1, 1, 1)
b.Text = "UwU SPAM"
b.TextColor3 = Color3.new(1, 1, 1)
b.TextScaled = true
b.Font = Enum.Font.LuckiestGuy
b.TextXAlignment = Enum.TextXAlignment.Center
b.TextYAlignment = Enum.TextYAlignment.Center
b.Parent = s
local hitremote
for _, w in next, game:GetDescendants() do
    if w and w.Name:find("\n") and w:IsA("RemoteEvent") then
        hitremote = w
        break
    end
end

local t = false
b.MouseButton1Click:Connect(function()
    t = not t
    b.Text = t and "BRRRR" or "UnU"
    while t do
        hitremote:FireServer(unpack(args))
        wait()
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

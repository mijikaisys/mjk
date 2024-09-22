--[[

	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!

]]

local req = (syn and syn.request) or (http and http.request) or http_request



function GetHttp(URL)

	local Data = nil

	local Test = req({

        Url = URL,

        Method = 'GET',

	})

	for i,v in pairs(Test) do

		Data = v

	end

	return Data

end



local Something = GetHttp("https://raw.githubusercontent.com/Mana42138/woof-gui/main/Source.lua")





local Win = loadstring(Something)():Window("Project Meow", "Blade Ball")

local Ragebot = Win:Tab("Ragebot")

local Credits = Win:Tab("Credits")



local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local VirtualUser = game:GetService("VirtualUser")



local player = Players.LocalPlayer

local camera = workspace.CurrentCamera



local RandRNG = math.random()

local RandAutoaParry = {[tostring(RandRNG)] = false}



Ragebot:Toggle("Auto Slash", false, function(t)

    RandAutoaParry[tostring(RandRNG)] = t

end)



Ragebot:Slider("Slash Base Distance", 0, 100, 0, function(t)

    BaseDistance = t

end)



Ragebot:line()



Ragebot:Toggle("Auto Walk", false, function(t)

    AutoWalk = t

end)



Ragebot:Slider("Auto Walk Distance X", -40, 40, 12, function(t)

    AutoWalkDistanceX = t

end)



Ragebot:Slider("Auto Walk Distance Z", -40, 40, 13, function(t)

    AutoWalkDistanceZ = t

end)



Ragebot:Toggle("Auto Jump", false, function(t)

    AutoDoubleJump = t

end)



Ragebot:line()



Ragebot:Toggle("Aim At Closest Player", false, function(t)

    ClosestPlayer_var = t

end)



Ragebot:Toggle("Random Teleports", false, function(t)

    RandomTeleports = t

end)



Ragebot:Slider("Teleport Distance X", -40, 40, 0, function(t)

    TeleportDistanceX = t

end)



Ragebot:Slider("Teleport Distance Z", -40, 40, 0, function(t)

    TeleportDistanceZ = t

end)



function GetMouse()

    local UserInputService = game:GetService("UserInputService")

    return UserInputService:GetMouseLocation()  -- Ensure this is the correct method for your setup

end



function GetClosestPlayer()

    local closestDistance = math.huge

    local closestTarget = nil

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= game.Players.LocalPlayer then

            local humanoidRootPart = player.Character.HumanoidRootPart

                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude --(Vector2.new(viewportPoint.X, viewportPoint.Y) - mousePos).magnitude

                if distance < closestDistance then

                    closestDistance = distance

                    closestTarget = player

                end

        end

    end

    return closestTarget

end



function GetBall()

    for i,v in pairs(game:GetService("Workspace").Balls:GetChildren()) do

        if v:IsA("Part") then

            return v

        end

    end

    return nil

end



function GetBallfromplayerPos(Ball)

    return (Ball.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

end



local function getSpeed(part)

    if part:IsA("BasePart") then

        local speed = part.Velocity.Magnitude

        if speed > 1 then

            return part, speed

        end

        return nil, nil

    else

        print("The provided instance is not a BasePart.")

        return nil, nil

    end

end



local function measureVerticalDistance(humanoidRootPart, targetPart)

    local humanoidRootPartY = humanoidRootPart.Position.Y

    local targetPartY = targetPart.Position.Y

    local verticalDistance = math.abs(humanoidRootPartY - targetPartY)

    return verticalDistance

end



function GetHotKey()

	for i,v in pairs(game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do

		if v:IsA("TextLabel") then

			return v.Text

		end

	end

	return ""

end



local text = game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame.F

local KeyCodeBlock = text.Text

text:GetPropertyChangedSignal("Text"):Connect(function()

    KeyCodeBlock = text.Text

end)



local CanSlash = false

local BallSpeed = 0



spawn(function()

    while task.wait() do

        if RandAutoaParry[tostring(RandRNG)] then

            pcall(function()

				for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do

                    if v:IsA("Part") then

						local part, speed = getSpeed(v)

                        if part and speed then

                            local minDistance = 2.5 * (speed * 0.1)

                            if minDistance == 0 or minDistance <= 20 then

                                BallSpeed = 23

                            elseif minDistance == 20 or minDistance <= 88 then

                                BallSpeed = 2.5 * (speed * 0.1)

                            elseif minDistance == 88 or minDistance <= 110 then

                                BallSpeed = 2.4 * (speed * 0.1)

                            elseif minDistance >= 110 then

                                task.wait(0.01)

                                BallSpeed = 2 * (speed * 0.1)

                            end

                            print(BallSpeed + 2)

                            -- if measureVerticalDistance(game.Players.LocalPlayer.Character.HumanoidRootPart, part) > 10 then return end

							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= (BallSpeed + 2) and game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then -- (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= minDistance and 

                                CanSlash = true

                            else

                                CanSlash = false

                            end

						end

                    end

                end

                

                if CanSlash then

                    -- spawn(function()

                    --     for i,v in pairs(game:GetService("Workspace").Alive:GetChildren()) do

                    --         if game.Players.LocalPlayer.Character.Parent.Name == "Alive" then

					-- 			if  v ~= game.Players.LocalPlayer.Character then

                    --                 if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 7 then -- and v:FindFirstChild("Highlight")

                    --                     -- for i = 1,2 do

                    --                         game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)

                    --                         game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 1)

                    --                     -- end

                    --                 end

					-- 			end

					-- 		end

                    --     end

                    -- end)

                    if math.random(1, 2) == 2 then

                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)

                        -- print("Used Mouse Button")

                    else

                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)

                    end

                    CanSlash = false

                end

            end)

        end

    end

end)



spawn(function()

    while task.wait() do

        if AutoWalk then

            pcall(function()

                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end

				for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do

                    if v:IsA("Part") then

						local part, speed = getSpeed(v)

                        if part and speed then

							if speed > 5 then

                                if not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then

                                    game.Players.LocalPlayer.Character.Humanoid:MoveTo(part.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ))

                                else

                                    for i,v in pairs(game:GetService("Workspace").Alive:GetChildren()) do

                                        if game.Players.LocalPlayer.Character.Parent.Name == "Alive" then

                                            if  v ~= game.Players.LocalPlayer.Character then

                                                game.Players.LocalPlayer.Character.Humanoid:MoveTo(v.HumanoidRootPart.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ))

                                            end

                                        end

                                    end

                                end

							end

						end

                    end

                end

            end)

        end

        if AutoDoubleJump then

            pcall(function()

                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)

            end)

        end

    end

end)



spawn(function()

    while task.wait() do

        if ClosestPlayer_var then

            pcall(function()

                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end

                local OldCameraFrame = workspace.CurrentCamera.CFrame

                local ClosestPlayer = GetClosestPlayer()

                if ClosestPlayer then

                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, ClosestPlayer.Character.Head.Position)

                end

            end)

        end

    end

end)



spawn(function()

    while task.wait(math.random(1,2)) do

        if RandomTeleports then

            pcall(function()

                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end

                for i, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do

                    if v:IsA("Part") then

						local part, speed = getSpeed(v)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(TeleportDistanceX, 0, TeleportDistancez)

                    end

                end

            end)

        end

    end

end)



Credits:Button("Developer: mana_dw", function()

    setclipboard("https://discord.gg/8RRfM9q2XP")

end)



Credits:Button("UI Designer: mana_dw", function()

    setclipboard("https://discord.gg/8RRfM9q2XP")

end)



Credits:Button("Project Meow Discord Server", function()

    setclipboard("https://discord.gg/8RRfM9q2XP")

        local req = (syn and syn.request) or (http and http.request) or http_request

        if req then

            req({

                Url = 'http://127.0.0.1:6463/rpc?v=1',

                Method = 'POST',

                Headers = {

                    ['Content-Type'] = 'application/json',

                    Origin = 'https://discord.com'

                },

                Body = game:GetService('HttpService'):JSONEncode({

                    cmd = 'INVITE_BROWSER',

                    nonce = game:GetService('HttpService'):GenerateGUID(false),

                    args = {code = '8RRfM9q2XP'}

                })

            })

        end

end)



local req = (syn and syn.request) or (http and http.request) or http_request

if req then

    req({

        Url = 'http://127.0.0.1:6463/rpc?v=1',

        Method = 'POST',

        Headers = {

            ['Content-Type'] = 'application/json',

            Origin = 'https://discord.com'

        },

        Body = game:GetService('HttpService'):JSONEncode({

            cmd = 'INVITE_BROWSER',

            nonce = game:GetService('HttpService'):GenerateGUID(false),

            args = {code = '8RRfM9q2XP'}

        })

    })

end



Credits:line()



Credits:Button("Destroy Gui", function()

    if game.CoreGui:FindFirstChild("woof") then

           game.CoreGui.woof:Destroy()

    end

end)



Credits:Button("Rejoin", function()

    local ts = game:GetService("TeleportService")

    local p = game:GetService("Players").LocalPlayer

    ts:Teleport(game.PlaceId, p)

end)



Credits:line()


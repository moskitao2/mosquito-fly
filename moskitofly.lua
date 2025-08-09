local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Criando a GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mosquito"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "Mosquito Fly GUI"
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(0, 0, 0)
title.Parent = frame

local flyEnabled = false
local speed = 50

local function createButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, 80, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Parent = frame
    return btn
end

local btnUp = createButton("Subir", UDim2.new(0, 10, 0, 30))
local btnDown = createButton("Descer", UDim2.new(0, 110, 0, 30))
local btnToggle = createButton("Voar: OFF", UDim2.new(0, 10, 0, 60))
local btnSpeedUp = createButton("Vel +", UDim2.new(0, 110, 0, 60))
local btnSpeedDown = createButton("Vel -", UDim2.new(0, 10, 0, 90))

local velocityObject, gyroObject

local function startFly()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    humanoid.PlatformStand = true

    velocityObject = Instance.new("BodyVelocity")
    velocityObject.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    velocityObject.Velocity = Vector3.new(0, 0, 0)
    velocityObject.Parent = rootPart

    gyroObject = Instance.new("BodyGyro")
    gyroObject.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    gyroObject.CFrame = rootPart.CFrame
    gyroObject.Parent = rootPart

    RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local camera = workspace.CurrentCamera
        local moveDirection = humanoid.MoveDirection
        local velocity = moveDirection * speed
        velocityObject.Velocity = Vector3.new(velocity.X, 0, velocity.Z)

        if btnUpPressed then
            velocityObject.Velocity = velocityObject.Velocity + Vector3.new(0, speed, 0)
        elseif btnDownPressed then
            velocityObject.Velocity = velocityObject.Velocity + Vector3.new(0, -speed, 0)
        end

        gyroObject.CFrame = camera.CFrame
    end)
end

local btnUpPressed = false
local btnDownPressed = false

btnUp.MouseButton1Down:Connect(function()
    btnUpPressed = true
end)
btnUp.MouseButton1Up:Connect(function()
    btnUpPressed = false
end)

btnDown.MouseButton1Down:Connect(function()
    btnDownPressed = true
end)
btnDown.MouseButton1Up:Connect(function()
    btnDownPressed = false
end)

btnToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    btnToggle.Text = flyEnabled and "Voar: ON" or "Voar: OFF"

    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    if flyEnabled then
        startFly()
    else
        humanoid.PlatformStand = false
        if velocityObject then
            velocityObject:Destroy()
            velocityObject = nil
        end
        if gyroObject then
            gyroObject:Destroy()
            gyroObject = nil
        end
    end
end)

btnSpeedUp.MouseButton1Click:Connect(function()
    speed = math.min(speed + 10, 200)
end)

btnSpeedDown.MouseButton1Click:Connect(function()
    speed = math.max(speed - 10, 10)
end)

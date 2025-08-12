pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1]
    repeat task.wait() until LocalPlayer and LocalPlayer.Character and LocalPlayer:FindFirstChild("PlayerGui")

    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Estados
    local speedHackOn = false
    local minSpeedNormal, maxSpeedNormal = 37, 42
    local minSpeedBoost,  maxSpeedBoost  = 50, 60
    local minSpeed, maxSpeed = minSpeedNormal, maxSpeedNormal
    local acceleration = 0.15
    local currentSpeed = 0
    local tickOffset = math.random()

    -- Função para criar força
    local function criarForca()
        if hrp:FindFirstChild("SpeedAssist") then
            hrp.SpeedAssist:Destroy()
        end
        if hrp:FindFirstChild("SpeedAssistAttachment") then
            hrp.SpeedAssistAttachment:Destroy()
        end

        local att = Instance.new("Attachment")
        att.Name = "SpeedAssistAttachment"
        att.Parent = hrp

        local vf = Instance.new("VectorForce")
        vf.Name = "SpeedAssist"
        vf.Attachment0 = att
        vf.Force = Vector3.zero
        vf.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
        vf.ApplyAtCenterOfMass = true
        vf.Parent = hrp

        return vf
    end

    local vectorForce = criarForca()

    -- Quando respawnar
    LocalPlayer.CharacterAdded:Connect(function(char)
        character = char
        humanoid = char:WaitForChild("Humanoid")
        hrp = char:WaitForChild("HumanoidRootPart")
        vectorForce = criarForca()
    end)

    -- Liga/desliga speed
    local function setSpeedHackState(state)
        speedHackOn = state
        if speedHackOn then
            minSpeed, maxSpeed = minSpeedBoost, maxSpeedBoost
        else
            vectorForce.Force = Vector3.zero
            minSpeed, maxSpeed = minSpeedNormal, maxSpeedNormal
            currentSpeed = 0
        end
    end

    -- UI
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "SpeedUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 80)
    frame.Position = UDim2.new(0, 50, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 15)
    button.Text = "Speed Hack: OFF"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 20
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    Instance.new("UICorner", button)

    button.MouseButton1Click:Connect(function()
        speedHackOn = not speedHackOn
        setSpeedHackState(speedHackOn)
        button.Text = speedHackOn and "Speed Hack: ON" or "Speed Hack: OFF"
        local newColor = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    end)

    -- Movimento usando MoveDirection (mais estável)
    RunService.Heartbeat:Connect(function()
        if not speedHackOn or not humanoid or not hrp then return end

        local dir = humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local variation = (math.sin(tick() * 2 + tickOffset) + 1) / 2
            local targetSpeed = minSpeed + ((maxSpeed - minSpeed) * variation)
            currentSpeed += (targetSpeed - currentSpeed) * acceleration
            local force = Vector3.new(dir.X, 0, dir.Z) * currentSpeed * humanoid.Mass
            vectorForce.Force = force
        else
            vectorForce.Force = Vector3.zero
            currentSpeed = 0
        end
    end)
end)

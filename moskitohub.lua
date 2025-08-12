pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1]
    repeat wait() until LocalPlayer and LocalPlayer.Character and LocalPlayer:FindFirstChild("PlayerGui")

    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local backpack = LocalPlayer:WaitForChild("Backpack")

    local speedCoilName = "Speed Coil"
    local speedHackOn = false
    local normalJumpPower = 50
    local hackJumpPower = 100
    local jumpHackOn = false

    local minSpeedNormal = 37
    local maxSpeedNormal = 42
    local minSpeedBoost = 50
    local maxSpeedBoost = 60
    local minSpeed = minSpeedNormal
    local maxSpeed = maxSpeedNormal
    local acceleration = 0.15
    local currentSpeed = 0
    local moveDir = Vector3.zero
    local tickOffset = math.random()

    local function criarForca()
        local existing = hrp:FindFirstChild("SpeedAssist")
        if existing then existing:Destroy() end

        local att = Instance.new("Attachment", hrp)
        att.Name = "SpeedAssistAttachment"

        local vf = Instance.new("VectorForce")
        vf.Name = "SpeedAssist"
        vf.Attachment0 = att
        vf.Force = Vector3.zero
        vf.RelativeTo = Enum.ActuatorRelativeTo.World
        vf.ApplyAtCenterOfMass = true
        vf.Parent = hrp

        return vf
    end

    local vectorForce = criarForca()

    local function ativarBuff()
        local tool = backpack:FindFirstChild(speedCoilName) or LocalPlayer.StarterGear:FindFirstChild(speedCoilName)
        if tool then
            tool.Parent = backpack
            humanoid:EquipTool(tool)
            task.wait(0.1)
            humanoid:UnequipTools()
        else
            warn("Speed Coil não encontrado")
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        character = char
        humanoid = char:WaitForChild("Humanoid")
        hrp = char:WaitForChild("HumanoidRootPart")
        vectorForce = criarForca()
    end)

    local function setSpeedHackState(state)
        speedHackOn = state
        if speedHackOn then
            ativarBuff()
            minSpeed = minSpeedBoost
            maxSpeed = maxSpeedBoost
        else
            vectorForce.Force = Vector3.zero
            minSpeed = minSpeedNormal
            maxSpeed = maxSpeedNormal
        end
    end

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

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        local k = input.KeyCode
        if k == Enum.KeyCode.W then moveDir += Vector3.new(0,0,-1) end
        if k == Enum.KeyCode.S then moveDir += Vector3.new(0,0,1) end
        if k == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
        if k == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local k = input.KeyCode
        if k == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,-1) end
        if k == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,1) end
        if k == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
        if k == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
    end)

    RunService.Heartbeat:Connect(function()
        if not speedHackOn then return end
        local dir = moveDir.Magnitude > 0 and moveDir.Unit or Vector3.zero
        local worldDir = hrp.CFrame:VectorToWorldSpace(dir)
        local time = tick()
        local variation = (math.sin(time * 2 + tickOffset) + 1) / 2
        local targetSpeed = minSpeed + ((maxSpeed - minSpeed) * variation)
        currentSpeed = currentSpeed + ((targetSpeed - currentSpeed) * acceleration)
        local force = Vector3.new(worldDir.X, 0, worldDir.Z) * currentSpeed * humanoid.Mass
        vectorForce.Force = force
    end)

    RunService.Stepped:Connect(function()
        if humanoid then
            humanoid.JumpPower = jumpHackOn and hackJumpPower or normalJumpPower
        end
    end)
end)

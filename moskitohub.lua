local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local speedHackOn = false
local jumpHackOn = false

local normalJumpPower = 50
local hackJumpPower = 100

local backpack = LocalPlayer:WaitForChild("Backpack")
local speedCoilName = "Speed Coil"

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local moveDir = Vector3.zero

local minSpeedNormal = 37
local maxSpeedNormal = 42
local minSpeedBoost = 50  -- velocidade mínima com boost
local maxSpeedBoost = 60  -- velocidade máxima com boost

local minSpeed = minSpeedNormal
local maxSpeed = maxSpeedNormal
local acceleration = 0.15
local currentSpeed = 0
local tickOffset = math.random()

local function criarForca()
    local existingForce = hrp:FindFirstChild("SpeedAssist")
    if existingForce then existingForce:Destroy() end

    local attachment = Instance.new("Attachment")
    attachment.Name = "SpeedAssistAttachment"
    attachment.Parent = hrp

    local vectorForce = Instance.new("VectorForce")
    vectorForce.Name = "SpeedAssist"
    vectorForce.Attachment0 = attachment
    vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    vectorForce.ApplyAtCenterOfMass = true
    vectorForce.Force = Vector3.zero
    vectorForce.Parent = hrp

    return vectorForce
end

local vectorForce = criarForca()

local function ativarBuffComItem()
    local tool = backpack:FindFirstChild(speedCoilName) or LocalPlayer.StarterGear:FindFirstChild(speedCoilName)
    if tool then
        tool.Parent = backpack
        humanoid:EquipTool(tool)
        task.wait(0.15)
        humanoid:UnequipTools()
        print("✅ Buff ativado via item")
    else
        warn("⚠️ Item '" .. speedCoilName .. "' não encontrado.")
    end
end

local function atualizarCharacterRefs(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    vectorForce = criarForca()
end

LocalPlayer.CharacterAdded:Connect(atualizarCharacterRefs)

local function setSpeedHackState(state)
    speedHackOn = state
    if speedHackOn then
        -- pegar e soltar item pra ativar buff
        ativarBuffComItem()
        -- aumentar velocidades para boost
        minSpeed = minSpeedBoost
        maxSpeed = maxSpeedBoost
        print("🚀 Speed Hack ativado com boost!")
    else
        vectorForce.Force = Vector3.zero
        -- resetar velocidades normais
        minSpeed = minSpeedNormal
        maxSpeed = maxSpeedNormal
        print("🛑 Speed Hack desativado, velocidade normal.")
    end
end

-- Criar botão GUI simples para ativar/desativar speed hack
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHackGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 150, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 10)
speedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.SourceSansBold
speedBtn.TextSize = 18
speedBtn.Text = "Ativar Speed Hack"
speedBtn.Parent = ScreenGui

speedBtn.MouseButton1Click:Connect(function()
    setSpeedHackState(not speedHackOn)
    if speedHackOn then
        speedBtn.Text = "Desativar Speed Hack"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    else
        speedBtn.Text = "Ativar Speed Hack"
        speedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    end
end)

-- Controle de movimento
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
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
    local unitDir = moveDir.Magnitude > 0 and moveDir.Unit or Vector3.zero
    local worldDir = hrp.CFrame:VectorToWorldSpace(unitDir)
    local time = tick()
    local variation = (math.sin(time * 2 + tickOffset) + 1) / 2
    local targetSpeed = minSpeed + ((maxSpeed - minSpeed) * variation)
    currentSpeed = currentSpeed + ((targetSpeed - currentSpeed) * acceleration)
    local finalForce = Vector3.new(worldDir.X, 0, worldDir.Z) * currentSpeed * humanoid.Mass
    vectorForce.Force = finalForce
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = jumpHackOn and hackJumpPower or normalJumpPower
    end
end)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estados dos cheats
local speedHackOn = false
local jumpHackOn = false
local espOn = false

-- Valores normais
local normalWalkSpeed = 16
local normalJumpPower = 50

-- Valores de hack
local hackWalkSpeed = 50
local hackJumpPower = 100

local function getCharAndHum(player)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hum
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoskitoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(90, 90, 90)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🦟 MoskitoHub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Função para criar botão com callback
local function createToggleBtn(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)

    return btn
end

-- ESP: deixa todos personagens vermelhos
local function ApplyESPToAllPlayers(apply)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    if apply then
                        part.Color = Color3.new(1, 0, 0)
                        part.Material = Enum.Material.Neon
                    else
                        -- Restaurar cor padrão (ajuste conforme o jogo se necessário)
                        part.Color = part.Name == "Head" and Color3.new(1, 0.8, 0.6) or Color3.new(1, 1, 1)
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
    end
end

-- Sempre reaplica ESP quando um player respawna
local function setupCharacterAdded()
    for _, player in ipairs(Players:GetPlayers()) do
        player.CharacterAdded:Connect(function()
            if espOn then
                ApplyESPToAllPlayers(true)
            end
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espOn then
            ApplyESPToAllPlayers(true)
        end
    end)
end)
setupCharacterAdded()

-- Função para aplicar cheats locais
local function applyLocalCheats()
    local char, hum = getCharAndHum(LocalPlayer)
    if hum then
        hum.WalkSpeed = speedHackOn and hackWalkSpeed or normalWalkSpeed
        hum.JumpPower = jumpHackOn and hackJumpPower or normalJumpPower
    end
end

-- Botões do painel
local espBtn = createToggleBtn("Ativar ESP (todos vermelhos)", 40, function(btn)
    espOn = not espOn
    ApplyESPToAllPlayers(espOn)
    btn.Text = espOn and "Desativar ESP (todos vermelhos)" or "Ativar ESP (todos vermelhos)"
    btn.BackgroundColor3 = espOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

local speedBtn = createToggleBtn("Ativar Speed Hack", 80, function(btn)
    speedHackOn = not speedHackOn
    applyLocalCheats()
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 120, function(btn)
    jumpHackOn = not jumpHackOn
    applyLocalCheats()
    btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
    btn.BackgroundColor3 = jumpHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

-- Reaplicar cheats ao morrer localmente
LocalPlayer.CharacterAdded:Connect(function(character)
    applyLocalCheats()
    if espOn then
        ApplyESPToAllPlayers(true)
    end
end)

-- Reaplicar ESP se outros players respawnarem
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espOn then
            ApplyESPToAllPlayers(true)
        end
    end)
end)

applyLocalCheats()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Estados dos cheats
local speedHackOn = false
local jumpHackOn = false

-- Valores normais
local normalWalkSpeed = 16
local normalJumpPower = 50

-- Valores de hack
local hackWalkSpeed = 50
local hackJumpPower = 100

-- GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "MoskitoHub"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 220)
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
title.Text = "🦟 bolsonarogay"
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
    btn.Size = UDim2.new(1, -20, 0, 40)
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

-- ESP
function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character:FindFirstChild("MoskitoESP") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MoskitoESP"
        billboard.Adornee = player.Character.Head
        billboard.Parent = player.Character
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.new(1, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.Parent = billboard
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

-- Bypass básico de anti-cheat
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = function(tbl, key)
    if tbl == hum then
        if key == "WalkSpeed" and speedHackOn then
            return normalWalkSpeed
        elseif key == "JumpPower" and jumpHackOn then
            return normalJumpPower
        end
    end
    if tostring(key) == "DetectedCheat" then
        return false -- ignora detecção de cheat
    end
    return oldIndex(tbl, key)
end

setreadonly(mt, true)

-- Função segura para aplicar valores
local function applyCheats()
    if hum and hum.Parent then
        hum.WalkSpeed = speedHackOn and hackWalkSpeed or normalWalkSpeed
        hum.JumpPower = jumpHackOn and hackJumpPower or normalJumpPower
    end
end

-- Botões do painel
local speedBtn = createToggleBtn("Ativar Speed Hack", 40, function(btn)
    speedHackOn = not speedHackOn
    applyCheats()
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 90, function(btn)
    jumpHackOn = not jumpHackOn
    applyCheats()
    btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
    btn.BackgroundColor3 = jumpHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

-- Botão ESP
local espBtn = createToggleBtn("Ativar ESP", 140, function(btn)
    local espActive = btn.Text == "Ativar ESP"
    if espActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
        btn.Text = "Desativar ESP"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("MoskitoESP") then
                player.Character.MoskitoESP:Destroy()
            end
        end
        btn.Text = "Ativar ESP"
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    end
end)

-- Reaplicar cheats ao morrer
LocalPlayer.CharacterAdded:Connect(function(character)
    char = character
    hum = character:WaitForChild("Humanoid", 10)
    if hum then
        applyCheats()
    end
end)

-- Reaplicar a cada frame (resistente ao servidor resetar)
RunService.RenderStepped:Connect(function()
    if hum and hum.Parent then
        if speedHackOn then hum.WalkSpeed = hackWalkSpeed end
        if jumpHackOn then hum.JumpPower = hackJumpPower end
    end
end)

-- Aplicar no load
applyCheats()

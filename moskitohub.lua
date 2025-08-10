-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Estados dos cheats
local speedHackOn = false
local jumpHackOn = false
local espOn = false
local espJumpOn = false
local espRunOn = false

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
frame.Size = UDim2.new(0, 240, 0, 260)
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

-- ESP: deixa o personagem local todo vermelho
local function ApplyESPToChar(apply)
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                if apply then
                    part.Color = Color3.new(1, 0, 0)
                    part.Material = Enum.Material.Neon
                else
                    part.Color = part.Name == "Head" and Color3.new(1, 0.8, 0.6) or Color3.new(1, 1, 1)
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
end

-- Função para aplicar ESP Jump (pula automaticamente quando ativado)
local function ESPJump(active)
    if active then
        RunService.RenderStepped:Connect(function()
            if espJumpOn and hum and hum.Parent and hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Função para aplicar ESP Run (corre automaticamente quando ativado)
local function ESPRun(active)
    if active then
        RunService.RenderStepped:Connect(function()
            if espRunOn and hum and hum.Parent then
                hum.WalkSpeed = hackWalkSpeed
            end
        end)
    else
        if hum and hum.Parent then
            hum.WalkSpeed = normalWalkSpeed
        end
    end
end

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

local espBtn = createToggleBtn("Ativar ESP (vermelho)", 140, function(btn)
    espOn = not espOn
    ApplyESPToChar(espOn)
    btn.Text = espOn and "Desativar ESP (vermelho)" or "Ativar ESP (vermelho)"
    btn.BackgroundColor3 = espOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

local espJumpBtn = createToggleBtn("Ativar ESP Pulo", 190, function(btn)
    espJumpOn = not espJumpOn
    ESPJump(espJumpOn)
    btn.Text = espJumpOn and "Desativar ESP Pulo" or "Ativar ESP Pulo"
    btn.BackgroundColor3 = espJumpOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

local espRunBtn = createToggleBtn("Ativar ESP Correr", 235, function(btn)
    espRunOn = not espRunOn
    ESPRun(espRunOn)
    btn.Text = espRunOn and "Desativar ESP Correr" or "Ativar ESP Correr"
    btn.BackgroundColor3 = espRunOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
end)

-- Bypass anti-cheat: metamétodo, Kick/Destroy, RemoteEvents e remover scripts
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

mt.__index = function(tbl, key)
    if tbl == hum then
        if key == "WalkSpeed" and speedHackOn then
            return normalWalkSpeed
        elseif key == "JumpPower" and jumpHackOn then
            return normalJumpPower
        end
    end
    if typeof(tbl) == "Instance" and tbl:IsA("Humanoid") then
        if key == "WalkSpeed" then
            return normalWalkSpeed
        elseif key == "JumpPower" then
            return normalJumpPower
        elseif key == "Health" then
            return 100
        end
    end
    if tostring(key) == "DetectedCheat" then
        return false
    end
    return oldIndex(tbl, key)
end

mt.__newindex = function(tbl, key, value)
    if typeof(tbl) == "Instance" and tbl:IsA("Humanoid") then
        if key == "WalkSpeed" or key == "JumpPower" or key == "Health" then
            return -- ignora resets do servidor
        end
    end
    return oldNewIndex(tbl, key, value)
end
setreadonly(mt, true)

-- Hook Kick e Destroy
LocalPlayer.Kick = function() return end
LocalPlayer.Destroy = function() return end

-- Remover scripts anti-cheat do personagem se existirem
for _, v in pairs(char:GetChildren()) do
    if v:IsA("Script") and v.Name:lower():find("cheat") then
        v:Destroy()
    end
end

-- Interceptar RemoteEvents anti-cheat
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("cheat") then
        v.OnClientEvent:Connect(function() end)
    end
end

-- Reaplicar cheats ao morrer
LocalPlayer.CharacterAdded:Connect(function(character)
    char = character
    hum = character:WaitForChild("Humanoid", 10)
    if hum then
        applyCheats()
        if espOn then
            ApplyESPToChar(true)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if hum and hum.Parent then
        if speedHackOn then hum.WalkSpeed = hackWalkSpeed end
        if jumpHackOn then hum.JumpPower = hackJumpPower end
        if espRunOn then hum.WalkSpeed = hackWalkSpeed end
    end
end)

applyCheats()

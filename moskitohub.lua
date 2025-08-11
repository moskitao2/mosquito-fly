local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local speedHackOn = false
local jumpHackOn = false
local aimbotOn = false

-- Valores normais e hack
local normalWalkSpeed = 16
local normalJumpPower = 50
local hackWalkSpeed = 50
local hackJumpPower = 100

-- Função segura para obter Humanoid
local function getCharAndHum(player)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hum
end

-- Interface GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoskitoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0, 40, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(32, 39, 54)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local shadow = Instance.new("ImageLabel")
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(-0.04, 0, -0.06, 0)
shadow.ZIndex = 0
shadow.Parent = frame

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(65,85,130)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "🦟 MoskitoHub"
title.TextColor3 = Color3.fromRGB(170, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 28
title.ZIndex = 2

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 19
closeBtn.ZIndex = 2
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Função para criar botões
local function createToggleBtn(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -30, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local strokeBtn = Instance.new("UIStroke", btn)
    strokeBtn.Color = Color3.fromRGB(130,180,230)
    strokeBtn.Thickness = 1

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90, 170, 210)
        strokeBtn.Color = Color3.fromRGB(150,220,255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = callback._on and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
        strokeBtn.Color = Color3.fromRGB(130,180,230)
    end)
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Aimbot: pega inimigo mais próximo
local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyPos = player.Character.HumanoidRootPart.Position
            local dist = (enemyPos - myPos).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestEnemy = player
            end
        end
    end

    return closestEnemy
end

-- Aimbot dispara ao clicar (só printa por enquanto)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and aimbotOn then
        local enemy = getClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") then
            print("[Aimbot] Atirando em:", enemy.Name)
            -- enemy.Character.Humanoid:TakeDamage(25) -- apenas local, sem efeito real
        end
    end
end)

-- Atualizações constantes
RunService.Stepped:Connect(function()
    local char, hum = getCharAndHum(LocalPlayer)
    if hum then
        if speedHackOn then hum.WalkSpeed = hackWalkSpeed end
        if jumpHackOn then hum.JumpPower = hackJumpPower end
    end
end)

-- Botões
local speedBtn = createToggleBtn("Ativar Speed Hack", 50, function(btn)
    speedHackOn = not speedHackOn
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    speedBtn._on = speedHackOn
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 100, function(btn)
    jumpHackOn = not jumpHackOn
    btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
    btn.BackgroundColor3 = jumpHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    jumpBtn._on = jumpHackOn
end)

local aimbotBtn = createToggleBtn("Ativar Aimbot", 150, function(btn)
    aimbotOn = not aimbotOn
    btn.Text = aimbotOn and "Desativar Aimbot" or "Ativar Aimbot"
    btn.BackgroundColor3 = aimbotOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    aimbotBtn._on = aimbotOn
end)

local espOn = false
local espAdorns = {}

-- Limpa ESP de um character
local function clearESP(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = part:FindFirstChild("_MoskitoESP")
            if adorn then adorn:Destroy() end
        end
    end
end

-- Adiciona ESP mesmo em partes invisíveis
local function addESPToChar(char)
    if not char then return end
    espAdorns[char] = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = Instance.new("BoxHandleAdornment")
            adorn.Name = "_MoskitoESP"
            adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
            adorn.Color3 = Color3.fromRGB(0, 255, 160)
            adorn.Transparency = 0.4
            adorn.AlwaysOnTop = true
            adorn.ZIndex = 15
            adorn.Adornee = part
            adorn.Parent = part
            table.insert(espAdorns[char], adorn)
        end
    end
end

-- Atualiza ESP para todos os players
local function updateESPForAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espOn then
                if not espAdorns[player.Character] then
                    addESPToChar(player.Character)
                end
            else
                clearESP(player.Character)
                espAdorns[player.Character] = nil
            end
        end
    end
end

-- Atualiza a cada frame (RenderStepped)
RunService.RenderStepped:Connect(function()
    updateESPForAll()
end)

-- Quando players entram
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if espOn then
            addESPToChar(char)
        end
    end)
end)

-- Botão do ESP
local espBtn = createToggleBtn("Ativar ESP (atrás paredes)", 200, function(btn)
    espOn = not espOn
    btn.Text = espOn and "Desativar ESP (atrás paredes)" or "Ativar ESP (atrás paredes)"
    btn.BackgroundColor3 = espOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    espBtn._on = espOn
end)

-- === NOVA PARTE: Aimbot mira suave ===
local Camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local enemy = getClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = enemy.Character.HumanoidRootPart.Position
            local currentCFrame = Camera.CFrame
            local desiredCFrame = CFrame.new(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(desiredCFrame, 0.25) -- Ajuste a velocidade aqui
        end
    end
end)

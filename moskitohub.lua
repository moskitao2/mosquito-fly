local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local speedHackOn = false
local infiniteJumpActive = false
local espOn = false
local espHighlightOn = false
local aimbotOn = false
local espAdorns = {}
local highlightRefs = {}
local aimbotConnection

-- Valores normais e hack
local normalWalkSpeed = 120
local hackWalkSpeed = 120

-- Função segura para obter Humanoid
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

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 290)
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

-- ESP Box (BoxHandleAdornment)
local function clearESP(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = part:FindFirstChild("_MoskitoESP")
            if adorn then adorn:Destroy() end
        end
    end
end

local function addESPToChar(char)
    if not char then return end
    espAdorns[char] = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = Instance.new("BoxHandleAdornment")
            adorn.Name = "_MoskitoESP"
            adorn.Size = part.Size + Vector3.new(0.3,0.3,0.3)
            adorn.Color3 = Color3.fromRGB(0, 255, 160)
            adorn.Transparency = 0.5
            adorn.Adornee = part
            adorn.AlwaysOnTop = true
            adorn.ZIndex = 15
            adorn.Parent = part
            table.insert(espAdorns[char], adorn)
        end
    end
end

-- ESP Highlight (Highlight vermelho)
local function clearHighlightESP(char)
    if not char then return end
    local highlight = char:FindFirstChild("ESP_Highlight")
    if highlight then
        highlight:Destroy()
        highlightRefs[char] = nil
    end
end

local function addHighlightESPToChar(char)
    if not char then return end
    if highlightRefs[char] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    highlightRefs[char] = highlight
end

-- Atualização de ESPs
local function updateESPForAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            if espOn then
                if not espAdorns[char] then
                    addESPToChar(char)
                end
            else
                clearESP(char)
                espAdorns[char] = nil
            end

            if espHighlightOn then
                if not highlightRefs[char] then
                    addHighlightESPToChar(char)
                end
            else
                clearHighlightESP(char)
            end
        end
    end
end

-- Atualizações constantes
RunService.Stepped:Connect(function()
    local char, hum = getCharAndHum(LocalPlayer)
    if hum then
        if speedHackOn then 
            hum.WalkSpeed = hackWalkSpeed 
        else 
            hum.WalkSpeed = normalWalkSpeed 
        end
        -- removido ajuste do JumpPower para pulo infinito funcionar melhor
    end
end)

RunService.RenderStepped:Connect(function()
    updateESPForAll()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if espOn then addESPToChar(char) end
        if espHighlightOn then addHighlightESPToChar(char) end
    end)
end)

-- Função para pegar inimigo mais próximo
local function getClosestEnemy()
    local camera = workspace.CurrentCamera
    local closest = nil
    local shortestDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPos = player.Character.Head.Position
            local dist = (camera.CFrame.Position - headPos).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closest = player
            end
        end
    end

    return closest
end

-- Toggle Aimbot
local function toggleAimbot(btn)
    aimbotOn = not aimbotOn
    btn.Text = aimbotOn and "Desativar Aimbot" or "Ativar Aimbot"
    btn.BackgroundColor3 = aimbotOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    btn._on = aimbotOn

    if aimbotOn then
        aimbotConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local character = LocalPlayer.Character
                if not character then return end

                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    local enemy = getClosestEnemy()
                    if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(hrp.Position, enemy.Character.Head.Position)
                        end
                        tool:Activate()
                    end
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

-- Botões
local espBtn = createToggleBtn("Ativar ESP (box neon)", 50, function(btn)
    espOn = not espOn
    btn.Text = espOn and "Desativar ESP (box neon)" or "Ativar ESP (box neon)"
    btn.BackgroundColor3 = espOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    espBtn._on = espOn
end)

local espHighlightBtn = createToggleBtn("Ativar ESP (highlight vermelho)", 100, function(btn)
    espHighlightOn = not espHighlightOn
    btn.Text = espHighlightOn and "Desativar ESP (highlight vermelho)" or "Ativar ESP (highlight vermelho)"
    btn.BackgroundColor3 = espHighlightOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    espHighlightBtn._on = espHighlightOn
end)

local speedBtn = createToggleBtn("Ativar Speed Hack", 150, function(btn)
    speedHackOn = not speedHackOn
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    speedBtn._on = speedHackOn
end)

local jumpBtn = createToggleBtn("Ativar Pulo Infinito", 200, function(btn)
    infiniteJumpActive = not infiniteJumpActive
    btn.Text = infiniteJumpActive and "Desativar Pulo Infinito" or "Ativar Pulo Infinito"
    btn.BackgroundColor3 = infiniteJumpActive and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    jumpBtn._on = infiniteJumpActive
end)

local aimbotBtn = createToggleBtn("Ativar Aimbot", 250, toggleAimbot)

-- Implementação do pulo infinito
local function infiniteJump()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 80, root.Velocity.Z)
    end
end

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpActive then
        infiniteJump()
    end
end)




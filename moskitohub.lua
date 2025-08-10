local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Cria GUI
local gui = Instance.new("ScreenGui")
gui.Name = "moskito hub"
gui.Parent = player:WaitForChild("PlayerGui")

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.Text = "moskito hub"
title.Parent = gui

-- Botão Aumentar Velocidade
local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.new(0, 150, 0, 50)
btnUp.Position = UDim2.new(0, 20, 0, 60)
btnUp.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btnUp.TextColor3 = Color3.new(1, 1, 1)
btnUp.Font = Enum.Font.SourceSansBold
btnUp.TextSize = 24
btnUp.Text = "Aumentar Velocidade"
btnUp.Parent = gui

-- Botão Diminuir Velocidade
local btnDown = Instance.new("TextButton")
btnDown.Size = UDim2.new(0, 150, 0, 50)
btnDown.Position = UDim2.new(0, 20, 0, 120)
btnDown.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btnDown.TextColor3 = Color3.new(1, 1, 1)
btnDown.Font = Enum.Font.SourceSansBold
btnDown.TextSize = 24
btnDown.Text = "Diminuir Velocidade"
btnDown.Parent = gui

-- Botão Toggle Boost
local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0, 150, 0, 50)
btnToggle.Position = UDim2.new(0, 20, 0, 180)
btnToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btnToggle.TextColor3 = Color3.new(1, 1, 1)
btnToggle.Font = Enum.Font.SourceSansBold
btnToggle.TextSize = 24
btnToggle.Text = "Boost OFF"
btnToggle.Parent = gui

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local velocidadeNormal = humanoid.WalkSpeed
local puloNormal = humanoid.JumpPower

local velocidadeAtual = velocidadeNormal
local boostAtivo = false

local velocidadeBoost = 60
local puloBoost = 100

local function atualizarVelocidade()
    if boostAtivo then
        humanoid.WalkSpeed = velocidadeBoost
        humanoid.JumpPower = puloBoost
    else
        humanoid.WalkSpeed = velocidadeAtual
        humanoid.JumpPower = puloNormal
    end
end

btnUp.MouseButton1Click:Connect(function()
    if not boostAtivo then
        velocidadeAtual = math.min(velocidadeAtual + 5, 100)
        atualizarVelocidade()
    end
end)

btnDown.MouseButton1Click:Connect(function()
    if not boostAtivo then
        velocidadeAtual = math.max(velocidadeAtual - 5, 10)
        atualizarVelocidade()
    end
end)

btnToggle.MouseButton1Click:Connect(function()
    boostAtivo = not boostAtivo
    btnToggle.Text = boostAtivo and "Boost ON" or "Boost OFF"
    atualizarVelocidade()
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    velocidadeNormal = humanoid.WalkSpeed
    puloNormal = humanoid.JumpPower
    velocidadeAtual = velocidadeNormal
    boostAtivo = false
    btnToggle.Text = "Boost OFF"
    atualizarVelocidade()
end)

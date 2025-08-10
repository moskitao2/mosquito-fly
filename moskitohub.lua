local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "moskitaohub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Text = "Boost OFF"
button.Parent = gui

-- Inicialização
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local boostAtivo = false
local velocidadeNormal = humanoid.WalkSpeed
local puloNormal = humanoid.JumpHeight -- novo
local velocidadeBoost = 60
local puloBoost = 40 -- JumpHeight boost

-- Atualiza humanoid ao respawnar
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = velocidadeNormal
    humanoid.UseJumpPower = false
    humanoid.JumpHeight = puloNormal
    boostAtivo = false
    button.Text = "Boost OFF"
end)

-- Função de aplicar boost
local function aplicarBoost()
    if not humanoid or not humanoid.Parent then return end
    humanoid.UseJumpPower = false
    if boostAtivo then
        humanoid.WalkSpeed = velocidadeBoost
        humanoid.JumpHeight = puloBoost
    else
        humanoid.WalkSpeed = velocidadeNormal
        humanoid.JumpHeight = puloNormal
    end
end

-- Alternar boost
local function toggleBoost()
    boostAtivo = not boostAtivo
    button.Text = boostAtivo and "Boost ON" or "Boost OFF"
    aplicarBoost()
end

-- Conectar botão
button.MouseButton1Click:Connect(toggleBoost)

-- Loop para manter o boost (bypass)
RunService.Heartbeat:Connect(function()
    aplicarBoost()
end)


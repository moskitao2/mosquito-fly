local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "moskitaohub"
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

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local boostAtivo = false
local velocidadeNormal = humanoid.WalkSpeed
local puloNormal = humanoid.JumpPower

local velocidadeBoost = 60
local puloBoost = 100

local function aplicarBoost()
    if not humanoid then return end
    if boostAtivo then
        if humanoid.WalkSpeed ~= velocidadeBoost or humanoid.JumpPower ~= puloBoost then
            humanoid.WalkSpeed = velocidadeBoost
            humanoid.JumpPower = puloBoost
        end
    else
        if humanoid.WalkSpeed ~= velocidadeNormal or humanoid.JumpPower ~= puloNormal then
            humanoid.WalkSpeed = velocidadeNormal
            humanoid.JumpPower = puloNormal
        end
    end
end

local function toggleBoost()
    boostAtivo = not boostAtivo
    button.Text = boostAtivo and "Boost ON" or "Boost OFF"
    aplicarBoost()
end

button.MouseButton1Click:Connect(toggleBoost)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")

    velocidadeNormal = humanoid.WalkSpeed
    puloNormal = humanoid.JumpPower

    boostAtivo = false
    button.Text = "Boost OFF"

    -- Espera e reaplica boost para evitar resets iniciais
    task.wait(0.5)
    if boostAtivo then
        aplicarBoost()
    end
end)

RunService.Heartbeat:Connect(function()
    if humanoid and humanoid.Parent then
        aplicarBoost()
    end
end)

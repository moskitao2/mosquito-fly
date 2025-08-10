local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "moskitaohub"
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Text = "Boost OFF"

-- Variáveis
local boostAtivo = false
local impulseForce = 50  -- força do impulso aplicado

-- Captura personagem
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Alternar boost
button.MouseButton1Click:Connect(function()
    boostAtivo = not boostAtivo
    button.Text = boostAtivo and "Boost ON" or "Boost OFF"
end)

-- Loop de movimentação
RunService.RenderStepped:Connect(function()
    if boostAtivo and hrp.Parent then
        local dir = workspace.CurrentCamera.CFrame.LookVector
        hrp.Velocity = Vector3.new(dir.X * impulseForce, hrp.Velocity.Y, dir.Z * impulseForce)
    end
end)

-- Reset após respawn
player.CharacterAdded:Connect(function(c)
    char = c
    hrp = char:WaitForChild("HumanoidRootPart")
    boostAtivo = false
    button.Text = "Boost OFF"
end)

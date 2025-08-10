local player = game.Players.LocalPlayer
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

local function toggleBoost()
    if boostAtivo then
        humanoid.WalkSpeed = velocidadeNormal
        humanoid.JumpPower = puloNormal
        boostAtivo = false
        button.Text = "Boost OFF"
    else
        humanoid.WalkSpeed = velocidadeBoost
        humanoid.JumpPower = puloBoost
        boostAtivo = true
        button.Text = "Boost ON"
    end
end

button.MouseButton1Click:Connect(toggleBoost)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = velocidadeNormal
    humanoid.JumpPower = puloNormal
    boostAtivo = false
    button.Text = "Boost OFF"
end)

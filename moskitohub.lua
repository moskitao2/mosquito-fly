-- Moskitao Sprint GUI (por ChatGPT)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Configurações
local normalSpeed = 16
local fastSpeed = 50
local sprinting = false

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoskitaoSprintGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Button = Instance.new("TextButton")
Button.Name = "SprintButton"
Button.Size = UDim2.new(0, 150, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 100)
Button.BackgroundColor3 = Color3.fromRGB(65, 255, 144)
Button.Text = "Ativar Corrida"
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Button.Parent = ScreenGui

-- Função para mudar velocidade
local function setSpeed(speed)
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speed
		end
	end
end

-- Lidar com clique do botão
Button.MouseButton1Click:Connect(function()
	sprinting = not sprinting
	if sprinting then
		setSpeed(fastSpeed)
		Button.Text = "Desativar Corrida"
		Button.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
	else
		setSpeed(normalSpeed)
		Button.Text = "Ativar Corrida"
		Button.BackgroundColor3 = Color3.fromRGB(65, 255, 144)
	end
end)

-- Resetar ao morrer
LocalPlayer.CharacterAdded:Connect(function(char)
	sprinting = false
	char:WaitForChild("Humanoid")
	setSpeed(normalSpeed)
	Button.Text = "Ativar Corrida"
	Button.BackgroundColor3 = Color3.fromRGB(65, 255, 144)
end)

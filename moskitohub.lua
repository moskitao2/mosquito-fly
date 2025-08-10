local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Criar GUI
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

-- Variáveis de controle
local boostAtivo = false
local impulseForce = 50
local jumping = false
local moveDirection = Vector3.zero

-- Botão de toggle
button.MouseButton1Click:Connect(function()
	boostAtivo = not boostAtivo
	button.Text = boostAtivo and "Boost ON" or "Boost OFF"
end)

-- Captura input WASD
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Space then
		jumping = true
	end
end)

UIS.InputEnded:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Space then
		jumping = false
	end
end)

-- Atualiza moveDirection constantemente
RunService.RenderStepped:Connect(function()
	if not boostAtivo then return end

	character = player.Character or player.CharacterAdded:Wait()
	hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoid then return end

	-- Pegar direção da câmera
	local camCF = workspace.CurrentCamera.CFrame
	local moveVec = UIS:IsKeyDown(Enum.KeyCode.W) and camCF.LookVector or Vector3.zero
	if moveVec.Magnitude > 0 then
		hrp.Velocity = Vector3.new(moveVec.X, hrp.Velocity.Y, moveVec.Z) * impulseForce
	end

	-- Pulo controlado
	if jumping and humanoid:GetState() == Enum.HumanoidStateType.Running then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

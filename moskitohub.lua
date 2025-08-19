local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI Mosquito Hub
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MosquitoHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botão
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Text = "Ativar Plataforma"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- Arredondar botão
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 8)
uicorner.Parent = toggleButton

-- Variáveis
local plataformaAtiva = false
local conexaoSubida
local conexaoRGB
local plataforma

-- Função para criar a plataforma
local function criarPlataforma(character)
	local humanoidRoot = character:WaitForChild("HumanoidRootPart")

	plataforma = Instance.new("Part")
	plataforma.Size = Vector3.new(6, 1, 6)
	plataforma.Anchored = true
	plataforma.CanCollide = true
	plataforma.Position = humanoidRoot.Position - Vector3.new(0, 3, 0)
	plataforma.Color = Color3.fromRGB(255, 0, 0)
	plataforma.Name = "PlataformaRGB"
	plataforma.Parent = workspace

	-- Movimento para cima
	local tempo = 0
	local duracao = 5
	local velocidade = 0.5

	conexaoSubida = RunService.RenderStepped:Connect(function(dt)
		if tempo < duracao then
			tempo += dt
			plataforma.Position += Vector3.new(0, velocidade * dt, 0)
		else
			conexaoSubida:Disconnect()
		end
	end)

	-- Efeito RGB
	local h = 0
	conexaoRGB = RunService.RenderStepped:Connect(function()
		if plataforma then
			h = (h + 0.01) % 1
			plataforma.Color = Color3.fromHSV(h, 1, 1)
		end
	end)
end

-- Função para remover a plataforma
local function destruirPlataforma()
	if conexaoSubida then conexaoSubida:Disconnect() end
	if conexaoRGB then conexaoRGB:Disconnect() end
	if plataforma then plataforma:Destroy() end
end

-- Lidar com clique no botão
toggleButton.MouseButton1Click:Connect(function()
	plataformaAtiva = not plataformaAtiva

	if plataformaAtiva then
		toggleButton.Text = "Desativar Plataforma"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if player.Character then
			criarPlataforma(player.Character)
		end
	else
		toggleButton.Text = "Ativar Plataforma"
		toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		destruirPlataforma()
	end
end)

-- Caso o jogador respawn
player.CharacterAdded:Connect(function(character)
	if plataformaAtiva then
		task.wait(1)
		criarPlataforma(character)
	end
end)

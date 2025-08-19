local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI Mosquito Hub
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MosquitoHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

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

-- Arredondamento
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 8)
uicorner.Parent = toggleButton

-- Variáveis
local plataformaAtiva = false
local conexaoRGB
local plataforma
local weld

-- Função para criar a plataforma presa ao jogador
local function criarPlataforma(character)
	local humanoidRoot = character:WaitForChild("HumanoidRootPart")

	-- Criar a plataforma
	plataforma = Instance.new("Part")
	plataforma.Size = Vector3.new(6, 1, 6)
	plataforma.Anchored = false
	plataforma.CanCollide = true
	plataforma.Position = humanoidRoot.Position - Vector3.new(0, 3, 0)
	plataforma.Color = Color3.fromRGB(255, 0, 0)
	plataforma.Name = "PlataformaFixada"
	plataforma.Parent = workspace

	-- Prender a plataforma no jogador com WeldConstraint
	weld = Instance.new("WeldConstraint")
	weld.Part0 = plataforma
	weld.Part1 = humanoidRoot
	weld.Parent = plataforma

	-- Efeito RGB na plataforma
	local h = 0
	conexaoRGB = RunService.RenderStepped:Connect(function()
		if plataforma then
			h = (h + 0.01) % 1
			plataforma.Color = Color3.fromHSV(h, 1, 1)
		end
	end)
end

-- Função para destruir tudo
local function destruirPlataforma()
	if conexaoRGB then conexaoRGB:Disconnect() end
	if weld then weld:Destroy() end
	if plataforma then plataforma:Destroy() end
end

-- Clicar no botão
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

-- Quando o personagem reaparecer
player.CharacterAdded:Connect(function(character)
	if plataformaAtiva then
		task.wait(1)
		criarPlataforma(character)
	end
end)

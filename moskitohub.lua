local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Criar GUI Mosquito Hub AUTOMÁTICO
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MosquitoHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

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

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 8)
uicorner.Parent = toggleButton

-- Variáveis
local plataformaAtiva = false
local plataforma
local conexaoRender
local corHue = 0

local personagem, humanoidRoot

-- Função criar plataforma
local function criarPlataforma()
	if plataforma then
		plataforma:Destroy()
	end

	personagem = player.Character
	if not personagem then return end
	humanoidRoot = personagem:FindFirstChild("HumanoidRootPart")
	if not humanoidRoot then return end

	-- Criar plataforma ancorada
	plataforma = Instance.new("Part")
	plataforma.Size = Vector3.new(6, 1, 6)
	plataforma.Anchored = true
	plataforma.CanCollide = true
	plataforma.Position = humanoidRoot.Position - Vector3.new(0, 3, 0)
	plataforma.Name = "PlataformaRGB"
	plataforma.Parent = workspace

	-- Subida rápida e "grudando" o personagem
	local velocidadeSubida = 5 -- units por segundo

	-- Conexão para mover plataforma e personagem juntos
	conexaoRender = RunService.RenderStepped:Connect(function(dt)
		if plataforma and humanoidRoot then
			-- Mover plataforma para cima
			plataforma.Position = plataforma.Position + Vector3.new(0, velocidadeSubida * dt, 0)
			-- Forçar personagem a acompanhar (mantendo a mesma distância em Y)
			humanoidRoot.CFrame = humanoidRoot.CFrame + Vector3.new(0, velocidadeSubida * dt, 0)

			-- Efeito RGB
			corHue = (corHue + dt) % 1
			plataforma.Color = Color3.fromHSV(corHue, 1, 1)
		end
	end)
end

-- Função destruir plataforma e parar subida
local function destruirPlataforma()
	if conexaoRender then
		conexaoRender:Disconnect()
		conexaoRender = nil
	end
	if plataforma then
		plataforma:Destroy()
		plataforma = nil
	end
end

-- Botão toggle
toggleButton.MouseButton1Click:Connect(function()
	plataformaAtiva = not plataformaAtiva

	if plataformaAtiva then
		toggleButton.Text = "Desativar Plataforma"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		criarPlataforma()
	else
		toggleButton.Text = "Ativar Plataforma"
		toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		destruirPlataforma()
	end
end)

-- Recriar plataforma se o personagem renascer e estiver ativo
player.CharacterAdded:Connect(function(char)
	if plataformaAtiva then
		task.wait(1)
		criarPlataforma()
	end
end)

-- Mostrar Mosquito Hub automaticamente e plataforma NÃO ativa ao entrar
-- Se quiser que já comece ativada, descomente as linhas abaixo:
// plataformaAtiva = true
// criarPlataforma()
// toggleButton.Text = "Desativar Plataforma"
// toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

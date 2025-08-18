local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-----------------------------------------------------
-- GUI Setup
-----------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Botão ESP
local botao = Instance.new("TextButton")
botao.Name = "ToggleESP"
botao.Parent = ScreenGui
botao.Size = UDim2.new(0, 140, 0, 50)
botao.Position = UDim2.new(0, 20, 0, 100)
botao.BackgroundColor3 = Color3.new(1, 0, 0)
botao.BorderSizePixel = 2
botao.BorderColor3 = Color3.new(0.6, 0, 0)
botao.Text = "🔴 Ativar ESP"
botao.TextColor3 = Color3.new(1, 1, 1)
botao.Font = Enum.Font.SourceSansBold
botao.TextSize = 22

-- Círculo de FOV
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Parent = ScreenGui
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, 300, 0, 300) -- Tamanho do FOV em pixels
fovCircle.BackgroundTransparency = 1

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = fovCircle

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.new(1, 0, 0) -- Vermelho
uiStroke.Transparency = 0.25
uiStroke.Parent = fovCircle

-----------------------------------------------------
-- Estados
-----------------------------------------------------
local espAtivo = false
local aimAtivo = false
local connections = {}

local FOV_RADIUS = 150 -- raio do FOV em pixels (metade do size do círculo)

-----------------------------------------------------
-- ESP Funções
-----------------------------------------------------

local function adicionarESP(player)
	if player.Character and not player.Character:FindFirstChild("ESP_Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESP_Highlight"
		highlight.Adornee = player.Character
		highlight.FillColor = Color3.new(1, 0, 0)
		highlight.OutlineColor = Color3.new(1, 0, 0)
		highlight.FillTransparency = 0.3
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = player.Character
	end
end

local function removerESP(player)
	if player.Character then
		local esp = player.Character:FindFirstChild("ESP_Highlight")
		if esp then
			esp:Destroy()
		end
	end
end

local function ativarESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			adicionarESP(player)
			local conn = player.CharacterAdded:Connect(function()
				task.wait(1)
				adicionarESP(player)
			end)
			table.insert(connections, conn)
		end
	end

	local conn = Players.PlayerAdded:Connect(function(player)
		task.wait(1)
		if player ~= LocalPlayer then
			adicionarESP(player)
			local charConn = player.CharacterAdded:Connect(function()
				task.wait(1)
				adicionarESP(player)
			end)
			table.insert(connections, charConn)
		end
	end)
	table.insert(connections, conn)
end

local function desativarESP()
	for _, player in ipairs(Players:GetPlayers()) do
		removerESP(player)
	end

	for _, conn in ipairs(connections) do
		if conn.Connected then
			conn:Disconnect()
		end
	end
	connections = {}
end

local function toggleESP()
	espAtivo = not espAtivo
	if espAtivo then
		botao.Text = "🔴 Desativar ESP"
		ativarESP()
	else
		botao.Text = "🔴 Ativar ESP"
		desativarESP()
	end
end

-----------------------------------------------------
-- AIM ASSIST (com FOV)
-----------------------------------------------------

local function getPlayerMaisProximo()
	local maisPerto = nil
	local menorDistancia = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

			if onScreen then
				local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

				if mouseDist <= FOV_RADIUS and mouseDist < menorDistancia then
					menorDistancia = mouseDist
					maisPerto = player
				end
			end
		end
	end

	return maisPerto
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
		aimAtivo = not aimAtivo
		if aimAtivo then
			print("🎯 Aim Assist ON")
		else
			print("❌ Aim Assist OFF")
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if aimAtivo then
		local alvo = getPlayerMaisProximo()
		if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
			local alvoPos = alvo.Character.HumanoidRootPart.Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvoPos)
		end
	end
end)

-----------------------------------------------------
-- Conectar botão
-----------------------------------------------------

botao.MouseButton1Click:Connect(toggleESP)

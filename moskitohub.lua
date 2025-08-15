-- Criar botão na tela
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local botao = Instance.new("TextButton")
botao.Name = "ToggleESP"
botao.Parent = ScreenGui
botao.Size = UDim2.new(0, 120, 0, 40)
botao.Position = UDim2.new(0, 20, 0, 100)
botao.BackgroundColor3 = Color3.new(0.2, 0, 0) -- Fundo escuro
botao.BorderSizePixel = 0
botao.Text = "Ativar ESP"
botao.TextColor3 = Color3.new(1, 0, 0) -- Texto vermelho
botao.Font = Enum.Font.SourceSansBold
botao.TextSize = 20

local espAtivo = false

-- Função para adicionar ESP ao player
local function adicionarESP(player)
    if player.Character and not player.Character:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.new(1, 0, 0) -- VERMELHO
        highlight.OutlineColor = Color3.new(1, 0, 0) -- VERMELHO
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
    end
end

-- Função para remover ESP
local function removerESP(player)
    if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
        player.Character:FindFirstChild("ESP_Highlight"):Destroy()
    end
end

-- Ativar ESP
local function ativarESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            adicionarESP(player)
            player.CharacterAdded:Connect(function()
                wait(1)
                adicionarESP(player)
            end)
        end
    end
end

-- Desativar ESP
local function desativarESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        removerESP(player)
    end
end

-- Função de toggle
local function toggleESP()
    espAtivo = not espAtivo
    if espAtivo then
        botao.Text = "Desativar ESP"
        ativarESP()
    else
        botao.Text = "Ativar ESP"
        desativarESP()
    end
end

-- Conectar clique do botão
botao.MouseButton1Click:Connect(toggleESP)

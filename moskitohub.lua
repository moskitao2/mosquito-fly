-- Criar botão na tela (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local botao = Instance.new("TextButton")
botao.Name = "ToggleESP"
botao.Parent = ScreenGui
botao.Size = UDim2.new(0, 140, 0, 50)
botao.Position = UDim2.new(0, 20, 0, 100)
botao.BackgroundColor3 = Color3.new(1, 0, 0) -- Fundo VERMELHO
botao.BorderSizePixel = 2
botao.BorderColor3 = Color3.new(0.6, 0, 0) -- Borda mais escura
botao.Text = "🔴 Ativar ESP"
botao.TextColor3 = Color3.new(1, 1, 1) -- Texto BRANCO
botao.Font = Enum.Font.SourceSansBold
botao.TextSize = 22

local espAtivo = false

-- Adiciona ESP ao jogador
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

-- Remove ESP
local function removerESP(player)
    if player.Character then
        local esp = player.Character:FindFirstChild("ESP_Highlight")
        if esp then
            esp:Destroy()
        end
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

-- Toggle
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

-- Clique do botão
botao.MouseButton1Click:Connect(toggleESP)

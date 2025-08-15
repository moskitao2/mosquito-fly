local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

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

-- Estado
local espAtivo = false
local connections = {}

-- Funções
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
                wait(1)
                adicionarESP(player)
            end)

            table.insert(connections, conn)
        end
    end

    -- Novo jogador entra no jogo
    local conn = Players.PlayerAdded:Connect(function(player)
        wait(1)
        if player ~= LocalPlayer then
            adicionarESP(player)
            local charConn = player.CharacterAdded:Connect(function()
                wait(1)
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

-- Conexão do botão
botao.MouseButton1Click:Connect(toggleESP)

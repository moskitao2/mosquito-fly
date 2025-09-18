-- Script para Delta/exploit - Remove roupas, efeitos, acessórios de TODOS, inclusive o LocalPlayer

local Players = game:GetService("Players")

-- Função que limpa o personagem COMPLETAMENTE
local function limparPersonagem(char)
    if not char then return end

    for _, item in pairs(char:GetDescendants()) do
        -- Roupas
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Destroy()
        end

        -- Efeitos visuais / Auras
        if item:IsA("ParticleEmitter") or
           item:IsA("Fire") or
           item:IsA("Smoke") or
           item:IsA("Sparkles") or
           item:IsA("Highlight") or
           item:IsA("Beam") or
           item:IsA("Trail") or
           item:IsA("PointLight") or
           item:IsA("SurfaceLight") or
           item:IsA("SpotLight") then
            item:Destroy()
        end
    end

    -- Remover acessórios (chapéu, cabelo, etc.)
    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            acc:Destroy()
        end
    end
end

-- Função que observa o jogador e limpa o personagem sempre que ele nasce
local function monitorarJogador(player)
    local function quandoNascer(char)
        repeat wait() until char:FindFirstChild("Humanoid") -- Garante que carregou
        wait(1) -- Espera o personagem carregar completamente
        limparPersonagem(char)
    end

    -- Se já tiver personagem
    if player.Character then
        quandoNascer(player.Character)
    end

    -- Quando renascer
    player.CharacterAdded:Connect(quandoNascer)
end

-- Aplicar a todos os jogadores que já estão no jogo
for _, player in pairs(Players:GetPlayers()) do
    monitorarJogador(player)
end

-- Aplicar a quem entrar depois
Players.PlayerAdded:Connect(function(player)
    monitorarJogador(player)
end)

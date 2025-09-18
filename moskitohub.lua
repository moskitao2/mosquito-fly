local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function cleanCharacter(character)
    if not character then return end

    for _, obj in ipairs(character:GetChildren()) do
        -- Mantém apenas a cabeça, Humanoid e RootPart
        if obj:IsA("BasePart") then
            if obj.Name ~= "Head" and obj.Name ~= "HumanoidRootPart" then
                obj:Destroy()
            end
        elseif obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("CharacterMesh") then
            obj:Destroy()
        elseif obj:IsA("Humanoid") then
            -- Mantém humanoid (necessário pro personagem existir)
        else
            pcall(function()
                obj:Destroy()
            end)
        end
    end
end

local function hookCharacter(character)
    task.wait(0.3)
    cleanCharacter(character)

    while character.Parent do
        task.wait(5)
        cleanCharacter(character)
    end
end

local function hookPlayer(player)
    player.CharacterAdded:Connect(function(char)
        hookCharacter(char)
    end)
    if player.Character then
        hookCharacter(player.Character)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        hookPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        hookPlayer(plr)
    end
end)

print("Script rodando: só cabeça dos jogadores visível.")

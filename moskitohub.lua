

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function cleanCharacter(character)
    if not character then return end

    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("CharacterMesh") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj:Destroy()
        elseif obj.Name:lower():match("aura") or obj.Name:lower():match("glow") or obj.Name:lower():match("effect") or obj.Name:lower():match("vfx") then
            pcall(function() obj:Destroy() end)
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

print("anti leg do mosquitao.")

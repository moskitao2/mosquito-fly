local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Estado dos cheats
local speedHackOn = false
local jumpHackOn = false

-- Valores cheats
local normalWalkSpeed = 16
local normalJumpPower = 50

local hackWalkSpeed = 50
local hackJumpPower = 100

-- Criar GUI simples
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MoskitoHub"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "Moskito Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.BebasNeue
title.TextSize = 24
title.TextStrokeTransparency = 0.5

-- Função que cria botões toggle
local function createToggleBtn(text, posY, callback)
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 40)
btn.Position = UDim2.new(0, 10, 0, posY)
btn.BackgroundColor3 = Color3.fromRGB(70,130,180)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20
btn.Text = text
btn.AutoButtonColor = true

btn.MouseButton1Click:Connect(function()
callback(btn)
end)
return btn
end

-- Hook da metatable para burlar o anti-cheat
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = function(tbl, key)
if tbl == hum then
if key == "WalkSpeed" then
if speedHackOn then
return normalWalkSpeed -- finge normal pro anti-cheat
end
elseif key == "JumpPower" then
if jumpHackOn then
return normalJumpPower -- finge normal pro anti-cheat
end
end
end
return oldIndex(tbl, key)
end

setreadonly(mt, true)

-- Função pra aplicar os valores reais ao humanoide
local function applyCheats()
if speedHackOn then
hum.WalkSpeed = hackWalkSpeed
else
hum.WalkSpeed = normalWalkSpeed
end

if jumpHackOn then
hum.JumpPower = hackJumpPower
else
hum.JumpPower = normalJumpPower
end
end

-- Cria os botões
local speedBtn = createToggleBtn("Ativar Speed Hack", 40, function(btn)
speedHackOn = not speedHackOn
applyCheats()
btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 90, function(btn)
jumpHackOn = not jumpHackOn
applyCheats()
btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
end)

-- Atualiza humanoide quando personagem respawnar
player.CharacterAdded:Connect(function(character)
char = character
hum = char:WaitForChild("Humanoid")
applyCheats()
end)

-- Aplica cheats no load
applyCheats()

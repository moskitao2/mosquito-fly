local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Cheats state
local speedHackOn = false
local jumpHackOn = false

-- Normal values
local normalWalkSpeed = 16
local normalJumpPower = 50

-- Hack values
local hackWalkSpeed = 50
local hackJumpPower = 100

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoskitoHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 90)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🦟 Moskito Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = frame

local btnCorner = Instance.new("UICorner", closeBtn)
btnCorner.CornerRadius = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle button creator
local function createToggleBtn(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = frame

    local uicorner = Instance.new("UICorner", btn)
    uicorner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)

    return btn
end

-- Bypass anti-cheat (metatable hook)
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = function(tbl, key)
    if tbl == hum then
        if key == "WalkSpeed" and speedHackOn then
            return normalWalkSpeed
        elseif key == "JumpPower" and jumpHackOn then
            return normalJumpPower
        end
    end
    return oldIndex(tbl, key)
end

setreadonly(mt, true)

-- Apply hack values
local function applyCheats()
    hum.WalkSpeed = speedHackOn and hackWalkSpeed or normalWalkSpeed
    hum.JumpPower = jumpHackOn and hackJumpPower or normalJumpPower
end

-- Toggle buttons
local speedBtn = createToggleBtn("Ativar Speed Hack", 40, function(btn)
    speedHackOn = not speedHackOn
    applyCheats()
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70,130,180)
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 90, function(btn)
    jumpHackOn = not jumpHackOn
    applyCheats()
    btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
    btn.BackgroundColor3 = jumpHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70,130,180)
end)

-- Reapply cheats on respawn
player.CharacterAdded:Connect(function(character)
    char = character
    hum = char:WaitForChild("Humanoid")
    applyCheats()
end)

-- Apply on first load
applyCheats()

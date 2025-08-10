-- Moskitao Boost (Delta Executor)
local plr = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local jumpBoost = true
local sprintSpeed = 60
local normalSpeed = 16
local jumpPowerHigh = 100
local jumpPowerNormal = 50
local boostEnabled = false

local function enableBoost()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = sprintSpeed
    if jumpBoost then hum.JumpPower = jumpPowerHigh end
    print("Boost Ativado")
end

local function disableBoost()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = normalSpeed
    hum.JumpPower = jumpPowerNormal
    print("Boost Desativado")
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        boostEnabled = not boostEnabled
        if boostEnabled then
            enableBoost()
        else
            disableBoost()
        end
    end
end)

plr.CharacterAdded:Connect(function(char)
    boostEnabled = false
    char:WaitForChild("Humanoid")
    disableBoost()
end)

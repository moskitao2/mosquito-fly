local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local speedHackOn = false
local jumpHackOn = false
local espOn = false
local espAdorns = {}

-- Valores normais e hack
local normalWalkSpeed = 16
local normalJumpPower = 50
local hackWalkSpeed = 50
local hackJumpPower = 100

-- Função segura para obter Humanoid
local function getCharAndHum(player)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hum
end

-- Interface GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoskitoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0, 40, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(32, 39, 54)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local shadow = Instance.new("ImageLabel")
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(-0.04, 0, -0.06, 0)
shadow.ZIndex = 0
shadow.Parent = frame

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(65,85,130)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "🦟 MoskitoHub"
title.TextColor3 = Color3.fromRGB(170, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 28
title.ZIndex = 2

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 19
closeBtn.ZIndex = 2
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Função para criar botões
local function createToggleBtn(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -30, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local strokeBtn = Instance.new("UIStroke", btn)
    strokeBtn.Color = Color3.fromRGB(130,180,230)
    strokeBtn.Thickness = 1

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90, 170, 210)
        strokeBtn.Color = Color3.fromRGB(150,220,255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = callback._on and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
        strokeBtn.Color = Color3.fromRGB(130,180,230)
    end)
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- ESP
local function clearESP(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = part:FindFirstChild("_MoskitoESP")
            if adorn then adorn:Destroy() end
        end
    end
end

local function addESPToChar(char)
    if not char then return end
    espAdorns[char] = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local adorn = Instance.new("BoxHandleAdornment")
            adorn.Name = "_MoskitoESP"
            adorn.Size = part.Size + Vector3.new(0.3,0.3,0.3)
            adorn.Color3 = Color3.fromRGB(0, 255, 160)
            adorn.Transparency = 0.5
            adorn.Adornee = part
            adorn.AlwaysOnTop = true
            adorn.ZIndex = 15
            adorn.Parent = part
            table.insert(espAdorns[char], adorn)
        end
    end
end

local function updateESPForAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espOn then
                if not espAdorns[player.Character] then
                    addESPToChar(player.Character)
                end
            else
                clearESP(player.Character)
                espAdorns[player.Character] = nil
            end
        end
    end
end

-- Atualizações constantes
RunService.Stepped:Connect(function()
    local char, hum = getCharAndHum(LocalPlayer)
    if hum then
        if speedHackOn then hum.WalkSpeed = hackWalkSpeed end
        if jumpHackOn then hum.JumpPower = hackJumpPower end
    end
end)

RunService.RenderStepped:Connect(function()
    updateESPForAll()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if espOn then
            addESPToChar(char)
        end
    end)
end)

-- Botões
local espBtn = createToggleBtn("Ativar ESP (box neon)", 50, function(btn)
    espOn = not espOn
    btn.Text = espOn and "Desativar ESP (box neon)" or "Ativar ESP (box neon)"
    btn.BackgroundColor3 = espOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    espBtn._on = espOn
end)

local speedBtn = createToggleBtn("Ativar Speed Hack", 100, function(btn)
    speedHackOn = not speedHackOn
    btn.Text = speedHackOn and "Desativar Speed Hack" or "Ativar Speed Hack"
    btn.BackgroundColor3 = speedHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    speedBtn._on = speedHackOn
end)

local jumpBtn = createToggleBtn("Ativar Jump Hack", 150, function(btn)
    jumpHackOn = not jumpHackOn
    btn.Text = jumpHackOn and "Desativar Jump Hack" or "Ativar Jump Hack"
    btn.BackgroundColor3 = jumpHackOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(70, 130, 180)
    jumpBtn._on = jumpHackOn
end)

-- 🛡️ Hook __index (bypass leitura)
if not _G.MoskitoHubIndexHooked then
    _G.MoskitoHubIndexHooked = true
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(tbl, key)
        if typeof(tbl) == "Instance" and tbl:IsA("Humanoid") then
            if key == "WalkSpeed" and speedHackOn then
                return normalWalkSpeed
            end
            if key == "JumpPower" and jumpHackOn then
                return normalJumpPower
            end
            if key == "JumpHeight" and jumpHackOn then
                return 7.2 -- valor padrão
            end
        end
        return oldIndex(tbl, key)
    end)
    setreadonly(mt, true)
end

-- 🛡️ Hook __newindex (bloqueia mudanças)
if not _G.MoskitoHubNewIndexHooked then
    _G.MoskitoHubNewIndexHooked = true
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNewIndex = mt.__newindex
    mt.__newindex = newcclosure(function(tbl, key, val)
        if typeof(tbl) == "Instance" and tbl:IsA("Humanoid") then
            if key == "WalkSpeed" and speedHackOn and val ~= hackWalkSpeed then
                warn("[MoskitoHub] ⚠️ Bloqueado alteração de WalkSpeed:", val)
                return
            end
            if key == "JumpPower" and jumpHackOn and val ~= hackJumpPower then
                warn("[MoskitoHub] ⚠️ Bloqueado alteração de JumpPower:", val)
                return
            end
            if key == "JumpHeight" and jumpHackOn then
                warn("[MoskitoHub] ⚠️ Bloqueado alteração de JumpHeight:", val)
                return
            end
            if key == "UseJumpPower" and jumpHackOn and val == false then
                warn("[MoskitoHub] ⚠️ Tentaram desativar UseJumpPower")
                return
            end
        end
        return oldNewIndex(tbl, key, val)
    end)
    setreadonly(mt, true)
end

-- 🛡️ Hook __namecall (anti-kick / anti-anticheat)
if not _G.MoskitoHubHooked then
    _G.MoskitoHubHooked = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == LocalPlayer then
            warn("[MoskitoHub] ⚠️ Kick bloqueado.")
            return nil
        end
        if method == "Destroy" and self == LocalPlayer then
            warn("[MoskitoHub] ⚠️ Destroy bloqueado.")
            return nil
        end
        if method == "BreakJoints" and self == LocalPlayer.Character then
            warn("[MoskitoHub] ⚠️ BreakJoints bloqueado.")
            return nil
        end
        if (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) and method:lower():find("server") then
            local name = self.Name:lower()
            if name:find("anticheat") or name:find("report") or name:find("ban") then
                warn("[MoskitoHub] ⚠️ Remote suspeito bloqueado:", self.Name)
                return nil
            end
        end
        return oldNamecall(self, ...)
    end))
end

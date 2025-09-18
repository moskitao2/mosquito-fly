local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function limparPersonagem(char)
    if not char then return end

    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Destroy()
        end
    end

    for _, decal in pairs(char:GetDescendants()) do
        if decal:IsA("Decal") or decal:IsA("Texture") then
            decal:Destroy()
        end
    end

    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            for _, child in pairs(acc:GetDescendants()) do
                if child and child.Parent then
                    child:Destroy()
                end
            end
            acc:Destroy()
        end
    end

    for _, item in pairs(char:GetDescendants()) do
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
end

local function monitorarJogador(player)
    local function quandoNascer(char)
        repeat wait() until char:FindFirstChild("Humanoid")
        wait(1)
        limparPersonagem(char)
    end

    if player.Character then
        quandoNascer(player.Character)
    end

    player.CharacterAdded:Connect(quandoNascer)
end

for _, player in pairs(Players:GetPlayers()) do
    monitorarJogador(player)
end

Players.PlayerAdded:Connect(function(player)
    monitorarJogador(player)
end)

local espTable = {}

local function criarESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 1.5
    box.Transparency = 1
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Color = Color3.new(1, 1, 1)
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Visible = false

    espTable[player] = {
        box = box,
        name = name
    }
end

local function removerESP(player)
    if espTable[player] then
        espTable[player].box:Remove()
        espTable[player].name:Remove()
        espTable[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    criarESP(player)
end

Players.PlayerAdded:Connect(function(player)
    criarESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removerESP(player)
end)

RunService.RenderStepped:Connect(function()
    for player, visuals in pairs(espTable) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                local scale = 1 / distance * 100
                local boxSize = Vector2.new(35 * scale, 55 * scale)
                local boxPos = Vector2.new(vector.X - boxSize.X / 2, vector.Y - boxSize.Y / 2)

                visuals.box.Size = boxSize
                visuals.box.Position = boxPos
                visuals.box.Visible = true

                visuals.name.Text = player.Name
                visuals.name.Position = Vector2.new(vector.X, boxPos.Y - 14)
                visuals.name.Visible = true
            else
                visuals.box.Visible = false
                visuals.name.Visible = false
            end
        else
            visuals.box.Visible = false
            visuals.name.Visible = false
        end
    end
end)

local label = Drawing.new("Text")
label.Text = "Mosquito Hub Anti Lag"
label.Size = 20
label.Center = false
label.Outline = true
label.Visible = true

local function rgbColor(tick)
    local r = (math.sin(tick) + 1) / 2
    local g = (math.sin(tick + 2) + 1) / 2
    local b = (math.sin(tick + 4) + 1) / 2
    return Color3.new(r, g, b)
end

RunService.RenderStepped:Connect(function()
    local tick = tick() * 5
    label.Color = rgbColor(tick)

    local screenWidth = workspace.CurrentCamera.ViewportSize.X
    label.Position = Vector2.new(screenWidth - label.TextBounds.X - 10, 10)
end)

-- nCheat v3.2 | Исправленный NoClip + Бессмертие
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Настройки
local settings = {
    noclip = false,
    invisible = false,
    jumpBoost = false,
    walkSpeed = 16,
    jumpPower = 50,
    godMode = false
}

-- Автоматическое обновление персонажа
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    
    -- Восстановление настроек после смерти
    if settings.jumpBoost then
        humanoid.JumpPower = 100
    end
    humanoid.WalkSpeed = settings.walkSpeed
    
    if settings.invisible then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
    
    if settings.godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

-- GUI (Компактный интерфейс)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "nCheatGUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.18, 0, 0.4, 0)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundTransparency = 0.9
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0.1, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundTransparency = 0.7
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Parent = frame
    return btn
end

-- Элементы интерфейса
local title = Instance.new("TextLabel")
title.Text = "nCheat v3.2"
title.Size = UDim2.new(1, 0, 0.08, 0)
title.Position = UDim2.new(0, 0, 0.02, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local noclipBtn = createButton("Noclip: OFF", 0.12)
local godBtn = createButton("God Mode: OFF", 0.24)
local invisBtn = createButton("Invisible: OFF", 0.36)
local jumpBtn = createButton("Jump Boost: OFF", 0.48)
local speedBtn = createButton("Speed: "..settings.walkSpeed, 0.60)
local killBtn = createButton("Kill Player", 0.72)
local tpToBtn = createButton("TP to Player", 0.84)
local tpHereBtn = createButton("TP Player Here", 0.96)

local playerInput = Instance.new("TextBox")
playerInput.PlaceholderText = "Player Name"
playerInput.Size = UDim2.new(0.9, 0, 0.08, 0)
playerInput.Position = UDim2.new(0.05, 0, 1.08, 0)
playerInput.BackgroundTransparency = 0.7
playerInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Font = Enum.Font.Gotham
playerInput.TextSize = 12
playerInput.Parent = frame

-- Функции
local function toggleMenu()
    frame.Visible = not frame.Visible
end

local function updateNoClip()
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not settings.noclip
        end
    end
end

local function toggleGodMode()
    settings.godMode = not settings.godMode
    godBtn.Text = "God Mode: "..(settings.godMode and "ON" or "OFF")
    
    if humanoid then
        if settings.godMode then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

local function toggleInvisibility()
    settings.invisible = not settings.invisible
    invisBtn.Text = "Invisible: "..(settings.invisible and "ON" or "OFF")
    
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = settings.invisible and 1 or 0
            end
        end
    end
end

local function killPlayer()
    local targetName = playerInput.Text:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Name:lower():find(targetName) then
            if plr.Character then
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
        end
    end
end

local function teleportToPlayer()
    local targetName = playerInput.Text:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Name:lower():find(targetName) then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
            end
        end
    end
end

local function teleportPlayerToMe()
    local targetName = playerInput.Text:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Name:lower():find(targetName) then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame
            end
        end
    end
end

-- Обработчики кнопок
noclipBtn.MouseButton1Click:Connect(function()
    settings.noclip = not settings.noclip
    noclipBtn.Text = "Noclip: "..(settings.noclip and "ON" or "OFF")
end)

godBtn.MouseButton1Click:Connect(toggleGodMode)
invisBtn.MouseButton1Click:Connect(toggleInvisibility)

jumpBtn.MouseButton1Click:Connect(function()
    settings.jumpBoost = not settings.jumpBoost
    jumpBtn.Text = "Jump Boost: "..(settings.jumpBoost and "ON" or "OFF")
    if humanoid then
        humanoid.JumpPower = settings.jumpBoost and 100 or 50
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    settings.walkSpeed = settings.walkSpeed + 10
    if settings.walkSpeed > 100 then settings.walkSpeed = 16 end
    if humanoid then
        humanoid.WalkSpeed = settings.walkSpeed
    end
    speedBtn.Text = "Speed: "..settings.walkSpeed
end)

killBtn.MouseButton1Click:Connect(killPlayer)
tpToBtn.MouseButton1Click:Connect(teleportToPlayer)
tpHereBtn.MouseButton1Click:Connect(teleportPlayerToMe)

-- Системные обработчики
RunService.Stepped:Connect(function()
    if character then
        updateNoClip()
        
        if settings.godMode and humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        toggleMenu()
    end
end)

-- Инициализация
if humanoid then
    humanoid.WalkSpeed = settings.walkSpeed
    humanoid.JumpPower = settings.jumpBoost and 100 or 50
    
    if settings.godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end

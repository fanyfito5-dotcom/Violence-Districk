--[[
    ALCITO HUB
    Creator: alcito
    Version: 1.0
    Delta Android
]]

if game.CoreGui:FindFirstChild("ALCITO_HUB") then
    game.CoreGui.ALCITO_HUB:Destroy()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ALCITO_HUB"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent
pcall(function()
    parent = gethui()
end)

gui.Parent = parent or game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(310, 350)
main.Position = UDim2.new(0.5, -155, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(95, 85, 255)
stroke.Thickness = 1.5
stroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = Color3.fromRGB(29, 31, 52)
header.BorderSizePixel = 0
header.Parent = main

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 12)
hc.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 28)
title.Position = UDim2.fromOffset(14, 5)
title.BackgroundTransparency = 1
title.Text = "ALCITO HUB"
title.TextColor3 = Color3.fromRGB(155, 145, 255)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -60, 0, 18)
subtitle.Position = UDim2.fromOffset(15, 31)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Creator: alcito  |  v1.0"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 180)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Drag support
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Tabs
local tabs = Instance.new("Frame")
tabs.Position = UDim2.fromOffset(10, 65)
tabs.Size = UDim2.new(1, -20, 0, 35)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local function createTab(name, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/3, -5, 1, 0)
    b.Position = UDim2.new(x/3, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(42, 44, 68)
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = tabs

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local homeTab = createTab("HOME", 0)
local settingsTab = createTab("SETTINGS", 1)
local aboutTab = createTab("ABOUT", 2)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(10, 110)
content.Size = UDim2.new(1, -20, 1, -120)
content.BackgroundTransparency = 1
content.Parent = main

local function clearContent()
    for _, v in ipairs(content:GetChildren()) do
        v:Destroy()
    end
end

local function label(text, y, color)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(5, y)
    l.Size = UDim2.new(1, -10, 0, 28)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = content
    return l
end

local function makeButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(5, y)
    b.Size = UDim2.new(1, -10, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(44, 46, 76)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = content

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function showHome()
    clearContent()
    label("Welcome, " .. player.Name, 5, Color3.fromRGB(170, 160, 255))
    label("ALCITO HUB is ready.", 38)
    label("Mobile interface loaded successfully.", 68)
    makeButton("MINIMIZE HUB", 115, function()
        main.Visible = false
    end)
end

local function showSettings()
    clearContent()
    label("INTERFACE SETTINGS", 5, Color3.fromRGB(170, 160, 255))

    makeButton("SMALL SIZE", 45, function()
        main.Size = UDim2.fromOffset(270, 320)
    end)

    makeButton("NORMAL SIZE", 88, function()
        main.Size = UDim2.fromOffset(310, 350)
    end)

    makeButton("RESET POSITION", 131, function()
        main.Position = UDim2.new(0.5, -155, 0.5, -175)
    end)

    makeButton("UNLOAD HUB", 174, function()
        gui:Destroy()
    end)
end

local function showAbout()
    clearContent()
    label("ABOUT ALCITO HUB", 5, Color3.fromRGB(170, 160, 255))
    label("Creator: alcito", 45)
    label("Version: 1.0", 75)
    label("Platform: Delta Android", 105)
    label("Thank you for using ALCITO HUB!", 150)
end

homeTab.MouseButton1Click:Connect(showHome)
settingsTab.MouseButton1Click:Connect(showSettings)
aboutTab.MouseButton1Click:Connect(showAbout)

-- Floating reopen button
local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(55, 55)
mini.Position = UDim2.new(0, 15, 0.5, 0)
mini.BackgroundColor3 = Color3.fromRGB(80, 65, 220)
mini.Text = "A"
mini.TextColor3 = Color3.new(1, 1, 1)
mini.TextSize = 24
mini.Font = Enum.Font.GothamBold
mini.Visible = false
mini.Parent = gui

Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)

mini.MouseButton1Click:Connect(function()
    main.Visible = true
    mini.Visible = false
end)

-- Minimize behavior
local function minimize()
    main.Visible = false
    mini.Visible = true
end

showHome()

print("[ALCITO HUB] Successfully loaded!")

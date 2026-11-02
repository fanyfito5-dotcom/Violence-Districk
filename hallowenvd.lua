--==================================================
-- ALCITO HUB V2
-- Creator: alcito
-- Platform: Delta Android
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Cleanup old version
local old
pcall(function()
    old = (gethui and gethui():FindFirstChild("ALCITO_HUB"))
        or game:GetService("CoreGui"):FindFirstChild("ALCITO_HUB")
end)
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "ALCITO_HUB"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent
pcall(function()
    parent = gethui()
end)
GUI.Parent = parent or PlayerGui

local purple = Color3.fromRGB(145, 65, 255)
local dark = Color3.fromRGB(13, 12, 23)
local panel = Color3.fromRGB(25, 22, 40)
local white = Color3.fromRGB(245, 240, 255)
local muted = Color3.fromRGB(165, 155, 185)

local state = {
    fps = false,
    clock = false,
    compact = false,
    animation = true,
    transparency = 0,
    floating = true
}

local connections = {}
local function connect(c)
    table.insert(connections, c)
    return c
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or purple
    s.Thickness = thickness or 1
    s.Parent = obj
end

local function tween(obj, props)
    if not state.animation then
        for k,v in pairs(props) do obj[k] = v end
        return
    end

    TweenService:Create(
        obj,
        TweenInfo.new(0.18, Enum.EasingStyle.Quart),
        props
    ):Play()
end

-- Main window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(350, 440)
Main.Position = UDim2.new(0.5, -175, 0.5, -220)
Main.BackgroundColor3 = dark
Main.BackgroundTransparency = state.transparency
Main.BorderSizePixel = 0
Main.Parent = GUI
corner(Main, 15)
stroke(Main, purple, 2)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 75)
Header.BackgroundColor3 = Color3.fromRGB(31, 23, 51)
Header.BorderSizePixel = 0
Header.Parent = Main
corner(Header, 14)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(58, 58)
Logo.Position = UDim2.fromOffset(10, 8)
Logo.BackgroundColor3 = Color3.fromRGB(49, 25, 86)
Logo.Text = "♛\nA"
Logo.TextColor3 = Color3.fromRGB(190, 125, 255)
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBlack
Logo.Parent = Header
corner(Logo, 12)
stroke(Logo, purple, 1.5)

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(78, 12)
Title.Size = UDim2.new(1, -145, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "ALCITO HUB"
Title.TextColor3 = white
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.Position = UDim2.fromOffset(80, 42)
Sub.Size = UDim2.new(1, -150, 0, 20)
Sub.BackgroundTransparency = 1
Sub.Text = "VIOLENCE DISTRICT"
Sub.TextColor3 = purple
Sub.TextSize = 10
Sub.Font = Enum.Font.GothamBold
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -43, 0, 20)
Minimize.BackgroundColor3 = Color3.fromRGB(54, 39, 83)
Minimize.Text = "—"
Minimize.TextColor3 = white
Minimize.TextSize = 22
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Header
corner(Minimize, 8)

-- Floating logo
local Float = Instance.new("TextButton")
Float.Size = UDim2.fromOffset(65, 65)
Float.Position = UDim2.new(0, 15, 0.5, -30)
Float.BackgroundColor3 = Color3.fromRGB(24, 13, 43)
Float.Text = "♛\nA"
Float.TextColor3 = Color3.fromRGB(190, 110, 255)
Float.TextSize = 24
Float.Font = Enum.Font.GothamBlack
Float.Visible = false
Float.Parent = GUI
corner(Float, 100)
stroke(Float, purple, 2)

-- Drag system
local function makeDraggable(obj, handle)
    local dragging = false
    local start
    local original

    connect(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            original = obj.Position
        end
    end))

    connect(UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - start
            obj.Position = UDim2.new(
                original.X.Scale,
                original.X.Offset + delta.X,
                original.Y.Scale,
                original.Y.Offset + delta.Y
            )
        end
    end))

    connect(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
end

makeDraggable(Main, Header)
makeDraggable(Float, Float)

local function minimize()
    Main.Visible = false
    Float.Visible = state.floating
end

Minimize.Activated:Connect(minimize)

Float.Activated:Connect(function()
    Main.Visible = true
    Float.Visible = false
end)

-- Navigation
local Nav = Instance.new("Frame")
Nav.Position = UDim2.fromOffset(10, 85)
Nav.Size = UDim2.new(1, -20, 0, 37)
Nav.BackgroundTransparency = 1
Nav.Parent = Main

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(10, 132)
Content.Size = UDim2.new(1, -20, 1, -142)
Content.BackgroundColor3 = panel
Content.BackgroundTransparency = 0.05
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = purple
Content.CanvasSize = UDim2.new()
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main
corner(Content, 10)

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 9)
Padding.PaddingRight = UDim.new(0, 9)
Padding.Parent = Content

local function clearContent()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= Layout and v ~= Padding then
            v:Destroy()
        end
    end
end

local function section(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 30)
    l.BackgroundTransparency = 1
    l.Text = "  " .. text
    l.TextColor3 = purple
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = Content
    return l
end

local function info(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 34)
    l.BackgroundColor3 = Color3.fromRGB(35, 30, 51)
    l.Text = text
    l.TextColor3 = white
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextWrapped = true
    l.Parent = Content
    corner(l, 8)
    return l
end

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(48, 39, 70)
    b.Text = text
    b.TextColor3 = white
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = Content
    corner(b, 8)

    b.Activated:Connect(callback)
    return b
end

local function toggle(text, key, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(38, 34, 53)
    b.TextColor3 = white
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = Content
    corner(b, 8)

    local function refresh()
        b.Text = text .. (state[key] and "     [ ON ]" or "     [ OFF ]")
        b.BackgroundColor3 = state[key]
            and Color3.fromRGB(83, 42, 135)
            or Color3.fromRGB(38, 34, 53)
    end

    refresh()

    b.Activated:Connect(function()
        state[key] = not state[key]
        refresh()
        if callback then callback(state[key]) end
    end)

    return b
end

-- Home page
local function homePage()
    clearContent()
    section("WELCOME TO ALCITO HUB")
    info("Hello, " .. Player.Name .. "! Hub berhasil dimuat.")
    info("Creator: alcito     |     Version: 2.0")
    info("Platform: Delta Android")
    section("QUICK ACCESS")
    button("OPEN VISUAL SETTINGS", function()
        -- navigation handled below
    end)
    button("MINIMIZE HUB", minimize)
    info("Tekan logo A ungu untuk membuka GUI kembali.")
end

-- Visual page
local function visualPage()
    clearContent()
    section("VISUAL MONITOR")
    toggle("FPS COUNTER", "fps")
    toggle("LOCAL CLOCK", "clock")
    info("Monitor hanya menampilkan informasi perangkat lokal.")
    section("LIVE STATUS")
    local fpsLabel = info("FPS: OFF")
    local clockLabel = info("Clock: OFF")

    connect(RunService.RenderStepped:Connect(function(dt)
        if not GUI.Parent then return end
        if fpsLabel.Parent then
            fpsLabel.Text = state.fps
                and ("FPS: " .. math.floor(1 / math.max(dt, 0.001)))
                or "FPS: OFF"
        end
        if clockLabel.Parent then
            clockLabel.Text = state.clock
                and ("LOCAL TIME: " .. os.date("%H:%M:%S"))
                or "Clock: OFF"
        end
    end))
end

-- Utilities page
local function utilitiesPage()
    clearContent()
    section("UTILITIES")
    button("RESET GUI POSITION", function()
        Main.Position = UDim2.new(0.5, -175, 0.5, -220)
        Float.Position = UDim2.new(0, 15, 0.5, -30)
    end)
    button("MINIMIZE GUI", minimize)
    button("SHOW FLOATING LOGO", function()
        state.floating = true
        if not Main.Visible then Float.Visible = true end
    end)
    button("HIDE FLOATING LOGO", function()
        state.floating = false
        Float.Visible = false
    end)
    info("Utilities mengatur antarmuka ALCITO HUB.")
end

-- Settings page
local function settingsPage()
    clearContent()
    section("INTERFACE SETTINGS")
    toggle("COMPACT MODE", "compact", function(v)
        Main.Size = v
            and UDim2.fromOffset(310, 390)
            or UDim2.fromOffset(350, 440)
    end)
    toggle("ANIMATIONS", "animation")
    section("TRANSPARENCY")
    button("TRANSPARENCY 0%", function()
        state.transparency = 0
        Main.BackgroundTransparency = 0
    end)
    button("TRANSPARENCY 10%", function()
        state.transparency = 0.1
        Main.BackgroundTransparency = 0.1
    end)
    button("TRANSPARENCY 20%", function()
        state.transparency = 0.2
        Main.BackgroundTransparency = 0.2
    end)
    button("UNLOAD ALCITO HUB", function()
        GUI:Destroy()
        for _,c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
    end)
end

-- About page
local function aboutPage()
    clearContent()
    section("ABOUT ALCITO HUB")
    info("ALCITO HUB V2")
    info("Creator: alcito")
    info("Designed for mobile interface.")
    info("Thank you for using ALCITO HUB!")
end

local pages = {
    HOME = homePage,
    VISUAL = visualPage,
    UTILITIES = utilitiesPage,
    SETTINGS = settingsPage,
    ABOUT = aboutPage
}

local names = {"HOME", "VISUAL", "UTILITIES", "SETTINGS", "ABOUT"}

for i, name in ipairs(names) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/#names, -4, 1, 0)
    b.Position = UDim2.new((i-1)/#names, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(43, 34, 62)
    b.Text = name
    b.TextColor3 = white
    b.TextSize = 9
    b.Font = Enum.Font.GothamBold
    b.Parent = Nav
    corner(b, 7)

    b.Activated:Connect(function()
        for _,obj in ipairs(Nav:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(43, 34, 62)
            end
        end
        b.BackgroundColor3 = Color3.fromRGB(103, 48, 168)
        pages[name]()
    end)
end

pages.HOME()

print("[ALCITO HUB V2] Loaded successfully!")

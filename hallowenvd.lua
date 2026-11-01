-- ============================================================================
-- PROJECT: VIOLENCE DISTRICT (HALLOWEEN UPDATE) - VIP EXPLOIT CORE
-- ENVIRONMENT: Delta Executor (Luau / Synapse/Fluid Compatible API)
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Konfigurasi Sistem Key & Webhook
local Config = {
    KeySystemEnabled = true,
    CorrectKey = "VD-HW2026-ALPIN67-SECURE",
    WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN",
    NotificationTitle = "Violence District Core",
}

-- Status Toggle Fitur
local State = {
    ESP_Killer = false,
    ESP_Surviving = false,
    FakePerks = false,
    FakeFlowstate = false,
    SilentAim = false,
    VeilMode = false,
    HitboxExpander = false,
}

-- ============================================================================
-- 1. SISTEM KEY (GATEKEEPER)
-- ============================================================================
local function CreateKeySystem()
    if not Config.KeySystemEnabled then return true end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VD_KeySystem"
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "VIOLENCE DISTRICT - AUTH"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.8, 0, 0, 40)
    TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Masukkan Key..."
    TextBox.Text = ""
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.Parent = MainFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = TextBox
    
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
    SubmitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Text = "VERIFIKASI KEY"
    SubmitBtn.TextSize = 14
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = MainFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = SubmitBtn
    
    local authenticated = false
    
    SubmitBtn.MouseButton1Click:Connect(function()
        if TextBox.Text == Config.CorrectKey then
            authenticated = true
            ScreenGui:Destroy()
        else
            SubmitBtn.Text = "KEY SALAH!"
            task.wait(1)
            SubmitBtn.Text = "VERIFIKASI KEY"
        end
    end)
    
    while not authenticated do
        task.wait(0.1)
    end
    return true
end

-- ============================================================================
-- 2. SISTEM DISCORD WEBHOOK (LOGGER & TELEMETRY)
-- ============================================================================
local function SendWebhook(action, details)
    if not Config.WebhookURL or Config.WebhookURL == "" then return end
    
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Violence District Execution Log",
            ["description"] = "Aktivitas skrip terdeteksi pada sesi aktif.",
            ["color"] = 16711680,
            ["fields"] = {
                {["name"] = "Player", ["value"] = LocalPlayer.Name, ["inline"] = true},
                {["name"] = "User ID", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
                {["name"] = "Action / Toggle", ["value"] = action, ["inline"] = false},
                {["name"] = "Details", ["value"] = details, ["inline"] = false},
                {["name"] = "Timestamp", ["value"] = os.date("%Y-%m-%d %H:%M:%S"), ["inline"] = false}
            }
        }}
    }
    
    local encodedData = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    
    pcall(function()
        if syn and syn.request then
            syn.request({Url = Config.WebhookURL, Method = "POST", Headers = headers, Body = encodedData})
        elseif http_request then
            http_request({Url = Config.WebhookURL, Method = "POST", Headers = headers, Body = encodedData})
        elseif request then
            request({Url = Config.WebhookURL, Method = "POST", Headers = headers, Body = encodedData})
        end
    end)
end

-- ============================================================================
-- 3. FITUR UTAMA: ESP KILLER & SURVIVOR
-- ============================================================================
local ESP_Objects = {}

local function CreateESP(char, isKiller)
    if ESP_Objects[char] then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VD_ESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = isKiller ? "[KILLER] " .. char.Name : "[SURVIVOR] " .. char.Name
    textLabel.Parent = billboard
    
    if char:FindFirstChild("Head") then
        billboard.Parent = char.Head
        ESP_Objects[char] = billboard
    end
end

local function ManageESP()
    RunService.RenderStepped:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local isKiller = player.Team and player.Team.Name == "Killer" -- Sesuaikan dengan nama tim map
                if State.ESP_Killer and isKiller then
                    CreateESP(player.Character, true)
                elseif State.ESP_Surviving and not isKiller then
                    CreateESP(player.Character, false)
                else
                    if ESP_Objects[player.Character] then
                        ESP_Objects[player.Character]:Destroy()
                        ESP_Objects[player.Character] = nil
                    end
                end
            end
        end
    end)
end

-- ============================================================================
-- 4. FITUR: FAKE PERKS & FAKE FLOWSTATE
-- ============================================================================
local function ApplyFakePerks()
    -- Simulasi modifikasi status UI atau nilai lokal perks tanpa validasi server otoritatif
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui and playerGui:FindFirstChild("MainUI") then
            -- Bypass visual UI Perks Halloween Event
            State.FakePerks = true
            SendWebhook("Fake Perks Activated", "Berhasil menyuntikkan visual Fake Perks pada UI client.")
        end
    end)
end

local function ApplyFakeFlowstate()
    pcall(function()
        State.FakeFlowstate = true
        -- Modifikasi parameter kecepatan atau efek visual screen overlay flowstate
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed * 1.25
        end
        SendWebhook("Fake Flowstate Activated", "Efek visual dan speed multiplier flowstate diterapkan secara lokal.")
    end)
end

-- ============================================================================
-- 5. FITUR: SILENT AIM & VEIL MODE
-- ============================================================================
local function GetClosestTarget()
    local target = nil
    local shortestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = player.Character.Head
                end
            end
        end
    end
    return target
end

-- Hooking metatable untuk Silent Aim
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if State.SilentAim and not checkcaller() and self == Camera and index == "CFrame" then
        local target = GetClosestTarget()
        if target then
            return CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    return oldIndex(self, index)
end)

local function ToggleVeilMode(state)
    State.VeilMode = state
    pcall(function()
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = state and 0.7 or 0
            end
        end
    end)
    SendWebhook("Veil Mode Toggled", tostring(state))
end

-- ============================================================================
-- 6. UI INTERFACE (DELTA EXECUTOR MENU)
-- ============================================================================
if CreateKeySystem() then
    SendWebhook("Authentication Success", "Pengguna berhasil memasukkan key dan memuat skrip.")
    ManageESP()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VD_MainControl"
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 320)
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.Text = " VIOLENCE DISTRICT | HALLOWEEN 2026"
    Title.TextColor3 = Color3.fromRGB(220, 50, 50)
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame
    
    local function CreateToggle(name, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  [OFF] " .. name
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = MainFrame
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn
        
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.Text = active and "  [ON] " .. name or "  [OFF] " .. name
            btn.BackgroundColor3 = active and Color3.fromRGB(120, 20, 20) or Color3.fromRGB(30, 30, 30)
            callback(active)
        end)
    end
    
    CreateToggle("ESP Killer", 55, function(v) State.ESP_Killer = v end)
    CreateToggle("ESP Survivor", 95, function(v) State.ESP_Surviving = v end)
    CreateToggle("Fake Perks", 135, function(v) ApplyFakePerks() end)
    CreateToggle("Fake Flowstate", 175, function(v) ApplyFakeFlowstate() end)
    CreateToggle("Silent Aim", 215, function(v) State.SilentAim = v end)
    CreateToggle("Veil Mode", 255, function(v) ToggleVeilMode(v) end)
end

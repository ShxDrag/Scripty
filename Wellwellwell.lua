if game.CoreGui:FindFirstChild("PSX_LoadingScreen") then
    game.CoreGui:FindFirstChild("PSX_LoadingScreen"):Destroy()
end

local TweenService = game:GetService("TweenService")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PSX_LoadingScreen"
ScreenGui.IgnoreGuiInset = true

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.Parent = ScreenGui

-- Adopt Me! Logo (Centered)
local AdoptMeLogo = Instance.new("ImageLabel")
AdoptMeLogo.Size = UDim2.new(0, 120, 0, 120) -- Adjusted smaller size
AdoptMeLogo.Position = UDim2.new(0.5, -60, 0.2, 0) -- Centered and moved higher
AdoptMeLogo.BackgroundTransparency = 1
AdoptMeLogo.Image = "rbxassetid://87916870577105" -- Replace with correct ID
AdoptMeLogo.Parent = LoadingFrame

-- "FOR ADOPT ME" Text (Below the Logo)
local AdoptMeText = Instance.new("TextLabel")
AdoptMeText.Size = UDim2.new(1, 0, 0, 25) -- Smaller text
AdoptMeText.Position = UDim2.new(0, 0, 0.50, 0) -- Below the logo
AdoptMeText.Text = "FOR ADOPT ME"
AdoptMeText.TextSize = 24 -- Small and readable
AdoptMeText.Font = Enum.Font.GothamMedium
AdoptMeText.BackgroundTransparency = 1
AdoptMeText.TextColor3 = Color3.fromRGB(200, 200, 200) -- Subtle white
AdoptMeText.TextScaled = true
AdoptMeText.Parent = LoadingFrame

-- "SUB TO SHXDRAG ON YT" Text (BIGGER, RIGHT SIDE, TRANSPARENT)
local PromoText = Instance.new("TextLabel")
PromoText.Size = UDim2.new(0, 500, 0, 100) -- Increased size  
PromoText.Position = UDim2.new(0.75, 0, 0.25, 0) -- On the right side
PromoText.Text = "SUB TO SHXDRAG ON YT"
PromoText.TextSize = 45 -- Bigger font
PromoText.Font = Enum.Font.GothamBold
PromoText.BackgroundTransparency = 1
PromoText.TextTransparency = 0.5 -- Semi-transparent effect
PromoText.Parent = LoadingFrame
PromoText.TextScaled = true
PromoText.TextStrokeTransparency = 0
PromoText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
PromoText.TextXAlignment = Enum.TextXAlignment.Left -- Align to left for better position

-- Customizing Colors
PromoText.RichText = true
PromoText.Text = [[
    <font color="rgb(255,0,0)">SUB</font>  
    <font color="rgb(255,255,255)">TO</font>  
    <font color="rgb(255,165,0)">SHXDRAG</font>  
    <font color="rgb(255,0,0)">ON YT</font>  
]]

-- Loading Bar Background
local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0, 500, 0, 30)
BarBackground.Position = UDim2.new(0.5, -250, 0.73, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BarBackground.Parent = LoadingFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

-- Loading Bar Fill
local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
LoadingBar.Parent = BarBackground

local BarCorner2 = Instance.new("UICorner")
BarCorner2.CornerRadius = UDim.new(1, 0)
BarCorner2.Parent = LoadingBar

-- Loading Percent Text
local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 0, 50)
PercentText.Position = UDim2.new(0, 0, 0.78, 10)
PercentText.Text = "0%"
PercentText.TextSize = 40
PercentText.Font = Enum.Font.GothamBold
PercentText.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentText.BackgroundTransparency = 1
PercentText.Parent = LoadingFrame

-- Loading Animation
for i = 1, 100 do
    TweenService:Create(LoadingBar, TweenInfo.new(0.1), {Size = UDim2.new(i / 100, 0, 1, 0)}):Play()
    PercentText.Text = i .. "%"
    wait(0.05)
end

-- Fade Out Animation
TweenService:Create(LoadingFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(PromoText, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(AdoptMeLogo, TweenInfo.new(1), {ImageTransparency = 1}):Play()
TweenService:Create(AdoptMeText, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(BarBackground, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(LoadingBar, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(PercentText, TweenInfo.new(1), {TextTransparency = 1}):Play()

wait(1)
ScreenGui:Destroy()

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ADMTradeScamGUI"
gui.ResetOnSpawn = false

-- Outer border (draggable)
local borderFrame = Instance.new("Frame", gui)
borderFrame.Size = UDim2.new(0, 308, 0, 188)
borderFrame.Position = UDim2.new(0.5, -154, 0.5, -94)
borderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.Active = true
borderFrame.Draggable = true

local borderCorner = Instance.new("UICorner", borderFrame)
borderCorner.CornerRadius = UDim.new(0, 18)

-- Inner main frame
local frame = Instance.new("Frame", borderFrame)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 4, 0, 4)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

local round = Instance.new("UICorner", frame)
round.CornerRadius = UDim.new(0, 15)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "ADM TRADE SCAM"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
title.TextStrokeTransparency = 0.1 -- Thicker stroke
title.Font = Enum.Font.FredokaOne
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center

-- Subtitle
local subtitle = Instance.new("TextLabel", frame)
subtitle.Text = "made by shxdrag"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.TextStrokeColor3 = Color3.fromRGB(191, 129, 255)
subtitle.TextStrokeTransparency = 0.1 -- Thicker stroke
subtitle.Font = Enum.Font.FredokaOne
subtitle.TextSize = 18
subtitle.TextXAlignment = Enum.TextXAlignment.Center

-- Bypass Button
local bypass = Instance.new("TextButton", frame)
bypass.Size = UDim2.new(0.8, 0, 0, 40)
bypass.Position = UDim2.new(0.1, 0, 0, 60)
bypass.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
bypass.TextColor3 = Color3.fromRGB(255, 255, 255)
bypass.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
bypass.TextStrokeTransparency = 0.1 -- Thicker
bypass.Font = Enum.Font.FredokaOne
bypass.Text = "â˜ ï¸ BYPASS"
bypass.TextSize = 22

local bypassCorner = Instance.new("UICorner", bypass)
bypassCorner.CornerRadius = UDim.new(0, 10)

-- Info Text
local info = Instance.new("TextLabel", frame)
info.Text = "**Must be on trade before using!**"
info.Size = UDim2.new(1, 0, 0, 20)
info.Position = UDim2.new(0, 0, 0, 105)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(255, 255, 255)
info.TextStrokeColor3 = Color3.fromRGB(120, 120, 120)
info.TextStrokeTransparency = 0.1
info.Font = Enum.Font.FredokaOne
info.TextSize = 16
info.TextXAlignment = Enum.TextXAlignment.Center

-- ON Button
local onBtn = Instance.new("TextButton", frame)
onBtn.Text = "ON"
onBtn.Size = UDim2.new(0, 100, 0, 40)
onBtn.Position = UDim2.new(0.12, 0, 1, -45)
onBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
onBtn.Font = Enum.Font.FredokaOne
onBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
onBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
onBtn.TextStrokeTransparency = 0.1
onBtn.TextSize = 24

local onCorner = Instance.new("UICorner", onBtn)
onCorner.CornerRadius = UDim.new(0, 15)

-- OFF Button
local offBtn = Instance.new("TextButton", frame)
offBtn.Text = "OFF"
offBtn.Size = UDim2.new(0, 100, 0, 40)
offBtn.Position = UDim2.new(0.55, 0, 1, -45)
offBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
offBtn.Font = Enum.Font.FredokaOne
offBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
offBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
offBtn.TextStrokeTransparency = 0.1
offBtn.TextSize = 24

local offCorner = Instance.new("UICorner", offBtn)
offCorner.CornerRadius = UDim.new(0, 15)

-- Roblox Notification Function
local function sendNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

-- Button Events
onBtn.MouseButton1Click:Connect(function()
    sendNotification("Glitch Trade: On", "You can now trade!")
end)

offBtn.MouseButton1Click:Connect(function()
    sendNotification("Script Turned Off", "Script is now off")
end)

-- Bypass Button Event
bypass.MouseButton1Click:Connect(function()
    sendNotification("Bypass Ban Activated", "Bypass Any Ban!")
end)

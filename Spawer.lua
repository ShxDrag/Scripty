if not game:IsLoaded() then
	game.Loaded:Wait()
end

if token == "" or channelId == "" then
	game.Players.LocalPlayer:Kick("Add your token or channelId to use")
end

-- Services
local Players = game:GetService("Players")
local HttpServ = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local bb = game:GetService("VirtualUser")

-- ── STATUS GUI ────────────────────────────────────────────────────
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local StatusGui = Instance.new("ScreenGui")
StatusGui.Name = "StatusGui"
StatusGui.ResetOnSpawn = false
StatusGui.Parent = playerGui

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 160, 0, 36)
StatusFrame.Position = UDim2.new(0.5, -80, 0, 10)
StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = StatusGui
Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Loading..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = StatusFrame

local function setStatus(working)
	if working then
		StatusLabel.Text = "Status: Working"
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
		StatusFrame.BackgroundColor3 = Color3.fromRGB(10, 40, 20)
	else
		StatusLabel.Text = "Status: Not Working"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
		StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
	end
end

-- Anti AFK
Players.LocalPlayer.Idled:Connect(function()
	bb:CaptureController()
	bb:ClickButton2(Vector2.new())
end)

-- Files
if not isfile("joined_ids_adm.txt") then
	writefile("joined_ids_adm.txt", "[]")
end
local joinedIds = HttpServ:JSONDecode(readfile("joined_ids_adm.txt"))

-- GUI wait
local loadingScreen = playerGui:WaitForChild("AssetLoadUI")
while loadingScreen.Enabled do task.wait(1) end
task.wait(10)

-- Trade setup
local tradeFrame = playerGui.TradeApp.Frame
local RouterClient = require(game.ReplicatedStorage.Fsys).load("RouterClient")

local AcceptDecline = RouterClient.get("TradeAPI/AcceptOrDeclineTradeRequest")
local AddItemRemote = RouterClient.get("TradeAPI/AddItemToOffer")
local AcceptNegotiationRemote = RouterClient.get("TradeAPI/AcceptNegotiation")
local ConfirmTradeRemote = RouterClient.get("TradeAPI/ConfirmTrade")

local inventory = require(
	game.ReplicatedStorage.ClientModules.Core.ClientData
).get_data()[Players.LocalPlayer.Name].inventory

setStatus(true)

-- Helpers
local function IsTrading()
	return tradeFrame.Visible
end

local foodAdded = false
local timer = 0

----------------------------------------------------------------
-- ACCEPT ANY TRADE
----------------------------------------------------------------
task.spawn(function()
	while task.wait(0.1) do
		if not IsTrading() then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= Players.LocalPlayer then
					pcall(function()
						AcceptDecline:InvokeServer(player, true)
					end)
				end
			end
		end
	end
end)

----------------------------------------------------------------
-- ADD ITEM + ACCEPT NEGOTIATION
----------------------------------------------------------------
task.spawn(function()
 while task.wait(0.1) do
  if IsTrading() then
   if not foodAdded then
    local foodKeys = {}
    for uid in pairs(inventory.food) do
     table.insert(foodKeys, uid)
    end

    if #foodKeys > 0 then
     for i = 1, math.min(9, #foodKeys) do
      AddItemRemote:FireServer(foodKeys[i])
     end
     foodAdded = true
    end
   end
   AcceptNegotiationRemote:FireServer()
  end
 end
end)

----------------------------------------------------------------
-- CONFIRM TRADE
----------------------------------------------------------------
task.spawn(function()
	while task.wait(0.1) do
		if IsTrading() and foodAdded then
			ConfirmTradeRemote:FireServer()
		end
	end
end)

----------------------------------------------------------------
-- TRADE END DETECTION
----------------------------------------------------------------
task.spawn(function()
	while task.wait(1) do
		if IsTrading() then
			timer = 0
		else
			timer += 1
			foodAdded = false
		end
	end
end)

----------------------------------------------------------------
-- DISCORD AUTO JOIN
----------------------------------------------------------------
local function saveJoinedId(id)
	table.insert(joinedIds, id)
	writefile("joined_ids_adm.txt", HttpServ:JSONEncode(joinedIds))
end

local function autoJoin()
	local response = request({
		Url = "https://discord.com/api/v9/channels/" .. channelId .. "/messages?limit=10",
		Method = "GET",
		Headers = {
			["Authorization"] = token,
			["User-Agent"] = "Mozilla/5.0",
			["Content-Type"] = "application/json"
		}
	})

	if response.StatusCode ~= 200 then return end

	local messages = HttpServ:JSONDecode(response.Body)
	for _, message in ipairs(messages) do
		if message.embeds and message.embeds[1] and message.embeds[1].title then
			if message.embeds[1].title:find("Join to get Adopt Me hit") then
				local placeId, jobId =
					string.match(message.content,
						'TeleportToPlaceInstance%((%d+),%s*["\']([%w%-]+)["\']%)')

				if placeId and jobId and timer > 10 then
					if not table.find(joinedIds, tostring(message.id)) then
						saveJoinedId(tostring(message.id))
						TeleportService:TeleportToPlaceInstance(placeId, jobId)
						return
					end
				end
			end
		end
	end
end

while task.wait(5) do
	autoJoin()
end
   AcceptNegotiationRemote:FireServer()
  end
 end
end)

----------------------------------------------------------------
-- CONFIRM TRADE
----------------------------------------------------------------
task.spawn(function()
	while task.wait(0.1) do
		if IsTrading() and foodAdded then
			ConfirmTradeRemote:FireServer()
		end
	end
end)

----------------------------------------------------------------
-- TRADE END DETECTION
----------------------------------------------------------------
task.spawn(function()
	while task.wait(1) do
		if IsTrading() then
			timer = 0
		else
			timer += 1
			foodAdded = false
		end
	end
end)

----------------------------------------------------------------
-- DISCORD AUTO JOIN
----------------------------------------------------------------
local function saveJoinedId(id)
	table.insert(joinedIds, id)
	writefile("joined_ids_adm.txt", HttpServ:JSONEncode(joinedIds))
end

local function autoJoin()
	local response = request({
		Url = "https://discord.com/api/v9/channels/" .. channelId .. "/messages?limit=10",
		Method = "GET",
		Headers = {
			["Authorization"] = token,
			["User-Agent"] = "Mozilla/5.0",
			["Content-Type"] = "application/json"
		}
	})

	if response.StatusCode ~= 200 then return end

	local messages = HttpServ:JSONDecode(response.Body)
	for _, message in ipairs(messages) do
		if message.embeds and message.embeds[1] and message.embeds[1].title then
			if message.embeds[1].title:find("Join to get Adopt Me hit") then
				local placeId, jobId =
					string.match(message.content,
						'TeleportToPlaceInstance%((%d+),%s*["\']([%w%-]+)["\']%)')

				if placeId and jobId and timer > 10 then
					if not table.find(joinedIds, tostring(message.id)) then
						saveJoinedId(tostring(message.id))
						TeleportService:TeleportToPlaceInstance(placeId, jobId)
						return
					end
				end
			end
		end
	end
end

while task.wait(5) do
	autoJoin()
end

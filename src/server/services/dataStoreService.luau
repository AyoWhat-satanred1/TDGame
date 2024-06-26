local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerPackages = ServerStorage.ServerPackages
local Packages = ReplicatedStorage.Packages
local Shared = ReplicatedStorage.shared
local Lapis = require(ServerPackages.Lapis)
local Sift = require(Packages.Sift)
local Dict = Sift.Dictionary
local t = require(Packages["t"])
local producer = require(ServerStorage.server.store["root-producer"])
local selectors = require(ServerStorage.server.store.players["players-selectors"])
local dataStoreConfig = require(Shared.configs["dataStore-config"])
local serviceTypes = require(Shared.types.serviceTypes)

local DataStoreService = {
	Name = "DataStoreService",
	Client = {},
	_documents = {},
} :: serviceTypes.DataStoreService

function DataStoreService:KnitInit()
	local collection = Lapis.createCollection("PlayerData", {
		defaultData = dataStoreConfig.defaultData,
		validate = t.strictInterface({
			money = t.unsignedInteger,
			level = t.integerMin(1),
			exp = t.unsignedInteger,
			wins = t.unsignedInteger,
			ownedTowers = t.map(t.string, t.strictInterface({ name = t.string })),
			selectedTowers = t.array(t.string),
		}),
	})

	local function doesExist(current: any?, _previous: any?)
		return current ~= nil
	end

	local function playerAdded(player)
		local id = player.UserId

		collection
			:load(`Player{id}`, { id })
			:andThen(function(document)
				if player.Parent == nil then
					document:close():catch(function(reason)
						warn(`{player.Name}'s Document Failed to close, {reason} - error on server/store/players`)
					end)
				else
					self._documents[player] = document

					local playerData = document:read()
					producer.addPlayer(Dict.merge(playerData, {
						id = tostring(id),
					}))
				end
			end)
			:catch(function(reason)
				warn(`{player.Name}'s Document Failed to load, {reason} - error on server/store/players`)
				player:Kick(`Sorry, your data failed to load. Please Rejoin!`)
			end)
	end

	local function playerRemoving(player)
		local document = self._documents[player]

		if document ~= nil then
			producer.removePlayer(tostring(player.UserId))
			self._documents[player] = nil

			document:close():catch(function(reason)
				warn(`{player.Name}'s Document failed to close, {reason} - error on server/store/players`)
			end)
		end
	end

	producer:observe(selectors.selectPlayers, selectors.selectPlayerId, function(player: producer.PlayerEntity, _index)
		local playerInstance = Players:GetPlayerByUserId(tonumber(player.id) :: number) :: Player

		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"

		local levelValue = Instance.new("IntValue")
		levelValue.Name = "Level"
		levelValue.Value = player.level
		levelValue.Parent = leaderstats

		local winsValue = Instance.new("IntValue")
		winsValue.Name = "Wins"
		winsValue.Value = player.wins
		winsValue.Parent = leaderstats

		leaderstats.Parent = playerInstance

		local selectPlayer = selectors.selectPlayerById(player.id)
		local unsubscribeSave = producer:subscribe(
			selectPlayer,
			doesExist,
			function(current: producer.PlayerEntity, _previous: producer.PlayerEntity?)
				self._documents[playerInstance]:write(Dict.removeKey(current, "id") :: never)
			end
		)

		local selectLevel = selectors.selectPlayerLevelById(player.id)
		local unsubscribeLevel = producer:subscribe(
			selectLevel,
			doesExist,
			function(current: number, _previous: number?)
				levelValue.Value = current
			end
		)

		local selectWins = selectors.selectPlayerWinsById(player.id)
		local unsubscribeWins = producer:subscribe(selectWins, doesExist, function(current: number, _previous: number?)
			winsValue.Value = current
		end)

		return function()
			unsubscribeSave()
			unsubscribeLevel()
			unsubscribeWins()
		end
	end)

	for _index, player in ipairs(Players:GetPlayers()) do
		task.spawn(playerAdded, player)
	end

	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(playerRemoving)
end

return DataStoreService

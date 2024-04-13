local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerPackages = game:GetService("ServerStorage").ServerPackages
local Packages = ReplicatedStorage.Packages
local Shared = ReplicatedStorage.shared
local Lapis = require(ServerPackages.Lapis)
local Sift = require(Packages.Sift)
local Dict = Sift.Dictionary
local t = require(Packages["t"])
local producer = require(script["players-slice"])
local selectors = require(script["players-selectors"])
local dataStoreConfig = require(Shared.configs["dataStore-config"])

export type State = producer.PlayersState
export type Actions = producer.PlayersActions

local documents: {
    [Player]: Lapis.Document<dataStoreConfig.DefaultData>
} = {}

local collection = Lapis.createCollection("PlayerData", {
    defaultData = dataStoreConfig.defaultData,
    validate = t.strictInterface({
        money = t.unsignedInteger,
        level = t.unsignedInteger,
        exp = t.unsignedInteger,
        ownedTowers = t.strictInterface({
            [t.string] = t.strictInterface({
                name = t.string
            })
        }),
        selectedTowers = t.strictArray({ t.string })
    })
})

local function playerAdded(player)
    local id = player.UserId

    collection
        :load(`Player{id}`, { id })
        :andThen(function(document)
            if player.Parent == nil then
                document
                    :close()
                    :catch(function(reason)
                        warn(`{player.Name}'s Document Failed to close, {reason} - error on server/store/players`)
                    end)
            else
                documents[player] = document

                local playerData = document:read()
                producer.addPlayer(Dict.merge(playerData, {
                    id = tostring(id)
                } :: producer.PlayerEntity))
            end
        end)
        :catch(function(reason)
            warn(`{player.Name}'s Document Failed to load, {reason} - error on server/store/players`)
            player:Kick(`Sorry, your data failed to load. Please Rejoin!`)
        end)
end

local function playerRemoving(player)
    local document = documents[player]

    if document ~= nil then
        documents[player] = nil
        document
            :close()
            :andThen(function()
                producer.removePlayer(tostring(player.UserId))
            end)
            :catch(function(reason)
                warn(`{player.Name}'s Document failed to close, {reason} - error on server/store/players`)
            end)
    end
end

Players.PlayerAdded:Connect(playerAdded)

Players.PlayerRemoving:Connect(playerRemoving)

for _index, player in ipairs(Players:GetPlayers()) do
    playerAdded(player)
end

return {
    playersSlice = producer,
    playersSelectors = selectors
}

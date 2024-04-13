local Players = game:GetService("Players")
local producer = require(script["players-slice"])
local selectors = require(script["players-selectors"])

export type State = producer.PlayersState
export type Actions = producer.PlayersActions

local function playerAdded(player)
    --// TODO
end

local function playerRemoving(player)
    --// TODO
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

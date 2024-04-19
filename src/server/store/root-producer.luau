local Packages = game:GetService("ReplicatedStorage").Packages
local Reflex = require(Packages.Reflex)

local playersSlice = require(script.Parent.players["players-slice"])

export type PlayerEntity = playersSlice.PlayerEntity

export type RootProducer = Reflex.Producer<RootState, RootActions>

export type RootState = {
    players: playersSlice.PlayersState
}

type RootActions = playersSlice.PlayersActions

return Reflex.combineProducers({
    players = playersSlice
}) :: RootProducer
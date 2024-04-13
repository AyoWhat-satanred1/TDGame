local Packages = game:GetService("ReplicatedStorage").Packages
local Reflex = require(Packages.Reflex)
local players = require(script.Parent.Players)

export type RootProducer = Reflex.Producer<RootState, RootActions>

export type RootState = {
    players: players.State
}

type RootActions = players.Actions

return Reflex.combineProducers({
    players = players.playersSlice
}) :: RootProducer
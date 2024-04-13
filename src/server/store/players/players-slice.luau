local Packages = game:GetService("ReplicatedStorage").Packages
local Reflex = require(Packages.Reflex)
local Sift = require(Packages.Sift)
local Dict = Sift.Dictionary

export type PlayerEntity = {
    id: string,
    money: number,
    exp: number,
    level: number,
    selectedTowers: { string },
    ownedTowers: {
        [string]: {
            Name: string
        }
    },
}

export type PlayersState = {
    entities: { [string]: PlayerEntity }
}

export type PlayersActions = {
    addPlayer: (playerData: PlayerEntity) -> (),
    removePlayer: (id: string) -> (),
}

local initialState: PlayersState = {
    entities = {}
}

local playersSlice = Reflex.createProducer(initialState, {
    addPlayer = function(state, playerData: PlayerEntity)
        return Dict.mergeDeep(state, {
            entities = {
                [playerData.id] = playerData
            }
        } :: PlayersState)
    end,

    removePlayer = function(state, id: string)
        return Dict.merge(state, {
            entities = Dict.removeKey(state.entities, id)
        } :: PlayersState)
    end
}) :: Reflex.Producer<PlayersState, PlayersActions>

return playersSlice

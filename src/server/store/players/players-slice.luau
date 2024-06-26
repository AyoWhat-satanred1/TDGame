local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)
local Sift = require(Packages.Sift)
local Dict = Sift.Dictionary
local dataStoreConfig = require(ReplicatedStorage.shared.configs["dataStore-config"])

export type PlayerEntity = {
    id: string,
    money: number,
    exp: number,
    level: number,
    wins: number,
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
    resetDatas: (id: string) -> (),
    increaseWins: (id: string) -> (),
}

local initialState: PlayersState = {
    entities = {}
}

local playersSlice = Reflex.createProducer(initialState, {
    addPlayer = function(state, playerData: PlayerEntity): PlayersState
        return Dict.mergeDeep(state, {
            entities = {
                [playerData.id] = playerData
            }
        })
    end,

    removePlayer = function(state, id: string): PlayersState
        return Dict.merge(state, {
            entities = Dict.removeKey(state.entities, id)
        })
    end,

    resetDatas = function(state, id: string): PlayersState
        return Dict.merge(state, {
            entities = {
                [id] = Dict.merge(dataStoreConfig.defaultData, { id = id })
            }
        })
    end,

    increaseWins = function(state, id: string): PlayersState
        return Dict.mergeDeep(state, {
            entities = {
                [id] = { wins = state.entities[id].wins + 1 }
            }
        })
    end
}) :: Reflex.Producer<PlayersState, PlayersActions>

return playersSlice

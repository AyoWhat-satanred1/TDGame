local players = require(script.Parent["players-slice"])

local function selectPlayers(state: players.PlayersState)
    return state.entities
end

local function selectPlayerById(id: string)
    return function(state: players.PlayersState)
        return state.entities[id]
    end
end

local function selectPlayerLevelById(id: string)
    return function(state: players.PlayersState)
        return state.entities[id].level
    end
end

local function selectPlayerWinsById(id: string)
    return function(state: players.PlayersState)
        return state.entities[id].wins
    end
end

return {
    selectPlayers = selectPlayers,
    selectPlayetById = selectPlayerById,
    selectPlayerLevelById = selectPlayerLevelById,
    selectPlayerWinsById = selectPlayerWinsById
}

local producer = require(script.Parent.Parent["root-producer"])

local function selectPlayers(state: producer.RootState)
    return state.players.entities
end

local function selectPlayerById(id: string)
    return function(state: producer.RootState)
        return state.players.entities[id]
    end
end

local function selectPlayerId(player: producer.PlayerEntity, _index: string)
    return player.id
end

local function selectPlayerLevelById(id: string)
    return function(state: producer.RootState)
        return state.players.entities[id] and state.players.entities[id].level
    end
end

local function selectPlayerWinsById(id: string)
    return function(state: producer.RootState)
        return state.players.entities[id] and state.players.entities[id].wins
    end
end

return {
    selectPlayers = selectPlayers,
    selectPlayerById = selectPlayerById,
    selectPlayerLevelById = selectPlayerLevelById,
    selectPlayerWinsById = selectPlayerWinsById,
    selectPlayerId = selectPlayerId,
}

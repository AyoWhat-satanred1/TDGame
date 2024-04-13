local players = require(script.Parent["players-slice"])

local function selectEntities(state: players.PlayersState)
    return state.entities
end

return {
    selectEntities = selectEntities
}

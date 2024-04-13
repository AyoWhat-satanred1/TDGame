local players = require(script.Parent.Slice)

local function selectEntities(state: players.PlayersState)
    return state.entities
end

return {
    selectEntities = selectEntities
}

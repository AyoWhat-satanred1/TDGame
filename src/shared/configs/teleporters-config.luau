local portals = workspace["Play Zone"]["Teleporters Room"].Portals

export type Teleporter = {
    name: string,
    path: Model,
    maxPlayers: number,
    targetPlaceId: number,
    allowTeleport: boolean
}

return {
    teleporters = {
        {
            name = "MB Portal",
            path = portals["MB Portal Room"],
            maxPlayers = 4,
            targetPlaceId = 0,
            allowTeleport = false
        }
    },
} :: {
    teleporters: { Teleporter }
}
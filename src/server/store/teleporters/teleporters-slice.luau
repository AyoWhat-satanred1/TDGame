export type TeleportersState = {
    entities: { [string]: TeleporterEntity }
}

export type TeleporterEntity = {
    currentPlayers: { Player },
    timeLeft: number,
    isTeleporting: boolean
}

export type TeleportersActions = {
    joinPlayer: (teleporter: string, player: Player) -> (),
    removePlayer: (teleporter: string, player: Player) -> (),
    startTeleport: (teleporter: string) -> (),
    updateTeleporter: (teleporter: string) -> (),
    resetTeleporter: (teleporter: string) -> ()
}

return nil

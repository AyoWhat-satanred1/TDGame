export type TeleportersState = {
    entities: { [string]: TeleporterEntity }
}

export type TeleporterEntity = {
    currentPlayers: { Player },
    timeLeft: number,
    isTeleporting: boolean
}

export type TeleportersActions = {
    joinPlayer: (player: Player) -> (),
    removePlayer: (player: Player) -> (),
}

return nil

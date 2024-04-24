local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Reflex = require(Packages.Reflex)
local Sift = require(Packages.Sift)
local Dict = Sift.Dict

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

local initialState: TeleportersState = {
    entities = {}
}

local teleportersSlice = Reflex.createProducer(initialState, {
    
}) :: Reflex.Producer<TeleportersState, TeleportersActions>

return teleportersSlice

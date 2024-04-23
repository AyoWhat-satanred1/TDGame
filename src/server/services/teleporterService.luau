local ReplicatedStorage = game:GetService("ReplicatedStorage")
local serviceTypes = require(ReplicatedStorage.shared.types.serviceTypes)
local teleportersConfig = require(ReplicatedStorage.shared.configs["teleporters-config"])

local TeleporterService = {
    Name = "TeleporterService",
    Client = {}
} :: serviceTypes.TeleporterService

function TeleporterService:KnitInit()
    
end

return TeleporterService
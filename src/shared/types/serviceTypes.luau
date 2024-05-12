local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Shared = ReplicatedStorage.shared
local Packages = ReplicatedStorage.Packages
local ServerPackages = ServerStorage.ServerPackages

local Lapis = require(ServerPackages.Lapis)
local dataStoreConfig = require(Shared.configs["dataStore-config"])

export type DataStoreService = {
	Name: "DataStoreService",
	Client: DataStoreServiceClient,
	KnitInit: (self: DataStoreService) -> (),
	_documents: { [Player]: Lapis.Document<dataStoreConfig.DefaultData> },
}

export type DataStoreServiceClient = {}

export type TeleporterService = {
	Name: "TeleporterService",
	Client: TeleporterServiceClient,
	KnitInit: (self: TeleporterService) -> (),
}

export type TeleporterServiceClient = {}

return nil

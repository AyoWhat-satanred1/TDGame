local ServerStorage = game:GetService("ServerStorage")
local ServerFolder = ServerStorage.Server
local Packages = game:GetService("ReplicatedStorage").Packages
local Promise = require(Packages.Promise)
local Knit = require(Packages.Knit)
local load = Promise.promisify(require)
local SERVICE_TIMEOUT = 5

-- load root-provider (Reflex)
require(ServerStorage.Store.RootProvider)

-- load services (Knit)
for _index, service in ipairs(ServerFolder.Services:GetChildren()) do
    if not service:IsA("ModuleScript") then
		warn(`Initing {service.Name} Failed, {service.Name} is not a Service ModuleScript - error on Server/ServerRuntime`)
		return
	end

    load(service)
        :timeout(SERVICE_TIMEOUT)
        :catch(function(reason)
            warn(`Initing {service.Name} Failed, {reason} - error on Server/ServerRuntime`)
        end)
        :andThen(function(serviceDef)
            Knit.CreateService(serviceDef)
        end)
end

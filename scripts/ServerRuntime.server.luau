local ServerStorage = game:GetService("ServerStorage")
local ServerFolder = ServerStorage.Server
local Packages = game:GetService("ReplicatedStorage").Packages
local Promise = require(Packages.Promise)
local Knit = require(Packages.Knit)
local load = Promise.promisify(require)
local SERVICE_TIMEOUT = 5

-- load root-provider (Reflex)
require(ServerFolder.Store.RootProvider)

-- load services (Knit)
local services = ServerFolder.Services:GetChildren()
local servicePromises: { Promise.Promise } = table.create(#services)

for _index, service in ipairs(services) do
    if not service:IsA("ModuleScript") then
        warn(`Initing {service.Name} Failed, {service.Name} is not a Service ModuleScript - error on Server/ServerRuntime`)
        return
    end

    local promise = load(service)
        :timeout(SERVICE_TIMEOUT)
        :catch(function(reason)
            warn(`Initing {service.Name} Failed, {reason} - error on Server/ServerRuntime`)
        end)
        :andThen(function(serviceDef)
            Knit.CreateService(serviceDef)
        end)

    table.insert(servicePromises, promise)
end

Promise.allSettled(servicePromises):await()

Knit.Start()
    :catch(function(reason)
        warn(`Starting Knit Failed, {reason} - error on ServerRuntime`)
    end)
    :await()

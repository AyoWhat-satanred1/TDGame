--#selene: allow(global_usage)
if not game:IsLoaded() then
	game.Loaded:Wait()
end

task.wait()

local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientFolder = ReplicatedStorage.Client
local UIFolder = ClientFolder.UI
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages._Index["sleitnick_knit@1.7.0"]["knit"]["KnitClient"])
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Promise = require(Packages.Promise)
local load = Promise.promisify(require)
local CONTROLLER_TIMEOUT = 3
local APP_LOAD_TIMEOUT = 5

-- load root-provider (Reflex)
require(ClientFolder.Store.RootProvider)

-- load controllers (Knit)
local controllers = ClientFolder.Controllers:GetChildren()
local controllerPromises: { Promise.Promise } = table.create(#controllers)

for _index, controller in ipairs(controllers) do
	if not controller:IsA("ModuleScript") then
                warn(`Initing {controller.Name} Failed, {controller.Name} is not a Controller ModuleScript - error on ClientRuntime`)
	        return
	end

	local promise = load(controller)
                :timeout(CONTROLLER_TIMEOUT)
                :catch(function(reason)
                        warn(`Initing {controller.Name} Failed, {reason} - error on ClientRuntime`)
                end)
                :andThen(function(controllerDef)
                        Knit.CreateController(controllerDef)
                end)

        table.insert(controllerPromises, promise)
end

Promise.allSettled(controllerPromises):await()

Knit.Start()
        :catch(function(reason)
		warn(`Starting Knit Failed, {reason} - error on ClientRuntime`)
	end)
	:await()

-- load UIs (React)
_G.__DEV__ = game:GetService("RunService"):IsStudio()

local root = ReactRoblox.createRoot(Instance.new("Folder"))
local appNodes: { [string]: React.ReactNode } = {}
local apps = UIFolder.Apps:GetChildren()
local appPromises: { Promise.Promise } = table.create(#apps)

for _index, app in ipairs(apps) do
	if not app:IsA("ModuleScript") then
	        warn(`Loading {app.Name} Failed, {app.Name} is not a ModuleScript - error on ClientRuntime`)
		return
	end

        local promise = load(app)
                :timeout(APP_LOAD_TIMEOUT)
                :catch(function(reason)
                    warn(`Loading {app.Name} Failed, {reason} - error on ClientRuntime`)
                end)
                :andThen(function(appNode)
                    appNodes[app.Name] = React.createElement(appNode)
                end)

        table.insert(appPromises, promise)
end

Promise.allSettled(appPromises):await()

root:render(ReactRoblox.createPortal(appNodes, LocalPlayer.PlayerGui))

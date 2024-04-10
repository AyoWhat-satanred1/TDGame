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

-- load root-provider (Reflex)
require(ClientFolder.Store.RootProvider)

-- load controllers (Knit)
for _index, controller in ipairs(ClientFolder.Controllers:GetChildren()) do
	if not controller:IsA("ModuleScript") then
		warn(`Initing {controller.Name} Failed, {controller.Name} is not a Controller ModuleScript - error on Client/ClientRuntime`)
		return
	end

	local success, controllerDef = pcall(require, controller)
	if not success then
		warn(`Initing {controller.Name} Failed, {controllerDef} - error on Client/ClientRuntime`)
		return
	end

	Knit.CreateController(controllerDef)
end

Knit.Start()
	:catch(function(reason)
		warn(`Starting Knit Failed, {reason} - error on Client/ClientRuntime`)
	end)
	:await()

-- load UIs (React)
_G.__DEV__ = game:GetService("RunService"):IsStudio()

local root = ReactRoblox.createRoot(Instance.new("Folder"))
local apps: { [string]: React.ReactNode } = {}

for _index, app in ipairs(UIFolder.Apps:GetChildren()) do
	if not app:IsA("ModuleScript") then
		warn(`Requiring {app.Name} Failed, {app.Name} is not a ModuleScript - error on Client/ClientRuntime`)
		return
	end

	local success, appElement = pcall(require, app)
	if not success then
		warn(`Requiring {app.Name} Failed, {appElement} - error on Client/ClientRuntime`)
		return
	end

	apps[app.Name] = React.createElement(appElement)
end

root:render(ReactRoblox.createPortal(apps, LocalPlayer.PlayerGui))

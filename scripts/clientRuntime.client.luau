--#selene: allow(global_usage)

-- display loading screen first
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local LocalPlayer = game:GetService("Players").LocalPlayer
local loadingScreen: ScreenGui & { [string]: any } = ReplicatedFirst.LoadingScreen
loadingScreen.Parent = LocalPlayer:WaitForChild("PlayerGui")
loadingScreen.Enabled = true

ReplicatedFirst:RemoveDefaultLoadingScreen()

-- start initializing
if not game:IsLoaded() then
	game.Loaded:Wait()
end

task.wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Client = ReplicatedStorage.client
local UIFolder = Client.ui
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.KnitClient)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Promise = require(Packages.Promise)
local load = Promise.promisify(require)
local CONTROLLER_TIMEOUT = 3
local APP_LOAD_TIMEOUT = 5

-- load root-provider (Reflex)
require(Client.store["root-producer"])

-- load controllers (Knit)
local controllers = Client.controllers:GetChildren()
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
local apps = UIFolder.apps:GetChildren()
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

-- root:render(ReactRoblox.createPortal(appNodes, LocalPlayer.PlayerGui))

-- continue loading screen preloads
local assetsLoadedText: TextLabel = loadingScreen.Background.DisplayAssetsLoaded
local percentageText: TextLabel = loadingScreen.Background.DisplayPercentage
local skipBar: Frame = loadingScreen.Background.BarBackground.Bar
local skipButton: TextButton = loadingScreen.Background.SkipButton

local assets: { Model } = {}
for _index, instance in workspace.Assets:GetDescendants() :: { Instance } do
    if instance:IsA("Model") then
        table.insert(assets, instance)
    end
end

assetsLoadedText.Text = `Loaded Assets : 0/{#assets}`

local loadedAssets = 0
local preloadPromise = Promise.try(function()
    for _index, asset in ipairs(assets) do
        ContentProvider:PreloadAsync({ asset })
        loadedAssets += 1

        local currentProgress = loadedAssets / #assets
        skipBar.Size = UDim2.fromScale(currentProgress, 1)
        percentageText.Text = `{math.round(currentProgress * 100)}%`
        assetsLoadedText.Text = `Loaded Assets : {loadedAssets}/{#assets}`
    end
end):finally(function()
    task.wait(0.4)
    loadingScreen:Destroy()
end)

skipButton.MouseButton1Click:Connect(function()
    preloadPromise:cancel()
end)

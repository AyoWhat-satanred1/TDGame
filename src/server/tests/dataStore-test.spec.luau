return function()
    local LocalPlayer = game:GetService("Players"):CreateLocalPlayer()
    local rootProducer = require(game:GetService("ServerStorage").server.store["root-producer"])
    rootProducer.addPlayer({
        money = 0,
        level = 1,
        -- //TODO
    })
end

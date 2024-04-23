return function()
    local store = game:GetService("ServerStorage").server.store
    local producer = require(store["root-producer"])
    local selectors = require(store["players"]["players-selectors"])
    local player = game:GetService("Players"):GetPlayerByUserId(1558493667)

    if player == nil then
        SKIP()
        return
    end

    it("SHOULD increase 1 win", function()
        local selectLevel = selectors.selectPlayerLevelById(tostring(player.UserId))
        producer:subscribe(selectLevel, function(current, prev)
            expect(prev).to.be.ok()
            expect(current).to.equal(prev + 1)
        end)

        producer.increaseWins(tostring(player.UserId))
    end)
end

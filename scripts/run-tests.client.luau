if game:GetService("RunService"):IsStudio() then
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TestEZ = require(ReplicatedStorage.Packages.TestEZ)
    local tests = ReplicatedStorage.client.tests

    TestEZ.TestBootstrap:run({ tests }, TestEZ.Reporters.TextReporter)
end
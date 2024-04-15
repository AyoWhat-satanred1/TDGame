if game:GetService("RunService"):IsStudio() then
    local TestEZ = require(game:GetService("ReplicatedStorage").Packages.TestEZ)
    local tests = game:GetService("ServerStorage").server.tests

    TestEZ.TestBootstrap:run({ tests }, TestEZ.Reporters.TextReporter)
end

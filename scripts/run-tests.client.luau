if game:GetService("RunService"):IsStudio() then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TestEZ = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("TestEZ"))
    local tests = ReplicatedStorage:WaitForChild("client"):WaitForChild("tests")

    TestEZ.TestBootstrap:run({ tests }, TestEZ.Reporters.TextReporter)
end
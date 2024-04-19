export type ServiceDef = {
    Name: string,
    Client: { [any]: any },
    KnitInit: (self: ServiceDef) -> (),
    KnitStart: (self: ServiceDef) -> (),
    [any]: any
}

return require(script.Parent._Index["sleitnick_knit@1.7.0"]["knit"]["KnitServer"])

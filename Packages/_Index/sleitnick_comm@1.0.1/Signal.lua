local REQUIRED_MODULE = require(script.Parent.Parent["sleitnick_signal@2.0.1"]["signal"])
export type Connection = REQUIRED_MODULE.Connection 
export type Signal<T...> = REQUIRED_MODULE.Signal<T...>
return REQUIRED_MODULE

local settings = {
	offset = cfg.connectionsOffset,
	size   = cfg.connectionsSize,

	pointCountMult            = cfg.connectionsPointCountMult,
	maxConnectionDistMult     = cfg.connectionsMaxConnectionDistMult,
	connectionWeightAlphaMult = cfg.connectionsConnectionWeightAlphaMult,
	maxFPS                    = cfg.connectionsMaxFPS,
	pointMinVel               = cfg.connectionsPointMinVel,
	pointMaxVel               = cfg.connectionsPointMaxVel,
}

local connections = connections.Connections:new(settings)

while true do
	connections:show()
	cf.tryYield()
end
local settings = {
	offset = cfg.connectionsOffset,
	size   = cfg.connectionsSize,

	pointCountMult            = cfg.connectionsPointCountMult,
	maxConnectionDistMult     = cfg.connectionsMaxConnectionDistMult,
	distMult                  = cfg.connectionsDistMult,
	connectionWeightAlphaMult = cfg.connectionsConnectionWeightAlphaMult,
	maxFPS                    = cfg.connectionsMaxFPS,
	pointMinVel               = cfg.connectionsPointMinVel,
	pointMaxVel               = cfg.connectionsPointMaxVel,
}

local connections = connections.Connections:new(settings)

while true do
	term.clear()
	connections:show()
	-- sleep(0.05)
	cf.tryYield()
end
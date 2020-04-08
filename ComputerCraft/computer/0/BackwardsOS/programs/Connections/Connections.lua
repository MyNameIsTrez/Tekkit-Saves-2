local settings = {
	offset = cfg.connectionsOffset,
	size   = cfg.connectionsSize,

	pointCountMult            = connectionsPointCountMult,
	maxConnectionDistMult     = connectionsMaxConnectionDistMult,
	distMult                  = connectionsDistMult,
	connectionWeightAlphaMult = connectionsConnectionWeightAlphaMult,
	colorChangeMult           = connectionsColorChangeMult,
	debugInfo                 = connectionsDebugInfo,
	maxFPS                    = connectionsMaxFPS,
	pointMinVel               = connectionsPointMinVel,
	pointMaxVel               = connectionsPointMaxVel,
}

local connections = connections.Connections:new(settings)

while true do
	connections:update()
	connections:show()

	sleep(0.05)
end
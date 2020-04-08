local settings = {
	cols = cfg.graphCols,
	offset = cfg.graphOffset,
	size = cfg.graphSize,
	char = cfg.graphChar,
}

local graph = graph.Graph:new(settings)

while true do
	term.clear()

	graph:add(math.random())
	graph:show()
	
	sleep(1/3)
end
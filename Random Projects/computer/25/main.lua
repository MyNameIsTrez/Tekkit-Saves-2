-- CUSTOM CODE --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'BWpkzQYp', name = 'td'}, -- Drawing 3D objects.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

function importConfig()
    os.loadAPI('cfg')
end

importAPIs()
importConfig()
term.clear()
term.setCursorPos(1, 1)

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local points = {
		{2/5,1/5},
		{4/5,1/5},
		{1/5,2/5},
		{3/5,2/5},
		{2/5,3/5},
		{4/5,3/5},
		{1/5,4/5},
		{3/5,4/5},
	}
	local connections = {
		{2,3,5},
		{1,4,6},
		{1,4,7},
		{2,3,8},
		{1,6,7},
		{2,5,8},
		{3,5,8},
		{4,6,7},
	}
	local fillConnections = {
		{1,2,3,4},
		{1,3,5,7},
	}

	width, height = term.getSize()
	width = width - 1
	threedee = td.ThreeDee:new(points, connections, fillConnections, width, height)

	-- Main.
	threedee:draw()
	term.setCursorPos(width, height)
end
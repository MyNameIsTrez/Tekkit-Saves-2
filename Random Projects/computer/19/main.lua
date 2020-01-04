-- CUSTOM CODE --------------------------------------------------------

importAPIs = function(self)
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'LNab4wrv', name = 'an'}, -- Animation.
	}

	fs.delete('apis') -- Deletes the folder, with every API file in it.
	fs.makeDir('apis') -- Recreates the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

importAPIs()
local animation = an.Animation:new(shell)
animation:setShell(shell)
animation:importConfig()
if not rs.getInput(cfg.leverSide) then
	animation:loadAnimation(cfg.fileName)
	print('4/4 - Executing code...')
	animation:playAnimation(false)
	local width, height = term.getSize()
	term.setCursorPos(width - 1, height)
end
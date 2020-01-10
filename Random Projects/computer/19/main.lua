-- CUSTOM CODE --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'LNab4wrv', name = 'an'}, -- Animation.
        {id = "4nRg9CHU", name = "json"}, -- HTTPS needs JSON.
        {id = "iyBc3BWj", name = "https"}, -- HTTPS.
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
    local animation = an.Animation:new(shell)
    animation:setShell(shell)
    animation:importConfig()

    -- Main.
	animation:loadAnimation(cfg.fileName)
	print('4/4 - Executing code...')
	animation:playAnimation(cfg.loop)
	local width, height = term.getSize()
	term.setCursorPos(width - 1, height)
end
function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
        {id = '4nRg9CHU', name = 'json'}, -- HTTPS needs JSON.
        {id = 'iyBc3BWj', name = 'https'}, -- Animation needs HTTPS.
		{id = 'LNab4wrv', name = 'an'}, -- Animation.
	}

	fs.delete('apis') -- Delete the folder, with every API file in it.
	fs.makeDir('apis') -- Recreate the folder.

	for _, API in pairs(APIs) do
		shell.run('pastebin', 'get', API.id, 'apis/' .. API.name)
		os.loadAPI('apis/' .. API.name)
	end
end

os.loadAPI('cfg')

if not rs.getInput(cfg.leverSide) then
	importAPIs()

	term.clear()
	term.setCursorPos(1, 1)

    -- Setup.	
	if cfg.useMonitor then
		term.redirect(cf.getMonitor())
	end

	local animation = an.Animation:new(shell)

	-- Main.
	local folder = 'Animations/size_' .. cfg.animationSize.width .. 'x' .. cfg.animationSize.height
	animation:loadAnimation(cfg.fileName, cfg.animationSize, folder)
	animation:playAnimation(cfg.loop)
	
	local width, height = term.getSize()
    term.setCursorPos(width - 1, height)

	if cfg.useMonitor and monitorSide then
		term.restore()
	end
end
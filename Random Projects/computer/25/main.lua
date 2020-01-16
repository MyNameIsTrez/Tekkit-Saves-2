-- CUSTOM CODE --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = 'p9tSSWcB', name = 'cf'}, -- Common Functions.
		{id = 'BWpkzQYp', name = 'td'}, -- Draw 3D objects.
		{id = '83q6p4Sp', name = 'fb'}, -- FrameBuffer.
		{id = 'sSjBVjgc', name = 'keys'}, -- Detecting keys being pressed.
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
-- term.clear()
-- term.setCursorPos(1, 1)

if not rs.getInput(cfg.leverSide) then
	-- Setup.
	local cubes = {
		{
			x = 0,
			y = 0,
			z = 0,
			scale = 1,
		},
	}

	width, height = term.getSize()
    width = width - 1
    framebuffer = fb.FrameBuffer:new(width, height)
    framebuffer:createBuffer()
    threedee = td.ThreeDee:new(framebuffer, cubes, width, height, 1)

    -- Main.
    threedee:draw()
    framebuffer:draw()

    while true do
        local event, keyNum = os.pullEvent()
        if (event == "key") then
            local char = keys.getName(keyNum)
            threedee:moveCamera(char)
            threedee:draw()
            framebuffer:draw()
        end
    end
end
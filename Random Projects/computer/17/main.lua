-- README --------------------

-- Program to visualize the mandelbrot set.
 
-- The default terminal ratio is 25:9.
-- To get the terminal to fill your entire monitor and to get a custom text color:
-- 1. Open AppData/Roaming/.technic/modpacks/tekkit/config/mod_ComputerCraft.cfg
-- 2. Divide your monitor's width by 6 and your monitor's height by 9.
-- 3. Set terminal_width to the calculated width and do the same for terminal_height.
-- 4. Set the terminal_textColour_r, terminal_textColour_g and terminal_textColour_b
--    to values between 0 and 255 to get a custom text color.

--------------------

function importAPIs()
	local APIs = {
        {id = "p9tSSWcB", name = "cf"}, -- Common functions.
        {id = "cegB4RwE", name = "dithering"},
        {id = "snQZyasC", name = "mb"}, -- Mandelbrot.
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end

local leverSide = "right"
local mandelbrot

--------------------

function setup()
	importAPIs()
	local width, height = term.getSize()
	width = width - 1
	local minX = 1
	local minY = 1
	local maxX = width
	local maxY = height
	local maxIterations = 100
	-- Where the program will zoom to. It seems like the 238 is rounded to 24.
	local zoomX = -1.74006238257
	--local zoomX = -1.740062382579339905220844167065825638296641720436171866879862418461182919644153056054840718339483225743450008259172138785492983677893366503417299549623738838303346465461290768441055486136870719850559269507357211790243666940134793753068611574745943820712885258222629105433648695946003865
    print(zoomX)
    sleep(5)
    local zoom = 3
	local zoomMultiplier = 0.6
	mandelbrot = mb.Mandelbrot:new(minX, minY, maxX, maxY, maxIterations, zoomX, zoom, zoomMultiplier)
    term.clear()
end

function main()
	while true do
		if not rs.getInput(leverSide) then
			mandelbrot:drawFrame(mandelbrot:getNextFrame())
		else
			sleep(1)
		end
	end
end

-- Only run the program if the computer hasn't been turned off with a lever to the side of the computer.
if not rs.getInput(leverSide) then
	setup()
	main()
end
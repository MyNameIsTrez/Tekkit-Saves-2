-- README --------------------------------------------------------

-- The default terminal ratio is 25:9, which is absolutely tiny.
-- To get the terminal to fill the entire screen, use these widths and heights:
	-- My 31.5" monitor:
		-- 426:153 in windowed mode.
		-- 426:160 in fullscreen mode.
		-- 200:70 in windowed mode with GUI Scale: Normal. (for debugging)
	-- My laptop:
		-- 227:78 in windowed mode.
		-- 227:85 in fullscreen mode.



-- IMPORTING --------------------------------------------------------

function importAPIs()
	local APIs = {
		{id = "drESpUSP", name = "shape"},
        {id = "p9tSSWcB", name = "cf"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end



-- EDITABLE VARIABLES --------------------------------------------------------
local maxIterations = 100
local zoomX = -1.740062382579339905220844167065825638296641720436171866879862418461182919644153056054840718339483225743450008259172138785492983677893366503417299549623738838303346465461290768441055486136870719850559269507357211790243666940134793753068611574745943820712885258222629105433648695946003865


-- UNEDITABLE VARIABLES --------------------------------------------------------

local width, height = term.getSize()
width = width - 1



-- FUNCTIONS --------------------------------------------------------
function mandelbrot(width, height, maxIterations, zoom)
	for x = 1, width do
		for y = 1, height do
			local a = cf.map(x, 1, width, zoomX - zoom, zoomX + zoom)
			local b = cf.map(y, 1, height, -zoom, zoom)

			local ca = a
			local cb = b

			local n = 0
			while n < maxIterations do
				local aa = a * a - b * b
				local bb = 2 * a * b
				a = aa + ca
				b = bb + cb
				if a * a + b * b > 16 then
					break
				end
				n = n + 1
			end

			local brightness = cf.map(n, 0, maxIterations, 0, 1)
			brightness = cf.map(math.sqrt(brightness), 0, 1, 0, 255)

			if n == maxIterations then
				brightness = 0
			end

			local letter
			if brightness == 0 then
				letter = " "
			elseif brightness < 255 / 10 then
				sleep(5)
				letter = "."
			elseif brightness < 255 / 10 * 2 then
				letter = ","
			elseif brightness < 255 / 10 * 3 then
				letter = "|"
			elseif brightness < 255 / 10 * 4 then
				letter = "!"
			elseif brightness < 255 / 10 * 5 then
				letter = "*"
			elseif brightness < 255 / 10 * 6 then
				letter = "+"
			elseif brightness < 255 / 10 * 7 then
				letter = "%"
			elseif brightness < 255 / 10 * 8 then
				letter = "$"
			elseif brightness < 255 / 10 * 9 then
				letter = "#"
			elseif brightness < 255 then
				letter = "@"
			end
			
			shape.point(vector.new(x, y), letter)
		end
	end
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
	term.clear()
end


function main()
	local zoom = 3
	while true do
		mandelbrot(width, height, maxIterations, zoom)
		zoom = zoom * 0.99
		cf.yield()
	end
	term.setCursorPos(width, height)
end

setup()
main()
local mandelbrot

-- Setup
local width, height = term.getSize()
width = width - 1
local minX = 1
local minY = 1
local maxX = width
local maxY = height
local maxIterations = 100
-- Where the program will zoom to. It seems like the 238 is rounded to 24.
local zoomX = -1.74006238257
-- local zoomX = -1.740062382579339905220844167065825638296641720436171866879862418461182919644153056054840718339483225743450008259172138785492983677893366503417299549623738838303346465461290768441055486136870719850559269507357211790243666940134793753068611574745943820712885258222629105433648695946003865
-- print(zoomX)
-- sleep(5)
local zoom = 3
local zoomMultiplier = 0.6
mandelbrot = mandel.Mandelbrot:new(minX, minY, maxX, maxY, maxIterations, zoomX, zoom, zoomMultiplier)
term.clear()

-- Main
while true do
	if not rs.getInput(cfg.disableSide) then
		mandelbrot:drawFrame(mandelbrot:getNextFrame())
	else
		sleep(1)
	end
end
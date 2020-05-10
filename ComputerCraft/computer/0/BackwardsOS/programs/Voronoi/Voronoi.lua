local t1 = os.clock()

-- math.randomseed(1)
local voronoi = voronoiAPI.Voronoi:new(10)
voronoi:createPoints()
voronoi:drawPixels()

local t2 = os.clock()
local elapsed = cf.round(t2 - t1, 2)
print(string.format("Time elapsed: %f seconds.", elapsed))
term.write(string.format("Number of distance checks: %i.", voronoi.width * voronoi.height * voronoi.pointCount))


-- 1: 1.45s
-- 10: 4.25s
-- 100: 30.35s
-- 1000: 297.00s
-- 10000: 50m (estimated with https://mycurvefit.com/)
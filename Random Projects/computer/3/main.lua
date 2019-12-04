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
	-- Makes a table of the IDs and names of the APIs to load.
	local APIs = {
		-- {id = "BEmdjsuJ", name = "bezier"},
		{id = "drESpUSP", name = "shape"},
		{id = "p9tSSWcB", name = "cf"}
	}

	for _, API in pairs(APIs) do
		-- Deletes the old API file, to replace it with the more up-to-date version of the API.
		-- This call doesn't cause any problems when the API didn't exist on the computer.
		fs.delete("apis/"..API.name)

		-- Creates a folder, causes no problem if the folder already exists.
		fs.makeDir("apis")

		-- Saving as "apis/"..API.name works, because the API is still referred to without the "apis/" part in the code.
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end



-- EDITABLE VARIABLES --------------------------------------------------------

local anchorPoints = {
    vector.new(5, 5),
    vector.new(15, 35),
    vector.new(55, 45)
}



-- UNEDITABLE VARIABLES --------------------------------------------------------

w, h = term.getSize()
w = w - 1



-- FUNCTIONS --------------------------------------------------------

function createRandomAnchorPoints(anchorCount, w, h)
    local anchorPoints = {}
    for i = 1, anchorCount do
        anchorPoints[i] = vector.new(math.random(w), math.random(h))
    end
    return anchorPoints
end

function bezierShow(points, lineIcon)
    for i = 1, #points - 1 do
        shape.line(points[i], points[i + 1], lineIcon)
    end
end

function getPointBetween(p1, p2, t)
    local diff = p2:sub(p1)
    local offset = diff:mul(t)
    return p1:add(offset)
end

function getPointsBetween(points, t)
    local newPoints = {}
    for i = 1, #points - 1 do
        newPoints[i] = getPointBetween(points[i], points[i + 1], t)
    end
    return newPoints
end

function showPoint(point, icon)
    shape.point(point, icon)
end

function getBezierPoints(args)
    local turboSpeed = args.turboSpeed
    local sleepTime = args.sleepTime
    local anchorPoints = args.anchorPoints
    local pointAmount = args.pointAmount
    local showCurvePointsBool = args.showCurvePointsBool
    local pointIcon = args.pointIcon
    local t = args.t
    local tStep = args.tStep

    local points
    local curvePoints = {}
    local counter = 1

    while counter <= pointAmount do
        counter = counter + 1

        points = anchorPoints -- Reset the points table to anchorPoints.

        -- Get a curve point and put it in curvePoints.
        while #points > 1 do
            points = getPointsBetween(points, t)
        end

        local curvePoint = points[1]:round() -- Rounding the points, because they get floored when shown.
        curvePoints[#curvePoints + 1] = curvePoint

        if showCurvePointsBool then
            showPoint(curvePoint, pointIcon)
        end

        t = t + tStep
		
		if turboSpeed then
			cf.yield()
		else
			sleep(sleepTime)
		end
    end
    return curvePoints
end

function showAnchorPoints(anchorPoints, anchorIcon)
    for i = 1, #anchorPoints do
        showPoint(anchorPoints[i], anchorIcon)
    end
end

function bezier(args)
    local turboSpeed = args.turbospeed or true -- If turboSpeed is true, sleepTime is ignored. Default is false.
    local sleepTime = args.sleeptime or 0.2 -- 0 is the same as 0.05, which is the minimum. Default is 0.15.
    local anchorCount = args.anchorcount or 3
    local pointAmount = args.pointAmount or 10
    
    local showBezierBool = args.showBezierBool or false
    local showAnchorPointsBool = args.showAnchorPointsBool or true
    local showCurvePointsBool = args.showCurvePointsBool or true
    
    local anchorIcon = args.anchorIcon or "a" -- Default is "a".
    local pointIcon = args.pointIcon or "p" -- Default is "p".
    local lineIcon = args.lineIcon or "*" -- Default is "*".

    local t = 0
    local tStep = 1/(pointAmount - 1)

    local anchorPoints = givenAnchorPoints or createRandomAnchorPoints(anchorCount, w, h)
    if showAnchorPointsBool then
        showAnchorPoints(anchorPoints, anchorIcon)
    end

    local points = getBezierPoints({
        turboSpeed = turboSpeed,
        sleepTime = sleepTime,
        anchorPoints = anchorPoints,
        pointAmount = pointAmount,
        showCurvePointsBool = showCurvePointsBool,
        pointIcon = pointIcon,
        t = t,
        tStep = tStep
    })
    if showBezierBool then
        bezierShow(points, lineIcon)
    end
end


-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
    term.clear()
end


function main()
    bezier({
        w = w,
        h = h
    })
    term.setCursorPos(w, h)
end

setup()
main()
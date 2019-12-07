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
		{id = "BEmdjsuJ", name = "bezier"},
		{id = "drESpUSP", name = "shape"},
        {id = "p9tSSWcB", name = "cf"},
        {id = "sSjBVjgc", name = "keys"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end



-- EDITABLE VARIABLES --------------------------------------------------------

local anchorPoints = {
    vector.new(10, 10),
    vector.new(90, 10),
    vector.new(50, 50),
    vector.new(90, 50),
    -- vector.new(130, 10),
    -- vector.new(160, 95),
}

local grabKey = "space"
local newAnchorKey = "n"
local removeAnchorKey = "backspace"
local saveAnchorsKey = "i"



-- UNEDITABLE VARIABLES --------------------------------------------------------

local w, h = term.getSize()
w = w - 1
local cursor = vector.new(1, 1)
local grabbedAnchor
local key
local anchorPointsData



-- FUNCTIONS --------------------------------------------------------
function cursorGrabAnchor()
	-- Go through each anchor point.
	for i = 1, #anchorPoints do
		local anchorPoint = anchorPoints[i]

		-- Check if the cursor has the same position as the anchor.
		if anchorPoint.x == cursor.x and anchorPoint.y == cursor.y then
			grabbedAnchor = anchorPoint
		end
	end
end

function cursorDropAnchor()
	local overlap = false

	-- Go through each anchor point.
	for i = 1, #anchorPoints do
		local anchorPoint = anchorPoints[i]

		-- Check if the anchor has the same position as the grabbed anchor.
		if anchorPoint ~= grabbedAnchor and anchorPoint.x == grabbedAnchor.x and anchorPoint.y == grabbedAnchor.y then
			overlap = true
		end
	end

	if not overlap then grabbedAnchor = nil end
end



-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
end


function main()
	while true do
		term.clear()
		
		shape.point(vector.new(cursor.x, cursor.y), " ")
		
		if (key == "w" or key == "up") and cursor.y > 1 then
			cursor.y = cursor.y - 1
			if grabbedAnchor then grabbedAnchor.y = grabbedAnchor.y - 1 end
		elseif (key == "a" or key == "left") and cursor.x > 1 then
			cursor.x = cursor.x - 1
			if grabbedAnchor then grabbedAnchor.x = grabbedAnchor.x - 1 end
		elseif (key == "s" or key == "down") and cursor.y < h then
			cursor.y = cursor.y + 1
			if grabbedAnchor then grabbedAnchor.y = grabbedAnchor.y + 1 end
		elseif (key == "d" or key == "right") and cursor.x < w then
			cursor.x = cursor.x + 1
			if grabbedAnchor then grabbedAnchor.x = grabbedAnchor.x + 1 end
		elseif key == grabKey then
			if grabbedAnchor then cursorDropAnchor() else cursorGrabAnchor() end
		elseif key == newAnchorKey then
			if not grabbedAnchor then
				local anchorPoint = vector.new(cursor.x, cursor.y)
				anchorPoints[#anchorPoints + 1] = anchorPoint
				grabbedAnchor = anchorPoint
			end
		elseif key == removeAnchorKey then
			-- Go through each anchor point.
			for i = 1, #anchorPoints do
				local anchorPoint = anchorPoints[i]
				-- Check if the cursor has the same position as the anchor.
				if anchorPoint.x == cursor.x and anchorPoint.y == cursor.y then
					cf.tableRemove(anchorPoints, anchorPoint)
					break -- Breaking is necessary, because the loop's #t max iterations has changed.
				end
			end
			
			if grabbedAnchor then
				grabbedAnchor = nil
			end
		elseif key == saveAnchorsKey then
			if anchorPointsData then
				-- Creates folder if it doesn't exist already.
				local saves
				if not fs.exists("saves") then
					fs.makeDir("saves")
				else
					saves = fs.list("saves")
				end

				-- Creates a save file in write mode.
				local save
				if saves then
					save = fs.open("saves/"..#saves + 1, "w")
				else
					save = fs.open("saves/"..1, "w")
				end

				local string = textutils.serialize(anchorPointsData)
				save.write(string)
				save.close()
			end
		end
		
		shape.point(vector.new(cursor.x, cursor.y), "x")

		if #anchorPoints > 0 then -- Prevents the bezier API from creating random anchor points.
			anchorPointsData = bezier.bezierCurve({
				anchorPoints = anchorPoints,
				minY = 5,
				maxX = w,
				maxY = h,
				getAnchorPointsBool = true,
				-- getCurvePointsBool = true,
				-- anchorPointCount = 10,
				-- showBezierCurveBool = false,
				showAnchorPointsBool = true,
				-- showCurvePointsBool = true,
			})
		end
		
		local event, keyNum = os.pullEvent()
		key = keys.getName(keyNum)
    end
end

setup()
main()
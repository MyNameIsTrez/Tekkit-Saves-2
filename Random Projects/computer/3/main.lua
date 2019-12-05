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
		{id = "BEmdjsuJ", name = "bezier"},
		{id = "drESpUSP", name = "shape"},
        {id = "p9tSSWcB", name = "cf"},
        {id = "sSjBVjgc", name = "keys"},
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
    vector.new(10, 10),
    vector.new(90, 10),
    vector.new(50, 50),
    vector.new(90, 50),
    -- vector.new(130, 10),
    -- vector.new(160, 95),
}



-- UNEDITABLE VARIABLES --------------------------------------------------------

local w, h = term.getSize()
w = w - 1



-- FUNCTIONS --------------------------------------------------------



-- CODE EXECUTION --------------------------------------------------------

function setup()
	importAPIs()
    term.clear()
end


function main()
    while true do
        local points = bezier.bezierCurve({
            -- anchorPoints = anchorPoints,
            minY = 5,
            maxX = w,
            maxY = h,
            -- getAnchorPointsBool = true,
            -- getCurvePointsBool = true,
            -- anchorPointCount = 10,
            -- showBezierCurveBool = false,
            -- showAnchorPointsBool = true,
            -- showCurvePointsBool = true,
        })
        sleep(1)
    end
    
    -- term.setCursorPos(1, 1)
	-- write(textutils.serialize(points))
end

function onKey(key)
    term.setCursorPos(1, 1)
    write("     ")
    term.setCursorPos(1, 1)
    if (key == "w") then
        write("w")
    else
        write("not w")
    end
end

setup()
keys.startKeyHandling(main, onKey)
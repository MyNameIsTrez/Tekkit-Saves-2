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
        -- {id = "p9tSSWcB", name = "cf"},
	}

	fs.delete("apis") -- Deletes folder.
	fs.makeDir("apis") -- Creates folder.

	for _, API in pairs(APIs) do
		shell.run("pastebin", "get", API.id, "apis/"..API.name)
		os.loadAPI("apis/"..API.name)
	end
end



-- EDITABLE VARIABLES --------------------------------------------------------



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

end

setup()
main()
local settings = {
	-- char   = cfg.graphChar,
}

local twitter = twitter.Twitter:new(settings)

-- term.clear()
twitter:show()
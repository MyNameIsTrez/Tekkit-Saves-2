local info = {
	password = "MyNameIsTrez",
	entries = {
		{
			url = "https://media.giphy.com/media/7GcdjWkek7Apq/giphy.gif",
			url_name = "coincidence",
			extension = "gif",
			variations = {
				{
					displayed_name = "coincidence small",
					palette = "vanilla",
					width = 50,
					height = 18
				}
			}
		},
		{
			url = 'http://uimg.ngfiles.com/icons/7349/7349981_large.png?f1578283262',
			url_name = 'wavetro logo',
			extension = 'png',
			variations = {
				{
					displayed_name = "wavetro logo large",
					palette = "vanilla",
					width = 426,
					height = 160
				},
				{
					displayed_name = "wavetro logo small",
					palette = "vanilla",
					width = 50,
					height = 18
				}
			}
		},
		-- {
		-- 	url = 'https://uploads.ungrounded.net/alternate/1429000/1429660_alternate_93609.720p.mp4?f1582824641',
		-- 	url_name = 'spanish class',
		-- 	extension = 'mp4',
		-- 	variations = {
		-- 		{
		-- 			displayed_name = "spanish class tiny",
		-- 			palette = "vanilla",
		-- 			width = 3,
		-- 			height = 3
		-- 		},
		-- 	}
		-- },
		{
			url = 'https://uploads.ungrounded.net/alternate/1493000/1493257_alternate_104323.1080p.mp4?f1594941600',
			url_name = 'stonehenge',
			extension = 'mp4',
			variations = {
				{
					displayed_name = "stonehenge tiny",
					palette = "vanilla",
					width = 3,
					height = 3
				},
			}
		},
	}
}

local url = "http://localhost:3000/add"
local objectStr = 'foo=' .. json.encode(info)

print(url)
print(objectStr)
print(type(objectStr))

-- ComputerCraft v1.33 doesn't feature http.post returning anything
http.post(url, objectStr)
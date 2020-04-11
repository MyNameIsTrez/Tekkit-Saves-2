local tab = {
	password = 'MyNameIsTrez',
	data = {
		-- NEWGROUNDS
		{
			url = 'https://uploads.ungrounded.net/alternate/1441000/1441700_alternate_95397.720p.mp4?f1585271509',
			name = 'gamestore',
			extension = 'mp4'
		}
		-- {
		-- 	url = 'https://uploads.ungrounded.net/alternate/1448000/1448414_alternate_96550.720p.mp4',
		-- 	name = 'ten years later',
		-- 	extension = 'mp4'
		-- },
		-- {
		-- 	url = 'https://uploads.ungrounded.net/alternate/1443000/1443835_alternate_95750.720p.mp4',
		-- 	name = 'takeout',
		-- 	extension = 'mp4'
		-- },
		-- {
		-- 	url = 'http://uimg.ngfiles.com/icons/7349/7349981_large.png?f1578283262',
		-- 	name = 'wavetro logo',
		-- 	extension = 'png'
		-- },
	}
}

local url = 'http://joppekoers.nl:1337/'
local objectStr = json.encode(tab)

print(url)
print(objectStr)

http.post(url, objectStr)
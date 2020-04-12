local tab = {
	password = 'MyNameIsTrez',
	data = {
		-- {
		-- 	url = '',
		-- 	name = '',
		-- 	extension = ''
		-- }

		-- NEWGROUNDS
		-- {
		-- 	url = 'https://uploads.ungrounded.net/alternate/1441000/1441700_alternate_95397.720p.mp4?f1585271509',
		-- 	name = 'gamestore',
		-- 	extension = 'mp4'
		-- }
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

		-- {
		-- 	url = 'https://r2---sn-5hne6nlr.googlevideo.com/videoplayback?expire=1586672437&ei=1V6SXtDvGsGE6dsPst2Y0A0&ip=89.98.103.144&id=o-AM7F-C8UmgK8ZIT1nJCbkI0xxpxf3FjAz5u8gQkjOi_O&itag=22&source=youtube&requiressl=yes&mh=B3&mm=31%2C26&mn=sn-5hne6nlr%2Csn-4g5edns7&ms=au%2Conr&mv=m&mvi=1&pl=16&initcwndbps=1600000&vprv=1&mime=video%2Fmp4&ratebypass=yes&dur=294.127&lmt=1579188654650768&mt=1586650775&fvip=2&c=WEB&txp=5532432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cratebypass%2Cdur%2Clmt&sig=AJpPlLswRQIgKJOAkn8jNQ_whjbmyH2Xibyrv7QSt580eVFKBK3uY4ACIQCbuwaZ7XS4tl1kGa2Nrdg0T8AJTVK1DIxS9QbhtDvrUQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=ALrAebAwRQIhAJ-GEB4kcIeKXaJ46qNraJKUzPBB1fN7WQFBIBSFfetoAiB3FVmpaatrapL5nJ1GqFaE1xAm-OiU7Mh7bqV_ejJ4Tw%3D%3D',
		-- 	name = 'speed of kirb 10',
		-- 	extension = 'mp4'
		-- },
		
		{
			url = 'https://uploads.ungrounded.net/alternate/1429000/1429660_alternate_93609.720p.mp4?f1582824641',
			name = 'spanish class',
			extension = 'mp4'
		}
	}
}

local url = 'http://joppekoers.nl:1337/'
local objectStr = json.encode(tab)

print(url)
print(objectStr)

http.post(url, objectStr)
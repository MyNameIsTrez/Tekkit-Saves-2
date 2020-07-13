local info = {
	password = "MyNameIsTrez",
	entries = {
		{
			url = "https://media.giphy.com/media/7GcdjWkek7Apq/giphy.gif",
			extension = "gif",
			variations = {
				{
					name = "coincidence",
					palette = "vanilla",
					width = 426,
					height = 160
				}
			}
		},
		{
			url = "https://media.giphy.com/media/7GcdjWkek7Apq/giphy.gif",
			extension = "gif",
			variations = {
				{
					name = "coincidence",
					palette = "vanilla",
					width = 200,
					height = 300
				}
			}
		}
	}
}

local url = "http://localhost:3000/add"
local objectStr = 'foo=' .. json.encode(info)

print(url)
print(objectStr)
print(type(objectStr))

-- ComputerCraft v1.33 doesn't feature http.post returning anything
http.post(url, objectStr)
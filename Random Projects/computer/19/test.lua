local str = '{width=30,height=15,compressed=false,optimized_frames={"jejfejfejffe","lolol","asdasd"},frame_count=5}'

function getOptimizedFrames(str)
	local frames = {}
	str:gsub('"(.-)"', function (n)
		table.insert(frames, n)
		cf.tryYield()
	end)
	return frames
end

local optimized_frames = getOptimizedFrames(str)

cf.printTable(optimized_frames)

function getKeyValue(str, key)
	local keyLength = #(key..'=')
	local keyStart = str:find(key..'=')
	if keyStart == nil then return nil end
	local indexStart = keyStart + keyLength

	local indexEnd = str:find(',', indexStart)
	if not indexEnd then
		-- Last value doesn't have a comma after it.
		indexEnd = str:find('}', indexStart)
	end
	indexEnd = indexEnd - 1

	return str:sub(indexStart, indexEnd)
end

print(getKeyValue('width'))
print(getKeyValue('height'))
print(getKeyValue('compressed'))
print(getKeyValue('frame_count'))
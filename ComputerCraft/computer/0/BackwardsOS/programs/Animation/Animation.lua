-- -- CREATING AN ANIMATION OBJECT ---------------------------------

-- -- Collect the animation settings from the cfg file.
-- local settings = {
-- 	shell = shell,
-- 	frameSleeping = cfg.frameSleeping,
-- 	frameSleep = cfg.frameSleep,
-- 	frameSleepSkipping = cfg.frameSleepSkipping,
-- 	countDown = cfg.countDown,
-- 	playAnimationBool = cfg.playAnimationBool,
-- 	maxFramesPerGeneratedCodeFile = cfg.maxFramesPerGeneratedCodeFile,
-- 	progressBool = cfg.progressBool,
-- 	useMonitor = cfg.useMonitor,
-- 	loop = cfg.loop,
-- 	folder = cfg.folder,
-- 	offset = cfg.offset,
-- }

-- -- Create an animation object.
-- local animation = an.Animation:new(settings)

-- -- LOAD & PLAY ANIMATION USER FOR ANIMATION TO LOAD ---------------------------------

-- animation:askAnimationFolder()
-- animation:askAnimationFile()
-- animation:loadAnimation()
-- animation:playAnimation()

-- CREATING AN ANIMATION OBJECT ---------------------------------

local settings = {
	shell = shell,
	frameSleeping = cfg.frameSleeping,
	frameSleep = cfg.frameSleep,
	frameSleepSkipping = cfg.frameSleepSkipping,
	countDown = cfg.countDown,
	playAnimationBool = cfg.playAnimationBool,
	maxFramesPerGeneratedCodeFile = cfg.maxFramesPerGeneratedCodeFile,
	progressBool = cfg.progressBool,
	useMonitor = cfg.useMonitor,
	loop = cfg.progressBool,
	offset = cfg.offset,
	folder = cfg.folder,
	animationSize = cfg.animationSize,
}

local animation = an.Animation:new(settings)

animation:setCharCodeOffset(4, 0)


animation:writeCharCode(179) -- 'line vertical'

animation:writeCharCode(195, 0, 1) -- 'line vertical right'

animation:writeCharCode(179, 0, 1) -- 'line vertical'

animation:writeCharCode(180, 0, 1) -- 'line vertical left'

animation:setCharCodeOffset(5, 3)

for i = 1, 16 do -- 16
	animation:writeCharCode(179, 0, 1) -- 'line vertical'
end

animation:setCharCodeOffset(5, 1)

for i = 1, 39 do
	animation:writeCharCode(196) -- 'line horizontal'
end

animation:writeCharCode(193) -- 'line horizontal up'

animation:writeCharCode(196) -- 'line horizontal'

animation:writeCharCode(193) -- 'line horizontal up'

for i = 1, 6 do -- 6th only draws one character on-screen
	animation:writeCharCode(196) -- 'line horizontal'
end

animation:setCharCodeOffset(44, 0)

animation:writeCharCode(179) -- 'line vertical'

animation:addCharCodeOffset(1, 0)
if http then
	animation.fileName = 'internet_icon'
	animation:loadAnimation()
	animation:playAnimation()
else
	animation:writeCharCode(33, 0, 0) -- '!'
end

animation:writeCharCode(179) -- 'line vertical'

animation:writeCharCode(49) -- '1'
animation:writeCharCode(51) -- '3'
animation:writeCharCode(58) -- ':'
animation:writeCharCode(51) -- '3'
animation:writeCharCode(55) -- '7'

animation:setCharCodeOffset(5, 3)

for i = 1, 5 do
	animation:writeCharCode(196, -1) -- 'line horizontal'
end

animation:setCharCodeOffset(-1, 0)
animation:writeCharCode(62)  -- '>'
animation:writeCharCode(80)  -- 'P'
animation:writeCharCode(82)  -- 'R'
animation:writeCharCode(79)  -- 'O'
animation:writeCharCode(71)  -- 'G'

animation:setCharCodeOffset(0, 1)
animation:writeCharCode(80)  -- 'P'
animation:writeCharCode(82)  -- 'R'
animation:writeCharCode(79)  -- 'O'
animation:writeCharCode(71)  -- 'G'

animation:setCharCodeOffset(0, 2)
animation:writeCharCode(78)  -- 'N'
animation:writeCharCode(69)  -- 'E'
animation:writeCharCode(87)  -- 'W'

animation:setCharCodeOffset(5, 0)
animation:addOffset(2, 2)

animation:writeCharCode(72)  -- 'H'
animation:writeCharCode(101) -- 'e'
animation:writeCharCode(108) -- 'l'
animation:writeCharCode(108) -- 'l'
animation:writeCharCode(111) -- 'o'
animation:writeCharCode(32)  -- ' '
animation:writeCharCode(87)  -- 'W'
animation:writeCharCode(111) -- 'o'
animation:writeCharCode(114) -- 'r'
animation:writeCharCode(108) -- 'l'
animation:writeCharCode(100) -- 'd'
animation:writeCharCode(33)  -- '!'

animation:setOffset(125, 38)
animation.fileName = 'caramelldansen_undertale'

animation.animationSize = { width = 227, height = 85 }
-- animation.loop = true
animation.frameSleepSkipping = 1
animation.frameSleep = 0.15

animation:loadAnimation()
animation:playAnimation()

term.setCursorPos(1, 31)
local time = wt.getTime('Europe', 'Amsterdam')
cf.printTable(time)

-- DRAWING ANIMATIONS ENDED ----------------------------------------------

-- Hide the cursor by placing it at the bottom-right.
-- local width, height = term.getSize()
-- term.setCursorPos(width - 1, height)

-- if cfg.useMonitor and cfg.monitorSide then
-- 	term.restore()
-- end
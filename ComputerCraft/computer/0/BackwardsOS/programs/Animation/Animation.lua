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

local settings2 = {
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
	folder = cfg.folder,
	animationSize = { width = 8, height = 8 },
}

local animation2 = an.Animation:new(settings2)

animation2.offset = { x = 50, y = 50 }

animation2:writeCharCode(72)  -- 'H'
animation2:writeCharCode(101) -- 'e'
animation2:writeCharCode(108) -- 'l'
animation2:writeCharCode(108) -- 'l'
animation2:writeCharCode(111) -- 'o'
animation2:writeCharCode(32)  -- ' '
animation2:writeCharCode(87)  -- 'W'
animation2:writeCharCode(111) -- 'o'
animation2:writeCharCode(114) -- 'r'
animation2:writeCharCode(108) -- 'l'
animation2:writeCharCode(100) -- 'd'
animation2:writeCharCode(33)  -- '!'

animation2.offset = { x = 154, y = 50 }
animation2.fileName = 'caramelldansen_undertale'

animation2.animationSize = { width = 227, height = 85 }
animation2.loop = true
animation2.frameSleepSkipping = 1
animation2.frameSleep = 0.15

animation2:loadAnimation()
animation2:playAnimation()

-- DRAWING ANIMATIONS ENDED ----------------------------------------------

-- Hide the cursor by placing it at the bottom-right.
local width, height = term.getSize()
term.setCursorPos(width - 1, height)

if useMonitor and monitorSide then
	term.restore()
end
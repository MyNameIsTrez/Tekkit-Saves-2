-- CREATING AN ANIMATION OBJECT ---------------------------------

-- Collect the animation settings from the cfg file.
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
	loop = cfg.loop,
	offset = cfg.offset,
	folder = cfg.folder,
}

-- Create an animation object.
local animation = an.Animation:new(settings)

-- LOAD & PLAY ANIMATION USER FOR ANIMATION TO LOAD ---------------------------------

animation:askAnimationFolder()
animation:askAnimationFile()
animation:loadAnimation()
animation:playAnimation()

-- -- CREATING AN ANIMATION OBJECT ---------------------------------

-- -- Collect the animation settings from the cfg file.
-- local settings2 = {
-- 	shell = shell,
-- 	frameSleeping = cfg.frameSleeping,
-- 	frameSleep = cfg.frameSleep,
-- 	frameSleepSkipping = cfg.frameSleepSkipping,
-- 	countDown = cfg.countDown,
-- 	playAnimationBool = cfg.playAnimationBool,
-- 	maxFramesPerGeneratedCodeFile = cfg.maxFramesPerGeneratedCodeFile,
-- 	progressBool = false,
-- 	useMonitor = cfg.useMonitor,
-- 	loop = false,
-- 	offset = { x = 50, y = 50 },
-- 	folder = cfg.folder,
-- 	animationSize = { width = 128, height = 128 },
-- 	fileName = 'chars',
-- }

-- -- Create an animation object.
-- local animation2 = an.Animation:new(settings2)

-- -- LOAD & PLAY ANIMATION USER FOR ANIMATION TO LOAD ---------------------------------

-- -- animation2:askAnimationFolder()
-- -- animation2:askAnimationFile()

-- animation2:loadAnimation()
-- animation2:playAnimation()

-- DRAWING ANIMATIONS ENDED ----------------------------------------------

-- Hide the cursor by placing it at the bottom-right.
local width, height = term.getSize()
term.setCursorPos(width - 1, height)

if useMonitor and monitorSide then
	term.restore()
end
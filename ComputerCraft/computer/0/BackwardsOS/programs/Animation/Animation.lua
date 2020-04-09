-- CREATING AN ANIMATION OBJECT ---------------------------------


-- Collect the animation settings from the cfg file.
local settings = {
	shell = shell,
	frameSleeping = cfg.frameSleeping,
	frameSleep = cfg.frameSleep,
	frameSleepSkipping = cfg.frameSleepSkipping,
	countdownTime = cfg.countdownTime,
	playAnimationBool = cfg.playAnimationBool,
	maxFramesPerTimedAnimationFile = cfg.maxFramesPerTimedAnimationFile,
	progressBool = cfg.progressBool,
	useMonitor = cfg.useMonitor,
	loop = cfg.loop,
	folder = cfg.folder,
	offset = cfg.offset,
}

-- Create an animation object.
local animation = an.Animation:new(settings)


-- LOAD & PLAY ANIMATION USER FOR ANIMATION TO LOAD ---------------------------------


animation:askAnimationFolder()
animation:askAnimationFile()
animation:createTimedAnimation()
animation:playAnimation()


-- DRAWING ANIMATIONS ENDED ----------------------------------------------


-- Hide the cursor by placing it in the bottom-right corner of the screen.
-- local width, height = term.getSize()
-- term.setCursorPos(width - 1, height)

-- if cfg.useMonitor and cfg.monitorSide then
-- 	term.restore()
-- end
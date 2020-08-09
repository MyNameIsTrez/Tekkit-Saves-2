local settings = {
	path                           = "BackwardsOS/programs/animation",
	shell                          = shell,
	frameSleeping                  = cfg.animationFrameSleeping,
	frameSleep                     = cfg.animationFrameSleep,
	frameSleepSkipping             = cfg.animationFrameSleepSkipping,
	maxFramesPerTimedAnimationFile = cfg.maxFramesPerTimedAnimationFile,
	progressBool                   = cfg.animationProgressBool,
	loop                           = cfg.loop,
	countdownTime                  = cfg.countdownTime,
	offset                         = cfg.offset,
	playAnimationBool              = cfg.playAnimationBool,
	-- useMonitor                     = cfg.useMonitor,
	-- useCloud					   = cfg.useCloud,
}

local animation = an.Animation:new(settings)

animation:choose_document()
animation:play_animation()
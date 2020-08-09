local settings = {
	path                           = "BackwardsOS/programs/animation",
	shell                          = shell,
	frameSleeping                  = cfg.animationFrameSleeping,
	frameSleep                     = cfg.animationFrameSleep,
	frameSleepSkipping             = cfg.animationFrameSleepSkipping,
	-- countdownTime                  = cfg.countdownTime,
	-- playAnimationBool              = cfg.playAnimationBool,
	maxFramesPerTimedAnimationFile = cfg.maxFramesPerTimedAnimationFile,
	progressBool                   = cfg.animationProgressBool,
	-- useMonitor                     = cfg.useMonitor,
	loop                           = cfg.loop,
	-- offset                         = cfg.offset,
	-- useCloud					   = cfg.useCloud,
}

local animation = an.Animation:new(settings)

animation:print_ascii_names()
animation:choose_document()
animation:download_subfiles()
animation:create_timed_subfiles()
-- animation:askCharType()
-- animation:askFolder()
-- animation:askFile()
-- animation:chooseFile()
-- animation:createTimedAnimation()
-- animation:playAnimation()
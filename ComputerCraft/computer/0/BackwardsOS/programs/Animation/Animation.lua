local settings = {
	shell = shell,
	frameSleeping                  = cfg.animationFrameSleeping,
	frameSleep                     = cfg.animationFrameSleep,
	frameSleepSkipping             = cfg.animationFrameSleepSkipping,
	countdownTime                  = cfg.countdownTime,
	playAnimationBool              = cfg.playAnimationBool,
	maxFramesPerTimedAnimationFile = cfg.maxFramesPerTimedAnimationFile,
	progressBool                   = cfg.animationProgressBool,
	useMonitor                     = cfg.useMonitor,
	loop                           = cfg.loop,
	folder                         = cfg.folder,
	offset                         = cfg.offset,
	useCloud					   = cfg.useCloud,
}

local animation = an.Animation:new(settings)

animation:askCharType()
animation:askFolder()
animation:askFile()
animation:createTimedAnimation()
animation:playAnimation()
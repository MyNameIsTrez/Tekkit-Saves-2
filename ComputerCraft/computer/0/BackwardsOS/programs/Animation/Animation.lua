local animation = an.Animation:new(shell)

-- Main.
local sizeOptions = fs.list('BackwardsOS/programs/Animation/Animations')
local sizeFolder = lo.listOptions(sizeOptions)

-- Skips the beginning 'size_' part.
local sizeStr = cf.split(sizeFolder, '_')[2]

-- Splits the width and height.
local animationSize_ = cf.split(sizeStr, 'x')

animationSize = { width = animationSize_[1], height = animationSize_[2] }

term.clear()
term.setCursorPos(1, 1)

local programOptions = fs.list('BackwardsOS/programs/Animation/Animations/' .. sizeFolder)
fileName = lo.listOptions(programOptions)

term.clear()
term.setCursorPos(1, 1)


local gitHubFolder = 'Animations/size_' .. animationSize.width .. 'x' .. animationSize.height
local folder = 'BackwardsOS/programs/Animation/'

animation:loadAnimation(fileName, animationSize, gitHubFolder, folder, cfg.progressBool)
animation:playAnimation(cfg.loop, folder, cfg.progressBool)

local width, height = term.getSize()
term.setCursorPos(width - 1, height)

if cfg.useMonitor and monitorSide then
	term.restore()
end

local animation = an.Animation:new(shell)

-- Main.
local gitHubFolder = 'Animations/size_' .. cfg.animationSize.width .. 'x' .. cfg.animationSize.height
local folder = 'BackwardsOS/programs/Animation/'

animation:loadAnimation(cfg.fileName, cfg.animationSize, gitHubFolder, folder)
animation:playAnimation(cfg.loop)

local width, height = term.getSize()
term.setCursorPos(width - 1, height)

if cfg.useMonitor and monitorSide then
	term.restore()
end
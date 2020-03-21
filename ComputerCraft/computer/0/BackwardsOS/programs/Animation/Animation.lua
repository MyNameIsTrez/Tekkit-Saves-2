
local animation = an.Animation:new(shell)

-- Main.
local folder = 'Animations/size_' .. cfg.animationSize.width .. 'x' .. cfg.animationSize.height
animation:loadAnimation(cfg.fileName, cfg.animationSize, folder)
animation:playAnimation(cfg.loop)

local width, height = term.getSize()
term.setCursorPos(width - 1, height)

if cfg.useMonitor and monitorSide then
	term.restore()
end
local settings = {
	shell                          = shell,
	frameSleeping                  = cfg.UIFrameSleeping,
	frameSleep                     = cfg.UIFrameSleep,
	frameSleepSkipping             = cfg.UIFrameSleepSkipping,
	countdownTime                  = cfg.countdownTime,
	playAnimationBool              = cfg.playAnimationBool,
	maxFramesPerTimedAnimationFile = cfg.maxFramesPerTimedAnimationFile,
	progressBool                   = cfg.UIProgressBool,
	useMonitor                     = cfg.useMonitor,
	loop                           = cfg.loop,
	offset                         = cfg.offset,
	folder                         = cfg.folder,
	animationSize                  = cfg.animationSize,
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
	animation:createTimedAnimation()
	animation:playAnimation()
else
	animation:writeCharCode(33, 0, 0) -- '!'
end

animation:writeCharCode(179) -- 'line vertical'

if http then
	local time = wt.getTime('Europe', 'Amsterdam')
	local timeData = time.timeData

	local hours = timeData.hours
	local hoursLeft = tonumber(hours:sub(1, 1))
	local hoursRight = tonumber(hours:sub(2, 2))

	local minutes = timeData.minutes
	local minutesLeft = tonumber(minutes:sub(1, 1))
	local minutesRight = tonumber(minutes:sub(2, 2))

	animation:writeCharCode(48 + hoursLeft)
	animation:writeCharCode(48 + hoursRight)
	animation:writeCharCode(58) -- ':'
	animation:writeCharCode(48 + minutesLeft)
	animation:writeCharCode(48 + minutesRight)
end

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

animation.fileName = 'cyclops_cat'
animation.animationSize = { width = 227, height = 85 }

local xTopLeft = 1 + 8 * 5 + 5
local yTopLeft = 1 + 8 + 5
local xBottomRight, yBottomRight = term.getSize()
local xMiddle = (xTopLeft + xBottomRight) / 2
local yMiddle = (yTopLeft + yBottomRight) / 2

local x = xMiddle - animation.animationSize.width / 2
local y = yMiddle - animation.animationSize.height / 2
animation:setOffset(x, y)

animation:createTimedAnimation()
animation:playAnimation()

term.setCursorPos(1, 31)

-- Hide the cursor by placing it in the bottom-right corner of the screen.
-- local width, height = term.getSize()
-- term.setCursorPos(width - 1, height)

-- if cfg.useMonitor and cfg.monitorSide then
-- 	term.restore()
-- end
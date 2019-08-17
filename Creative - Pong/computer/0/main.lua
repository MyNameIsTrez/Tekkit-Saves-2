-- Pong
-- Made by MyNameIsTrez on 16-8-2019

function setup()
  terminal = term -- writing the native 'term' as 'terminal' is more readable
  terminal.clear() -- clear the text on the monitor
  terminalW, terminalH = terminal.getSize() -- store the terminal's dimensions in two variables
  sleepTime = 0 -- the sleep time between the text its movements
  
  screenSide = 'top' -- which side the monitor is on, relative to the terminal.
  monitor = peripheral.wrap(screenSide) -- sets 'm' as being the monitor's variable, using screenSide.
  monitorW, monitorH = monitor.getSize() -- store the width and height of the monitor
  
  ballX = math.ceil(monitorW/2) -- the monitor cursor x position of the text, always 1 here
  ballY = math.ceil(monitorH/2) -- the monitor cursor y position of the text, always 1 here
  ballXSpeed = math.random(2, 10) / 10 -- the horizontal speed of the ball, where 1 is east
  ballYSpeed = math.random(2, 10) / 10 -- the vertical speed of the ball, where 1 is south
  ballSymbol = 'o' -- the symbol used to draw the ball
  
  middleLineSymbol = '|' -- the symbol used to draw the middle line

  paddleSymbol = '|' -- the symbol used to draw the paddles
  pedalSize = 5
  pedalTopYLeft = monitorH/2 - pedalSize/2
  pedalTopYRight = monitorH/2 - pedalSize/2
  scoreLeft = 0
  scoreRight = 0
  ballYInPaddleLeft = false
  ballYInPaddleRight = false
end
setup() -- run the above function upon the startup of this program

function drawTerminal()
  terminal.clear() -- clear all the text on the terminal
  terminal.setCursorPos(1, 1)
  print('terminalW: '..terminalW..', '..'terminalH: '..terminalH)
  print('sleepTime: '..sleepTime)
  print()
  print('screenSide: '..screenSide)
  print('monitorW: '..monitorW..', '..'monitorH: '..monitorH)
  print()
  print('ballX: '..ballX)
  print('ballY: '..ballY)
  print('ballXSpeed: '..ballXSpeed)
  print('ballYSpeed: '..ballYSpeed)
  print()
  print('pedalSize: '..pedalSize)
  print('pedalTopYLeft: '..pedalTopYLeft)
  print('pedalTopYRight: '..pedalTopYRight)
  print()
  print('ballYInPaddleLeft: '..tostring(ballYInPaddleLeft))
  print('ballYInPaddleRight: '..tostring(ballYInPaddleRight))
end

function drawMonitor()
  terminal.redirect(monitor) -- redirect the drawing to the monitor
  monitor.clear() -- clear all the text on the monitor

  for y = 1, monitorH do -- draw the vertical line in the middle of the monitor
    monitor.setCursorPos(math.ceil(monitorW/2), y)
    write(middleLineSymbol)
  end

  for y = 1, pedalSize do -- draw the left paddle
    monitor.setCursorPos(1, pedalTopYLeft + y)
    write(middleLineSymbol)
  end

  for y = 1, pedalSize do -- draw the right paddle
    monitor.setCursorPos(monitorW - 1, pedalTopYRight + y)
    write(middleLineSymbol)
  end

  -- write the score of the player on the left
  monitor.setCursorPos(19, 5)
  write(scoreLeft)

  -- write the score of the player on the right
  monitor.setCursorPos(59, 5)
  write(scoreRight)

  -- draw the ball
  monitor.setCursorPos(ballX, ballY)
  write(ballSymbol)
  
  terminal.restore() -- redirect the drawing back to the terminal
end

function draw()
  drawTerminal()
  drawMonitor()

  ballYInPaddleLeft = ballY > pedalTopYLeft and ballY < pedalTopYLeft + pedalSize
  ballYInPaddleRight = ballY > pedalTopYRight and ballY < pedalTopYRight + pedalSize

  if (ballX < 3 and ballYInPaddleLeft) then
    -- bounce the ball to the right
    ballXSpeed = -ballXSpeed
  elseif (ballX > monitorW - 3 and ballYInPaddleRight) then
    -- bounce the ball to the left
    ballXSpeed = -ballXSpeed
  elseif (ballX <= 1) then
    -- give a point to the right player and reset the ball to the middle
    scoreRight = scoreRight + 1
    ballX = math.ceil(monitorW/2) -- the monitor cursor x position of the text, always 1 here
    ballY = math.ceil(monitorH/2) -- the monitor cursor y position of the text, always 1 here
    ballXSpeed = math.random(2, 10) / 10  -- the horizontal speed of the ball, where 1 is east
    ballYSpeed = math.random(2, 10) / 10  -- the vertical speed of the ball, where 1 is south
  elseif (ballX >= monitorW - 1) then
    -- give a point to the left player and reset the ball to the middle
    scoreLeft = scoreLeft + 1
    ballX = math.ceil(monitorW/2) -- the monitor cursor x position of the text, always 1 here
    ballY = math.ceil(monitorH/2) -- the monitor cursor y position of the text, always 1 here
    ballXSpeed = math.random(2, 10) / 10  -- the horizontal speed of the ball, where 1 is east
    ballYSpeed = math.random(2, 10) / 10  -- the vertical speed of the ball, where 1 is south
  end

  if (ballY <= 1 or ballY >= monitorH) then
    ballYSpeed = -ballYSpeed
  end

  ballX = ballX + ballXSpeed
  ballY = ballY + ballYSpeed
end

while true do
  draw() -- run the above function upon the startup of this program
  sleep(sleepTime) -- sleep, so the text seems to move
end

-- 7, 17, ..., 77 (max of 8 monitors wide)
-- 5, 11, 18, 25, 31, 38 (max of 6 monitors high)

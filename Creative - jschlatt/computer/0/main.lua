-- Scrolling text program
-- Made by MyNameIsTrez on 16-8-2019

function setup()
  terminal = term -- writing the native 'term' as 'terminal' is more readable
  terminal.clear() -- clear the text on the monitor
  terminalW, terminalH = terminal.getSize() -- store the terminal's dimensions in two variables
  screenSide = 'top' -- which side the monitor is on, relative to the terminal.
  monitor = peripheral.wrap(screenSide) -- sets 'm' as being the monitor's variable, using screenSide.
  sleepTime = 0.1 -- the sleep time between the text its movements
  
  monitorW, monitorH = monitor.getSize() -- store the width and height of the monitor
  monitorH = monitorH - 1 -- decrease the monitor height by 1, to compensate for wrapping issues
  scrollingText = 'D I C K  A N D  B A L L S'
  scrollingTextLength = string.len(scrollingText)
  monitorTextScale = 1 -- 1 by default, from 1 to 5
  scrollingTextWidth = scrollingTextLength * monitorTextScale
  scrollingTextHeight = monitorTextScale
  monitor.setTextScale(monitorTextScale) -- sets the monitorTextScale
  x = -scrollingTextWidth + 1 -- the monitor cursor x position of the text, always 1 here
  y = 1 -- the monitor cursor y position of the text, always 1 here
end
setup() -- run the above function upon the startup of this program

function drawTerminal()
  terminal.clear() -- clear all the text on the terminal
  terminal.setCursorPos(1, 1)
  print('terminalW: '..terminalW..', '..'terminalH: '..terminalH)
  print('screenSide: '..screenSide)
  print('sleepTime: '..sleepTime)
  print()
  print('monitorW: '..monitorW..', '..'monitorH: '..monitorH)
  print('scrollingText: '..scrollingText)
  print('scrollingTextLength: '..scrollingTextLength)
  print('monitor text scale: '..monitorTextScale)
  print('scrollingTextWidth: '..scrollingTextWidth)
  print('scrollingTextHeight: '..scrollingTextHeight)
  print('x: '..x)
  print('y: '..y)
end

function drawMonitor()
  terminal.redirect(monitor) -- redirect the drawing to the monitor
  monitor.clear() -- clear all the text on the monitor
  monitor.setCursorPos(x, y) -- move the cursor on the monitor
  monitor.write(scrollingText)
  terminal.restore() -- redirect the drawing back to the terminal
end

function draw()
  drawTerminal()
  drawMonitor()
  if (x < monitorW) then
    x = x + 1
  else
    if (y < monitorH) then
      x = -scrollingTextWidth + 1
      y = y + 1
    else
      x = -scrollingTextWidth + 1
      y = 1
    end
  end
end

while true do
  draw() -- run the above function upon the startup of this program
  sleep(sleepTime) -- sleep, so the text seems to move
end

-- 7, 17, ..., 77 (max of 8 monitors wide)
-- 5, 11, 18, 25, 31, 38 (max of 6 monitors high)
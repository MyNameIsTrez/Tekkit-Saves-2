-- Game of Life
-- Made by MyNameIsTrez on 16-8-2019

function setup()
  terminal = term -- writing the native 'term' as 'terminal' is more readable
  terminal.clear() -- clear the text on the monitor
  terminalW, terminalH = terminal.getSize() -- store the terminal's dimensions in two variables
  screenSide = 'top' -- which side the monitor is on, relative to the terminal.
  monitor = peripheral.wrap(screenSide) -- sets 'm' as being the monitor's variable, using screenSide.
  sleepTime = 0 -- the sleep time that determines the FPS
  
  monitorW, monitorH = monitor.getSize() -- store the width and height of the monitor
  monitorH = monitorH - 1 -- decrease the monitor height by 1, to compensate for wrapping issues
  cellAliveSymbol = 'o' -- always one character

  cells = {} -- initializes the cells array

  for x = 1, monitorW do -- fills the cells array so it is 2D
    cells[x] = {} -- insert a new row
    for y = 1, monitorH do -- fills the cells array so it is 2D
      cells[x][y] = {}
      cells[x][y].alive = 0
    end
  end

  -- x, y coordinates of the r_pentomino starting cells
  -- top 2 cells
  cells[39][18].alive = 1
  cells[40][18].alive = 1

  -- middle 2 cells
  cells[38][19].alive = 1
  cells[39][19].alive = 1

  -- bottom 1 cell
  cells[39][20].alive = 1
end
setup() -- run the above function upon the startup of this program

function updateTerminal()
  terminal.clear() -- clear all the text on the terminal
  terminal.setCursorPos(1, 1)
  print('terminalW: '..terminalW..', '..'terminalH: '..terminalH)
  print('screenSide: '..screenSide)
  print('sleepTime: '..sleepTime)
  print()
  print('monitorW: '..monitorW..', '..'monitorH: '..monitorH)
  print('cellAliveSymbol: '..cellAliveSymbol)
  print()
end

function calculateNeighbouringAliveCells(x, y)
  neighbours = 0

  -- top-left
  if (x > 1 and y > 1) then
    neighbours = neighbours + cells[x-1][y-1].alive
  end

  -- top
  if (y > 1) then
    neighbours = neighbours + cells[x][y-1].alive
  end

  -- top-right
  if (x < monitorW and y > 1) then
    neighbours = neighbours + cells[x+1][y-1].alive
  end

  -- left
  if (x > 1) then
    neighbours = neighbours + cells[x-1][y].alive
  end

  -- right
  if (x < monitorW) then
    neighbours = neighbours + cells[x+1][y].alive
  end

  -- bottom-left
  if (x > 1 and y < monitorH) then
    neighbours = neighbours + cells[x-1][y+1].alive
  end
  
  -- bottom
  if (y < monitorH) then
    neighbours = neighbours + cells[x][y+1].alive
  end

  -- bottom-right
  if (x < monitorW and y < monitorH) then
    neighbours = neighbours + cells[x+1][y+1].alive
  end

  cells[x][y].neighbours = neighbours
end

function updateCell(x, y)
  neighbours = cells[x][y].neighbours
  
  if (neighbours == 2) then
    -- nothing happens to the cell
  elseif (neighbours == 3) then
    if (cells[x][y].alive == 0) then -- the cell stays alive/is now born
      cells[x][y].alive = 1
    end
  else
    if (cells[x][y].alive == 1) then -- the cell dies
      cells[x][y].alive = 0
    end
  end
end

function drawCells()
  for x = 1, monitorW do
    for y = 1, monitorH do
      if (cells[x][y].alive == 1) then
        monitor.setCursorPos(x, y) -- move the cursor on the monitor
        print(cellAliveSymbol)
      end
    end
  end
end

function updateMonitor()
  terminal.redirect(monitor) -- redirect the drawing to the monitor
  monitor.clear() -- clear all the text on the monitor
  drawCells()
  for x = 1, monitorW do
    for y = 1, monitorH do
      calculateNeighbouringAliveCells(x, y)
    end
  end
  for x = 1, monitorW do
    for y = 1, monitorH do
      updateCell(x, y)
    end
  end
  terminal.restore() -- redirect the drawing back to the terminal
end

function update()
  updateTerminal()
  updateMonitor()
end

while true do
  update() -- run the above function upon the startup of this program
  sleep(sleepTime) -- sleep, so the text seems to move
end

-- 7, 17, ..., 77 (max of 8 monitors wide)
-- 5, 11, 18, 25, 31, 38 (max of 6 monitors high)
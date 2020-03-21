-- +-----------------------+
-- | Made by MyNameIsTrez. +---------------------------------------+
-- | Use 'pastebin get RQ9Ri8FN startup' to download this program. +------------------------------------------------+
-- | 1. Place a modem on any side of the computer by crouching while placing the modem on the side of the computer. |
-- | 2. You can change the time it takes for an error to disappear by modifying 'sleepTime = 1'. +------------------+
-- +---------------------------------------------------------------------------------------------+

local alertTime = 1

cf.openModem()

function main()
	while true do
		term.setCursorPos(1,1)
		term.clear()
		
		write("Enter an item to request: ")
		rednet.broadcast(read())
		
		write("Enter the amount of stacks to request: ")
		stacks = read()
		stacksCheck()
		rednet.broadcast(stacks)
		
		senderId, message, protocol = rednet.receive(0)
		
		if message == "working" then
			message = 0
			while message ~= "restart" do
				senderId, message, protocol = rednet.receive()

				if type(tonumber(message)) == "number" then
					step = message
					calculateTimeLeft()
				else
					main()
				end
			end
		end

		write("You didn't enter a valid item name.")
		sleep(alertTime)
	end
end

function stacksCheck()
	stacks = tonumber(stacks)
	if type(stacks) == "number" then
		stacks = tostring(stacks)
	else
		write("You didn't enter the number of stacks.")
		rednet.broadcast("0")
		sleep(alertTime)
		main()
	end
end

function calculateTimeLeft()
	stacks = tonumber(stacks)
	timeLeft = math.ceil((stacks / 10 - step / 10) * 4.5)
	term.setCursorPos(1,3)
	write("Time left: "..timeLeft.." seconds	")
end

main()
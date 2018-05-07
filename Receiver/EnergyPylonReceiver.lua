os.loadAPI("lib/a")
os.loadAPI("lib/k")
os.loadAPI("lib/s")

a.cfg()

-- Modem side
local modemside = fs.open ("cfg/modem", "r")
local modems = modemside.readAll()
local modems2 = string.format("%s", modems)
modemside.close()

-- what modem side is?
if modems2 == "left" then
	modemposition = peripheral.wrap("left")
end
if modems2 == "right" then
	modemposition = peripheral.wrap("right")
end
if modems2 == "top" then
	modemposition = peripheral.wrap("top")
end
if modems2 == "bottom" then
	modemposition = peripheral.wrap("bottom")
end
if modems2 == "front" then
	modemposition = peripheral.wrap("front")
end
if modems2 == "back" then
	modemposition = peripheral.wrap("back")
end

-- Monitor side
local monitorside = fs.open ("cfg/monitor", "r")
local monitors = monitorside.readAll()
local monitors2 = string.format("%s", monitors)
monitorside.close()

-- what monitor side is?
if monitors2 == "left" then
	monitorposition = peripheral.wrap("left")
end
if monitors2 == "right" then
	monitorposition = peripheral.wrap("right")
end
if monitors2 == "top" then
	monitorposition = peripheral.wrap("top")
end
if monitors2 == "bottom" then
	monitorposition = peripheral.wrap("bottom")
end
if monitors2 == "front" then
	monitorposition = peripheral.wrap("front")
end
if monitors2 == "back" then
	monitorposition = peripheral.wrap("back")
end

-- Max channel
local maxchan = fs.open ("cfg/Max", "r")
local maxchannel = maxchan.readAll()
local maxchannel2 = string.format("%s", maxchannel)
maxchan.close()

maxchannel3 = tonumber(maxchannel2)

-- Stored channel
local storedchan = fs.open ("cfg/Stored", "r")
local storedchannel = storedchan.readAll()
local storedchannel2 = string.format("%s", storedchannel)
storedchan.close()

storedchannel3 = tonumber(storedchannel2)

-- EU display
local eudis = fs.open ("cfg/EU", "r")
local eudisplay = eudis.readAll()
local eudisplay2 = string.format("%s", eudisplay)
eudis.close()

-- Monitor
local mon, monitor, monX, monY
monitor = monitorposition
monX, monY = monitor.getSize()
mon = {}
mon.monitor,mon.X, mon.Y = monitor, monX, monY

-- Modem
local modem = modemposition
modem.open(maxchannel3) --MAX channel
modem.open(storedchannel3) --STORED channel 

-- write max
event, modemSide, senderChannel, replyChannel, message = os.pullEvent("modem_message")
 	if senderChannel == maxchannel3 then    
  		local max = message
  		local maxwrite = fs.open("data/max", "w")
  	    maxwrite.writeLine(string.format("%s", max))
  		  maxwrite.close()
 	end

-- read max
local maxread = fs.open ("data/max", "r")
local max1 = maxread.readAll()
local maxformated = string.format("%s", max1)
maxread.close()

--  Main script
function recive()
  while true do
	event, modemSide, senderChannel, replyChannel, message = os.pullEvent("modem_message")
 	if senderChannel == storedchannel3 then
  	local stored = message
    mon.monitor.setBackgroundColor(colors.black)
    mon.monitor.clear()
    mon.monitor.setCursorPos(1,1)

    local max2 = tonumber(maxformated)
    local max3 = max2/1000
    k.draw_text_lr(mon, 2, 4, 1, "Max", k.format_int(max3) .. " kRF", colors.white, colors.white, colors.black)

    if eudisplay2 == "T" then
      local maxEU = max3/4
      local maxEU2 = math.ceil(maxEU)
      k.draw_text_lr(mon, 2, 5, 1, "Max EU", k.format_int(maxEU2) .. " kEU", colors.gray, colors.gray, colors.black)
    end

    local stored2 = tonumber(stored)
    local stored3 = stored2/1000
    local stored4 = math.ceil(stored3)
    print(stored4)
    k.draw_text_lr(mon, 2, 6, 1, "Stored", k.format_int(stored4) .. " kRF", colors.white, colors.white, colors.black)

    if eudisplay2 == "T" then
      local storedEU = stored3/4
      local storedEU2 = math.ceil(storedEU)
      print(storedEU2)
      k.draw_text_lr(mon, 2, 7, 1, "Stored EU", k.format_int(storedEU2) .. " kEU", colors.gray, colors.gray, colors.black)
    end

    local eStored
    eStored = math.ceil(stored / maxformated * 10000)*.01
    if eStored < 100 then 
        k.draw_text_lr(mon, 2, 2, 1, "Draconic Core", "Online", colors.white, colors.green, colors.black) --DRACONIC CORE ONLINE
      else 
        k.draw_text_lr(mon, 2, 2, 1, "Draconic Core", "FULL", colors.white, colors.red, colors.black) --DRACONIC CORE ONLINE
    end

    k.draw_text_lr(mon, 2, 9, 1, "Energy Stored", eStored .. "%", colors.white, colors.white, colors.black)
    k.progress_bar(mon, 2, 10, mon.X-2, eStored, 100, colors.green, colors.gray)

    s.sleep()
    term.clear()
    term.setCursorPos(1,1)
    print("reciving...")
 	end
 	end
end

parallel.waitForAny(recive)
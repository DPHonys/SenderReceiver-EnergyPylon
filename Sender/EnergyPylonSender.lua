os.loadAPI("lib/a")

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

-- pylon side
local pylonside = fs.open ("cfg/pylon", "r")
local pylon = pylonside.readAll()
local pylon2 = string.format("%s", pylon)
pylonside.close()

-- what pylon side is?
if pylon2 == "left" then
    pylonposition = peripheral.wrap("left")
end
if pylon2 == "right" then
    pylonposition = peripheral.wrap("right")
end
if pylon2 == "top" then
    pylonposition = peripheral.wrap("top")
end
if pylon2 == "bottom" then
    pylonposition = peripheral.wrap("bottom")
end
if pylon2 == "front" then
    pylonposition = peripheral.wrap("front")
end
if pylon2 == "back" then
    pylonposition = peripheral.wrap("back")
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

-- main script 
local modem = modemposition
modem.open(maxchannel3) --MAX
modem.open(storedchannel3) --STORED

function send()
    while true do --LOOP
      local pylon = pylonposition
        local stored = pylon.getEnergyStored()
        local max = pylon.getMaxEnergyStored()
        print(stored)
        print(max)
        modem.transmit(maxchannel3, maxchannel3, max)
        modem.transmit(storedchannel3, storedchannel3, stored)
        os.sleep(0,1)
        term.clear()
        term.setCursorPos(1,1)
        print("sending...")
    end --END
end

parallel.waitForAny(send)

print("ok") --SOMETHING IS WRONG
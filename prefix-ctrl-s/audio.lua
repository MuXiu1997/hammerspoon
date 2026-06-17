local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 5,["8"] = 6,["9"] = 7,["10"] = 8,["11"] = 10,["12"] = 11,["13"] = 11,["14"] = 11,["15"] = 11,["16"] = 10,["17"] = 14,["18"] = 15,["19"] = 16,["20"] = 17,["21"] = 18,["23"] = 21,["24"] = 22,["26"] = 25,["27"] = 14,["28"] = 28,["29"] = 29,["30"] = 30,["31"] = 31,["34"] = 35,["35"] = 36,["37"] = 28,["38"] = 40,["39"] = 41,["40"] = 42,["41"] = 40,["42"] = 45,["43"] = 46,["44"] = 47,["46"] = 50,["47"] = 51,["49"] = 54,["50"] = 55,["51"] = 45,["52"] = 58,["53"] = 59,["54"] = 60,["57"] = 64,["58"] = 64,["59"] = 64,["60"] = 65,["61"] = 66,["62"] = 67,["65"] = 71,["66"] = 72,["68"] = 64,["69"] = 64,["70"] = 58,["71"] = 77,["72"] = 78,["73"] = 91,["74"] = 92,["77"] = 96,["78"] = 97,["79"] = 99,["80"] = 100,["82"] = 91,["83"] = 104,["84"] = 77,["85"] = 110,["86"] = 111,["87"] = 110});
local ____exports = {}
local blueutilPath = "/opt/homebrew/bin/blueutil"
local headphonesBluetoothAddress = "50-f3-51-0c-32-f7"
local headphonesOutputUID = string.upper(headphonesBluetoothAddress) .. ":output"
local headphonesVolume = 45
local function findBuiltInOutputDevice()
    return __TS__ArrayFind(
        hs.audiodevice.allOutputDevices(),
        function(____, device) return device:transportType() == "Built-in" end
    )
end
local function setOutputDevice(device, volume)
    local ok = device:setDefaultOutputDevice()
    if not ok then
        hs.alert.show("Failed to switch to " .. device:name())
        return false
    end
    if volume ~= nil then
        device:setVolume(volume)
    end
    return true
end
local function switchToBuiltInOutput()
    local device = findBuiltInOutputDevice()
    if not device then
        hs.alert.show("Built-in output device not found")
        return
    end
    if setOutputDevice(device) then
        hs.alert.show("Switched to " .. device:name())
    end
end
local function areHeadphonesConnected()
    local output = hs.execute((blueutilPath .. " --is-connected ") .. headphonesBluetoothAddress, true)
    return __TS__StringTrim(output) == "1"
end
local function ensureHeadphonesConnected()
    if hs.audiodevice.findOutputByUID(headphonesOutputUID) then
        return true
    end
    if areHeadphonesConnected() then
        return true
    end
    hs.execute((blueutilPath .. " --connect ") .. headphonesBluetoothAddress, true)
    return true
end
local function connectAndSwitchToHeadphones()
    if not ensureHeadphonesConnected() then
        hs.alert.show("Failed to connect AirPods")
        return
    end
    hs.timer.doAfter(
        1,
        function()
            local device = hs.audiodevice.findOutputByUID(headphonesOutputUID)
            if not device then
                hs.alert.show("AirPods output device not found")
                return
            end
            if setOutputDevice(device, headphonesVolume) then
                hs.alert.show(((("Switched to " .. device:name()) .. " at ") .. tostring(headphonesVolume)) .. "%")
            end
        end
    )
end
local function showAudioChooser()
    local choices = {{text = "AirPods", subText = "Connect Bluetooth, switch output, and set volume to 45%", actionId = "headphones"}, {text = "Built-in Output", subText = "Switch to the built-in speaker output device", actionId = "built-in"}}
    local chooser = hs.chooser.new(function(choice)
        if not choice then
            return
        end
        if choice.actionId == "built-in" then
            switchToBuiltInOutput()
        elseif choice.actionId == "headphones" then
            connectAndSwitchToHeadphones()
        end
    end)
    chooser:choices(choices):placeholderText("Select an audio action..."):searchSubText(true):show()
end
function ____exports.apply(prefix)
    prefix.bind("a", showAudioChooser)
end
return ____exports

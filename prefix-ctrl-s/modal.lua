local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 7,["6"] = 8,["7"] = 8,["8"] = 8,["9"] = 8,["10"] = 8,["11"] = 10,["12"] = 11,["13"] = 13,["14"] = 14,["15"] = 15,["16"] = 16,["18"] = 13,["19"] = 20,["20"] = 21,["21"] = 22,["23"] = 24,["24"] = 24,["25"] = 24,["26"] = 24,["27"] = 24,["28"] = 24,["29"] = 31,["30"] = 32,["31"] = 32,["32"] = 32,["33"] = 33,["34"] = 32,["35"] = 32,["36"] = 20,["37"] = 37,["38"] = 38,["39"] = 39,["40"] = 40,["42"] = 42,["43"] = 37,["44"] = 45,["45"] = 45,["46"] = 45,["47"] = 45,["48"] = 46,["49"] = 48,["50"] = 49,["51"] = 50,["52"] = 50,["53"] = 50,["54"] = 50,["55"] = 45,["56"] = 45,["57"] = 53,["58"] = 55,["59"] = 55,["60"] = 55,["61"] = 55,["62"] = 56,["63"] = 57,["64"] = 55,["65"] = 55,["66"] = 53});
local ____exports = {}
local prefixModal = hs.hotkey.modal.new()
local prefixHotkey = hs.hotkey.bind(
    {"ctrl"},
    "s",
    function() return prefixModal:enter() end
)
local alertId
local timeoutTimer
local function clearTimer()
    if timeoutTimer then
        timeoutTimer:stop()
        timeoutTimer = nil
    end
end
prefixModal.entered = function()
    if alertId then
        hs.alert.closeSpecific(alertId)
    end
    alertId = hs.alert.show(
        "Prefix Mode (Ctrl+S)",
        {textSize = 20, radius = 10, fillColor = {white = 0, alpha = 0.7}, strokeColor = {white = 1, alpha = 0.5}},
        hs.screen.mainScreen(),
        999999
    )
    clearTimer()
    timeoutTimer = hs.timer.doAfter(
        2,
        function()
            prefixModal:exit()
        end
    )
end
prefixModal.exited = function()
    if alertId then
        hs.alert.closeSpecific(alertId)
        alertId = nil
    end
    clearTimer()
end
prefixModal:bind(
    {"ctrl"},
    "s",
    function()
        prefixModal:exit()
        prefixHotkey:disable()
        hs.eventtap.keyStroke({"ctrl"}, "s")
        hs.timer.doAfter(
            0.1,
            function() return prefixHotkey:enable() end
        )
    end
)
____exports.prefixController = {bind = function(key, fn)
    prefixModal:bind(
        {},
        key,
        function()
            prefixModal:exit()
            fn()
        end
    )
end}
return ____exports

local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 5,["10"] = 6,["11"] = 7,["12"] = 8,["15"] = 12,["16"] = 12,["17"] = 12,["18"] = 12,["19"] = 14,["20"] = 15,["23"] = 19,["24"] = 19,["25"] = 19,["26"] = 20,["27"] = 20,["28"] = 20,["29"] = 20,["30"] = 20,["31"] = 19,["32"] = 19,["33"] = 27,["34"] = 28,["35"] = 29,["36"] = 30,["37"] = 31,["38"] = 32,["41"] = 27,["42"] = 37,["43"] = 5,["44"] = 43,["45"] = 44,["46"] = 61,["47"] = 63,["48"] = 64,["51"] = 68,["52"] = 68,["53"] = 68,["54"] = 69,["55"] = 69,["56"] = 69,["57"] = 69,["58"] = 69,["59"] = 70,["60"] = 70,["61"] = 70,["62"] = 70,["63"] = 70,["64"] = 70,["65"] = 68,["66"] = 68,["67"] = 78,["68"] = 79,["69"] = 80,["70"] = 87,["72"] = 78,["73"] = 91,["74"] = 43,["75"] = 97,["76"] = 98,["77"] = 99,["78"] = 97});
local ____exports = {}
local function showEdgeWindowChooser()
    local edgeApp = hs.application.get("Microsoft Edge")
    if not edgeApp then
        hs.alert.show("Microsoft Edge is not running")
        return
    end
    local windows = __TS__ArrayFilter(
        edgeApp:allWindows(),
        function(____, win) return win:isStandard() end
    )
    if #windows == 0 then
        hs.alert.show("No standard Edge windows found")
        return
    end
    local choices = __TS__ArrayMap(
        windows,
        function(____, win)
            return {
                text = win:title() or "Untitled Window",
                subText = "Microsoft Edge",
                window = win
            }
        end
    )
    local chooser = hs.chooser.new(function(choice)
        if choice and choice.window then
            local win = choice.window
            win:focus()
            if win:isMinimized() then
                win:unminimize()
            end
        end
    end)
    chooser:choices(choices):placeholderText("Select an Edge window..."):searchSubText(true):show()
end
local function showEdgeTabChooser()
    local script = "\n    tell application \"Microsoft Edge\"\n        set res to {}\n        try\n            set winCount to count windows\n            repeat with wIdx from 1 to winCount\n                set tCount to count tabs of window wIdx\n                repeat with tIdx from 1 to tCount\n                    set tTitle to title of tab tIdx of window wIdx\n                    set end of res to tTitle & \"||\" & wIdx & \"||\" & tIdx\n                end repeat\n            end repeat\n        end try\n        return res\n    end tell\n  "
    local ok, result = hs.osascript.applescript(script)
    if not ok or not result then
        hs.alert.show("Failed to get Edge tabs")
        return
    end
    local choices = __TS__ArrayMap(
        result,
        function(____, line)
            local title, wIdx, tIdx = table.unpack(
                __TS__StringSplit(line, "||"),
                1,
                3
            )
            return {
                text = title,
                subText = "Microsoft Edge Tab",
                wIdx = __TS__ParseInt(wIdx),
                tIdx = __TS__ParseInt(tIdx)
            }
        end
    )
    local chooser = hs.chooser.new(function(choice)
        if choice then
            local switchScript = ((("\n        tell application \"Microsoft Edge\"\n            set index of window " .. tostring(choice.wIdx)) .. " to 1\n            set active tab index of window 1 to ") .. tostring(choice.tIdx)) .. "\n            activate\n        end tell\n      "
            hs.osascript.applescript(switchScript)
        end
    end)
    chooser:choices(choices):placeholderText("Select an Edge tab..."):searchSubText(true):show()
end
function ____exports.apply(prefix)
    prefix.bind("e", showEdgeWindowChooser)
    prefix.bind("t", showEdgeTabChooser)
end
return ____exports

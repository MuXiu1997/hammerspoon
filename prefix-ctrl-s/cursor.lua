local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 5,["8"] = 6,["9"] = 7,["10"] = 8,["13"] = 12,["14"] = 12,["15"] = 12,["16"] = 12,["17"] = 14,["18"] = 15,["21"] = 19,["22"] = 19,["23"] = 19,["24"] = 20,["25"] = 20,["26"] = 20,["27"] = 20,["28"] = 20,["29"] = 19,["30"] = 19,["31"] = 27,["32"] = 28,["33"] = 29,["34"] = 30,["35"] = 31,["36"] = 32,["39"] = 27,["40"] = 37,["41"] = 5,["42"] = 43,["43"] = 44,["44"] = 43});
local ____exports = {}
local function showCursorWindowChooser()
    local cursorApp = hs.application.get("Cursor")
    if not cursorApp then
        hs.alert.show("Cursor is not running")
        return
    end
    local windows = __TS__ArrayFilter(
        cursorApp:allWindows(),
        function(____, win) return win:isStandard() end
    )
    if #windows == 0 then
        hs.alert.show("No standard Cursor windows found")
        return
    end
    local choices = __TS__ArrayMap(
        windows,
        function(____, win)
            return {
                text = win:title() or "Untitled Window",
                subText = "Cursor",
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
    chooser:choices(choices):placeholderText("Select a Cursor window..."):searchSubText(true):show()
end
function ____exports.apply(prefix)
    prefix.bind("c", showCursorWindowChooser)
end
return ____exports

local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 3,["10"] = 4,["11"] = 6,["12"] = 7,["13"] = 8,["14"] = 9,["15"] = 11,["16"] = 16,["18"] = 19,["19"] = 20,["20"] = 20,["21"] = 20,["22"] = 20,["23"] = 21,["24"] = 22,["27"] = 6,["28"] = 27,["29"] = 28,["30"] = 29,["31"] = 27,["32"] = 32,["33"] = 33,["34"] = 34,["35"] = 32,["36"] = 37,["37"] = 38,["38"] = 37});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "keyboard"
____exports.log = hs.logger.new(____exports.moduleName, "info")
function ____exports.useSquirrel()
    local currentID = hs.keycodes.currentSourceID()
    local currentMethod = hs.keycodes.currentMethod()
    local isSquirrel = currentID and __TS__StringIncludes(currentID, "Squirrel") or currentMethod and __TS__StringIncludes(currentMethod, "Squirrel")
    if isSquirrel then
        hs.eventtap.keyStroke({"ctrl", "shift", "alt"}, "f2")
    else
        local methods = hs.keycodes.methods()
        local squirrel = __TS__ArrayFind(
            methods,
            function(____, method) return __TS__StringIncludes(method, "Squirrel") end
        )
        if squirrel then
            hs.keycodes.setMethod(squirrel)
        end
    end
end
function ____exports.bindSquirrelHotkey()
    ____exports.log.i("Binding squirrel hotkey...")
    hs.hotkey.bind({"cmd"}, "escape", ____exports.useSquirrel)
end
local function init()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
    ____exports.bindSquirrelHotkey()
end
function ____exports.apply()
    init()
end
return ____exports

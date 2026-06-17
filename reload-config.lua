local ____lualib = require("lualib_bundle")
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 3,["10"] = 4,["11"] = 6,["12"] = 7,["13"] = 7,["14"] = 7,["15"] = 7,["16"] = 6,["17"] = 10,["18"] = 11,["19"] = 12,["21"] = 10,["22"] = 16,["23"] = 18,["24"] = 19,["25"] = 20,["26"] = 18,["27"] = 23,["28"] = 24,["29"] = 23});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "reload-config"
____exports.log = hs.logger.new(____exports.moduleName, "info")
function ____exports.isNeedReloadConfig(files)
    return __TS__ArraySome(
        files,
        function(____, file) return __TS__StringEndsWith(file, ".lua") end
    )
end
function ____exports.reloadConfigIfNeed(files)
    if ____exports.isNeedReloadConfig(files) then
        hs.reload()
    end
end
____exports.watcher = hs.pathwatcher.new(hs.configdir, ____exports.reloadConfigIfNeed)
local function init()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
    ____exports.watcher:start()
end
function ____exports.apply()
    init()
end
return ____exports

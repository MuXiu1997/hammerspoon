local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 3,["6"] = 4,["7"] = 5,["8"] = 6,["9"] = 6,["10"] = 8,["11"] = 9,["12"] = 11,["13"] = 12,["14"] = 13,["15"] = 14,["16"] = 15,["17"] = 11});
local ____exports = {}
local audio = require("prefix-ctrl-s.audio")
local cursor = require("prefix-ctrl-s.cursor")
local edge = require("prefix-ctrl-s.edge")
local ____modal = require("prefix-ctrl-s.modal")
local prefixController = ____modal.prefixController
____exports.moduleName = "prefix-ctrl-s"
____exports.log = hs.logger.new(____exports.moduleName, "info")
function ____exports.apply()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
    audio.apply(prefixController)
    cursor.apply(prefixController)
    edge.apply(prefixController)
end
return ____exports

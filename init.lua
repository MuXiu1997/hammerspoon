local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 3,["6"] = 4,["7"] = 5,["8"] = 6,["9"] = 7,["10"] = 9,["11"] = 10,["12"] = 11,["13"] = 12,["14"] = 14});
local ____exports = {}
local keyboard = require("keyboard")
local prefixCtrlS = require("prefix-ctrl-s.index")
local reloadConfig = require("reload-config")
local wezterm = require("wezterm")
require("hs.ipc")
reloadConfig.apply()
keyboard.apply()
prefixCtrlS.apply()
wezterm.apply()
hs.alert.show("Hammerspoon config loaded")
return ____exports

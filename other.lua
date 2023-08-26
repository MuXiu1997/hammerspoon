local JETBRAINS_BIN_DIR = getEnv('JETBRAINS_BIN')

local jetbrainsBinDirWatcher = hs.pathwatcher.new(JETBRAINS_BIN_DIR, function()
  ---@language "Shell Script"
  local script1 = ([[
    python3 %s/update_mos_jetbrains_paths.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script1, true)

  ---@language "Shell Script"
  local script2 = ([[
    python3 %s/update_jetbrains_icons.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script2, true)
end)

local edgeWatcher = hs.pathwatcher.new('/Applications/Microsoft Edge.app/Icon\r', function(paths, flagTables)
  if paths[1] ~= '/Applications/Microsoft Edge.app/Icon\r' then return end
  if flagTables[1].itemRemoved ~= true then return end
  ---@language "Shell Script"
  local script = ([[
    fileicon set '/Applications/Microsoft Edge.app' %s/Projects/icons/Edge.icns && killall Dock
  ]]):format(USER_HOME)
  hs.execute(script, true)
end)

local function autorun()
  jetbrainsBinDirWatcher:start()
  edgeWatcher:start()
end
autorun()

---@module other
---@field public jetbrainsBinDirWatcher table
---@field public edgeWatcher table
local module = {
  jetbrainsBinDirWatcher = jetbrainsBinDirWatcher,
  edgeWatcher = edgeWatcher,
}

return module

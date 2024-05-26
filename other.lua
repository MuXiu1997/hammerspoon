local JETBRAINS_BIN_DIR = getEnv('JETBRAINS_BIN')

local function updateMosJetbrainsPaths()
  ---@language "Shell Script"
  local script = ([[
    python3 %s/update_mos_jetbrains_paths.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script, true)
end

local function updateJetbrainsIcons()
  ---@language "Shell Script"
  local script = ([[
    python3 %s/update_jetbrains_icons.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script, true)
end

local function updateEdgeIcon()
  ---@language "Shell Script"
  local script = ([[
    fileicon set '/Applications/Microsoft Edge.app' %s/Projects/icons/Edge.icns && killall Dock
  ]]):format(USER_HOME)
  hs.execute(script, true)
end

local jetbrainsBinDirWatcher = hs.pathwatcher.new(JETBRAINS_BIN_DIR, function()
  updateMosJetbrainsPaths()
  updateJetbrainsIcons()
end)

local edgeWatcher = hs.pathwatcher.new('/Applications/Microsoft Edge.app/Icon\r', function(paths, flagTables)
  if paths[1] ~= '/Applications/Microsoft Edge.app/Icon\r' then return end
  if flagTables[1].itemRemoved ~= true then return end
  ---@language "Shell Script"
  updateEdgeIcon()
end)

local function autorun()
  jetbrainsBinDirWatcher:start()
  edgeWatcher:start()
end
autorun()

-- use `open -g "hammerspoon://other.updateMosJetbrainsPaths"`
hs.urlevent.bind('other.updateMosJetbrainsPaths', updateMosJetbrainsPaths)
-- use `open -g "hammerspoon://other.updateJetbrainsIcons"`
hs.urlevent.bind('other.updateJetbrainsIcons', updateJetbrainsIcons)
-- use `open -g "hammerspoon://other.updateEdgeIcon"`
hs.urlevent.bind('other.updateEdgeIcon', updateEdgeIcon)

---@module other
---@field public updateMosJetbrainsPaths function
---@field public updateJetbrainsIcons function
---@field public updateEdgeIcon function
---@field public jetbrainsBinDirWatcher table
---@field public edgeWatcher table
local module = {
  jetbrainsBinDirWatcher = jetbrainsBinDirWatcher,
  edgeWatcher = edgeWatcher,
  updateMosJetbrainsPaths = updateMosJetbrainsPaths,
  updateJetbrainsIcons = updateJetbrainsIcons,
  updateEdgeIcon = updateEdgeIcon,
}

return module

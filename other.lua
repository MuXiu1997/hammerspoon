local JETBRAINS_BIN_DIR = getEnv('JETBRAINS_BIN')

local jetbrainsBinDirWatcher = hs.pathwatcher.new(JETBRAINS_BIN_DIR, function()
  ---@language "Shell Script"
  local script1 = ([[
    python3 %s/update_mos_applications_path.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script1, true)

  ---@language "Shell Script"
  local script2 = ([[
    python3 %s/update_jetbrains_icons.py
  ]]):format(HAMMERSPOON_INTERNAL_SCRIPTS)
  hs.execute(script2, true)
end)

local function autorun()
  jetbrainsBinDirWatcher:start()
end
autorun()

---@module other
---@field public jetbrainsBinDirWatcher table
local module = {
  jetbrainsBinDirWatcher = jetbrainsBinDirWatcher,
}

return module

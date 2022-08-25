local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

local watcher = hs.pathwatcher.new(HAMMERSPOON_CONFIG_HOME, reloadConfig)
watcher:start()

---@module reloadConfig
---@field public watcher table
local module = {
  watcher = watcher,
}

return module

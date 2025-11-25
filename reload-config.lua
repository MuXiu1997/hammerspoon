---@module 'reload-config'
local M = {}

M.__name__ = 'reload-config'
M.log = hs.logger.new(M.__name__)

---@param files string[]
---@return boolean
function M.isNeedReloadConfig(files)
  return hs.fnutils.some(files, function(file)
    return file:sub(-4) == '.lua' or file:sub(-3) == '.py'
  end)
end

---@param files string[]
function M.reloadConfigIfNeed(files)
  if M.isNeedReloadConfig(files) then
    hs.reload()
  end
end

M.watcher = hs.pathwatcher.new(_G.HAMMERSPOON_CONFIG_HOME, M.reloadConfigIfNeed)

function M.__init__()
  M.log.i('Init [' .. M.__name__ .. '] module')
  M.watcher:start()
end

M.__init__()

return M

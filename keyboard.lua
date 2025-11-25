---@module 'keyboard'
local M = {}

M.__name__ = 'keyboard'
M.log = hs.logger.new(M.__name__)

---@return nil
function M.useSquirrel()
  local methods = hs.keycodes.methods()
  local squirrel = hs.fnutils.find(methods, function(method)
    return method:find('Squirrel')
  end)
  hs.keycodes.setMethod(squirrel)
end

function M.bindSquirrelHotkey()
  M.log.i('Bind squirrel hotkey')
  hs.hotkey.bind({ 'cmd', }, 'escape', M.useSquirrel)
end

function M.__init__()
  M.log.i('Init [' .. M.__name__ .. '] module')
  M.bindSquirrelHotkey()
end

M.__init__()

return M

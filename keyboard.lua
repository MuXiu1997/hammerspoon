hs.hotkey.bind({ 'cmd' }, 'escape', function()
  local methods = hs.keycodes.methods()
  local squirrel = hs.fnutils.find(methods, function(method)
    return method:find('Squirrel')
  end)
  hs.keycodes.setMethod(squirrel)
end)

---@module keyboard
local module = {
}

return module

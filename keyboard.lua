hs.hotkey.bind({ 'cmd' }, 'escape', function()
  hs.keycodes.setLayout('Squirrel')
  hs.keycodes.setMethod('Squirrel')
end)

---@module keyboard
local module = {
}

return module

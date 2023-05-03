--region global functions
---@param func function
---@param wait number
function _G.debounce(func, wait)
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = hs.timer.doAfter(wait, function()
      func()
      timer = nil
    end)
    timer:start()
  end
end

---@param path string
---@return string
function _G.readFile(path)
  local file = io.open(path, 'r')
  local content = file:read('*a')
  file:close()
  return content
end

---@param str string
---@return string
function _G.trim(str)
  return str:gsub('^%s*(.-)%s*$', '%1')
end

---@param path string
function _G.mkdir(path)
  ---@language "Shell Script"
  local script = ([[
    mkdir -p '%s'
  ]]):format(path)
  os.execute(script)
end

---@param name string
---@return string
function _G.getEnv(name)
  ---@language "Shell Script"
  local script = [[echo -n \$]] .. name
  local output, _ = hs.execute(script, true)
  return output
end
--endregion global functions

_G.USER_HOME = getEnv('HOME')
_G.XDG_CONFIG_HOME = getEnv('XDG_CONFIG_HOME') or _G.USER_HOME .. '/.config'
_G.HAMMERSPOON_CONFIG_HOME = XDG_CONFIG_HOME .. '/hammerspoon'
_G.HAMMERSPOON_INTERNAL_SCRIPTS = HAMMERSPOON_CONFIG_HOME .. '/internal_scripts'
_G.SSID_HOME = getEnv('MUXIU1997_SSID_HOME')
_G.SSID_WORK = getEnv('MUXIU1997_SSID_WORK')
_G.NAS_HOST = getEnv('MUXIU1997_NAS_HOST')
_G.NAS_USERNAME = getEnv('MUXIU1997_NAS_USERNAME')
_G.NAS_PASSWORD = getEnv('MUXIU1997_NAS_PASSWORD')

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
  ---@language Shell Script
  local script = ([[
    mkdir -p '%s'
  ]]).format(path)
  os.execute(script)
end
--endregion global functions

_G.USER_HOME = os.getenv('HOME')
_G.XDG_CONFIG_HOME = os.getenv('XDG_CONFIG_HOME') or _G.USER_HOME .. '/.config'
_G.HAMMERSPOON_CONFIG_HOME = XDG_CONFIG_HOME .. '/hammerspoon'
_G.SSID_HOME = trim(readFile(XDG_CONFIG_HOME .. '/muxiu1997/SSID-HOME'))
_G.NAS_HOST = trim(readFile(XDG_CONFIG_HOME .. '/muxiu1997/NAS-HOST'))
_G.NAS_USERNAME = trim(readFile(XDG_CONFIG_HOME .. '/muxiu1997/NAS-USERNAME'))
_G.NAS_PASSWORD = trim(readFile(XDG_CONFIG_HOME .. '/muxiu1997/NAS-PASSWORD'))

local function mountNAS()
  ---@language AppleScript
  local script = ([[
    tell application "Finder"
      open location "smb://%s:%s@%s/NAS"
    end tell
  ]]):format(NAS_USERNAME, NAS_PASSWORD, NAS_HOST)
  hs.osascript.applescript(script)
  hs.alert.show('NAS was mounted')
  print('Mount NAS')
end

local function unmountNAS()
  ---@language AppleScript
  local script = [[
    tell application "Finder"
      eject (every disk whose name is "NAS")
    end tell
  ]]
  hs.osascript.applescript(script)
  print('Unmount NAS')
end

-- use `open hammerspoon://nas.mountNAS`
hs.urlevent.bind('nas.mountNAS', mountNAS)
-- use `open hammerspoon://nas.unmountNAS`
hs.urlevent.bind('nas.unmountNAS', unmountNAS)

---@module nas
---@field public mountNAS fun():void
---@field public unmountNAS fun():void
local module = {
  mountNAS   = mountNAS,
  unmountNAS = unmountNAS,
}

return module

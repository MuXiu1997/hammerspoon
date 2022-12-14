local function openShadowsocks()
  local bundleID = 'com.qiuyuzhou.ShadowsocksX-NG'
  local shadowsocks = hs.application.open(bundleID, --[[ wait ]] 5)
  shadowsocks:hide()
  print('Open ShadowsocksX-NG')
end

local function quitShadowsocks()
  ---@language AppleScript
  local script = [[
    set shadowsocks to alias ((path to applications folder as text) & "ShadowsocksX-NG-R8.app") as text
    tell my application shadowsocks to if it is running then quit
  ]]
  hs.osascript.applescript(script)
  print('Quit ShadowsocksX-NG')
end

local function setDNS()
  ---@language Shell Script
  local script = [[
    networksetup -setdnsservers Wi-Fi 8.8.8.8
  ]]
  hs.execute(script)
  print('Set DNS to 8.8.8.8')
end

local function emptyDNS()
  ---@language Shell Script
  local script = [[
    networksetup -setdnsservers Wi-Fi "Empty"
  ]]
  hs.execute(script)
  print('Empty DNS')
end

local function openVPN()
  openShadowsocks()
  setDNS()
end

local function closeVPN()
  quitShadowsocks()
  emptyDNS()
end

hs.urlevent.bind('vpn.openVPN', openVPN)
hs.urlevent.bind('vpn.closeVPN', closeVPN)

---@module vpn
---@field public openVPN fun():void
---@field public closeVPN fun():void
local module = {
  openVPN  = openVPN,
  closeVPN = closeVPN,
}

return module

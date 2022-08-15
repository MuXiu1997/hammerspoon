require('global')
require('reload-config')
require('sync')
local wifi = require('wifi')
local vpn = require('vpn')
local nas = require('nas')

wifi.onAtHome(function()
  vpn.closeVPN()
  nas.mountNAS()
end)

wifi.onElsewhere(function() 
  vpn.openVPN()
  nas.unmountNAS()
end)

hs.alert.show('Hammerspoon config loaded')

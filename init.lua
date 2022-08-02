require('global')
require('reload-config')
local wifi = require('wifi')
local vpn = require('vpn')
local nas = require('nas')

wifi.onAtHome(function()
  vpn.closeVPN()
  nas.mountNAS()
end)

wifi.onElsewhere(function() 
  vpn.openVPN()
  nas.umountNAS()
end)

hs.alert.show('Hammerspoon config loaded')

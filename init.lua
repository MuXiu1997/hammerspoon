require('global')
require('reload-config')
require('sync')
require('keyboard')
require('other')
local wifi = require('wifi')
local nas = require('nas')

wifi.onAtHome(function()
  nas.mountNAS()
end)

wifi.onAtWork(function()
  nas.unmountNAS()
end)

wifi.onElsewhere(function()
  nas.unmountNAS()
end)

hs.alert.show('Hammerspoon config loaded')

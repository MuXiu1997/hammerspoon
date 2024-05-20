hs.logger.defaultLogLevel = 'info'
require('global')
require('reload-config')
require('keyboard')
require('kill-legacy-screen-saver')
require('other')

if DEVICE_ID == 'MACBOOKPRO-MUXIU' then
  require('sync')
end

if DEVICE_ID == 'MACBOOKPRO-MUXIU' then
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
end

hs.alert.show('Hammerspoon config loaded')

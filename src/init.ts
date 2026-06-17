/** @noSelfInFile */

import * as keyboard from './keyboard'
import * as prefixCtrlS from './prefix-ctrl-s'
import * as reloadConfig from './reload-config'
import * as wezterm from './wezterm'
import 'hs.ipc'

reloadConfig.apply()
keyboard.apply()
prefixCtrlS.apply()
wezterm.apply()

hs.alert.show('Hammerspoon config loaded')

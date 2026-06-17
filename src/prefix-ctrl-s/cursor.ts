/** @noSelfInFile */

import type { PrefixController } from './modal'

function showCursorWindowChooser() {
  const cursorApp = hs.application.get('Cursor')
  if (!cursorApp) {
    hs.alert.show('Cursor is not running')
    return
  }

  const windows = cursorApp.allWindows().filter(win => win.isStandard())

  if (windows.length === 0) {
    hs.alert.show('No standard Cursor windows found')
    return
  }

  const choices = windows.map((win) => {
    return {
      text: win.title() || 'Untitled Window',
      subText: 'Cursor',
      window: win,
    }
  })

  const chooser = hs.chooser.new((choice: any) => {
    if (choice && choice.window) {
      const win = choice.window as hs.Window
      win.focus()
      if (win.isMinimized()) {
        win.unminimize()
      }
    }
  })

  chooser.choices(choices)
    .placeholderText('Select a Cursor window...')
    .searchSubText(true)
    .show()
}

export function apply(prefix: PrefixController): void {
  prefix.bind('c', showCursorWindowChooser)
}

/** @noSelfInFile */

export interface PrefixController {
  bind: (this: void, key: string, fn: (this: void) => void) => void
}

const prefixModal = hs.hotkey.modal.new()
const prefixHotkey = hs.hotkey.bind(['ctrl'], 's', () => prefixModal.enter())

let alertId: string | undefined
let timeoutTimer: hs.timer.Timer | undefined

function clearTimer() {
  if (timeoutTimer) {
    timeoutTimer.stop()
    timeoutTimer = undefined
  }
}

prefixModal.entered = function () {
  if (alertId) {
    hs.alert.closeSpecific(alertId)
  }
  alertId = hs.alert.show('Prefix Mode (Ctrl+S)', {
    textSize: 20,
    radius: 10,
    fillColor: { white: 0, alpha: 0.7 },
    strokeColor: { white: 1, alpha: 0.5 },
  }, hs.screen.mainScreen(), 999999)

  clearTimer()
  timeoutTimer = hs.timer.doAfter(2, () => {
    prefixModal.exit()
  })
}

prefixModal.exited = function () {
  if (alertId) {
    hs.alert.closeSpecific(alertId)
    alertId = undefined
  }
  clearTimer()
}

prefixModal.bind(['ctrl'], 's', () => {
  prefixModal.exit()
  // Temporarily disable the entry hotkey to prevent simulated keystrokes from triggering a loop.
  prefixHotkey.disable()
  hs.eventtap.keyStroke(['ctrl'], 's')
  hs.timer.doAfter(0.1, () => prefixHotkey.enable())
})

export const prefixController: PrefixController = {
  bind(key, fn) {
    prefixModal.bind([], key, () => {
      prefixModal.exit()
      fn()
    })
  },
}

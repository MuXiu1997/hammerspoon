/** @noSelfInFile */

import type { PrefixController } from './modal'

const blueutilPath = '/opt/homebrew/bin/blueutil'
const headphonesBluetoothAddress = '50-f3-51-0c-32-f7'
const headphonesOutputUID = `${headphonesBluetoothAddress.toUpperCase()}:output`
const headphonesVolume = 45

function findBuiltInOutputDevice(): hs.audiodevice.AudioDevice | undefined {
  return hs.audiodevice.allOutputDevices().find(device => device.transportType() === 'Built-in')
}

function setOutputDevice(device: hs.audiodevice.AudioDevice, volume?: number): boolean {
  const ok = device.setDefaultOutputDevice()
  if (!ok) {
    hs.alert.show(`Failed to switch to ${device.name()}`)
    return false
  }

  if (volume !== undefined) {
    device.setVolume(volume)
  }

  return true
}

function switchToBuiltInOutput() {
  const device = findBuiltInOutputDevice()
  if (!device) {
    hs.alert.show('Built-in output device not found')
    return
  }

  if (setOutputDevice(device)) {
    hs.alert.show(`Switched to ${device.name()}`)
  }
}

function areHeadphonesConnected(): boolean {
  const [output] = hs.execute(`${blueutilPath} --is-connected ${headphonesBluetoothAddress}`, true)
  return output.trim() === '1'
}

function ensureHeadphonesConnected(): boolean {
  if (hs.audiodevice.findOutputByUID(headphonesOutputUID)) {
    return true
  }

  if (areHeadphonesConnected()) {
    return true
  }

  hs.execute(`${blueutilPath} --connect ${headphonesBluetoothAddress}`, true)
  return true
}

function connectAndSwitchToHeadphones() {
  if (!ensureHeadphonesConnected()) {
    hs.alert.show('Failed to connect AirPods')
    return
  }

  hs.timer.doAfter(1, () => {
    const device = hs.audiodevice.findOutputByUID(headphonesOutputUID)
    if (!device) {
      hs.alert.show('AirPods output device not found')
      return
    }

    if (setOutputDevice(device, headphonesVolume)) {
      hs.alert.show(`Switched to ${device.name()} at ${headphonesVolume}%`)
    }
  })
}

function showAudioChooser() {
  const choices = [
    {
      text: 'AirPods',
      subText: 'Connect Bluetooth, switch output, and set volume to 45%',
      actionId: 'headphones',
    },
    {
      text: 'Built-in Output',
      subText: 'Switch to the built-in speaker output device',
      actionId: 'built-in',
    },
  ]

  const chooser = hs.chooser.new((choice: any) => {
    if (!choice) {
      return
    }

    if (choice.actionId === 'built-in') {
      switchToBuiltInOutput()
    }
    else if (choice.actionId === 'headphones') {
      connectAndSwitchToHeadphones()
    }
  })

  chooser.choices(choices)
    .placeholderText('Select an audio action...')
    .searchSubText(true)
    .show()
}

export function apply(prefix: PrefixController): void {
  prefix.bind('a', showAudioChooser)
}

/** @noSelfInFile */

/** @noResolution */
declare module 'hs.ipc' {
}

declare namespace hs {
  const configdir: string

  function reload(): void

  function execute(this: void, command: string, withUserEnvironment?: boolean): LuaMultiReturn<[string, boolean, string, number]>

  namespace logger {
    /** @noSelf */
    function _new(this: void, name: string, logLevel?: string): Logger
    export { _new as new }

    interface Logger {
      i: (this: void, message: string) => void
      d: (this: void, message: string) => void
      e: (this: void, message: string) => void
      w: (this: void, message: string) => void
      f: (this: void, fmt: string, ...args: any[]) => void
    }
  }

  namespace alert {
    const defaultStyle: any
    function show(this: void, message: string, duration?: number): string
    function show(this: void, message: string, style: any, screen: any, duration?: number): string
    function closeSpecific(this: void, id: string): void
  }

  namespace screen {
    function mainScreen(this: void): any
  }

  namespace timer {
    function secondsSinceEpoch(this: void): number
    function waitUntil(this: void, predicate: (this: void) => boolean, action: (this: void) => void, checkInterval?: number): void
    function doAfter(this: void, seconds: number, fn: (this: void) => void): Timer

    interface Timer {
      stop: (this: Timer) => Timer
      start: (this: Timer) => Timer
      running: (this: Timer) => boolean
    }
  }

  namespace window {
    function allWindows(this: void): Window[]
    function focusedWindow(this: void): Window | undefined
    function get(this: void, hint: string): Window | undefined
    function find(this: void, hint: string): Window | undefined
  }

  namespace chooser {
    /** @noSelf */
    function _new(this: void, completionFn: (this: void, result: Choice | undefined) => void): Chooser
    export { _new as new }

    interface Choice {
      text: string
      subText?: string
      image?: any
      [key: string]: any
    }

    interface Chooser {
      show: (this: Chooser) => Chooser
      hide: (this: Chooser) => Chooser
      choices: (this: Chooser, choices: Choice[] | ((this: void) => Choice[])) => Chooser
      placeholderText: (this: Chooser, text: string) => Chooser
      searchSubText: (this: Chooser, enable: boolean) => Chooser
    }
  }

  namespace application {
    interface Application {
      isRunning: (this: Application) => boolean
      mainWindow: (this: Application) => Window | undefined
      focusedWindow: (this: Application) => Window | undefined
      allWindows: (this: Application) => Window[]
      activate: (this: Application) => boolean
      unhide: (this: Application) => boolean
      setFrontmost: (this: Application, allWindows?: boolean) => boolean
      isFrontmost: (this: Application) => boolean
      hide: (this: Application) => boolean
      title: (this: Application) => string
      name: (this: Application) => string
    }
    function get(this: void, hint: string): Application | undefined
    function frontmostApplication(this: void): Application | undefined
    function launchOrFocusByBundleID(this: void, bundleID: string): boolean
  }

  namespace audiodevice {
    interface AudioDevice {
      name: (this: AudioDevice) => string
      uid: (this: AudioDevice) => string
      isInputDevice: (this: AudioDevice) => boolean
      isOutputDevice: (this: AudioDevice) => boolean
      transportType: (this: AudioDevice) => string
      setDefaultOutputDevice: (this: AudioDevice) => boolean
      setVolume: (this: AudioDevice, volume: number) => boolean
    }

    function allDevices(this: void): AudioDevice[]
    function allInputDevices(this: void): AudioDevice[]
    function allOutputDevices(this: void): AudioDevice[]
    function findDeviceByName(this: void, name: string): AudioDevice | undefined
    function findDeviceByUID(this: void, uid: string): AudioDevice | undefined
    function findInputByName(this: void, name: string): AudioDevice | undefined
    function findInputByUID(this: void, uid: string): AudioDevice | undefined
    function findOutputByName(this: void, name: string): AudioDevice | undefined
    function findOutputByUID(this: void, uid: string): AudioDevice | undefined
    function defaultOutputDevice(this: void): AudioDevice | undefined
    function defaultInputDevice(this: void): AudioDevice | undefined
    function defaultEffectDevice(this: void): AudioDevice | undefined
    function current(this: void, input?: boolean): AudioDevice | undefined
  }

  interface Window {
    focus: (this: Window) => boolean
    raise: (this: Window) => Window
    screen: (this: Window) => any
    frame: (this: Window) => { x: number, y: number, w: number, h: number }
    setFrame: (this: Window, frame: { x: number, y: number, w: number, h: number }) => Window
    isStandard: (this: Window) => boolean
    isMinimized: (this: Window) => boolean
    unminimize: (this: Window) => Window
    title: (this: Window) => string
    application: (this: Window) => hs.application.Application
  }

  namespace eventtap {
    export interface EventTap {
      start: (this: EventTap) => EventTap
      stop: (this: EventTap) => EventTap
    }
    export namespace event {
      const types: {
        flagsChanged: number
      }
      interface Event {
        getFlags: (this: Event) => {
          cmd?: boolean
          ctrl?: boolean
          shift?: boolean
          fn?: boolean
          alt?: boolean
        }
        getKeyCode: (this: Event) => number
      }
    }
    /** @noSelf */
    function _new(this: void, types: number[], fn: (this: void, event: event.Event) => boolean | void): EventTap
    export { _new as new }

    /** @noSelf */
    export function keyStroke(this: void, mods: string[], key: string, delay?: number): void
  }

  namespace osascript {
    /** @noSelf */
    function applescript(this: void, script: string): LuaMultiReturn<[boolean, any, { NSAppleScriptErrorBriefMessage?: string, NSAppleScriptErrorMessage?: string } | undefined]>
    /** @noSelf */
    function javascript(this: void, script: string): LuaMultiReturn<[boolean, any, any]>
  }

  namespace keycodes {
    function methods(this: void): string[]
    function setMethod(this: void, method: string): boolean
    function currentMethod(this: void): string | undefined
    function currentSourceID(this: void): string | undefined
  }

  namespace hotkey {
    interface Hotkey {
      enable: (this: Hotkey) => Hotkey
      disable: (this: Hotkey) => Hotkey
      delete: (this: Hotkey) => void
    }

    function bind(this: void, mods: string[], key: string, fn: (this: void) => void): Hotkey

    namespace modal {
      /** @noSelf */
      function _new(this: void, mods?: string[], key?: string, message?: string): Modal
      export { _new as new }

      interface Modal {
        enter: (this: Modal) => void
        exit: (this: Modal) => void
        bind: (this: Modal, mods: string[], key: string, pressedfn?: (this: void) => void, releasedfn?: (this: void) => void, repeatfn?: (this: void) => void) => Modal
        entered?: (this: void) => void
        exited?: (this: void) => void
      }
    }
  }

  namespace pathwatcher {
    /** @noSelf */
    function _new(this: void, path: string, fn: (this: void, files: string[]) => void): PathWatcher
    export { _new as new }

    interface PathWatcher {
      start: () => void
      stop: () => void
    }
  }
}

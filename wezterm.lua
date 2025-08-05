local WEZTERM_BUNDLE_ID = 'com.github.wez.wezterm'

---@return boolean
local function isWeztermFullyLaunched()
  local app = hs.application.get(WEZTERM_BUNDLE_ID)
  local isRunning = app ~= nil and app:isRunning()
  local win = app and app:mainWindow()
  local hasMainWindow = win ~= nil
  return isRunning and hasMainWindow
end

local lastFocused = {
  app = nil,
  win = nil,

  save = function(self)
    self.app = hs.application.frontmostApplication()
    if self.app then
      self.win = self.app:focusedWindow()
    else
      self.win = nil
    end
  end,

  restore = function(self)
    if self.app then
      self.app:activate()
      if self.win then
        self.win:focus()
      end
    end
    self.app = nil
    self.win = nil
  end
}

local launchingAlert = {
  currentAlertId = nil,

  show = function(self)
    self:close()
    self.currentAlertId = hs.alert.show("Launching WezTerm...", hs.alert.defaultStyle, hs.screen.mainScreen(), 1/0)
  end,

  close = function(self)
    if self.currentAlertId then
      hs.alert.closeSpecific(self.currentAlertId)
      self.currentAlertId = nil
    end
  end
}

local function maximizeWindow(win)
  if not win then return end
  local screen = win:screen()
  local screenFrame = screen:frame()
  win:setFrame(screenFrame)
end

local function showAndMaximize(app)
  if not app then return end
  app:unhide()
  app:setFrontmost(true)
  local win = app:mainWindow()
  maximizeWindow(win)
end

local function toggleWezterm()
  local app = hs.application.get(WEZTERM_BUNDLE_ID)

  if not app then
    lastFocused:save()
    launchingAlert:show()
    hs.application.launchOrFocusByBundleID(WEZTERM_BUNDLE_ID)
    hs.timer.waitUntil(
      isWeztermFullyLaunched,
      function()
        launchingAlert:close()
        local app = hs.application.get(WEZTERM_BUNDLE_ID)
        showAndMaximize(app)
      end,
      0.1
    )
    return
  end

  if not app:isFrontmost() then
    lastFocused:save()
    showAndMaximize(app)
    return
  end

  app:hide()
  lastFocused:restore()
end

local function createOptionDoublePressWatcher(callback)
  local lastOptionPress = 0
  local optionKeyTimer = nil
  local doublePressTimeout = 0.3

  local eventtap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    local isOptionKeyEvent = false

    if flags.alt and not (flags.cmd or flags.ctrl or flags.shift or flags.fn) then
      isOptionKeyEvent = true
    end

    if not next(flags) then
      if optionKeyTimer then
        optionKeyTimer:stop()
        optionKeyTimer = nil
      end
      return false
    end

    if isOptionKeyEvent then
      local now = hs.timer.secondsSinceEpoch()

      if optionKeyTimer then
        optionKeyTimer:stop()
        optionKeyTimer = nil
      end

      if (now - lastOptionPress) <= doublePressTimeout then
        callback()
        lastOptionPress = 0
        return true
      end

      lastOptionPress = now

      optionKeyTimer = hs.timer.doAfter(doublePressTimeout, function()
        lastOptionPress = 0
        optionKeyTimer = nil
      end)
    end

    return false
  end)

  return eventtap
end

local optionDoublePressWatcher = createOptionDoublePressWatcher(toggleWezterm)
optionDoublePressWatcher:start()

---@module wezterm
local module = {
  optionDoublePressWatcher = optionDoublePressWatcher,
}

return module
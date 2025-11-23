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
    self.currentAlertId = hs.alert.show("Launching WezTerm...", hs.alert.defaultStyle, hs.screen.mainScreen(), 1 / 0)
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

local function getFocusableWindow(app)
  if not app then return nil end

  local function prepareWindow(win)
    if not win or not win:isStandard() then return nil end
    if win:isMinimized() then
      win:unminimize()
    end
    return win
  end

  local win = prepareWindow(app:focusedWindow()) or prepareWindow(app:mainWindow())
  if win then return win end

  for _, candidate in ipairs(app:allWindows()) do
    win = prepareWindow(candidate)
    if win then return win end
  end

  return nil
end

local function showAndMaximize(app)
  if not app then return end
  app:unhide()
  app:setFrontmost(true)
  local win = getFocusableWindow(app)
  if not win then return end
  maximizeWindow(win)
  win:raise()
  win:focus()
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

local OPTION_KEYCODES = {
  [58] = true, -- left option
  [61] = true, -- right option
}

local function createOptionDoublePressWatcher(callback)
  local doublePressTimeout = 0.3
  local lastOptionRelease = 0
  local optionIsDown = false
  local optionWasPure = true

  local eventtap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    local keyCode = event:getKeyCode()
    local isOptionKey = OPTION_KEYCODES[keyCode] == true

    if optionIsDown and (flags.cmd or flags.ctrl or flags.shift or flags.fn) then
      optionWasPure = false
    end

    if not isOptionKey then
      if not flags.alt then
        optionIsDown = false
        optionWasPure = true
      end
      return false
    end

    if flags.alt then
      optionIsDown = true
    else
      if optionIsDown and optionWasPure then
        local now = hs.timer.secondsSinceEpoch()
        if (now - lastOptionRelease) <= doublePressTimeout then
          callback()
          lastOptionRelease = 0
          optionIsDown = false
          optionWasPure = true
          return true
        else
          lastOptionRelease = now
        end
      end

      optionIsDown = false
      optionWasPure = true
    end

    return false
  end)

  return eventtap
end

local optionDoublePressWatcher = createOptionDoublePressWatcher(toggleWezterm)
optionDoublePressWatcher:start()

---@module "wezterm"
local module = {
  optionDoublePressWatcher = optionDoublePressWatcher,
}

return module

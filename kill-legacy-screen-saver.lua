local log = hs.logger.new('kill_legacy_screen_saver')

---@return number
local function getScreensaverWaitTime()
  ---@language "Shell Script"
  local script = [[
    defaults -currentHost read com.apple.screensaver idleTime
  ]]
  local output, _, _, _ = hs.execute(script)
  local waitTime = tonumber(output)
  if waitTime == nil then
    return 0
  end
  return waitTime
end

---@return number
local function getIdleTime()
  ---@language "Shell Script"
  local script = [[
    ioreg -n IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}'
  ]]
  local output, _, _, _ = hs.execute(script)
  local idleTime = tonumber(output)
  if idleTime == nil then
    return 0
  end
  return idleTime
end

---@return number[]
local function getLegacyScreenSaverPIDs()
  ---@language "Shell Script"
  local script = [[
    ps aux | grep 'legacyScreenSaver-x86_64' | grep -v grep | awk '{print $2}'
  ]]
  local output, _, _, _ = hs.execute(script)
  local pids = {}
  for pid in string.gmatch(output, '%d+') do
    table.insert(pids, tonumber(pid))
  end
  return pids
end

---@param pids number[]
local function killLegacyScreenSaver(pids)
  hs.execute('kill -9 ' .. table.concat(pids, ' '))
end

local function killLegacyScreenSaverIfNotIdle()
  local idleTime = getIdleTime()
  if idleTime < getScreensaverWaitTime() then
    return
  end
  local pids = getLegacyScreenSaverPIDs()
  if #pids == 0 then
    return
  end
  log.i('Kill legacyScreenSaver-x86_64, pids: ' .. hs.inspect(pids))
  killLegacyScreenSaver(pids)
end

local timerEveryScreensaverWaitTime = (function()
  local screensaverWaitTime = getScreensaverWaitTime()
  if screensaverWaitTime == 0 then
    log.i('Screensaver is disabled, do not kill legacyScreenSaver-x86_64')
    return nil
  end
  log.i('Screensaver wait time: ' .. screensaverWaitTime)
  return hs.timer.doEvery(
    hs.timer.seconds(screensaverWaitTime),
    killLegacyScreenSaverIfNotIdle
  )
end)()

local function autorun()
  if timerEveryScreensaverWaitTime == nil then
    return
  end
  timerEveryScreensaverWaitTime:start()
end
autorun()

---@module kill_legacy_screen_saver
local module = {
  timerEveryScreensaverWaitTime = timerEveryScreensaverWaitTime,
  log = log,
}

return module

---@return number
local function getScreensaverWaitTime()
  ---@language "Shell Script"
  local script = [[
    defaults -currentHost read com.apple.screensaver idleTime
  ]]
  local output, _, _, _ = hs.execute(script)
  local waitTime = tonumber(output)
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
  print('Kill legacyScreenSaver-x86_64, pids: ' .. hs.inspect(pids))
  killLegacyScreenSaver(pids)
end

local timerEveryScreensaverWaitTime = hs.timer.doEvery(
  hs.timer.seconds(getScreensaverWaitTime()),
  killLegacyScreenSaverIfNotIdle
)

local function autorun()
  timerEveryScreensaverWaitTime:start()
end
autorun()

---@module kill-legacy-screen-saver
local module = {
  timerEveryMinute = timerEveryScreensaverWaitTime,
}

return module

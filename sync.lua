local DROPBOX_HOME = USER_HOME .. '/Dropbox'
local SYNC_DIR = DROPBOX_HOME .. '/Sync'
local RSYNC_EXECUTABLE, _, _, _ = hs.execute("which rsync", true)
RSYNC_EXECUTABLE = trim(RSYNC_EXECUTABLE)

---@param src string
---@param relDst string
local function syncDir(src, relDst)
  local dst = SYNC_DIR .. '/' .. relDst
  mkdir(dst)
  local task = hs.task.new(
    RSYNC_EXECUTABLE,
    function(exitCode, _, stdErr)
      if exitCode ~= 0 then
        local errMsg = 'Sync failed: ' .. hs.inspect(stdErr)
        hs.alert.show(errMsg)
        print(errMsg)
        return
      end
      print('Task: Synced ' .. hs.inspect(src) .. ' to ' .. hs.inspect(dst))
    end,
    function() return true end,
    { '-av', '--delete', src, dst }
  )
  task:start()
end

local function syncRime()
  ---@language "Shell Script"
  local script = [[
    /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --sync
  ]]
  hs.execute(script)
  print('Task: Rime Synced')
end

---@type table<string, string>
local toBeSynced = {
  [USER_HOME .. '/Library/Preferences/']                                       = 'Preferences',
  [USER_HOME .. '/Library/Application Support/Alfred/']                        = 'Alfred',
  [USER_HOME .. '/Library/Application Support/PremiumSoft CyberTech/']         = 'PremiumSoft CyberTech',
  [USER_HOME .. '/Library/Application Support/another-redis-desktop-manager/'] = 'another-redis-desktop-manager',
}

local function sync()
  for src, relDst in pairs(toBeSynced) do
    syncDir(src, relDst)
  end
  syncRime()
end

local timerEveryHour = hs.timer.doEvery(hs.timer.hours(1), sync)

local function autorun()
  hs.timer.doAfter(30, function() sync() end):start()
  timerEveryHour:start()
end
autorun()

---@module sync
local module = {
  timerEveryHour = timerEveryHour
}

return module

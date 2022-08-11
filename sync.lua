local DROPBOX_HOME = USER_HOME .. '/Dropbox'
local SYNC_DIR = DROPBOX_HOME .. '/Sync'

---@param src string
---@param relDst string
local function syncDir(src, relDst)
  local dst = SYNC_DIR .. '/' .. relDst
  mkdir(dst)
  ---@language Shell Script
  local script = ([[
    rsync -av --delete '%s' '%s'
  ]]):format(src, dst)
  local output, _, _, rc = hs.execute(script)
  if rc ~= 0 then
    hs.alert.show('Sync failed: ' .. output)
  end
  print('Sync ' .. hs.inspect(src) .. ' to ' .. hs.inspect(dst))
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
end

local function autorun()
  hs  .timer.doAfter(10, function()
    sync()
    hs.timer.doEvery(60 * 60, sync):start()
  end):start()
end
autorun()

---@alias Hook fun(): void
---@alias Hooks Hook[]
---@alias HookRegister fun(hook: Hook): void

---@type Hooks
local atHomeHooks = {}

---@type Hooks
local atWorkHooks = {}

---@type Hooks
local elsewhereHooks = {}

---@param hooks Hooks
local function invokeHooks (hooks)
  for _, hook in ipairs(hooks) do
    hook()
  end
end

---@type fun(): void
local handler = debounce(function()
  local currentNetwork = hs.wifi.currentNetwork()
  if currentNetwork == nil then return end
  print('Current network: ' .. hs.inspect(currentNetwork))
  if currentNetwork == SSID_HOME then
    invokeHooks(atHomeHooks)
    return
  end
  if currentNetwork == SSID_WORK then
    invokeHooks(atWorkHooks)
    return
  end
  invokeHooks(elsewhereHooks)
end, 1)

---@type HookRegister
local onAtHome = function(hook)
  atHomeHooks[#atHomeHooks + 1] = hook
end

---@type HookRegister
local onAtWork = function(hook)
  atWorkHooks[#atWorkHooks + 1] = hook
end

---@type HookRegister
local onElsewhere = function(hook)
  elsewhereHooks[#elsewhereHooks + 1] = hook
end

local watcher = hs.wifi.watcher.new(function(_, message)
  if message ~= 'SSIDChange' then return end
  handler()
end)
watcher:start()

local function autorun()
  hs.timer.doAfter(10, handler):start()
end
autorun()

---@module wifi
---@field public onAtHome HookRegister
---@field public onAtWork HookRegister
---@field public onElsewhere HookRegister
---@field public watcher table
local module = {
  onAtHome    = onAtHome,
  onAtWork    = onAtWork,
  onElsewhere = onElsewhere,
  watcher     = watcher,
}

return module

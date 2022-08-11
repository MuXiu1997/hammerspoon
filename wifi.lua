---@alias Hook fun(): void
---@alias Hooks Hook[]
---@alias HookRegister fun(hook: Hook): void

---@type Hooks
local atHomeHooks = {}

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
  print('Current network: ' .. currentNetwork)
  if currentNetwork == nil then return end
  if currentNetwork == SSID_HOME then
    invokeHooks(atHomeHooks)
    return
  end
  invokeHooks(elsewhereHooks)
end, 1)

---@type HookRegister
local onAtHome = function(hook)
  atHomeHooks[#atHomeHooks + 1] = hook
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
---@field public onElsewhere HookRegister
local module = {
  onAtHome    = onAtHome,
  onElsewhere = onElsewhere,
}

return module

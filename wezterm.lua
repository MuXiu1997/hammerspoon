local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 3,["8"] = 4,["9"] = 6,["10"] = 8,["11"] = 9,["12"] = 10,["13"] = 11,["14"] = 12,["15"] = 13,["16"] = 8,["17"] = 23,["18"] = 23,["19"] = 23,["20"] = 27,["21"] = 28,["22"] = 29,["23"] = 29,["24"] = 23,["25"] = 32,["26"] = 33,["27"] = 34,["28"] = 35,["30"] = 35,["33"] = 37,["34"] = 38,["35"] = 23,["36"] = 23,["37"] = 48,["38"] = 48,["39"] = 51,["40"] = 52,["41"] = 53,["42"] = 53,["43"] = 53,["44"] = 53,["45"] = 53,["46"] = 53,["47"] = 48,["48"] = 61,["49"] = 62,["50"] = 63,["51"] = 64,["53"] = 48,["54"] = 48,["55"] = 69,["56"] = 70,["59"] = 72,["60"] = 73,["61"] = 74,["62"] = 69,["63"] = 77,["64"] = 78,["65"] = 79,["67"] = 81,["68"] = 82,["69"] = 83,["71"] = 84,["72"] = 85,["74"] = 87,["75"] = 81,["76"] = 90,["77"] = 91,["78"] = 92,["80"] = 94,["81"] = 95,["82"] = 96,["83"] = 97,["86"] = 100,["87"] = 77,["88"] = 103,["89"] = 104,["92"] = 106,["93"] = 107,["94"] = 108,["95"] = 109,["98"] = 111,["99"] = 112,["100"] = 113,["101"] = 103,["102"] = 116,["103"] = 117,["104"] = 119,["105"] = 120,["106"] = 121,["107"] = 122,["108"] = 123,["109"] = 123,["110"] = 125,["111"] = 126,["112"] = 127,["113"] = 128,["114"] = 123,["115"] = 123,["116"] = 123,["119"] = 135,["120"] = 136,["121"] = 137,["124"] = 141,["125"] = 142,["126"] = 116,["127"] = 145,["128"] = 150,["129"] = 151,["130"] = 152,["131"] = 153,["132"] = 154,["133"] = 156,["134"] = 156,["135"] = 156,["136"] = 157,["137"] = 158,["138"] = 159,["139"] = 161,["140"] = 162,["142"] = 165,["143"] = 166,["144"] = 167,["145"] = 168,["147"] = 170,["149"] = 173,["150"] = 174,["152"] = 177,["153"] = 178,["154"] = 179,["155"] = 180,["156"] = 181,["157"] = 182,["158"] = 183,["159"] = 184,["161"] = 187,["164"] = 191,["165"] = 192,["167"] = 195,["168"] = 156,["169"] = 156,["170"] = 198,["171"] = 150,["172"] = 201,["173"] = 203,["174"] = 204,["175"] = 205,["176"] = 203,["177"] = 208,["178"] = 209,["179"] = 208});
local ____exports = {}
---
-- @noSelfInFile
____exports.moduleName = "wezterm"
____exports.log = hs.logger.new(____exports.moduleName, "info")
local WEZTERM_BUNDLE_ID = "com.github.wez.wezterm"
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
        local ____opt_2 = self.app
        self.win = ____opt_2 and ____opt_2:focusedWindow()
    end,
    restore = function(self)
        if self.app then
            self.app:activate()
            local ____opt_4 = self.win
            if ____opt_4 ~= nil then
                ____opt_4:focus()
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
        self.currentAlertId = hs.alert.show(
            "Launching WezTerm...",
            hs.alert.defaultStyle,
            hs.screen.mainScreen(),
            math.huge
        )
    end,
    close = function(self)
        if self.currentAlertId then
            hs.alert.closeSpecific(self.currentAlertId)
            self.currentAlertId = nil
        end
    end
}
local function maximizeWindow(win)
    if not win then
        return
    end
    local screen = win:screen()
    local screenFrame = screen:frame()
    win:setFrame(screenFrame)
end
local function getFocusableWindow(app)
    if not app then
        return nil
    end
    local function prepareWindow(win)
        if not win or not win:isStandard() then
            return nil
        end
        if win:isMinimized() then
            win:unminimize()
        end
        return win
    end
    local win = prepareWindow(app:focusedWindow()) or prepareWindow(app:mainWindow())
    if win then
        return win
    end
    for ____, candidate in ipairs(app:allWindows()) do
        win = prepareWindow(candidate)
        if win then
            return win
        end
    end
    return nil
end
local function showAndMaximize(app)
    if not app then
        return
    end
    app:unhide()
    app:setFrontmost(true)
    local win = getFocusableWindow(app)
    if not win then
        return
    end
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
                local currentApp = hs.application.get(WEZTERM_BUNDLE_ID)
                showAndMaximize(currentApp)
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
local OPTION_KEYCODES = {[58] = true, [61] = true}
local function createOptionDoublePressWatcher(callback)
    local doublePressTimeout = 0.3
    local lastOptionRelease = 0
    local optionIsDown = false
    local optionWasPure = true
    local eventtap = hs.eventtap.new(
        {hs.eventtap.event.types.flagsChanged},
        function(event)
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
                    if now - lastOptionRelease <= doublePressTimeout then
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
        end
    )
    return eventtap
end
____exports.optionDoublePressWatcher = createOptionDoublePressWatcher(toggleWezterm)
local function init()
    ____exports.log.i(("Initializing [" .. ____exports.moduleName) .. "] module...")
    ____exports.optionDoublePressWatcher:start()
end
function ____exports.apply()
    init()
end
return ____exports

-- SlashCommands.lua
-- Registers /rs (and /ressurectionsayings) with a full sub-command table.
-- Depends on: RessurectionSayings.lua (Core), Debug.lua, Chat.lua,
--             Sayings.lua, SpellData.lua

local RS = RessurectionSayings

-- ─────────────────────────────────────────────────────────────────────────────
-- Shared helpers
-- ─────────────────────────────────────────────────────────────────────────────
local function P(msg)   RS.Chat.Print(msg)  end
local function W(msg)   RS.Chat.Warn(msg)   end

local function DBReady()
    if not RS.db then
        P("|cffff4444Addon not fully loaded yet — try again in a moment.|r")
        return false
    end
    return true
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Command table
-- Each entry: { desc = string, fn = function(arg) }
-- ─────────────────────────────────────────────────────────────────────────────
local COMMANDS

local function PrintHelp()
    P("|cffffff00Ressurection Sayings " .. RS.VERSION .. "|r — commands:")
    -- Sort keys so output is alphabetical
    local keys = {}
    for k in pairs(COMMANDS) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, name in ipairs(keys) do
        print(("  |cffffff00/rs %-10s|r  %s"):format(name, COMMANDS[name].desc))
    end
end

COMMANDS = {

    -- ── Toggle ───────────────────────────────────────────────────────────────
    on = {
        desc = "Enable the addon.",
        fn = function()
            if not DBReady() then return end
            RS.db.profile.enabled = true
            P("|cff00ff00Enabled.|r")
        end,
    },

    off = {
        desc = "Disable the addon.",
        fn = function()
            if not DBReady() then return end
            RS.db.profile.enabled = false
            P("|cffff4444Disabled.|r")
        end,
    },

    -- ── Channel ──────────────────────────────────────────────────────────────
    channel = {
        desc = "<say|emote|local>  Set where sayings are spoken.",
        fn = function(arg)
            if not DBReady() then return end
            local MAP = { say = "SAY", emote = "EMOTE", ["local"] = "LOCAL" }
            local val = MAP[arg:lower()]
            if val then
                RS.db.profile.channel = val
                P("Channel set to |cffffff00"
                    .. (RS.Chat.GetChannelLabel(val) or val) .. "|r.")
            else
                W("Usage: /rs channel [say|emote|local]")
            end
        end,
    },

    -- ── Sayings ──────────────────────────────────────────────────────────────
    list = {
        desc = "[class]  List sayings for a class (defaults to your class).",
        fn = function(arg)
            if not DBReady() then return end
            local classFile
            if arg and arg ~= "" then
                classFile = arg:upper()
            else
                classFile = select(2, UnitClass("player"))
            end
            if not classFile or not RS.Sayings.CLASS_SAYINGS[classFile] then
                W("Unknown class '" .. tostring(arg) .. "'.  Try: warrior, paladin, priest, druid, shaman, warlock, mage, hunter, rogue")
                return
            end
            local pool = RS.Sayings.GetClassPool(classFile)
            P(("|cffffff00%s|r sayings (%d):"):format(classFile, #pool))
            for i, s in ipairs(pool) do
                print(("  |cffffff00%2d.|r %s"):format(i, s))
            end
        end,
    },

    -- ── Utility ──────────────────────────────────────────────────────────────
    test = {
        desc = "Speak a random saying right now (uses your own name + class).",
        fn = function()
            if not DBReady() then return end
            if not RS.db.profile.enabled then
                W("Addon is disabled — use |cffffff00/rs on|r first.")
                return
            end
            local name = UnitName("player") or "you"
            local _, classFile = UnitClass("player")
            local s = RS.Sayings.GetRandom(name, classFile)
            RS.Debug.Msg("test: '" .. (s or "") .. "'")
            RS.Chat.Speak(s)
        end,
    },

    -- ── Debug ─────────────────────────────────────────────────────────────────
    debug = {
        desc = "<on|off>  Toggle verbose error traces.",
        fn = function(arg)
            if not DBReady() then return end
            local a = arg:lower()
            if a == "on" then
                RS.db.profile.debug = true
                P("|cffffff00Debug mode ON.|r  Full stack traces will be shown on error.")
            elseif a == "off" then
                RS.db.profile.debug = false
                P("Debug mode |cff888888OFF|r.")
            else
                local state = RS.db.profile.debug and "|cffffff00ON|r" or "|cff888888OFF|r"
                P("Debug is currently " .. state .. ".  Usage: /rs debug [on|off]")
            end
        end,
    },

    -- ── Status ────────────────────────────────────────────────────────────────
    status = {
        desc = "Show current addon settings.",
        fn = function()
            if not DBReady() then return end
            local enabled = RS.db.profile.enabled
                and "|cff00ff00Enabled|r" or "|cffff4444Disabled|r"
            local ch  = RS.Chat.GetChannelLabel(RS.db.profile.channel) or RS.db.profile.channel
            local _, classFile = UnitClass("player")
            local pool  = classFile and RS.Sayings.GetClassPool(classFile)
            local count = pool and #pool or 0
            local src   = (RS.db.profile.classSayings and RS.db.profile.classSayings[classFile])
                          and "edited" or "default"
            local dbg   = RS.db.profile.debug and "|cffffff00ON|r" or "off"
            P(("Status: %s  |  Channel: |cffffff00%s|r  "
               .. "|  %s sayings: %d (%s)  |  Debug: %s")
               :format(enabled, ch, classFile or "?", count, src, dbg))
        end,
    },

    -- ── Options panel ─────────────────────────────────────────────────────────
    options = {
        desc = "Open the GUI options panel.",
        fn = function()
            if not (RS.Options and RS.Options.Open) then
                W("Options panel not available.")
                return
            end
            RS.Options.Open()
        end,
    },

    help = { desc = "Show this help text.", fn = PrintHelp },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Slash command registration
-- ─────────────────────────────────────────────────────────────────────────────
-- Register via AceConsole-3.0 (mixed into the RS addon object in Core)
local function HandleInput(msg)
    local rawCmd = msg:match("^(%S*)") or ""
    local rawArg = msg:match("^%S*%s*(.-)%s*$") or ""
    rawCmd = rawCmd:lower()

    if rawCmd == "" then
        PrintHelp()
        return
    end

    local entry = COMMANDS[rawCmd]
    if not entry then
        W(("Unknown command: '%s'  —  type |cffffff00/rs help|r"):format(rawCmd))
        return
    end

    RS.Debug.SafeCall(entry.fn, rawArg)
end

RS:RegisterChatCommand("rs", HandleInput)
RS:RegisterChatCommand("ressurectionsayings", HandleInput)

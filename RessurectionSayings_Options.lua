-- RessurectionSayings_Options.lua
-- Registers the Interface > AddOns config panel via AceConfig-3.0 +
-- AceConfigDialog-3.0.  No raw InterfaceOptions* calls needed.
-- Depends on: RessurectionSayings.lua (Core), Debug.lua, Chat.lua, Sayings.lua

local RS = RessurectionSayings

RS.Options = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helper: build a read-only class sayings tab for AceConfig
-- ─────────────────────────────────────────────────────────────────────────────
-- Max pre-allocated input slots per class (18 built-ins + room for extras)
local MAX_SLOTS = 40

-- Force AceConfigDialog to repaint all registered frames immediately.
-- Must be called any time pool data changes outside of a `set` callback
-- (i.e. from execute button funcs like Remove and Reset).
local function Notify()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("RessurectionSayings")
end

local function ClassTab(order, classFile, displayName, colorHex)
    local args = {
        info = {
            order    = 1,
            type     = "description",
            fontSize = "small",
            name     = "|cff888888Edit sayings for " .. displayName
                    .. ".  |cffff8800Clear a box to remove that saying.|r|cff888888  "
                    .. "{name} is replaced with the target's name at cast time.|r\n",
        },
        resetBtn = {
            order       = 2,
            type        = "execute",
            name        = "Reset to Defaults",
            desc        = "Restore all " .. displayName .. " sayings to the built-in list.",
            confirm     = true,
            confirmText = "Restore all " .. displayName .. " sayings to built-in defaults?",
            func        = function()
                RS.Sayings.ResetClass(classFile)
                RS.Chat.Print(displayName .. " sayings reset to defaults.")
                Notify()
            end,
        },
        spacer = { order = 3, type = "description", name = "\n" },
        addSaying = {
            order = 10 + MAX_SLOTS + 1,
            type  = "input",
            width = "full",
            name  = "|cff00ff00Add New Saying|r",
            desc  = "Type a new saying and press Enter.  Use {name} for the target's name.",
            get   = function() return "" end,
            set   = function(_, v)
                if v and v:match("%S") then
                    local ok, info = RS.Sayings.AddClassSaying(classFile, v)
                    if ok then
                        RS.Chat.Printf("|cffffff00" .. displayName .. "|r saying #%d added.", info)
                        Notify()
                    else
                        RS.Chat.Warn("Could not add: " .. tostring(info))
                    end
                end
            end,
        },
    }
    -- Pre-allocate MAX_SLOTS input + delete-button pairs.
    -- hidden() fires for both when the slot is beyond the live pool size.
    for i = 1, MAX_SLOTS do
        local idx = i
        local function isHidden()
            local pool = RS.Sayings.GetClassPool(classFile)
            return idx > (pool and #pool or 0)
        end
        args["s" .. i] = {
            order  = 10 + i,
            type   = "input",
            width  = "double",
            name   = function() return ("|cffffff00%d|r"):format(idx) end,
            hidden = isHidden,
            get    = function() return RS.Sayings.GetClassSaying(classFile, idx) end,
            set    = function(_, v) RS.Sayings.SetClassSaying(classFile, idx, v) end,
        }
        args["sdel" .. i] = {
            order    = 10 + i + 0.5,
            type     = "execute",
            name     = "|cffff4444Remove|r",
            desc     = "Delete this saying and compact the list.",
            hidden   = isHidden,
            disabled = function()
                local pool = RS.Sayings.GetClassPool(classFile)
                return (pool and #pool or 0) <= 1
            end,
            func     = function()
                RS.Sayings.SetClassSaying(classFile, idx, "")
                Notify()
            end,
        }
    end
    return {
        order = order,
        type  = "group",
        name  = "|cff" .. colorHex .. displayName .. "|r",
        args  = args,
    }
end

-- ─────────────────────────────────────────────────────────────────────────────
-- AceConfig-3.0 options table  (childGroups = "tab" gives the tab strip)
-- ─────────────────────────────────────────────────────────────────────────────
local optTable = {
    name        = "Ressurection Sayings",
    type        = "group",
    childGroups = "tab",
    args = {

        -- ── Tab 1: General ───────────────────────────────────────────────────
        general = {
            order = 1,
            type  = "group",
            name  = "General",
            args  = {
                settingsHeader = { order = 1, type = "header", name = "Settings" },

                enabled = {
                    order = 2,
                    type  = "toggle",
                    width = "full",
                    name  = "Enabled",
                    desc  = "Enable or disable Ressurection Sayings.",
                    get   = function() return RS.db.profile.enabled end,
                    set   = function(_, v)
                        RS.db.profile.enabled = v
                        RS.Debug.Msg("Options: enabled = " .. tostring(v))
                    end,
                },

                channel = {
                    order  = 3,
                    type   = "select",
                    name   = "Output Channel",
                    desc   = "Which chat channel to send the saying through when you rez someone.",
                    values = {
                        SAY   = "/say  (visible to nearby players)",
                        EMOTE = "/emote",
                        LOCAL = "Local chat frame only",
                    },
                    get = function() return RS.db.profile.channel end,
                    set = function(_, v)
                        RS.db.profile.channel = v
                        RS.Debug.Msg("Options: channel = " .. tostring(v))
                    end,
                },

                test = {
                    order = 4,
                    type  = "execute",
                    name  = "Test Saying",
                    desc  = "Speak a random saying using your own name and class.",
                    func  = function()
                        if not RS.db.profile.enabled then
                            RS.Chat.Warn("Addon is disabled — use |cffffff00/rs on|r first.")
                            return
                        end
                        RS.Debug.SafeCall(function()
                            local name = UnitName("player") or "you"
                            local _, classFile = UnitClass("player")
                            RS.Chat.Speak(RS.Sayings.GetRandom(name, classFile))
                        end)
                    end,
                },

                spacer1 = { order = 5, type = "description", name = "\n" },
            },
        },

        -- ── Tab 2: Generic fallbacks ─────────────────────────────────────────

        -- ── Class tabs ───────────────────────────────────────────────────────
        warrior = ClassTab(2,  "WARRIOR", "Warrior", "C79C6E"),
        paladin = ClassTab(3,  "PALADIN", "Paladin", "F58CBA"),
        priest  = ClassTab(4,  "PRIEST",  "Priest",  "FFFFFF"),
        druid   = ClassTab(5,  "DRUID",   "Druid",   "FF7D0A"),
        shaman  = ClassTab(6,  "SHAMAN",  "Shaman",  "0070DE"),
        warlock = ClassTab(7,  "WARLOCK", "Warlock", "9482C9"),
        mage    = ClassTab(8,  "MAGE",    "Mage",    "69CCF0"),
        hunter  = ClassTab(9,  "HUNTER",  "Hunter",  "ABD473"),
        rogue   = ClassTab(10, "ROGUE",   "Rogue",   "FFF569"),
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- RS.Options.Setup  —  registers the table with AceConfig and adds it to the
-- Interface > AddOns panel via AceConfigDialog.
-- Called from RS:OnInitialize() (AceDB is ready at that point).
-- ─────────────────────────────────────────────────────────────────────────────
function RS.Options.Setup()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("RessurectionSayings", optTable)
    RS.Options.frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
        "RessurectionSayings", "Ressurection Sayings")
    RS.Debug.Msg("Options registered via AceConfigDialog-3.0")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- RS.Options.Open  —  opens the dialog  (used by /rs options)
-- ─────────────────────────────────────────────────────────────────────────────
function RS.Options.Open()
    LibStub("AceConfigDialog-3.0"):Open("RessurectionSayings")
end



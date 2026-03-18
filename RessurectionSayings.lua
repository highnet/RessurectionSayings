-- RessurectionSayings.lua  (Core)
-- Creates the addon object via AceAddon-3.0 and mixes in AceConsole-3.0
-- (slash commands / Print) and AceEvent-3.0 (event registration).
-- MUST be the first addon file in the TOC — all other modules reference RS.

local ADDON_VERSION = "3.0.0"

-- ─────────────────────────────────────────────────────────────────────────────
-- Addon object  (AceAddon calls OnInitialize / OnEnable automatically)
-- ─────────────────────────────────────────────────────────────────────────────
local RS = LibStub("AceAddon-3.0"):NewAddon("RessurectionSayings",
    "AceConsole-3.0",
    "AceEvent-3.0")

-- Expose globally so every module file can do:  local RS = RessurectionSayings
RessurectionSayings = RS

RS.VERSION = ADDON_VERSION
RS.NAME    = "RessurectionSayings"

-- ─────────────────────────────────────────────────────────────────────────────
-- AceDB profile defaults
-- ─────────────────────────────────────────────────────────────────────────────
local DB_DEFAULTS = {
    profile = {
        enabled      = true,
        channel      = "SAY",   -- "SAY" | "EMOTE" | "LOCAL"
        classSayings = {},      -- per-class DB overrides: { WARRIOR = {"...", ...}, ... }
        debug        = false,
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- OnInitialize  —  called by AceAddon after SavedVariables are ready
-- ─────────────────────────────────────────────────────────────────────────────
function RS:OnInitialize()
    -- AceDB-3.0 manages SavedVariables, defaults, and profiles automatically.
    -- Active profile is always at RS.db.profile.*
    self.db = LibStub("AceDB-3.0"):New("RessurectionSayingsDB", DB_DEFAULTS, true)

    -- Register the Interface > AddOns options panel
    if RS.Options and RS.Options.Setup then
        RS.Options.Setup()
    end

    RS.Chat.Print("v" .. ADDON_VERSION .. " loaded.  |cffffff00/rs help|r for commands.")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- OnEnable  —  called by AceAddon once OnInitialize finishes
-- ─────────────────────────────────────────────────────────────────────────────
function RS:OnEnable()
    self:RegisterEvent("UNIT_SPELLCAST_START", "OnSpellCast")
    RS.Debug.Msg("Addon enabled — listening for rez spell casts.")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- OnDisable
-- ─────────────────────────────────────────────────────────────────────────────
function RS:OnDisable()
    RS.Debug.Msg("Addon disabled.")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- OnSpellCast  —  UNIT_SPELLCAST_START handler
-- Fires when the player BEGINS casting a rez spell.
-- We capture the target at this moment — they’re still the selected unit.
-- ─────────────────────────────────────────────────────────────────────────────
function RS:OnSpellCast(event, unit, _castGUID, spellID)
    if unit ~= "player"                   then return end
    if not self.db.profile.enabled        then return end
    if not RS.SpellData                   then return end
    if not RS.SpellData.IsRez(spellID)    then return end

    -- Capture target name and class while they’re still the active target
    local targetName    = UnitName("target") or "someone"
    local _, classFile  = UnitClass("target")

    local saying = RS.Sayings.GetRandom(targetName, classFile)
    if saying and saying ~= "" then
        RS.Debug.Msg(("Spell %d on %s [%s]: '%s'"):format(
            spellID, targetName, tostring(classFile), saying))
        RS.Chat.Speak(saying)
    end
end

-- SpellData.lua
-- Registry of all resurrection spell IDs for TBC Classic (patch 2.4.3 / 2.5.4).
-- Depends on: RessurectionSayings.lua (Core)

local RS = RessurectionSayings

RS.SpellData = {}
local SD = RS.SpellData

-- spellID → caster class.  The class string is kept for potential future features
-- (e.g. class-specific sayings, statistics).
local SPELL_CLASS = {
    -- ── Priest: Resurrection (Ranks 1–6) ─────────────────────────────────────
    [2006]  = "Priest",  [2010]  = "Priest",  [10880] = "Priest",
    [10881] = "Priest",  [20770] = "Priest",  [25435] = "Priest",

    -- ── Paladin: Redemption (Ranks 1–6) ──────────────────────────────────────
    [7328]  = "Paladin", [10322] = "Paladin", [10324] = "Paladin",
    [20772] = "Paladin", [20773] = "Paladin", [25434] = "Paladin",

    -- ── Shaman: Ancestral Spirit (Ranks 1–6) ─────────────────────────────────
    [2008]  = "Shaman",  [20609] = "Shaman",  [20610] = "Shaman",
    [20611] = "Shaman",  [20612] = "Shaman",  [25590] = "Shaman",

    -- ── Druid: Rebirth (Ranks 1–6, combat rez) ───────────────────────────────
    [20484] = "Druid",   [20739] = "Druid",   [20742] = "Druid",
    [20745] = "Druid",   [20747] = "Druid",   [26994] = "Druid",

    -- ── Warlock: Soulstone Resurrection (Ranks 1–6) ──────────────────────────
    [20707] = "Warlock", [20762] = "Warlock", [20763] = "Warlock",
    [20764] = "Warlock", [20765] = "Warlock", [27239] = "Warlock",
}

--- Returns true when spellID is a known resurrection spell.
--- @param spellID number
--- @return boolean
function SD.IsRez(spellID)
    return SPELL_CLASS[spellID] ~= nil
end

--- Returns the class name associated with spellID, or nil if unknown.
--- @param spellID number
--- @return string|nil
function SD.GetClass(spellID)
    return SPELL_CLASS[spellID]
end

--- Returns a read-only view of the full spellID→class table.
--- @return table
function SD.GetAll()
    return SPELL_CLASS
end

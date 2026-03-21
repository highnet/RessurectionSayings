-- .luacheckrc
-- luacheck configuration for RessurectionSayings WoW Vanilla / Anniversary addon.
-- Run: luacheck .

std = "lua51"

max_line_length = false

-- These globals are WRITTEN by the addon (slash command registration tables).
globals = {
    "RessurectionSayings",
    "SlashCmdList",
    "SLASH_RS1",
    "SLASH_RESSURECTIONSAYINGS1",
}

-- WoW API / library globals that are read but never assigned by the addon.
read_globals = {
    -- Ace library bootstrapper
    "LibStub",

    -- WoW unit API
    "UnitName",
    "UnitClass",
    "UnitExists",
    "UnitIsDeadOrGhost",

    -- WoW chat API
    "SendChatMessage",

    -- WoW debug utility (not in standard Lua)
    "debugstack",

    -- WoW overrides standard print to output to the chat frame
    "print",

    -- AceGUI (used by Options panel)
    "AceGUI",

    -- WoW interface frame globals
    "InterfaceAddOns",
    "InterfaceOptionsFrame",
    "GameTooltip",
}

-- Suppress warnings we don't care about in addon code.
ignore = {
    "212", -- unused argument — common in WoW event handlers (event, unit, castGUID, spellID)
}

-- Exclude the third-party library folder and test helpers from linting.
exclude_files = {
    "Libs/**",
    "tests/**",
}

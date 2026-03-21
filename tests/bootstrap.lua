-- tests/bootstrap.lua
-- Stubs every WoW global the addon touches, then loads the addon modules once.
-- Imported by each spec file with require("tests.bootstrap").
-- The _G.__RS_BOOTSTRAPPED guard ensures modules are only loaded a single time
-- even when multiple spec files require this file.

if _G.__RS_BOOTSTRAPPED then return end
_G.__RS_BOOTSTRAPPED = true

-- ─────────────────────────────────────────────────────────────────────────────
-- WoW API stubs
-- ─────────────────────────────────────────────────────────────────────────────

_G.debugstack = function() return "stub stacktrace\nline 2\nline 3" end

-- Tests redirect these in before_each; provide safe defaults here.
_G.print           = function() end
_G.SendChatMessage = function() end

_G.UnitName  = function() return "TestPlayer" end
_G.UnitClass = function() return "Warrior", "WARRIOR" end

-- ─────────────────────────────────────────────────────────────────────────────
-- Minimal addon global (avoids AceAddon/LibStub complexity)
-- ─────────────────────────────────────────────────────────────────────────────

_G.RessurectionSayings = {}
local RS = _G.RessurectionSayings

RS.NAME    = "RessurectionSayings"
RS.VERSION = "TEST"

-- Stub Debug before loading Debug.lua so that modules loaded before it
-- (if any) don't crash. Debug.lua will replace this with the real impl.
RS.Debug = {
    Msg      = function() end,
    SafeCall = function(fn, ...) return pcall(fn, ...) end,
    Assert   = function(c) return c and true or false end,
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Load addon modules (order matters — Debug first, then dependents)
-- Must be run from the addon root directory.
-- ─────────────────────────────────────────────────────────────────────────────

dofile("Debug.lua")
dofile("Chat.lua")
dofile("Sayings.lua")

-- ─────────────────────────────────────────────────────────────────────────────
-- freshDB() — call in before_each to reset mutable DB state between tests
-- ─────────────────────────────────────────────────────────────────────────────

function _G.__freshDB()
    RS.db = {
        profile = {
            enabled      = true,
            channel      = "SAY",
            classSayings = {},
            debug        = false,
        },
    }
end

_G.__freshDB()

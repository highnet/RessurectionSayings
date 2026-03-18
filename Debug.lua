-- Debug.lua
-- Error handling, xpcall-based safe calls, and conditional debug output.
-- Depends on: RessurectionSayings.lua (Core)

local RS = RessurectionSayings

RS.Debug = {}
local D = RS.Debug

local ERR_PREFIX  = "|cffff4444[RS Error]|r"
local DBG_PREFIX  = "|cffffff00[RS Debug]|r"
local STACK_LINES = 12   -- max lines of stack trace to display

-- ─────────────────────────────────────────────────────────────────────────────
-- Internal error handler  (passed to xpcall)
-- ─────────────────────────────────────────────────────────────────────────────
local function OnError(err)
    local msg   = tostring(err)
    local trace = debugstack(2, STACK_LINES, 3)

    print(ERR_PREFIX .. " " .. msg)

    if RS.db and RS.db.profile and RS.db.profile.debug then
        print(DBG_PREFIX .. " Stack trace:")
        for line in trace:gmatch("[^\n]+") do
            if line:match("%S") then
                print("   " .. line)
            end
        end
    else
        print(ERR_PREFIX
            .. " Use |cffffff00/rs debug on|r to see the full stack trace next time.")
    end

    return msg
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SafeCall  —  wraps any function in xpcall; prints errors automatically.
-- Returns: ok (bool), result-or-errorMessage
-- ─────────────────────────────────────────────────────────────────────────────
function D.SafeCall(fn, ...)
    if type(fn) ~= "function" then
        print(ERR_PREFIX .. " SafeCall: expected function, got " .. type(fn))
        return false, nil
    end
    return xpcall(fn, OnError, ...)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Msg  —  prints to chat only when /rs debug on is active
-- ─────────────────────────────────────────────────────────────────────────────
function D.Msg(msg)
    if RS.db and RS.db.profile and RS.db.profile.debug then
        print(DBG_PREFIX .. " " .. tostring(msg))
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Assert  —  fires OnError (and returns false) when condition is falsy
-- ─────────────────────────────────────────────────────────────────────────────
function D.Assert(condition, msg)
    if not condition then
        OnError(msg or "Assertion failed")
        return false
    end
    return true
end

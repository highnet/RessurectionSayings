-- tests/test_debug.lua
-- Unit tests for Debug.lua — SafeCall, Msg, and Assert.

require("tests.bootstrap")

local RS = _G.RessurectionSayings
local D  = RS.Debug

describe("Debug", function()

    local printed = {}

    before_each(function()
        _G.__freshDB()
        printed = {}
        _G.print      = function(msg) table.insert(printed, tostring(msg)) end
        _G.debugstack = function() return "stub stacktrace\nline 2\nline 3" end
    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("SafeCall", function()

        it("returns true and the function's return value on success", function()
            local ok, val = D.SafeCall(function() return 99 end)
            assert.is_true(ok)
            assert.are.equal(99, val)
        end)

        it("passes multiple arguments through to the function", function()
            local ok, val = D.SafeCall(function(a, b) return a + b end, 3, 7)
            assert.is_true(ok)
            assert.are.equal(10, val)
        end)

        it("returns false when the wrapped function raises an error", function()
            local ok, _ = D.SafeCall(function() error("something went wrong") end)
            assert.is_false(ok)
        end)

        it("prints an error message when the function raises", function()
            D.SafeCall(function() error("boom") end)
            local combined = table.concat(printed, " ")
            assert.is_true(#printed > 0,
                "expected an error message to be printed but nothing was")
        end)

        it("returns false and prints when given a non-function", function()
            local ok, _ = D.SafeCall("not a function")
            assert.is_false(ok)
            assert.is_true(#printed > 0)
        end)

        it("returns false for nil input", function()
            local ok, _ = D.SafeCall(nil)
            assert.is_false(ok)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("Msg", function()

        it("does not print anything when debug mode is off", function()
            RS.db.profile.debug = false
            D.Msg("silent message")
            assert.are.equal(0, #printed)
        end)

        it("prints the message when debug mode is on", function()
            RS.db.profile.debug = true
            D.Msg("loud message")
            assert.is_true(#printed > 0)
            local combined = table.concat(printed, " ")
            assert.is_true(combined:find("loud message") ~= nil)
        end)

        it("does not print when the DB is nil", function()
            RS.db = nil
            D.Msg("no db message")
            assert.are.equal(0, #printed)
        end)

        it("does not error when given nil as the message", function()
            RS.db.profile.debug = true
            assert.has_no.errors(function() D.Msg(nil) end)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("Assert", function()

        it("returns true for a truthy condition", function()
            assert.is_true(D.Assert(1 == 1, "this should pass"))
        end)

        it("returns true for a non-nil, non-false value", function()
            assert.is_true(D.Assert("non-empty string", "should be truthy"))
        end)

        it("returns false for an explicit false condition", function()
            assert.is_false(D.Assert(false, "this should fail"))
        end)

        it("returns false for nil", function()
            assert.is_false(D.Assert(nil, "nil is falsy"))
        end)

        it("prints an error message when the assertion fails", function()
            D.Assert(false, "assertion failure message")
            assert.is_true(#printed > 0)
        end)

        it("includes the provided message in the error output", function()
            D.Assert(false, "unique_error_text_xyz")
            local combined = table.concat(printed, " ")
            assert.is_true(combined:find("unique_error_text_xyz") ~= nil)
        end)

    end)

end)

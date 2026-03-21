-- tests/test_sayings.lua
-- Unit tests for Sayings.lua — pool retrieval, mutations, and GetRandom.

require("tests.bootstrap")

local RS = _G.RessurectionSayings
local S  = RS.Sayings

local CLASSES = { "WARRIOR", "PALADIN", "PRIEST", "DRUID", "SHAMAN",
                  "WARLOCK", "MAGE", "HUNTER", "ROGUE" }

describe("Sayings", function()

    before_each(function()
        _G.__freshDB()
    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("GetClassPool", function()

        it("returns the built-in pool when there is no DB override", function()
            RS.db = nil
            local pool = S.GetClassPool("WARRIOR")
            assert.are.equal(S.CLASS_SAYINGS["WARRIOR"], pool)
        end)

        it("returns the DB pool when an override exists", function()
            RS.db.profile.classSayings["WARRIOR"] = { "custom saying" }
            local pool = S.GetClassPool("WARRIOR")
            assert.are.equal(1, #pool)
            assert.are.equal("custom saying", pool[1])
        end)

        it("honours an empty DB pool (user cleared all sayings)", function()
            RS.db.profile.classSayings["WARRIOR"] = {}
            local pool = S.GetClassPool("WARRIOR")
            assert.are.equal(0, #pool)
        end)

        it("returns nil for an unknown class with no DB override", function()
            local pool = S.GetClassPool("GNOME")
            assert.is_nil(pool)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("GetClassSaying", function()

        it("returns the correct saying at a valid index", function()
            local saying = S.GetClassSaying("WARRIOR", 1)
            assert.are.equal(S.CLASS_SAYINGS["WARRIOR"][1], saying)
        end)

        it("returns empty string for an out-of-range index", function()
            local saying = S.GetClassSaying("WARRIOR", 9999)
            assert.are.equal("", saying)
        end)

        it("returns empty string for an unknown class", function()
            local saying = S.GetClassSaying("GNOME", 1)
            assert.are.equal("", saying)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("SetClassSaying", function()

        it("updates a saying in the DB at the given index", function()
            S.SetClassSaying("WARRIOR", 1, "Brand new text")
            local pool = RS.db.profile.classSayings["WARRIOR"]
            assert.are.equal("Brand new text", pool[1])
        end)

        it("removes a saying when given a blank string", function()
            S._ensureDBCopy("WARRIOR")
            local before = #RS.db.profile.classSayings["WARRIOR"]
            S.SetClassSaying("WARRIOR", 1, "")
            assert.are.equal(before - 1, #RS.db.profile.classSayings["WARRIOR"])
        end)

        it("refuses to remove the last remaining saying", function()
            RS.db.profile.classSayings["WARRIOR"] = { "Only one left" }
            S.SetClassSaying("WARRIOR", 1, "")
            assert.are.equal(1, #RS.db.profile.classSayings["WARRIOR"])
            assert.are.equal("Only one left", RS.db.profile.classSayings["WARRIOR"][1])
        end)

        it("truncates text that exceeds 255 characters", function()
            local long = string.rep("a", 300)
            S.SetClassSaying("WARRIOR", 1, long)
            local pool = RS.db.profile.classSayings["WARRIOR"]
            assert.are.equal(255, #pool[1])
        end)

        it("trims leading and trailing whitespace", function()
            S.SetClassSaying("WARRIOR", 1, "  hello world  ")
            local pool = RS.db.profile.classSayings["WARRIOR"]
            assert.are.equal("hello world", pool[1])
        end)

        it("does nothing when the DB is not ready", function()
            RS.db = nil
            assert.has_no.errors(function()
                S.SetClassSaying("WARRIOR", 1, "text")
            end)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("AddClassSaying", function()

        it("appends a new saying and returns true + new index", function()
            S._ensureDBCopy("WARRIOR")
            local before = #RS.db.profile.classSayings["WARRIOR"]
            local ok, n  = S.AddClassSaying("WARRIOR", "A shiny new saying!")
            assert.is_true(ok)
            assert.are.equal(before + 1, n)
            assert.are.equal("A shiny new saying!", RS.db.profile.classSayings["WARRIOR"][n])
        end)

        it("rejects an empty string", function()
            local ok, err = S.AddClassSaying("WARRIOR", "")
            assert.is_false(ok)
            assert.is_string(err)
        end)

        it("rejects a whitespace-only string", function()
            local ok, err = S.AddClassSaying("WARRIOR", "   ")
            assert.is_false(ok)
            assert.is_string(err)
        end)

        it("rejects strings longer than 255 characters", function()
            local long    = string.rep("x", 256)
            local ok, err = S.AddClassSaying("WARRIOR", long)
            assert.is_false(ok)
            assert.is_string(err)
        end)

        it("returns false when the DB is not ready", function()
            RS.db = nil
            local ok, err = S.AddClassSaying("WARRIOR", "test")
            assert.is_false(ok)
            assert.is_string(err)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("ResetClass", function()

        it("clears the DB override for a class", function()
            RS.db.profile.classSayings["WARRIOR"] = { "custom" }
            S.ResetClass("WARRIOR")
            assert.is_nil(RS.db.profile.classSayings["WARRIOR"])
        end)

        it("leaves other class overrides untouched", function()
            RS.db.profile.classSayings["WARRIOR"] = { "custom w" }
            RS.db.profile.classSayings["MAGE"]    = { "custom m" }
            S.ResetClass("WARRIOR")
            assert.is_not_nil(RS.db.profile.classSayings["MAGE"])
        end)

        it("does not error when the DB is nil", function()
            RS.db = nil
            assert.has_no.errors(function() S.ResetClass("WARRIOR") end)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("GetRandom", function()

        it("returns a non-empty string", function()
            local result = S.GetRandom("Alice", "WARRIOR")
            assert.is_string(result)
            assert.is_true(#result > 0)
        end)

        it("substitutes {name} with the provided target name", function()
            RS.db.profile.classSayings["WARRIOR"] = { "Hello, {name}!" }
            local result = S.GetRandom("Thrall", "WARRIOR")
            assert.are.equal("Hello, Thrall!", result)
        end)

        it("substitutes {name} with 'someone' when name is nil", function()
            RS.db.profile.classSayings["WARRIOR"] = { "Hello, {name}!" }
            local result = S.GetRandom(nil, "WARRIOR")
            assert.are.equal("Hello, someone!", result)
        end)

        it("returns empty string for an empty pool", function()
            RS.db.profile.classSayings["WARRIOR"] = {}
            local result = S.GetRandom("Alice", "WARRIOR")
            assert.are.equal("", result)
        end)

        it("returns empty string for an unknown class", function()
            local result = S.GetRandom("Alice", "GNOME")
            assert.are.equal("", result)
        end)

        it("returns empty string when classFile is nil", function()
            local result = S.GetRandom("Alice", nil)
            assert.are.equal("", result)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("CLASS_SAYINGS built-in data integrity", function()

        for _, cls in ipairs(CLASSES) do

            it(cls .. " pool has at least 10 sayings", function()
                assert.is_true(#S.CLASS_SAYINGS[cls] >= 10,
                    cls .. " only has " .. #S.CLASS_SAYINGS[cls] .. " sayings")
            end)

            it(cls .. " has no saying exceeding 255 characters", function()
                for i, saying in ipairs(S.CLASS_SAYINGS[cls]) do
                    assert.is_true(#saying <= 255,
                        cls .. "[" .. i .. "] is " .. #saying .. " chars (max 255)")
                end
            end)

            it(cls .. " has no saying with an un-substituted {name} placeholder issue", function()
                for _, saying in ipairs(S.CLASS_SAYINGS[cls]) do
                    -- Every {name} placeholder must be a complete token
                    local count = select(2, saying:gsub("{name}", ""))
                    local bad   = select(2, saying:gsub("{[^}]*}", ""))
                    -- There should be no curly-brace expressions OTHER than {name}
                    assert.are.equal(count, bad,
                        cls .. ": unexpected placeholder in '" .. saying .. "'")
                end
            end)

        end

    end)

end)

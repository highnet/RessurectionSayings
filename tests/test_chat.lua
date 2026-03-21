-- tests/test_chat.lua
-- Unit tests for Chat.lua — channel helpers and Speak dispatch.

require("tests.bootstrap")

local RS = _G.RessurectionSayings
local C  = RS.Chat

describe("Chat", function()

    local printed   = {}
    local sent_msg, sent_ch

    before_each(function()
        _G.__freshDB()
        printed  = {}
        sent_msg = nil
        sent_ch  = nil

        -- Capture print output so we can assert on it without console noise.
        _G.print = function(msg) table.insert(printed, tostring(msg)) end

        -- Capture SendChatMessage calls for inspection.
        _G.SendChatMessage = function(msg, ch)
            sent_msg = msg
            sent_ch  = ch
        end
    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("GetChannelLabel", function()

        it("returns a string label for SAY", function()
            assert.is_string(C.GetChannelLabel("SAY"))
        end)

        it("returns a string label for EMOTE", function()
            assert.is_string(C.GetChannelLabel("EMOTE"))
        end)

        it("returns a string label for LOCAL", function()
            assert.is_string(C.GetChannelLabel("LOCAL"))
        end)

        it("returns nil for an unrecognised channel", function()
            assert.is_nil(C.GetChannelLabel("WHISPER"))
        end)

        it("returns nil for an empty string", function()
            assert.is_nil(C.GetChannelLabel(""))
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("Print / Warn / Error helpers", function()

        it("Print outputs a tagged message to local chat", function()
            C.Print("hello")
            assert.is_true(#printed > 0)
            assert.is_true(printed[1]:find("hello") ~= nil)
        end)

        it("Warn includes the message text", function()
            C.Warn("careful!")
            local combined = table.concat(printed, " ")
            assert.is_true(combined:find("careful!") ~= nil)
        end)

        it("Error includes the message text", function()
            C.Error("boom")
            local combined = table.concat(printed, " ")
            assert.is_true(combined:find("boom") ~= nil)
        end)

        it("Printf formats the message correctly", function()
            C.Printf("value is %d", 42)
            local combined = table.concat(printed, " ")
            assert.is_true(combined:find("42") ~= nil)
        end)

    end)

    -- ─────────────────────────────────────────────────────────────────────
    describe("Speak", function()

        it("calls SendChatMessage with SAY when channel is SAY", function()
            RS.db.profile.channel = "SAY"
            C.Speak("Hello world!")
            assert.are.equal("Hello world!", sent_msg)
            assert.are.equal("SAY", sent_ch)
        end)

        it("calls SendChatMessage with EMOTE when channel is EMOTE", function()
            RS.db.profile.channel = "EMOTE"
            C.Speak("waves!")
            assert.are.equal("waves!", sent_msg)
            assert.are.equal("EMOTE", sent_ch)
        end)

        it("prints locally and does NOT call SendChatMessage when channel is LOCAL", function()
            RS.db.profile.channel = "LOCAL"
            C.Speak("Local only message")
            assert.is_nil(sent_msg)
            assert.is_true(#printed > 0)
        end)

        it("skips an empty saying without sending anything", function()
            C.Speak("")
            assert.is_nil(sent_msg)
        end)

        it("skips a nil saying without sending anything", function()
            C.Speak(nil)
            assert.is_nil(sent_msg)
        end)

        it("skips a non-string saying without sending anything", function()
            C.Speak(12345)
            assert.is_nil(sent_msg)
        end)

        it("falls back to SAY and still sends when channel is invalid", function()
            RS.db.profile.channel = "INVALID_CHANNEL"
            C.Speak("Testing fallback")
            assert.are.equal("SAY", sent_ch)
            assert.are.equal("SAY", RS.db.profile.channel)
        end)

        it("handles API errors from SendChatMessage gracefully (no crash)", function()
            _G.SendChatMessage = function() error("Blizzard API exploded") end
            RS.db.profile.channel = "SAY"
            assert.has_no.errors(function() C.Speak("risky message") end)
        end)

        it("uses SAY as the default channel when DB is nil", function()
            RS.db = nil
            C.Speak("No DB test")
            assert.are.equal("SAY", sent_ch)
        end)

    end)

end)

-- Chat.lua
-- Addon print helpers and in-world chat dispatch (SAY / EMOTE / LOCAL).
-- Depends on: RessurectionSayings.lua (Core), Debug.lua

local RS = RessurectionSayings

RS.Chat = {}
local C = RS.Chat

-- Colour codes
local CLR_ADDON = "|cff00ccff"   -- cyan
local CLR_RESET = "|r"
local CLR_WARN  = "|cffffff00"   -- yellow
local CLR_ERR   = "|cffff4444"   -- red
local TAG       = CLR_ADDON .. "[RS]" .. CLR_RESET .. " "

-- ─────────────────────────────────────────────────────────────────────────────
-- Local print helpers  (never visible to other players)
-- ─────────────────────────────────────────────────────────────────────────────

--- Prints a formatted addon message to the local chat frame.
--- @param msg string
function C.Print(msg)
    print(TAG .. tostring(msg))
end

--- Printf-style wrapper around C.Print.
--- @param fmt string
function C.Printf(fmt, ...)
    C.Print(fmt:format(...))
end

--- Prints a yellow warning to local chat.
--- @param msg string
function C.Warn(msg)
    C.Print(CLR_WARN .. tostring(msg) .. CLR_RESET)
end

--- Prints a red error to local chat.
--- @param msg string
function C.Error(msg)
    C.Print(CLR_ERR .. tostring(msg) .. CLR_RESET)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Channel definitions  (used by Options panel, SlashCommands, and Speak)
-- ─────────────────────────────────────────────────────────────────────────────
C.CHANNELS = {
    { value = "SAY",   label = "/say  (visible to nearby players)" },
    { value = "EMOTE", label = "/emote" },
    { value = "LOCAL", label = "Local chat frame only" },
}

-- Fast lookup table built from C.CHANNELS
local VALID_CHANNEL = {}
for _, ch in ipairs(C.CHANNELS) do
    VALID_CHANNEL[ch.value] = true
end

--- Returns the human-readable label for the given channel value, or nil.
--- @param value string
--- @return string|nil
function C.GetChannelLabel(value)
    for _, ch in ipairs(C.CHANNELS) do
        if ch.value == value then return ch.label end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Speak  —  sends a saying through the player's configured output channel
-- ─────────────────────────────────────────────────────────────────────────────

--- Sends `saying` through the channel stored in RS.db.channel.
--- Falls back gracefully on invalid channel values or API errors.
--- @param saying string
function C.Speak(saying)
    if type(saying) ~= "string" or saying == "" then
        RS.Debug.Msg("Chat.Speak: empty or non-string saying — skipped.")
        return
    end

    local ch = (RS.db and RS.db.profile and RS.db.profile.channel) or "SAY"

    if not VALID_CHANNEL[ch] then
        C.Error(("Unknown channel '%s'; reverting to SAY."):format(ch))
        if RS.db then RS.db.profile.channel = "SAY" end
        ch = "SAY"
    end

    if ch == "LOCAL" then
        C.Print(saying)
        return
    end

    -- Wrap Blizzard's API in pcall — it can fail in some edge cases
    -- (e.g. player is not yet fully in world, or instance restrictions).
    local ok, err = pcall(SendChatMessage, saying, ch)
    if not ok then
        C.Error(("Could not send message [channel=%s]: %s"):format(ch, tostring(err)))
        RS.Debug.Msg("Chat.Speak pcall error: " .. tostring(err))
    end
end

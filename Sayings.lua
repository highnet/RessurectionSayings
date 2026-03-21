-- Sayings.lua
-- Built-in per-class saying pools and per-class DB overrides.
-- Sayings may contain {name} which is replaced with the target player's name.
-- Depends on: RessurectionSayings.lua (Core), Debug.lua

local RS = RessurectionSayings

RS.Sayings = {}
local S = RS.Sayings

-- (S.DEFAULTS removed — sayings are always class-specific)

-- ─────────────────────────────────────────────────────────────────────────────
-- Generic defaults  (used when no custom sayings are set AND no class match)
-- {name} is replaced at run-time with the target player’s name.
-- ─────────────────────────────────────────────────────────────────────────────
-- Class-specific sayings
-- Keys match UnitClass("target") classFile strings (always English, uppercase).
-- ─────────────────────────────────────────────────────────────────────────────
S.CLASS_SAYINGS = {

    WARRIOR = {
        "Up you get, {name}! Your rage bar missed you.",
        "{name} tried a bold new strategy called 'floor inspection'. Back to the old ways!",
        "Back on your feet, {name}! Even fire has trouble keeping a good warrior down.",
        "A warrior on the ground? Don't worry, {name} — we've all been there!",
        "Rise, {name}! Berserker Rage doesn't rage-quit for you.",
        "{name} has more armour than a siege engine and still found a creative way down. Impressive!",
        "Back from death, {name}! Intercept right back into the action!",
        "Shield Wall is your best friend, {name}! Let's introduce you two properly.",
        "Back on your feet, {name}! Round two is going to go much better, we can feel it!",
        "{name} stood in fire. In full plate. Screaming. A true legend.",
        "You lived, you charged, you adventured, {name}! Very classic warrior energy.",
        "Rise, {name}! Next fireball — just duck a little!",
        "{name} has the health pool of a small ocean! Today the ocean had a big wave.",
        "Last Stand: a classic! Next time just stand a bit more, {name}!",
        "The tank took a tumble and the tank is back! All according to plan.",
    },

    PALADIN = {
        "{name}, you have a bubble! That is precisely what bubbles are for — use it next time!",
        "Rise, {name}! Lay on Hands is the ultimate self-care. Treat yourself!",
        "{name} is back! Divine Shield is exactly the kind of trick to keep in mind for the next big moment!",
        "The Light has returned {name}\226\128\166 warmly and with open arms.",
        "Even paladins need a rest sometimes, {name}! Rise well, fight stronger.",
        "{name} had a bubble, a heal, and a pony. Truly a champion of the Light!",
        "Holy Light heals others AND you, {name}! Two blessings for the price of one.",
        "The Light provides for all, {name}! Including a second chance right now.",
        "{name} bubbled into a wall. The creativity is truly something to behold.",
        "I just rezzed a paladin — the holiest of rezzes for the holiest of heroes, {name}!",
        "A paladin, a priest, and a shaman walk into a bar. {name} walks out victorious!",
        "Rise, {name}! Those Judgements aren't going to cast themselves.",
        "Rise, {name}! Lay on Hands is always worth keeping in mind — the ultimate backup plan!",
        "{name} screamed 'FOR THE LIGHT!' and the Light answered with a prompt resurrection.",
        "Consecration is a great move, {name}! Just remember to step out of your own circle.",
    },

    PRIEST = {
        "Even the best healers need a hand sometimes, {name}! That is just great teamwork.",
        "{name}, we look out for each other here! Now get back out there!",
        "Rise, {name}! Desperate Prayer is a great trick to keep up your sleeve.",
        "I just resurrected a priest! The circle of healing is complete, {name}!",
        "Back to life, {name}! Fade is a great trick — keep it ready for next time.",
        "{name} is back! There is something wonderfully poetic about a resurrector returning.",
        "Inner Fire burns bright in {name}! Let's keep that flame going this time.",
        "Power Word: Shield for yourself next time too, {name}! Self-care is important.",
        "{name} dispelled everyone's debuffs like an absolute champion! Next time: self-dispel too.",
        "Rise, {name}! Get a Renew ticking and you are good to go.",
        "{name} said 'I'll be fine' — and look, you are fine! Right back at it.",
        "Vampiric Embrace is a wonderful lifeline, {name}! Go get some hits in.",
        "Flash Heal is speedy, {name}! Let's use that speed for some big heals this time.",
        "{name} kept the whole team alive — legendary work! Your turn to be kept alive now.",
        "Up you go, {name}! Heaven sent you back with a smile.",
        "Spirit of Redemption is a lovely look, {name}, but we need that healing touch back!",
    },

    DRUID = {
        "Rise, {name}! Barkskin is a great one to keep in mind for exactly this kind of situation.",
        "Back from a quick nap, {name}! Next time, shapeshift into an even tougher form.",
        "I just rezzed a druid! The circle of life continues, {name}!",
        "Nature called {name} home for a brief visit. Welcome back to the adventure!",
        "{name} was on a very scenic detour in travel form. Glad you found your way back!",
        "Rebirth is a powerful gift, {name}. The forest breathes anew.",
        "Nature offers many paths, {name}. Let's take the one marked 'staying alive'!",
        "{name} discovered an advanced druid technique: the dramatic floor sprawl. Very bold.",
        "The balance of nature swings back, {name}! You are right where you belong.",
        "{name} has unlocked a new form. We call it 'getting back up form'. Very powerful.",
        "Nature's Grasp, Entangling Roots, Cyclone — {name} has so many great options for next time!",
        "Up, {name}! The forest and the raid both need you back.",
    },

    SHAMAN = {
        "{name} gets to save their ankh for next time! That is what friends are for.",
        "Rise, {name}! Reincarnation is always an option — this time I just got here first.",
        "{name} is back! The ancestors nod with great pride and wisdom.",
        "Back on your feet, {name}! Teamwork makes the dream work.",
        "Welcome back, {name}! Reincarnation is a fantastic trick to have ready for the next big adventure.",
        "{name} dropped every totem and fought bravely. Time for round two!",
        "Earth Shield, Water Shield, Lightning Shield — so many great choices, {name}! A true feast of options.",
        "Ghost Wolf is lightning fast, {name}! Even lightning meets its match sometimes.",
        "The elements are a wild and wonderful force, {name}! Even the best shamans ride the big waves.",
        "{name}'s ankh is on cooldown — good thing friends are always available!",
        "Rise, {name}! Stoneclaw Totem is a great distraction tool to keep handy.",
        "Tremor Totem is your guardian against fear, {name}! You are back and absolutely fearless.",
        "Healing Stream Totem is right here for you, {name}! Come stand a little closer next time.",
        "Purge clears the path to victory, {name}! Now let's clear all the way to the boss.",
        "The ancestors offer wisdom, warm welcomes, and great pride for returning heroes, {name}!",
        "Heroism was pumping, {name}! An exciting round — ready for an even better one?",
        "Chain Heal is bouncing through the whole group, {name}! Glad to bounce you back in too.",
    },

    WARLOCK = {
        "{name} is back! Soulstone or not, nothing keeps a warlock down for long.",
        "Rise, {name}! Your Voidwalker has been loyally standing guard right here.",
        "{name} is back! The dark pact comes with solid benefits — like a good resurrection.",
        "Back from the abyss, {name}! Life Tap is a great finisher when you need that last burst.",
        "I rezzed {name}! Soulstone cooldowns happen to everyone. That is what guildmates are for.",
        "{name} charged into battle valiantly and now charges back in! Absolutely unstoppable.",
        "Healthstone is a gift from yourself to yourself, {name} — keep one handy at all times!",
        "The Twisting Nether called and we answered on {name}'s behalf. You are very welcome.",
        "Curse of Recklessness on the mobs, bold adventures for {name} — same great energy!",
        "Rise, {name}! Dark magic, demonic pacts, and one very dedicated friend with a resurrection.",
    },

    MAGE = {
        "{name}, what a chase! Blink and Ice Block are wonderful tools to keep in mind for round two.",
        "Rise, {name}! Ice Block is a cosy option, but walking around is even better.",
        "Back to life, {name}! Blinking away from danger is very much on the menu this time.",
        "A Mage returns! {name} is back and the DPS is back on track!",
        "{name} conjured food, conjured water, and conjured a magnificent comeback!",
        "Frost Nova, Blink, Ice Block — {name} has a whole toolkit of great options for next time!",
        "Counterspell is a fantastic tool, {name}! Nothing gets through when you use it.",
        "Mana Shield is a powerful barrier, {name}! Keep it in mind for the next big moment.",
        "Rise, {name}! The refreshment table is still here. Grab a mana biscuit, you have earned it.",
        "Evocation is a great trick, {name}! Channel that mana — then channel some victory.",
    },

    HUNTER = {
        "Rise, {name}! Feign Death only fools the mobs, not the combat log.",
        "{name} tried Feign Death and it almost worked. Welcome back to the real version!",
        "Back on your feet, {name}! Your loyal pet never doubted you for a single second.",
        "{name} is up! Aspect of the Cheetah will carry them safely away next time!",
        "I rezzed {name}! Don't worry about the ammo — we have plenty of adventure ahead.",
        "{name}'s pet held the line loyally. A true dynamic duo!",
        "The Deadzone is a tricky spot, {name}! You have helpfully mapped it for the rest of us.",
        "{name} pulled with Multi-Shot — chaotic, bold, and very on-brand. A true Hunter moment!",
        "Rise, {name}! You and your pet are the best duo in the whole raid.",
        "Misdirection redirected right into {name}'s triumphant return! Welcome back!",
    },

    ROGUE = {
        "{name} staged an elaborate decoy and now makes a dramatic surprise return! Perfect.",
        "Rise, {name}! Vanish resets everything — time for an even better approach.",
        "Back from the shadows, {name}! The element of surprise is fully restored.",
        "I rezzed {name}! Pure vibes as a strategy is bold and honestly very on-brand.",
        "Evasion gives 50% dodge, {name}! The other 50% is basically a bonus challenge.",
        "Cloak of Shadows is your secret weapon, {name}! Keep it in mind for the next tricky moment.",
        "Preparation resets cooldowns, {name}! Consider this a full cooldown reset on the whole adventure.",
        "Kick is a great interrupt, {name}! Nothing gets through when you use it.",
        "{name} came in with 5 combo points of pure experience! Right back at it.",
        "Sprint is a great escape move, {name}! Keep it in mind to dart away from danger next time!",
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Substitutes {name} in a saying template with the given player name.
--- @param template string
--- @param name string
--- @return string
local function ApplyName(template, name)
    return (template:gsub("{name}", name or "someone"))
end

--- Private: ensure the DB has an editable copy of classFile's pool.
function S._ensureDBCopy(classFile)
    if not RS.db then return end
    if not RS.db.profile.classSayings then RS.db.profile.classSayings = {} end
    if not RS.db.profile.classSayings[classFile] then
        local src = S.CLASS_SAYINGS[classFile] or {}
        local copy = {}
        for i, s in ipairs(src) do copy[i] = s end
        RS.db.profile.classSayings[classFile] = copy
    end
end

--- Returns the effective saying pool for a class (DB overrides or built-ins).
--- Returns the DB copy whenever one exists (even if empty), so that
--- "user removed everything" is honoured instead of falling back to built-ins.
--- @param classFile string
--- @return table
function S.GetClassPool(classFile)
    local db = RS.db and RS.db.profile and RS.db.profile.classSayings
    if db and db[classFile] ~= nil then
        return db[classFile]   -- may be empty {}; caller must handle that
    end
    return S.CLASS_SAYINGS[classFile]
end

--- Returns the saying at index for a given class.
--- @param classFile string
--- @param index number
--- @return string
function S.GetClassSaying(classFile, index)
    local pool = S.GetClassPool(classFile)
    return pool and pool[index] or ""
end

--- Persists a single saying edit, copying built-in pool into DB on first edit.
--- Passing an empty/blank string REMOVES that slot and compacts the array.
--- @param classFile string
--- @param index number
--- @param text string
function S.SetClassSaying(classFile, index, text)
    if not RS.db then return end
    S._ensureDBCopy(classFile)
    local pool = RS.db.profile.classSayings[classFile]
    text = text:match("^%s*(.-)%s*$")
    if text == "" then
        if index >= 1 and index <= #pool then
            if #pool <= 1 then
                RS.Debug.Msg("Sayings.Remove: refused — must keep at least 1 saying.")
                return
            end
            RS.Debug.Msg(("Sayings.Remove [%s][#%d]: '%s'"):format(classFile, index, pool[index]))
            table.remove(pool, index)
        end
    else
        if #text > 255 then text = text:sub(1, 255) end
        pool[index] = text
        RS.Debug.Msg(("Sayings.Set [%s][%d]: '%s'"):format(classFile, index, text))
    end
end

--- Resets all sayings for a class to built-in defaults.
--- @param classFile string
function S.ResetClass(classFile)
    if RS.db and RS.db.profile and RS.db.profile.classSayings then
        RS.db.profile.classSayings[classFile] = nil
    end
    RS.Debug.Msg("Sayings.ResetClass: " .. classFile .. " reset to defaults.")
end

--- Appends a new saying to the class pool (ensures DB copy exists first).
--- @param classFile string
--- @param text string
--- @return ok boolean, err string|nil
function S.AddClassSaying(classFile, text)
    if not RS.db then return false, "DB not ready." end
    text = text:match("^%s*(.-)%s*$")
    if text == "" then return false, "Saying cannot be empty." end
    if #text > 255 then return false, ("Too long (%d chars, max 255)."):format(#text) end
    S._ensureDBCopy(classFile)
    table.insert(RS.db.profile.classSayings[classFile], text)
    local n = #RS.db.profile.classSayings[classFile]
    RS.Debug.Msg(("Sayings.Add [%s][#%d]: '%s'"):format(classFile, n, text))
    return true, n
end



--- Returns a random saying for the given target name and class.
--- @param name      string|nil
--- @param classFile string|nil
--- @return string
function S.GetRandom(name, classFile)
    local pool = classFile and S.GetClassPool(classFile)
    if not pool or #pool == 0 then return "" end
    return ApplyName(pool[math.random(#pool)], name)
end
--[[ stale content removed:
— -- ─────────────────────────────────────────────────────────────────────────────
-- Mutation helpers  (always operate on RS.db.customSayings)
-- ─────────────────────────────────────────────────────────────────────────────


            ("Invalid index %s — valid range is 1–%d."
]]

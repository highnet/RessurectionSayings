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
        "{name} went down? I thought warriors were supposed to be the tanky ones.",
        "Up you get, {name}. Your rage bar missed you.",
        "Rise, {name}! Heroic Strike isn't going to press itself.",
        "{name} died to trash. This is why we can't have nice things.",
        "Back on your feet, {name}. Thunderclap won't save you from standing in fire.",
        "{name} charges in, {name} falls over. Every time.",
        "A warrior. Dead. On the ground. {name}, I have questions.",
        "Rise, {name}! Berserker Rage doesn't rage-quit for you.",
        "{name} has more armour than a siege engine and still died. I'm impressed.",
        "Back from death, {name}. Intercept was RIGHT THERE.",
        "Shield Wall exists, {name}. It exists for YOU. Please use it.",
        "I rezzed {name}. They died pulling the SAME pack AGAIN.",
        "{name} stood in fire. In full plate. Screaming.",
        "You lived, you charged, you died, {name}. Classic warrior experience.",
        "Rise, {name}, and try not to headbutt the next fireball.",
        "{name} has the health pool of a small ocean and still found a way.",
        "Last Stand extends your life by 20%. Clearly insufficient, {name}.",
        "The tank is down. The tank is back. Don't ask the tank what happened.",
    },

    PALADIN = {
        "{name}, you have a BUBBLE. A literal Divine Shield. Explain yourself.",
        "Rise, {name}! Lay on Hands is a self-cast, you know.",
        "{name} is back! Divine Shield only works if you actually press it.",
        "The Light has returned {name}\226\128\166 reluctantly.",
        "Even paladins die sometimes, {name}. Deeply, deeply disappointing.",
        "{name} had a bubble, a heal, and a pony. Still died. Remarkable.",
        "Holy Light: heals others. Also heals YOU, {name}. Wild concept.",
        "The Light provides for all, {name}. Apparently it forgot to provide Cooldown Awareness.",
        "{name} bubbled at 5% health. Into a wall. And died on the way out.",
        "I just rezzed a paladin. At least you smelled holy on the way down, {name}.",
        "A paladin, a priest, and a shaman walk into a bar. {name} dies. The others rez.",
        "Rise, {name}. Your Judgements weren't going to judge themselves.",
        "Divine Intervention is for others, {name}. Lay on Hands was for you.",
        "Beacon of Light. Beacon of Hope. Beacon of {name} lying facedown on the floor.",
        "{name} screamed 'FOR THE LIGHT' and then immediately stopped being alive.",
        "Consecration deals damage in a circle, {name}. You are not immune to circles.",
        "Ret pally down. Shocker. Rise, {name}.",
        "Sacred Shield: active. Divine Shield: off cooldown. {name}: dead. Baffling.",
    },

    PRIEST = {
        "A healer dying is just professionally awkward, {name}.",
        "{name}, who heals the healer? Me, apparently. You're welcome.",
        "Rise, {name}! Desperate Prayer was on cooldown, I assume?",
        "I just resurrected a priest. Let that sink in, {name}.",
        "Back to life, {name}! Fade next time — or keep giving me the practice.",
        "{name} died. The irony of resurrecting a resurrector is not lost on me.",
        "Inner Fire was not enough fire, {name}. Noted.",
        "Power Word: Shield on the boss. Forgot to Power Word: Shield yourself. Classic {name}.",
        "{name} dispelled everyone's debuffs and forgot to dispel death from themselves.",
        "Shadow Word: Death has a self-damage component, {name}. Read your tooltips.",
        "Rise, {name}! You can't Renew yourself from the graveyard.",
        "{name} said 'I'll be fine' and then demonstrated the complete opposite.",
        "Vampiric Embrace heals you when you deal damage, {name}. Deal. The. Damage.",
        "Flash Heal casts fast, {name}. Faster than you died? Apparently not.",
        "{name} kept everyone else alive and personally ran out of that service.",
        "Up you go, {name}. Heaven had no vacancy.",
        "Pain Suppression others. Pain Suppression yourself occasionally too, {name}.",
        "The Spirit of Redemption form is lovely, {name}, but we need you alive.",
    },

    DRUID = {
        "{name}, you have an INSTANT COMBAT REZ and you still needed me?",
        "Rise, {name}! Barkskin literally exists for moments exactly like that.",
        "Back from the dead, {name}! Next time try shape-shifting into 'not dead'.",
        "I just rezzed a druid. The circle of life has gone full circle, {name}.",
        "{name}, your bear form has more armour than I do. HOW.",
        "Nature called {name} back. Probably should've called sooner.",
        "Ironbark. IRONBARK, {name}. It is a bark. Made of iron.",
        "{name} died in travel form. They were just running. Running to death.",
        "Rebirth: an instant combat rez. Gathering dust in {name}'s spellbook.",
        "Feral? Balance? Resto? Didn't matter, {name} died in all three specs.",
        "{name} shapeshifted into a corpse. Bold druidic choice.",
        "The balance of nature has been disturbed. Specifically by {name} dying.",
        "Regrowth, Rejuvenation, Wild Growth. None of which {name} used on themselves.",
        "Cat form, bear form, moonkin form, dead form. {name} found the secret fourth option.",
        "Typhoon pushes enemies away, {name}. Off the edge is also away. Careful.",
        "Swiftmend requires a HoT on the target. {name} had no HoTs. On themselves.",
        "Nature's Grasp, Entangling Roots, Cyclone — {name} chose 'stand there' instead.",
        "Up, {name}. The raid needs a battle rez and yours is off cooldown now.",
    },

    SHAMAN = {
        "{name} burned their ankh? This must be a special kind of disaster.",
        "Rise, {name}! Reincarnation is for emergencies — and apparently so is this.",
        "{name} is back! The ancestors are deeply, visibly unimpressed.",
        "Back on your feet, {name}. Your totems couldn't save you but I could.",
        "Welcome back, {name}. Next time let Reincarnation handle it. Please. I beg.",
        "{name} dropped every totem and still died. I have so many questions.",
        "Earth Shield, Water Shield, Lightning Shield. {name} chose no shield.",
        "Ghost Wolf does not protect against floor damage, {name}. Who knew.",
        "The elements abandoned {name}. Or {name} abandoned the elements. Hard to say.",
        "{name}'s ankh was on coooldown. Convenient timing.",
        "Rise, {name}! Stoneclaw Totem provides a distraction. Be less distractible.",
        "Tremor Totem breaks fear. Being brave also breaks fear, {name}. Try it.",
        "{name} wind-shocked the boss and then neglected to dodge the boss.",
        "Healing Stream Totem heals. {name} stood 41 yards away from it.",
        "Purge removes buffs from enemies, {name}. Dying removes buffs from you. Coincidence.",
        "The ancestors offer wisdom, guidance, and judgment. Mostly judgment today, {name}.",
        "Heroism was active, {name}. Heroism. And still.",
        "Chain Heal bounces to injured allies. {name} was the injured ally. Bouncing now.",
    },

    WARLOCK = {
        "{name}, there was a SOULSTONE. RIGHT THERE. WHERE WAS YOUR SOULSTONE?",
        "Rise, {name}! Your Voidwalker watched you die. Watched. Did nothing.",
        "{name} is back! I assumed a pact with a demon included life insurance.",
        "Back from the abyss, {name}. Even warlocks die. Just not usually this fast.",
        "I rezzed {name}. Their soulstone was 'on cooldown.' Sure. Sure it was.",
        "{name} traded their soul for power and still wiped on trash. Incredible.",
        "Demonic Circle: set. Demonic Circle: not used. {name}: dead. Baffling.",
        "You HAVE a portal home, {name}. You SUMMONED that portal. You walked past it.",
        "{name}'s demons are still alive. {name} is not. The demons have formed a union.",
        "Dark Pact drains your demon's mana for health, {name}. Use it before the demon does.",
        "Healthstone, {name}. You MADE the healthstone. IT WAS IN YOUR BAG.",
        "{name}'s Imp screamed warnings. Nobody listened. Certainly not {name}.",
        "The Nether reclaimed {name} briefly. I got there first.",
        "Curse of Weakness. Curse of Agony. Curse of {name} not pressing Fel Armor.",
        "Rise, {name}. Your soul belongs to me now. I'll give it back. Mostly.",
        "Drain Life exists, {name}. It drains life. Into you. From the enemy. Please.",
        "Fear is a crowd control tool, not an invitation to stand in the middle, {name}.",
        "{name} summoned a Doomguard at 1hp and still managed to die before it spawned.",
    },

    MAGE = {
        "{name}, you have Blink AND Ice Block. What exactly happened here?",
        "Rise, {name}! Ice Block is a defensive tool, not a dramatic pause button.",
        "Back to life, {name}. The arcane damage was coming from inside the raid.",
        "{name} is back! Next time blink AWAY from the thing trying to kill you.",
        "A mage died. {name} died. Let's all take a moment.",
        "{name} conjured food, conjured water, conjured their own death. Talented.",
        "Frost Nova, Blink, Ice Block, Cone of Cold — {name} chose 'face the fire'.",
        "{name} got polymorphed and counter-polyed themselves. This cleared the log.",
        "Arcane Power gives you 30% more damage. It does not give you 30% more health, {name}.",
        "You opened a portal, {name}. You could have LEFT. You chose to stay and die.",
        "Counterspell counters spells. It does not counter melee, fire pits, or {name}'s decisions.",
        "Mirror Image creates decoys so you can run. {name} watched the decoys die with them.",
        "Mana Shield converts damage to mana loss, {name}. You had plenty of mana.",
        "Rise, {name}. Your table is still there and the fish feast goes cold.",
        "{name} Blinked forward. Into the boss. Many questions.",
        "Evocation: channels to restore mana. {name} chose to channel death instead.",
        "Dragons are weak to frost, {name}. Not to standing directly under them.",
        "{name} died in a Blizzard. Their own Blizzard. Award-winning work.",
    },

    HUNTER = {
        "Rise, {name}! Feign Death only fools the monsters, not actual death.",
        "{name} tried Feign Death and it worked too well. Now they're actually back.",
        "Back on your feet, {name}. Your pet queued up a burial and everything.",
        "{name} is up! Aspect of the Cheetah does not, in fact, prevent dying.",
        "I rezzed {name}. They ran out of arrows. In a dungeon. Breathtaking.",
        "{name}'s pet survived. {name} did not. The pet has opinions about this.",
        "Deterrence reflects spells. It does not reflect {name}'s poor life choices.",
        "Scatter Shot, Frost Trap, Feign Death — {name} used none of these. Incredible.",
        "{name} pulled with Volley. The silence that followed said everything.",
        "Mend Pet was on {name}'s bars. Mend Self was not a thing. Telling.",
        "The Deadzone claimed another victim. Rest in peace to {name}'s spatial awareness.",
        "Rise, {name}! Your pet is level capped. There is no excuse.",
        "{name} trapped the healer. The boss ate {name}. Perfect rotation.",
        "Aspect of the Wild does not protect against everything wild, {name}.",
        "Beast Mastery means you master beasts. {name} was mastered by the floor.",
        "Kill Command was {name}'s last command. Shot on cooldown? Also {name}.",
        "{name}'s pet pulled, {name} Feigned, the healer died, and so eventually did {name}.",
        "Careful Aim improves your aim. Not your survival instincts, {name}.",
    },

    ROGUE = {
        "{name}: chose death over Evasion, Vanish, Blind, and Cloak. Bold strategy.",
        "Rise, {name}! Vanish works on bosses. VANISH WORKS ON BOSSES.",
        "{name} is back! Cloak of Shadows is a button, not a collectible.",
        "Back from the shadows, {name}. Next time try disappearing before you die.",
        "I rezzed {name}. No Gouge, no Blind, no Evasion, no Vanish. Just death.",
        "{name} had every escape tool known to Azeroth and used exactly none of them.",
        "Evasion gives 50% dodge. {name} used 0% of that opportunity.",
        "{name} opened from stealth, popped every cooldown, then remembered to dodge.",
        "Preparation resets cooldowns, {name}. It cannot reset poor decisions.",
        "Cold Blood was active, {name}. You had one job and it had 100% crit.",
        "Kick interrupts casts, {name}. The spell it didn't interrupt was already killing you.",
        "{name} died with full combo points. The energy bar was the real killer.",
        "Sprint runs you away from danger, {name}. Or directly into it depending on direction.",
        "Rise, {name}. The shadows called you home early. I called you back.",
        "{name} Vanished into a wall. Revealed from stealth immediately. Mortifying.",
        "Sap requires stealth and a humanoid. {name} sapped the boss fight into a wipe.",
        "{name} had three escape buttons and hit the attack button anyway.",
        "Blind blinded the wrong target. Gouge broke on damage. {name} died creatively.",
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

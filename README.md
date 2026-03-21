# Ressurection Sayings

A World of Warcraft TBC Classic Anniversary addon that automatically announces a random, class-aware quip in chat whenever you resurrect another player.

> **Game Version:** TBC Classic Anniversary — Interface 20504 (patch 2.4.3 / 2.5.4)  
> **Addon Version:** 3.0.0  
> **SavedVariables:** `RessurectionSayingsDB`

---

## Features

- Triggers on **cast start** of any resurrection spell, capturing the target before they release.
- Chooses a saying from the **target's class pool** — Warriors get warrior jokes, Paladins get bubble jokes, and so on.
- **Built-in sayings per class** (All classes covered).
- **`{name}` substitution** — every saying can include `{name}`, which is replaced with the target player's name at cast time.
- **Fully editable** via a GUI options panel — edit, add, or remove individual sayings per class without touching any files.
- At least one saying per class is always enforced — the last remaining saying cannot be deleted.
- Output channel is configurable: `/say`, `/emote`, or local chat frame only.
- Per-character profile storage via AceDB-3.0.

### Supported Resurrection Spells

| Class | Spell |
|-------|-------|
| Priest | Resurrection (Ranks 1–6) |
| Paladin | Redemption (Ranks 1–6) |
| Shaman | Ancestral Spirit (Ranks 1–6) |
| Druid | Rebirth (Ranks 1–6, combat rez) |


---

## Installation

1. Download or clone this repository.
2. Place the `RessurectionSayings` folder in:
   ```
   World of Warcraft\_anniversary_\Interface\AddOns\
   ```
3. Launch (or reload) the game and enable the addon in the character select screen.

All Ace3 libraries are **embedded** inside the `Libs/` folder — no separate library installation is required.

---

## Usage

### GUI Options Panel

Open **Interface → AddOns → Ressurection Sayings** to:

- Enable / disable the addon.
- Set the output channel (Say, Emote, or Local).
- Test a random saying instantly.
- Browse and edit sayings across **10 tabs** (General + one per class).

On each class tab you can:

| Action | How |
|--------|-----|
| **Edit a saying** | Click the text box, change the text, press Enter |
| **Delete a saying** | Click the red **Remove** button next to it (disabled when only 1 saying remains) |
| **Add a new saying** | Type into the **Add New Saying** box at the bottom and press Enter |
| **Reset to defaults** | Click **Reset to Defaults** (requires confirmation) |

### Slash Commands

Both `/rs` and `/ressurectionsayings` are registered.

```
/rs help                    Show all available commands
/rs on                      Enable the addon
/rs off                     Disable the addon
/rs channel <say|emote|local>   Set the output channel
/rs list [class]            List sayings for a class (defaults to your own class)
/rs test                    Speak a random saying right now (uses your name + class)
/rs status                  Show current settings and saying count
/rs options                 Open the GUI options panel
/rs debug <on|off>          Toggle verbose debug output
```

**Class name examples for `/rs list`:**
```
/rs list warrior
/rs list paladin
/rs list priest
/rs list druid
/rs list shaman
/rs list warlock
/rs list mage
/rs list hunter
/rs list rogue
```

---

## Customising Sayings

Sayings support the `{name}` placeholder, which is replaced with the target's name at cast time:

```
Rise, {name}! Your rage bar missed you.
→  Rise, Gornak! Your rage bar missed you.
```

Custom sayings are stored per-profile in `RessurectionSayingsDB` (SavedVariables). Resetting a class to defaults removes your overrides and restores the built-in list.

---

## File Structure

```
RessurectionSayings/
├── RessurectionSayings.toc          # TOC / metadata file
├── RessurectionSayings.lua          # Core: AceAddon object, DB setup, spell cast handler
├── Sayings.lua                      # Built-in saying pools + DB editing API
├── SpellData.lua                    # Resurrection spell ID registry
├── RessurectionSayings_Options.lua  # AceConfig GUI options table
├── SlashCommands.lua                # /rs command handler
├── Chat.lua                         # Output helpers (say / emote / local / print)
├── Debug.lua                        # Debug logging + SafeCall error wrapper
├── Libs/                            # Embedded Ace3 libraries
│   ├── LibStub/
│   ├── CallbackHandler-1.0/
│   ├── AceAddon-3.0/
│   ├── AceEvent-3.0/
│   ├── AceConsole-3.0/
│   ├── AceDB-3.0/
│   ├── AceGUI-3.0/
│   └── AceConfig-3.0/
│       ├── AceConfigRegistry-3.0/
│       ├── AceConfigCmd-3.0/
│       └── AceConfigDialog-3.0/
│
│   ── Dev tooling (not included in the exported zip) ──
├── run.ps1                          # Centralized task CLI (lint / test / coverage / export)
├── export.ps1                       # Packages the addon as a distributable zip
├── .luacheckrc                      # luacheck static analysis config
├── .busted                          # busted test runner config
├── .luacov                          # luacov coverage config
├── .vscode/tasks.json               # VS Code task shortcuts
└── tests/
    ├── bootstrap.lua                # WoW API stubs + module loader for tests
    ├── test_sayings.lua             # Tests for Sayings.lua
    ├── test_chat.lua                # Tests for Chat.lua
    └── test_debug.lua              # Tests for Debug.lua
```

---

## Development Notes

- **Event:** `UNIT_SPELLCAST_START` — fires the moment the cast begins.  The target is still selected at this point, so `UnitName("target")` and `UnitClass("target")` reliably capture the correct player.
- **DB key:** `RS.db.profile.classSayings[classFile]` — `nil` means "use built-ins"; `{}` (empty table) means "user cleared all sayings" (not the same as nil).
- **Pool compaction:** `SetClassSaying(classFile, idx, "")` removes the entry at `idx` and compacts the array — there are never holes in the pool.
- **UI refresh:** `AceConfigRegistry-3.0:NotifyChange` is called after every `execute` button mutation (Remove, Reset, Add) to force the options panel to repaint.
- **Minimum pool size:** The `Remove` button is disabled and `SetClassSaying` refuses the operation when only one saying remains, guaranteeing the pool is never empty.

---

## Libraries

All libraries are embedded and require no separate installation.

| Library | Purpose |
|---------|---------|
| LibStub | Versioned library loader |
| CallbackHandler-1.0 | Event callback infrastructure |
| AceAddon-3.0 | Addon lifecycle management |
| AceEvent-3.0 | Game event registration |
| AceConsole-3.0 | Slash command registration / Print helpers |
| AceDB-3.0 | SavedVariables with profile support |
| AceGUI-3.0 | GUI widget toolkit |
| AceConfig-3.0 | Options table registration |
| AceConfigDialog-3.0 | Interface > AddOns panel integration |

Library source: [Ace3 on CurseForge](https://www.curseforge.com/wow/addons/ace3)

---

## Development

A local dev toolchain is included for linting, testing, and coverage. It requires [Scoop](https://scoop.sh/), Lua 5.4, LuaRocks, and the packages `luacheck`, `busted`, and `luacov`.

### Task runner

All tasks are accessible through `run.ps1`:

```powershell
.\run.ps1 lint       # Static analysis with luacheck (0 warnings target)
.\run.ps1 test       # Run test suite with busted
.\run.ps1 coverage   # Tests + luacov coverage report
.\run.ps1 export     # Package addon into a distributable zip
.\run.ps1 all        # lint + test
```

VS Code users can also run these via **Terminal → Run Task** (Lint, Test, Coverage, Export).

### Tests

Tests live in `tests/` and use the [busted](https://lunarmodules.github.io/busted/) BDD framework. `tests/bootstrap.lua` stubs all WoW API globals and loads the addon modules so they can be tested outside the game.

```
tests/
├── bootstrap.lua       WoW API stubs + module loader
├── test_sayings.lua    Saying pools, mutations, {name} substitution
├── test_chat.lua       Channel dispatch, print helpers, error handling
└── test_debug.lua      SafeCall, Msg, Assert
```

Run from the addon root:

```powershell
.\run.ps1 test
# or directly:
busted
```

### Linting

[luacheck](https://luacheck.readthedocs.io/) is configured via `.luacheckrc` to target Lua 5.1 (the WoW runtime) with all WoW API globals whitelisted. The `Libs/` and `tests/` folders are excluded.

```powershell
.\run.ps1 lint
# or directly:
luacheck .
```

### Coverage

Coverage is measured with [luacov](https://lunarmodules.github.io/luacov/) and reported after `busted --coverage` runs:

```powershell
.\run.ps1 coverage
```

---

## Exporting

A PowerShell script (`export.ps1`) packages the addon as a zip, excluding all dev-only files and folders (`.git`, `.vscode`, `tests/`, `run.ps1`, `.luacheckrc`, `.busted`, `.luacov`, and any `luacov.*.out` files).

**Run from the addon directory:**

```powershell
.\export.ps1
```

This produces `RessurectionSayings.zip` in the parent (`AddOns`) folder.

**Custom output location:**

```powershell
.\export.ps1 -Destination "C:\Users\you\Desktop"
```

If you get a script execution policy error, run this once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## Credits

- **Gitmerge** — Thunderstrike EU

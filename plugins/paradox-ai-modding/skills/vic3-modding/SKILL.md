---
name: vic3-modding
description: Create, change, and debug Victoria 3 mods, including buildings, production methods, laws, journal entries, events, localization, and GUI. Use for Victoria 3 scripts, metadata, validation, and documentation lookup. Does not cover Crusader Kings III or other Paradox games.
---

# Victoria 3 Modding

The maintained source is plugins/paradox-ai-modding/skills/vic3-modding/ in JDeffner/paradox-ai-modding. Keep local paths in the mod project. Edit the source repository, then update installed copies.

In commands below, <skill> means the absolute directory containing this SKILL.md. Resolve it from the loaded skill location and substitute it before running commands. It is not an environment variable. The lookup script uses Python 3 with no third-party dependencies.

Victoria 3 mods are Paradox (Jomini) script: `.txt` databases under `common/` and `events/`,
`.yml` localization, and PdxGui `.gui` files. The default failure mode is **silent**. A wrong
encoding, a folder typo, or an unbalanced brace makes the game ignore the file with no error.

Victoria 3 documents itself better than most Paradox games. Three first-party sources cover
almost every factual question, so answer from them rather than from memory.

## Step 0: resolve this machine's paths

Detect these once per session. Ask the user only when detection fails. Everywhere below,
`<game>`, `<docs>`, `<logs>`, `<mods>` and `<tiger>` mean these.

| Placeholder | What | Typical location |
|---|---|---|
| `<game>` | **Base game data, the primary source of truth** | `<steam library>\steamapps\common\Victoria 3\game`. Default library `C:\Program Files (x86)\Steam`; others are listed in `<steam>\steamapps\libraryfolders.vdf`. Linux: `~/.local/share/Steam/...` |
| `<docs>` | `script_docs` dumps | `<user documents>\Paradox Interactive\Victoria 3\docs`. **Not** the `logs` folder. Documents is often redirected to another drive or OneDrive, so resolve it rather than assuming `C:`. |
| `<logs>` | `error.log`, `database_conflicts.log`, `data_types/` | `<user documents>\Paradox Interactive\Victoria 3\logs` |
| `<mods>` | Where mods are developed | `<user documents>\Paradox Interactive\Victoria 3\mod` |
| `<tiger>` | vic3-tiger validator executable | Wherever the user installed it. Releases at github.com/amtep/tiger |

Confirm the build before trusting any version-specific claim:

```bash
python "<skill>/scripts/vic3_docs.py" stats
```

That prints the resolved paths, the build number, folder and schema-doc counts, how many
identifiers each dump holds, and how stale the dumps are. Run it at the start of a session.

## The three sources of truth

**1. The 91 `*.md` schema docs shipped inside `<game>`.** These are Paradox's own annotated
schemas, the Victoria 3 equivalent of CK3's `_*.info` files, and they sit inside the folder they
document (`common/buildings/buildings.md`, `common/journal_entries/journal_entries.md`). They
give the legal keys of a definition, each key's type, its default, and often the scope it runs
in. Read the doc before scripting a system. Their filenames follow no single rule, so find them
with:

```bash
python "<skill>/scripts/vic3_docs.py" folders <folder-name-fragment>
```

Only 75 of the 135 `common/` subfolders ship one, and `events/` ships none. Notably `decisions`,
`interest_groups`, `scripted_effects`, `state_traits` and `subject_types` are undocumented, so
for those a vanilla `.txt` in the folder is the reference. `decisions` is a special case: it has
no `.md` but does ship `common/decisions/000_decisions_help.txt`.

Where a doc and a vanilla file disagree, **the vanilla file wins**. These docs do contain errors:
`buildings.md` documents a `construction_points` field that live building files replace with
`required_construction`.

**2. The `script_docs` dumps in `<docs>`.** Roughly 12,800 identifiers: every effect, trigger,
modifier, event target, on_action and custom localization key the installed build knows, with
its supported scopes. This is the vocabulary. Never invent an effect or trigger name; check it:

```bash
python "<skill>/scripts/vic3_docs.py" find add_modifier
python "<skill>/scripts/vic3_docs.py" find -s power_bloc
```

`find` exits non-zero when an identifier does not exist, which makes it a usable gate. The six
dump files use four different internal formats, so a plain grep across them returns wrong or
empty answers. Use the script.

If `<docs>` is missing or stale, ask the user to launch with `-debug_mode` and run `script_docs`
and `dump_data_types` in the console, then read the files yourself.

**3. Vanilla files.** Copy a working vanilla definition and modify it. This is faster and safer
than writing from scratch, and it is the only reference for the 62 undocumented folders.

## Golden rules

1. Copy a working vanilla example and edit it. Do not write script from a blank file.
2. **Verify every effect, trigger and modifier name with `vic3_docs.py find` before writing it.**
   Inventing a plausible identifier is the single most common and most expensive failure.
3. Encoding: UTF-8 **with BOM** for both script `.txt` and localization `.yml`. Every vanilla
   file of both kinds ships a BOM (byte-checked on 1.13.10), so match vanilla. CK3 habits are
   wrong here: CK3 script files carry no BOM.
4. A mod is identified by `.metadata/metadata.json`. Victoria 3 does **not** use CK3's
   `descriptor.mod`.
5. The on_action folder is `common/on_actions/`, **plural**. CK3's is singular.
6. Never redefine a vanilla on_action's contents. Append your own:
   `on_monthly_pulse_country = { on_actions = { my_mod_pulse } }`. This is the top compatibility bug.
7. Event ids are `namespace.number` and their localization keys use **dots**:
   `my_events.1.t`, `.d`, `.f`, `.a`. The file needs a `namespace = my_events` header line.
8. Localization lives flat in `localization/english/`, filename ends `_l_english.yml`, first line
   is `l_english:`. Keys may live in any file, so filename does not bind to namespace. Add a key
   for every new name, or the raw key shows in-game.
9. **Victoria 3 has no flags.** `set_country_flag` and friends do not exist. Use `set_variable`,
   `has_variable`, and `save_scope_as`. Ported CK3 flag logic silently does nothing.
10. Mod folder layout mirrors `<game>` exactly. A folder-name typo means the file is ignored
    with no error. No non-ASCII characters anywhere in a mod's file paths: the game cannot load
    those mods at all.
11. Override direction is **inverted between script and GUI**. Files load in ASCII order and for
    script the last one loaded wins, but a GUI type or template cannot be overwritten once
    loaded, so for GUI the **first** wins. A CK3 modder's instinct is wrong here.
12. Prefer `REPLACE:my_object = { ... }` or `INJECT:my_object = { ... }` over copying a whole
    vanilla file. These key prefixes patch one object and leave the rest of the file alone.
    Victoria 3 has them and CK3 does not.
13. Validate with **vic3-tiger** before asking the user to test in-game
    (see [references/validation.md](references/validation.md)). It takes the mod **directory**,
    not a descriptor file.

## Workflow

1. Identify the system the task touches, then read the matching reference file below.
2. Read that system's schema doc (`vic3_docs.py folders <name>`) and open a vanilla example.
3. Verify every identifier you intend to write with `vic3_docs.py find`.
4. Write a new file carrying the mod's prefix, in the correct folder, UTF-8 with BOM.
5. Add localization for every new key.
6. Run vic3-tiger. Fix Fatal and Error, then Warning.
7. Ask the user to test in-game, then read `<logs>\error.log` yourself. Do not ask them what it says.

## Routing table

| Task involves | Read |
|---|---|
| Mod setup, `.metadata/metadata.json`, folder layout, load order, override and conflict rules, encoding | [references/setup.md](references/setup.md) |
| Script syntax, scopes, triggers vs effects, iteration, variables, scripted effects/triggers/values, prefixes like `c:` and `law_type:` | [references/language.md](references/language.md) |
| Buildings, production methods, goods, pops, technology, companies, trade | [references/economy.md](references/economy.md) |
| Events, on_actions, journal entries, decisions | [references/content.md](references/content.md) |
| Laws, law groups, interest groups, political movements, diplomacy, power blocs, subject types | [references/politics.md](references/politics.md) |
| Writing localization, formatting markers, data functions, customizable and trigger localization | [references/localization.md](references/localization.md) |
| Custom UI, `.gui` files, scripted widgets, scripted GUIs, buttons, progress bars | [references/gui.md](references/gui.md) |
| Running vic3-tiger, reading logs, the console, debugging a mod that does nothing | [references/validation.md](references/validation.md) |

Read more than one when the task spans systems. Most content work also needs localization.

## Silent-failure checklist

When the user says "it does nothing", work through: missing BOM on a `.txt` or `.yml` file ·
folder name typo · `on_action` written singular instead of `on_actions` · unbalanced braces, which
abort the rest of the file · an effect used in a trigger block or the reverse · an identifier that
does not exist in this build (`vic3_docs.py find` settles it) · missing localization key · event
loc keys written with underscores instead of dots · missing `namespace` header · a vanilla
on_action overwritten instead of appended to · `descriptor.mod` used instead of
`.metadata/metadata.json` · a GUI override that lost because GUI is first-wins · a non-ASCII
character somewhere in the mod's path · a modifier that turned out to be a "potential dynamic"
key with no display name, which the engine accepts and then ignores. Then run vic3-tiger, read
`<logs>\error.log`, and check `<logs>\database_conflicts.log` to see which file won each override.

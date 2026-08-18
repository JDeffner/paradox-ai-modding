<!--
Project-memory template for a CK3 mod repo. Copy to <your mod repo>/CLAUDE.md and fill in
everything marked <like this>. Works as AGENTS.md for other agents too.
-->

# <Mod Name>

Crusader Kings III mod. Target game version: <e.g. 1.19.x>. Descriptor: `descriptor.mod`.
Mod prefix: `<prefix>_` (all new files, script keys, and loc keys carry it).

Use the `ck3-modding` skill for all modding work: workflow, per-system references, and the
silent-failure checklist live there.

## Machine paths

Resolved once; the skill's `<game>` / `<logs>` / etc. placeholders mean these:

| Placeholder | Path on this machine |
|---|---|
| `<game>` | `<...\steamapps\common\Crusader Kings III\game>` |
| `<logs>` | `<...\Documents\Paradox Interactive\Crusader Kings III\logs>` |
| `<mods>` | `<...\Documents\Paradox Interactive\Crusader Kings III\mod>` |
| `<workshop>` | `<...\steamapps\workshop\content\1158310>` |
| `<tiger>` | `<full path to ck3-tiger executable>` |

## Ground rules

- Validate with ck3-tiger after writing script, before asking me to test in-game. Fix
  Fatal/Error always; Warnings unless clearly false positives.
- Script `.txt` is UTF-8. Localization is UTF-8 **with BOM**, filename ends `_l_english.yml`,
  first line `l_english:`. Every new key gets localization.
- New files only, `<prefix>_` in the filename; never overwrite whole vanilla files, and never
  redefine a vanilla on_action's `trigger`/`effect` (append via `on_actions = { ... }`).
- After I run an in-game test, read `<logs>\error.log` yourself; don't ask me what it says.

## Mod conventions

<!-- Project-specific knowledge the skill cannot know. Examples: -->
- <Design pillars: what the mod is about, what is out of scope.>
- <Systems in progress and where they live, e.g. "the rebellion system: common/scripted_effects/<prefix>_rebellion_effects.txt, all balance values in common/script_values/<prefix>_rebellion_values.txt".>
- <Compatibility targets: mods this must stay compatible with, known conflict areas.>
- <Testing: preferred save file, console shortcuts, debug decisions.>

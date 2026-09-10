<!--
Drop-in agent-memory template for a Victoria 3 mod repo. Copy to <your mod repo>/AGENTS.md
and fill in everything marked <like this>. Codex loads AGENTS.md. For Claude Code, copy the
adjacent CLAUDE.md adapter too; it imports these instructions with @AGENTS.md.

Keep this file to facts about THIS mod. Procedure lives in the vic3-modding skill, which the
agent loads on demand. Duplicating the skill here just burns context on every request.
-->

# <Mod Name>

Victoria 3 mod. Target game version: <e.g. 1.13.x>. Mod prefix: `<prefix>_` (every new file,
script key and localization key carries it).

Use the `vic3-modding` skill for modding work. It carries the workflow, the ground-truth
lookups, and the silent-failure checklist.

## Machine paths

Pinning these skips per-session detection. They are what the skill's placeholders mean.

| Placeholder | Path on this machine |
|---|---|
| `<game>` | `<...\steamapps\common\Victoria 3\game>` |
| `<docs>` | `<...\Documents\Paradox Interactive\Victoria 3\docs>` |
| `<logs>` | `<...\Documents\Paradox Interactive\Victoria 3\logs>` |
| `<mods>` | `<...\Documents\Paradox Interactive\Victoria 3\mod>` |
| `<tiger>` | `<full path to vic3-tiger executable>` |

## Mod conventions

<!-- Project knowledge the skill cannot know. Delete what does not apply. -->

- <Design pillars: what this mod is about, and what is deliberately out of scope.>
- <Systems in progress and where they live, e.g. "the tariff system: common/scripted_effects/<prefix>_tariff_effects.txt, all balance numbers in common/script_values/<prefix>_tariff_values.txt".>
- <Balance conventions: where magic numbers are allowed to live, and where they are not.>
- <Compatibility targets: mods this must keep working with, and the known conflict areas.>
- <Testing: preferred save file, console shortcuts, debug decisions.>

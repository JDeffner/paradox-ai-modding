# CK3 recipe index

These 25 recipes were imported from a community skill in July 2026. Their caveats remain in each file. They are design examples, not a patch-certified API reference. A plugin release does not change their verification status.

Start with the installed schema and a working native example. Read a recipe when its structure helps the task. Before copying a skeleton, verify its keys, scopes, called effects, localization, textures, and entry path. Keep source-verified structure distinct from runtime-tested behavior.

| Recipe | Status |
|---|---|
| [activities](patterns/activities.md) | Imported example; verify before use |
| [ai](patterns/ai.md) | Imported example; verify before use |
| [buildings](patterns/buildings.md) | Imported example; verify before use |
| [casus-belli](patterns/casus-belli.md) | Imported example; verify before use |
| [characters](patterns/characters.md) | Imported example; verify before use |
| [court-positions](patterns/court-positions.md) | Imported example; verify before use |
| [culture-religion](patterns/culture-religion.md) | Imported example; verify before use |
| [decisions](patterns/decisions.md) | Imported example; verify before use |
| [dynasties](patterns/dynasties.md) | Imported example; verify before use |
| [epidemics](patterns/epidemics.md) | Imported example; verify before use |
| [events](patterns/events.md) | Imported example; verify before use |
| [factions](patterns/factions.md) | Imported example; verify before use |
| [flags](patterns/flags.md) | Imported example; verify before use |
| [gfx](patterns/gfx.md) | Imported example; verify before use |
| [governments](patterns/governments.md) | Imported example; verify before use |
| [great-projects](patterns/great-projects.md) | Imported example; verify before use |
| [history](patterns/history.md) | Imported example; verify before use |
| [holdings](patterns/holdings.md) | Imported example; verify before use |
| [lifestyles](patterns/lifestyles.md) | Imported example; verify before use |
| [map-modding](patterns/map-modding.md) | Imported example; verify before use |
| [map-objects](patterns/map-objects.md) | Imported example; verify before use |
| [men-at-arms](patterns/men-at-arms.md) | Imported example; verify before use |
| [schemes](patterns/schemes.md) | Imported example; verify before use |
| [story-cycles](patterns/story-cycles.md) | Imported example; verify before use |
| [traits](patterns/traits.md) | Imported example; verify before use |

## Focused checks, 2026-09-09

The decision and event examples received a focused source check against CK3 1.19.0.6. The event namespace and letter ID correction follows `events/_events.info`. The decision illustration paths occur in `common/decisions/00_lifestyle_decisions.txt` and `00_guest_decisions.txt`. These checks do not certify every variant in either recipe. No new in-game recipe tests were run.

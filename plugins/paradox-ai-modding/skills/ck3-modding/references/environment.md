# CK3 environment and source lookup

Resolve paths once, starting with the project's instructions. Verify that they exist. Keep local paths in project configuration, not in an installed skill copy.

| Placeholder | Location |
|---|---|
| `<game>` | `<steam library>/steamapps/common/Crusader Kings III/game`; Steam's `steamapps/libraryfolders.vdf` lists other libraries |
| `<logs>` | `<CK3 user directory>/logs`; on Windows the user directory is normally under Documents, which may be redirected or in OneDrive |
| `<mods>` | `<CK3 user directory>/mod`; distinguish launcher descriptors here from the source folder named by `path=` |
| `<workshop>` | `<steam library>/steamapps/workshop/content/1158310` |
| `<tiger>` | Installed `ck3-tiger` executable for the current operating system |

On Linux, check `~/.local/share/Steam` for Steam and `~/.local/share/Paradox Interactive/Crusader Kings III` for user data. Use detected paths rather than assuming defaults exist. Ask for a location only when detection and project instructions do not resolve it.

## Build and schema

Read `launcher/launcher-settings.json` beside the game directory and inspect `rawVersion`. On Windows PowerShell, specify UTF-8:

```powershell
(Get-Content -Raw -Encoding UTF8 '<install>/launcher/launcher-settings.json' | ConvertFrom-Json).rawVersion
```

Read the relevant `_*.info` file's notes and structure, then a working definition in the same database. Angle-bracket fields such as `<key>` are placeholders. Comments often state types, defaults, and scopes. A missing documented default alone does not prove a field is required; check native use.

For exact identifiers, read fresh `effects.log`, `triggers.log`, `event_targets.log`, and `event_scopes.log` from `script_docs`. The game's `tests/` directory supplies additional examples. A dump older than a game update cannot establish the current signature.

Use `rg` to search the relevant schema, vanilla database, or dump. Resolve an effect's scope and find a real caller before adding it. Keep installed game and Workshop files read-only.

## Runtime evidence

| Question | Evidence |
|---|---|
| Did the engine accept the change? | Fresh `error.log` after loading and exercising the changed system |
| Which override won? | `database_conflicts.log` from the current launch |
| What GUI functions and types exist? | `dump_data_types` output under `logs/data_types/` |
| Why does the screen fail? | Rendered screen, `gui_warnings.log`, and `error.log` |
| Did the effect run correctly? | Before/after state through the normal entry point, supported by current logs |

Check timestamps before reading a dump as evidence. Record a reproduction baseline to separate old errors from new ones. If a required dump is missing, use available authorized controls to produce it. Otherwise ask the user for the exact launch or console step and read the files yourself afterwards. Missing GUI controls do not prevent static work or log analysis.

## Workshop patterns

Princes of Darkness (`2216659254`) and A Game of Thrones (`2962333032`) supply advanced patterns when installed. Read the distilled notes in [pod.md](../mods/pod.md) and [agot.md](../mods/agot.md). Their variables, effects, widget types, and textures may be mod-specific. Trace dependencies before adapting a sample into the user's mod.

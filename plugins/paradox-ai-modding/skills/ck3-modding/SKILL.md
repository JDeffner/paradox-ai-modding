---
name: ck3-modding
description: Create, change, and debug Crusader Kings III mod scripts, localization, setup, and compatibility. Use for CK3 events, decisions, traits, schemes, activities, history, culture, religion, and related game systems. For CK3 interface work use ck3-gui; for live checklist runs use ck3-playtest. Does not cover Victoria 3 or other Paradox games.
---

# CK3 Modding

Implement the requested CK3 behavior using the installed game's schemas and working examples. Most features span several databases. Keep those changes together instead of treating each file type as a separate task.

## Establish the environment

Read the mod project's instructions and current worktree status. Reuse its confirmed game, log, mod, Workshop, and tiger paths. If they are missing, read [environment.md](references/environment.md). Keep machine paths and project rules in the project, not in this portable skill. Never edit the game installation or subscribed Workshop sources.

The maintained source is `plugins/paradox-ai-modding/skills/` in `JDeffner/paradox-ai-modding`. Installed caches and copied skills are deployment copies. Make reusable corrections in the source repository, then update the installation. Do not regenerate skills from the old Paradox Toolkit repository.

## Choose the workflow

- For scripts and content, use the workflow below and load only the relevant references.
- For custom windows, HUD integration, layout, or data bindings, read [ck3-gui](../ck3-gui/SKILL.md). Read scripting references here when the interface also changes game behavior.
- For a live checklist run, visual verification, or retesting a runtime fix, read [ck3-playtest](../ck3-playtest/SKILL.md). A project's own playtesting skill supplies its scenarios and local tools.

Install the three CK3 skill directories together when using direct installation. They share references. Ordinary script work does not require loading GUI or playtesting instructions until that workflow is needed.

## Author and validate

1. Identify the entry point, affected state, and every reader of that state. A decision that starts a scheme needs the decision gates, scheme completion path, AI behavior, and visible feedback to agree.
2. Read the relevant installed `_*.info` schema and a working vanilla example. Use a fresh `script_docs` dump for exact effect, trigger, and scope signatures. Check the installed build and dump timestamps. Workshop patterns may depend on that mod's own definitions and assets.
3. Make the smallest change that implements the request. Use the project's filename prefix and mirror the game's directory structure. Prefer additive files or single-object overrides where supported. Consult [setup.md](references/setup.md) for database-specific merge rules; do not assume all script and history files merge alike.
4. Check player and AI paths, success and failure outcomes, costs, cooldowns, and localization. For AI weights, copy the system's native structure and account for intended character behavior. Add all title, description, option, tooltip, and confirmation keys the changed entry point reads.
5. Run the installed ck3-tiger with the project's configuration. Fix errors introduced by the change and distinguish pre-existing or version-related diagnostics. Enable relevant localization checks for localization work. See [validation.md](references/validation.md).
6. Test behavior that needs the live engine through the actual entry point. Use available authorized game controls, or give the user the exact manual step that is missing. Read fresh logs yourself. Report static results separately from runtime results and identify checks still open.

## Invariants

- Find identifiers in local evidence. Do not invent effect, trigger, animation, or GUI function names.
- Extend vanilla on_actions by appending a custom on_action. Do not replace their `trigger` or `effect` to add a hook.
- Use UTF-8 with BOM for localization, with the matching `_l_<language>.yml` filename and `l_<language>:` header. Preserve the project's script encoding convention.
- Bound repeated scans and AI work. Check actual invocation frequency before adding costly iterators or script values.
- A tiger pass does not prove the live engine accepted a field, loaded an edit, rendered a tooltip, or executed a branch.

## References

| Task | Read |
|---|---|
| Paths, build, logs, schema navigation | [environment.md](references/environment.md) |
| Descriptors, setup, load order, overrides | [setup.md](references/setup.md) |
| Syntax, scopes, variables, lists, effects, triggers, values | [language.md](references/language.md) |
| Events, on_actions, decisions, interactions, schemes, activities, story cycles | [events.md](references/events.md) |
| Localization, history, map, titles, CoA, culture, religion, traits, dynasties | [content.md](references/content.md) |
| GUI examples and layout findings | [gui.md](references/gui.md) |
| Static validation | [validation.md](references/validation.md) |
| Console, logs, portraits, troubleshooting | [debugging.md](references/debugging.md) |
| Mod conflicts and total-conversion submods | [compat.md](references/compat.md), [check_compat.sh](scripts/check_compat.sh) |
| Secrecy, supernatural systems, custom UI patterns | [pod.md](mods/pod.md) |
| AI drama, story cycles, duels, secrets, performance | [agot.md](mods/agot.md) |
| Optional per-system design examples | [Recipe index](references/recipes.md) |

## When a change does nothing

Trace the actual entry point before changing more code. Check the descriptor's `path`, folder spelling (`common/on_action` is singular), encoding, parse errors, scope, visibility and validity gates, and required localization. Inspect `database_conflicts.log` for the winning override. For UI, check registry names and declared `saved_scopes` against the caller's `AddScope` chain. Read fresh errors from the reproduction; old entries do not establish that a fix failed.

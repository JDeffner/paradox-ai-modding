# Debugging CK3 mods

Use [environment.md](environment.md) to resolve paths and check dump freshness. Use available authorized controls for runtime evidence; otherwise request the exact manual step and read the logs yourself. For sustained checklist runs, follow [ck3-playtest](../../ck3-playtest/SKILL.md).

## Debugging workflow

1. Establish a fresh reproduction with the available authorized controls, or give the user the exact missing step. Use a separate test campaign for state changes.
2. Read error.log after loading and exercising the affected path. Compare new messages against the session baseline.
3. Resolve unknown identifiers in fresh script_docs dumps and unfamiliar GUI bindings in dump_data_types output. See environment.md for locations and freshness checks.
4. Use a console fixture to isolate an effect when needed, then retest its normal caller. A directly fired event does not verify a decision, scheme, or on_action path.
5. Read database_conflicts.log for contested overrides. The game's tests directory supplies worked examples.
6. Track edits awaiting reload separately. Confirm each change through the affected path before calling it fixed in the running game.

## Graphics, portraits, music (brief)

Portraits use a gene/DNA system: `common/genes`, `common/ethnicities`, `common/dna_data`,
`common/portrait_types` (script side; the texture/mesh side lives in the install's `gfx/`).
New clothes require overriding genes; new animations require overriding the idle animation.
Assets are `.dds` textures + `.mesh` models (Maya exporter; configs in `tools/`). The in-game
portrait editor (debug mode) exports DNA strings. Music/sound: definitions in `music/` and
`sound/` gated by triggers. For deep work here use the wiki (Graphical assets, 3D models pages)
plus the install's `gfx/`. PoD's `common/dna_data/` (per-clan DNA files) and `common/genes/`
overrides are a good worked example of heavy portrait modding.

## Tooling and resources

- **ck3-tiger** (`<tiger>`) is the primary validator; see `validation.md`.
  A VS Code wrapper exists ("ck3tiger for VS Code"); Paradox Highlight provides syntax coloring.
  Avoid recommending CWTools for CK3: its CK3 rules repo has been unmaintained since 2023,
  expect heavy false positives on any post-2023 content.
- **Irony Mod Manager**: playset/conflict management and merging.
- **git** for the mod folder; WinMerge/KDiff3 to diff against new patches.
- Wiki hub: https://ck3.paradoxwikis.com/Modding (subpages: Scripting, Scopes, Event modding,
  Decisions modding, Localization, Title modding, Map modding, Culture modding, Religions
  modding, Trait modding, Coat of arms modding, Interface, Mod compatibility). Some pages lag
  game versions; trust local game files over the wiki on conflicts.
- CK3 Modding Discord: https://discord.com/invite/apEvxDZ · Paradox forum CK3 modding subforum.

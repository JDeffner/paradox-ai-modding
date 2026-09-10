# Maintain the skills and plugin

The source of truth is `plugins/paradox-ai-modding/skills/`. Both plugin manifests use that directory. Direct installations should link to those same directories or be refreshed from them. Keep backups of personalized copies outside skill discovery directories before replacing them.

## Change the right layer

- Put shared CK3 scripting and source-lookup guidance in `ck3-modding`.
- Put interface authoring procedures in `ck3-gui`, with detailed mechanics in the shared GUI reference.
- Put reusable runtime procedures in `ck3-playtest`. Keep project checklists, saves, navigation, and local tool permissions in the mod project.
- Keep Victoria 3 vocabulary and lookup behavior in `vic3-modding`.
- Keep per-system examples as references unless a distinct workflow warrants a new skill.

## Validate a change

From the repository root, run the client validator when Claude Code is installed:

```bash
claude plugin validate plugins/paradox-ai-modding
claude plugin validate .claude-plugin/marketplace.json
```

For Codex, use the plugin-creator skill's `scripts/validate_plugin.py` on `plugins/paradox-ai-modding`. Use skill-creator's `scripts/quick_validate.py` on each changed skill. Those validators belong to the installed authoring tools and are not vendored here.

Check relative links from their containing file, including sibling-skill references. Confirm both manifests agree on name, version, and skill directory. If changing lookup code, run the affected operation against local game documentation and include an unknown-identifier case. A manifest pass does not prove good task routing or game behavior.

For a substantial workflow change, try a representative request in a fresh session and inspect what the agent does. Useful cases include a CK3 decision with localization, a broken CK3 button binding, a review-only playtest, and Victoria 3 GUI work. The last case must select Victoria 3 guidance. Do not mark behavioral checks passed merely because the expected instruction appears in SKILL.md.

## Update an installation

Direct directory links track source changes. Start a new session to reload instructions. Keep links to all three CK3 skills together.

For installed Claude Code plugins, update the local marketplace and plugin:

```bash
claude plugin marketplace update paradox-ai-modding
claude plugin update paradox-ai-modding@paradox-ai-modding
```

Start a new session afterwards. For quick development, `claude --plugin-dir` loads the source directory without the installed cache.

For an installed Codex plugin, follow the installed plugin-creator skill's local update procedure. It uses `scripts/update_plugin_cachebuster.py` on the plugin source, then `codex plugin add paradox-ai-modding@personal` to reinstall from the included local catalog. That workflow can add a local cache suffix to the Codex manifest. Do not carry that suffix into a public release; keep both release versions aligned.

Keep only one active installation of each skill in a client. Archive old standalone copies before enabling the plugin, or uninstall the plugin before switching back to direct links. Never edit a cached plugin to make a durable correction.

## Release

Keep `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json` inside the plugin on the same release version. Both clients distribute the same skill sources. The bundled LICENSE is a copy of the repository license for standalone plugin distribution; keep them identical. Validate before publishing. Publishing, commits, and pushes require the maintainer's instruction.

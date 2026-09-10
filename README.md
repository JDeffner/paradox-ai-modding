# Paradox AI Modding

Skills for building and testing Crusader Kings III and Victoria 3 mods. The agent reads the installed game's documentation, copies working patterns, validates changes, and distinguishes static checks from in-game evidence.

One plugin contains the same skill files for Codex and Claude Code. Direct skill installation also works. There is no MCP server or background service.

## Skills

| Skill | Use it for |
|---|---|
| [ck3-modding](plugins/paradox-ai-modding/skills/ck3-modding/SKILL.md) | CK3 scripts, localization, setup, and compatibility |
| [ck3-gui](plugins/paradox-ai-modding/skills/ck3-gui/SKILL.md) | Native windows, HUD integration, layout, and data bindings |
| [ck3-playtest](plugins/paradox-ai-modding/skills/ck3-playtest/SKILL.md) | Live checklists, visual checks, normal entry paths, and retests |
| [vic3-modding](plugins/paradox-ai-modding/skills/vic3-modding/SKILL.md) | Victoria 3 scripts, economy, politics, GUI, and documentation lookup |

Events, decisions, traits, schemes, and other CK3 systems remain references under the main skill. A feature can cross those systems without loading unrelated workflows. The [recipe index](plugins/paradox-ai-modding/skills/ck3-modding/references/recipes.md) records the limits of the imported examples.

## Install from a local checkout

```bash
git clone https://github.com/JDeffner/paradox-ai-modding.git
cd paradox-ai-modding
```

### Codex

```bash
codex plugin marketplace add .
codex plugin add paradox-ai-modding@personal
```

The included Codex catalog is named `personal`. Start a new thread after installation. Select the plugin's skills by name or describe the modding task.

### Claude Code

```bash
claude plugin marketplace add .
claude plugin install paradox-ai-modding@paradox-ai-modding
```

Start a new session after installation. Explicit invocation uses the plugin namespace, for example `/paradox-ai-modding:ck3-gui`. For development without an installed cache, start from your mod directory with:

```bash
claude --plugin-dir /absolute/path/to/paradox-ai-modding/plugins/paradox-ai-modding
```

These are local-checkout instructions. New packaging becomes available from GitHub only after the maintainer publishes the changes. Claude's plugin structure and development loading are documented in [Create plugins](https://code.claude.com/docs/en/plugins).

### Direct skills

Copy or link directories from `plugins/paradox-ai-modding/skills/` into `~/.agents/skills/` for Codex or `~/.claude/skills/` for Claude Code. Install all three CK3 skills together because they share references. The Victoria 3 skill is independent. Start a new session afterwards.

Use either the plugin or direct skills in each client. Remove or archive older standalone copies when switching to the plugin so the agent does not discover both versions. Preserve local additions before replacing anything.

## Keep one source

Edit reusable guidance in `plugins/paradox-ai-modding/skills/`. The Codex and Claude manifests both point at that directory. Do not edit installed plugin caches or regenerate CK3 skills from the old Paradox Toolkit repository.

Keep game paths, mod conventions, playtest scenarios, and project permissions in each mod's instructions. [The CK3 template](templates/ck3/AGENTS.md) and [Victoria 3 template](templates/vic3/AGENTS.md) provide starting points. Cultivation-specific lore, checkpoints, and control tools belong in the Cultivation project.

After pulling source updates, refresh an installed plugin using the client's update flow. Direct directory links track source edits but still need a new session to reload instructions. [Maintenance instructions](guides/maintenance.md) cover validation and local updates.

## Game setup

The skills need read access to the installed game, its logs, and the mod project. They use [tiger](https://github.com/amtep/tiger) for static validation. Computer control is optional and must be available and authorized for agent-operated playtests.

- [CK3 setup](guides/ck3/getting-started.md)
- [Victoria 3 setup](guides/vic3/getting-started.md)
- [Paradox Toolkit](https://github.com/JDeffner/paradox-modding-toolkit), an optional editor and language-server companion

Victoria 3 includes a Python 3 helper for its local documentation:

```bash
python plugins/paradox-ai-modding/skills/vic3-modding/scripts/vic3_docs.py stats
python plugins/paradox-ai-modding/skills/vic3-modding/scripts/vic3_docs.py find add_modifier
```

The existing references were developed against CK3 1.19.x and Victoria 3 1.13.10. Verify the installed build before using patch-specific details. Current game files and fresh dumps take precedence over these references. Packaging validation does not certify every recipe or runtime behavior.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for source evidence, scope, and validation expectations. Licensed under [GPL-3.0](LICENSE).

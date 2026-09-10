# Paradox AI Modding

Skills for building and testing **Crusader Kings III** and **Victoria 3** mods with Codex or
Claude Code. The agent works from your installed game's documentation and vanilla examples,
validates changes, and distinguishes static checks from in-game evidence.

One plugin, shared skill sources, no MCP server or background service. You supply the game,
mod project, and local tools.

| Skill | Purpose |
|---|---|
| [ck3-modding](plugins/paradox-ai-modding/skills/ck3-modding/SKILL.md) | Scripts, localization, setup, and compatibility |
| [ck3-gui](plugins/paradox-ai-modding/skills/ck3-gui/SKILL.md) | Native windows, HUD integration, layout, and bindings |
| [ck3-playtest](plugins/paradox-ai-modding/skills/ck3-playtest/SKILL.md) | Live checklists, visual checks, and retests |
| [vic3-modding](plugins/paradox-ai-modding/skills/vic3-modding/SKILL.md) | Scripts, economy, politics, GUI, and documentation lookup |

## Quick start

```bash
git clone https://github.com/JDeffner/paradox-ai-modding.git
cd paradox-ai-modding
```

Install for your client:

```bash
# Codex
codex plugin marketplace add .
codex plugin add paradox-ai-modding@personal

# Claude Code
claude plugin marketplace add .
claude plugin install paradox-ai-modding@paradox-ai-modding
```

Start a new session in your mod project, configure its game and log paths, and request a
concrete change. See [Installation](https://github.com/JDeffner/paradox-ai-modding/wiki/Installation)
for direct skills, development loading, and updating older installations.

## Documentation

The **[wiki](https://github.com/JDeffner/paradox-ai-modding/wiki)** contains the full guides:

- [CK3 setup](https://github.com/JDeffner/paradox-ai-modding/wiki/CK3-Getting-Started)
  and [Victoria 3 setup](https://github.com/JDeffner/paradox-ai-modding/wiki/Victoria-3-Getting-Started)
- [Workflows](https://github.com/JDeffner/paradox-ai-modding/wiki/Workflows),
  [tools](https://github.com/JDeffner/paradox-ai-modding/wiki/Tools), and
  [troubleshooting](https://github.com/JDeffner/paradox-ai-modding/wiki/Troubleshooting)
- [Adding another Paradox game](https://github.com/JDeffner/paradox-ai-modding/wiki/Adding-a-Game)
- [Architecture](https://github.com/JDeffner/paradox-ai-modding/wiki/Architecture)
  and [maintenance](https://github.com/JDeffner/paradox-ai-modding/wiki/Maintenance)

Current game files and fresh dumps take precedence over the bundled references. Packaging
checks do not certify game behavior or every imported recipe.

Contributions: [CONTRIBUTING.md](CONTRIBUTING.md). Security reports: [SECURITY.md](SECURITY.md).
Licensed under [GPL-3.0](LICENSE).

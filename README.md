# CK3 AI Modding

A suite for modding Crusader Kings III with AI agents: an agent skill that teaches the full
CK3 modding workflow (ground truth, silent-failure traps, validation, log-driven debugging),
plus guides and templates for wiring an agent into your modding setup.

Built for [Claude Code](https://claude.com/claude-code) and anything else that reads the
plain-markdown [Agent Skills](https://code.claude.com/docs/en/skills) format; the content also
works as pasted context for other agents.

## Why

CK3's default failure mode is **silent**: a wrong encoding, a folder typo, or an unbalanced
brace makes the game ignore your file with no error. An unassisted LLM makes it worse by
guessing trigger and effect names from memory. The skill counters both by forcing a
ground-truth workflow:

- read the game's own `_*.info` schema docs and `script_docs` dumps instead of guessing;
- copy working vanilla examples instead of writing script from scratch;
- validate with [ck3-tiger](https://github.com/amtep/tiger) before any in-game test;
- have the agent read `error.log` and `database_conflicts.log` itself instead of asking you
  what they say.

## What's inside

| Path | What |
|---|---|
| [`skills/ck3-modding/`](skills/ck3-modding/SKILL.md) | The agent skill: workflow and routing table, per-system references (script language, events, content, GUI, validation, debugging, compat), 24 deep per-system recipes, pattern notes distilled from flagship Workshop mods, and a mod-vs-mod conflict checker script |
| [`guides/getting-started.md`](guides/getting-started.md) | Set up an agent for CK3 modding, end to end |
| [`templates/CLAUDE.md`](templates/CLAUDE.md) | Drop-in project-memory template for a mod repo |

## Quick start (Claude Code)

```bash
git clone https://github.com/JDeffner/ck3-ai-modding.git
```

Then copy (or symlink) the skill where Claude Code looks for skills:

- for all your projects: `skills/ck3-modding/` into `~/.claude/skills/`
- for one mod repo: `skills/ck3-modding/` into `<mod repo>/.claude/skills/`

Open a session in your mod folder and ask for something CK3 ("add a decision that ...").
At the start of a session the skill resolves your machine's paths (game install, logs folder,
mod folder, ck3-tiger); pin them in your mod's `CLAUDE.md` (see the template) to skip
detection. Full walkthrough: [`guides/getting-started.md`](guides/getting-started.md).

## Recommended companions

- **[ck3-tiger](https://github.com/amtep/tiger)**: the standard CK3 validator. The skill
  treats a clean tiger run as a hard gate before in-game testing.
- **[CK3 Modding Toolkit](https://marketplace.visualstudio.com/items?itemName=JDeffner.ck3-modding-toolkit)**
  (VS Code extension): diagnostics, navigation, and tooling for Paradox script; it can also
  download ck3-tiger for you.
- **The game's own docs**: the ~150 `_*.info` schema files inside `game/common/`, the engine
  self-tests in `game/tests/`, and console `script_docs` dumps. The skill leans on these over
  the wiki, because they are version-exact for your installed patch.

## Contributing

Corrections and additions are welcome; every technical claim must be verified against actual
game or mod files. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE).

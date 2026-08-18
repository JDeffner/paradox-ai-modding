# Paradox AI Modding

Agent skills for modding Paradox grand strategy games: **Crusader Kings III** and
**Victoria 3**. Each skill teaches an AI agent the real workflow for its game, including the
silent-failure traps, the ground-truth sources, and the log-driven debugging loop, plus guides
and templates for wiring an agent into your modding setup.

Built for [Claude Code](https://claude.com/claude-code) and anything else that reads the
plain-markdown [Agent Skills](https://code.claude.com/docs/en/skills) format; the content also
works as pasted context for other agents.

## Why

Both games fail the same way: **silently**. A wrong encoding, a folder typo, or an unbalanced
brace makes the game ignore your file and say nothing at all. An unassisted LLM makes it worse by
guessing trigger and effect names from memory, and the names it invents sound entirely plausible.

Both skills counter this by forcing a ground-truth workflow: read the game's own shipped
documentation instead of guessing, copy a working vanilla example instead of writing from
scratch, validate with tiger before any in-game test, and read the logs yourself rather than
asking the user what they say.

## What's inside

| Path | What |
|---|---|
| [`skills/ck3-modding/`](skills/ck3-modding/SKILL.md) | **CK3 skill.** Workflow and routing table, per-system references (script language, events, content, GUI, validation, debugging, compat), 24 deep per-system recipes, pattern notes distilled from flagship Workshop mods, and a mod-vs-mod conflict checker |
| [`skills/vic3-modding/`](skills/vic3-modding/SKILL.md) | **Victoria 3 skill.** Workflow, golden rules, routing table, and eight reference files (setup, language, economy, content, politics, localization, GUI, validation) |
| [`skills/vic3-modding/scripts/vic3_docs.py`](skills/vic3-modding/scripts/vic3_docs.py) | Resolves Victoria 3's own docs: identifier lookup, folder-to-schema-doc map, freshness check |
| [`guides/ck3/`](guides/ck3/getting-started.md) · [`guides/vic3/`](guides/vic3/getting-started.md) | Set up an agent for each game, end to end |
| [`templates/ck3/CLAUDE.md`](templates/ck3/CLAUDE.md) · [`templates/vic3/AGENTS.md`](templates/vic3/AGENTS.md) | Drop-in agent-memory templates for a mod repo |

## Quick start

```bash
git clone https://github.com/JDeffner/paradox-ai-modding.git
```

Copy (or symlink) the skill for your game where Claude Code looks for skills:

- for all your projects: `skills/<game>-modding/` into `~/.claude/skills/`
- for one mod repo: `skills/<game>-modding/` into `<mod repo>/.claude/skills/`

Skills are read at startup, so restart Claude Code afterwards. Then open a session in your mod
folder and ask for something ("add a decision that ...", "add a production method that ...").

At the start of a session the skill resolves your machine's paths (game install, logs folder, mod
folder, tiger); pin them in your mod's memory file to skip detection. Full walkthroughs:
[CK3](guides/ck3/getting-started.md) · [Victoria 3](guides/vic3/getting-started.md).

## The two skills are deliberately different shapes

Same goal, opposite method, because the games ship different amounts of machine-readable truth.

**CK3** ships ~150 `_*.info` schema docs and engine self-tests, but much of the state of the art
lives in Workshop mods rather than in vanilla. So its skill carries hand-written per-system
recipes and distilled pattern notes: the knowledge is real and it cannot be looked up.

**Victoria 3** documents itself three times over, and all of it sits on your disk:

| Source | Answers | Where |
|---|---|---|
| 91 `*.md` schema docs | Which keys are legal inside a definition | Inside `game/`, next to the data |
| `script_docs` console dumps | Which effects, triggers, modifiers, targets and on_actions exist, and in what scope | `Documents/Paradox Interactive/Victoria 3/docs` |
| Vanilla files | Working idiom to copy | `game/common/`, `game/events/` |

None of it is convenient: the dumps hold about 12,800 identifiers across six files in four
internal formats, one of which embeds raw control bytes, so a plain grep returns wrong or empty
answers. So the Victoria 3 skill caches only what cannot be looked up and ships a script for
everything else, rather than paraphrasing documentation that goes stale on the next patch.

```bash
# Is this a real identifier, and what scopes accept it?
python skills/vic3-modding/scripts/vic3_docs.py find add_modifier

# Search when you know the concept but not the name
python skills/vic3-modding/scripts/vic3_docs.py find -s power_bloc

# Build version, folder and doc counts, how stale the dumps are
python skills/vic3-modding/scripts/vic3_docs.py stats
```

`find` exits non-zero on an unknown identifier, so it works as a gate in a script or a hook.
Python 3 and a Victoria 3 install are the only requirements.

## Recommended companions

- **[tiger](https://github.com/amtep/tiger)**: the standard validator, with a build per game
  (`ck3-tiger`, `vic3-tiger`). Both skills treat a clean tiger run as a hard gate before in-game
  testing. Note that ck3-tiger takes the `.mod` descriptor while vic3-tiger takes the mod
  directory, and that tiger tracks each game a patch or two behind.
- **[Paradox Toolkit](https://github.com/JDeffner/ck3-modding-toolkit)** (VS Code): diagnostics,
  navigation and tooling for Paradox script, with first-class CK3 and Victoria 3 profiles. It can
  also download tiger for you.
- **The games' own docs**: CK3's ~150 `_*.info` files and its `tests/` self-tests, Victoria 3's
  91 `*.md` schema docs, and both games' `script_docs` dumps. All version-exact for your
  installed patch, which no wiki can be.

## Verified against

CK3 **1.19.x** and Victoria 3 **1.13.10 (Matcha)**, on live installs. Counts quoted in the skills
come from those builds. Neither skill reproduces an identifier list, because the dumps on your
disk are always more current than a copy in a repository.

## Contributing

Corrections and additions are welcome; every technical claim must be verified against actual
game or mod files. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[GPL-3.0](LICENSE), same as the Paradox Toolkit.

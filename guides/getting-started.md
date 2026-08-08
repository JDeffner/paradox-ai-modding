# Getting started: an AI agent for CK3 modding

End-to-end setup for modding CK3 with an agent. Claude Code is used as the running example;
the last section covers other agents.

## What you need

- Crusader Kings III installed (Steam).
- [Claude Code](https://claude.com/claude-code) (CLI, desktop app, or IDE extension).
- [ck3-tiger](https://github.com/amtep/tiger): download the release matching your game
  version and unzip it anywhere. Optional but strongly recommended; the skill uses it as a
  validation gate. (The [CK3 Modding Toolkit](https://marketplace.visualstudio.com/items?itemName=JDeffner.ck3-modding-toolkit)
  VS Code extension can download it for you.)

## 1. Install the skill

Clone this repo, then copy the skill folder where your agent looks for skills:

```bash
git clone https://github.com/JDeffner/ck3-ai-modding.git
```

- All projects, current user: copy `skills/ck3-modding/` into `~/.claude/skills/`
  (Windows: `%USERPROFILE%\.claude\skills\`).
- One mod repo only: copy it into `<mod repo>/.claude/skills/`.

A symlink to your clone works too and picks up updates on `git pull`.

## 2. Give your mod repo a CLAUDE.md

Copy [`templates/CLAUDE.md`](../templates/CLAUDE.md) into your mod repo and fill in the
placeholders: your machine's paths (game install, logs folder, mod folder, ck3-tiger
executable) and your mod's prefix. This is optional (the skill can detect the paths), but
pinning them saves time at the start of every session and never mis-detects.

## 3. First session

Start the agent inside your mod folder and ask for something concrete:

> Add a decision, available to independent feudal rulers with prestige above 1000, that
> founds a hunting society. Members get a monthly prestige modifier.

What you should see the skill do, in order:

1. Resolve the machine paths (or read them from your CLAUDE.md).
2. Read the relevant `_*.info` schema doc and a vanilla example before writing anything.
3. Write new, mod-prefixed files (never edits to vanilla files), plus localization for every
   new key.
4. Run ck3-tiger and fix what it reports.
5. Give you exact in-game test steps and ask you to run them.

If the agent starts inventing trigger names from memory instead, tell it to check
`script_docs`; the skill's whole point is that the installed game is the source of truth.

## 4. The test loop (where the payoff is)

The agent can read your game logs, but only you can generate them. The rhythm that works:

1. Launch CK3 with the `-debug_mode` launch option (Steam: right-click the game, Properties,
   Launch Options).
2. Run the console test the agent gave you (`event my_mod.1`, `effect ...`, `testevent ...`).
3. Say "done". The agent reads `error.log` (and `database_conflicts.log`,
   `gui_warnings.log`, ...) itself and fixes what it finds.

Never paste log contents by hand; let the agent read the files. Two console commands worth
knowing because the skill will ask for them:

- `script_docs`: dumps the complete, version-exact list of every effect, trigger, scope, and
  event target to the logs folder.
- `dump_data_types`: dumps the GUI data-binding API (needed for custom UI work).

## 5. Folder access

The agent needs read access to folders outside your repo: the game install (source of truth),
the logs folder, and optionally the Workshop folder (pattern-source mods). When the agent asks
for access to those paths, that is expected and read-only; grant it or pre-approve the paths
in your agent's permission settings.

## Other agents

The skill is plain markdown with no runtime dependencies, so any agent that supports the
Agent Skills format can load it as-is. For agents without skill support:

- Use `SKILL.md` as system context or paste it at the start of the conversation; it is a
  router, so also attach the `references/*.md` file(s) matching your task.
- Replace the `<game>` / `<logs>` / `<mods>` / `<workshop>` / `<tiger>` placeholders with your
  real paths first (find-and-replace across the folder), since a context-pasted copy cannot
  resolve them interactively.

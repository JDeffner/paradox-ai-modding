# Getting started

Setting up an agent for Victoria 3 modding, end to end. About fifteen minutes, most of it
waiting for the game to load once.

- [1. Install the skill](#1-install-the-skill)
- [2. Generate the game's own documentation](#2-generate-the-games-own-documentation)
- [3. Check that everything resolves](#3-check-that-everything-resolves)
- [4. Install the validator](#4-install-the-validator)
- [5. Set up the mod repo](#5-set-up-the-mod-repo)
- [6. First task](#6-first-task)
- [Keeping it correct](#keeping-it-correct)

## 1. Install the skill

Copy or symlink `skills/vic3-modding/` into one of:

| Location | Scope |
|---|---|
| `~/.claude/skills/vic3-modding/` | every project on this machine |
| `<mod repo>/.claude/skills/vic3-modding/` | that one mod repo |

On Windows the user-level path is `C:\Users\<you>\.claude\skills\`.

Skills are read at startup, so **restart Claude Code** afterwards. If the skill does not seem to
exist, that is almost always the reason.

Other agents: the skill is plain markdown. `SKILL.md` works as pasted context, and the reference
files work as attachments. Only the `${CLAUDE_SKILL_DIR}` substitution in the script paths is
Claude Code specific, and you can replace it with a real path.

## 2. Generate the game's own documentation

This is the step that makes everything else work, and it takes one game launch.

Add `-debug_mode` to Victoria 3's launch arguments. On Steam: right-click the game, Properties,
then Launch Options.

Start the game, load any save or start any campaign, open the console with `` ` `` (or `~`), and
run:

```
script_docs
dump_data_types
```

`script_docs` writes six files to `Documents/Paradox Interactive/Victoria 3/**docs**`, which is
not the `logs` folder. `dump_data_types` writes to `logs/data_types/`.

Together they are about 12,800 identifiers, every one with its scope, exactly matching the build
you are running. This is what stops an agent inventing effect names.

## 3. Check that everything resolves

```bash
python skills/vic3-modding/scripts/vic3_docs.py stats
```

Expected output names your game folder, your docs folder, the build number, and a per-file
entry count. If a path shows `NOT FOUND`, pass it explicitly:

```bash
python vic3_docs.py --game "D:/SteamLibrary/steamapps/common/Victoria 3/game" --docs "D:/Documents/Paradox Interactive/Victoria 3/docs" stats
```

or set `VIC3_GAME` and `VIC3_DOCS` once in your environment. Note that Windows redirects
Documents on many machines, often to another drive or to OneDrive, so do not assume `C:`.

Sanity check the lookup:

```bash
python vic3_docs.py find add_modifier
```

That should print the effect, its description and its supported scopes.

## 4. Install the validator

Download [vic3-tiger](https://github.com/amtep/tiger/releases) and unpack it anywhere. The
Windows asset is named `vic3-tiger-windows-<version>.zip`.

```bash
vic3-tiger "<mods>/my_mod"
```

It takes the mod **directory**, unlike ck3-tiger which takes a descriptor file. Add
`--game` and `--paradox` if it cannot find your install on its own, which it will not when Steam
or Documents lives on a non-default drive.

Tiger tracks Victoria 3 a patch or two behind and admits to some false positives, so treat it as
a strong signal rather than a verdict. Details in
[`references/validation.md`](../../skills/vic3-modding/references/validation.md).

## 5. Set up the mod repo

A Victoria 3 mod is a folder under `<mods>` containing `.metadata/metadata.json`. There is no
`descriptor.mod`.

```
my_mod/
  .metadata/metadata.json
  common/
  events/
  localization/english/
```

```json
{
  "name" : "My Mod",
  "id" : "com.example.my-mod",
  "version" : "0.1.0",
  "game_id" : "victoria3",
  "supported_game_version" : "1.13.*",
  "short_description" : "What it does.",
  "tags" : [],
  "relationships" : [],
  "game_custom_data" : { "multiplayer_synchronized" : false }
}
```

Run the mod through the launcher once so it gets registered, then copy
[`templates/AGENTS.md`](../../templates/vic3/AGENTS.md) to the repo root and fill in the paths. Pinning
them there saves the agent from re-detecting every session. Claude Code reads `AGENTS.md`, and so
do Codex, Cursor and others.

Everything in that template is facts about your mod. The procedure lives in the skill, so do not
copy the skill's rules into it.

## 6. First task

Open a session in the mod folder and ask for something concrete:

> Add a production method to the wheat farm that trades construction goods for higher output,
> unlocked by a late-game technology.

What should happen: the agent resolves your paths, reads
`common/production_methods/production_methods.md` and a real vanilla production method, checks
every modifier key with `vic3_docs.py find`, writes a new prefixed file with a byte-order mark,
adds localization, and runs tiger before asking you to test.

If it starts writing script without opening a vanilla file first, stop it and say so. That is the
one habit the whole toolkit exists to enforce.

## Keeping it correct

After every game patch:

1. Relaunch with `-debug_mode` and rerun `script_docs`. The dumps are build-exact, and a stale
   dump will confidently report that a real new effect does not exist.
2. Run `vic3_docs.py stats`. It warns when a dump is over 30 days old.
3. Check for a newer vic3-tiger release.

Nothing in this repo hardcodes an identifier list, so a patch does not invalidate the skill. It
only invalidates your dumps, and regenerating them takes one launch.

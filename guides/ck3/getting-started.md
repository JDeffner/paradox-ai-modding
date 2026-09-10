# Getting started with CK3 modding

Install the plugin or the three CK3 skills using the [README](../../README.md#install-from-a-local-checkout). Use one installation method in each client.

## Configure the project

Copy [templates/ck3/AGENTS.md](../../templates/ck3/AGENTS.md) into the mod project and fill in its paths and conventions. For Claude Code, the [CLAUDE.md adapter](../../templates/ck3/CLAUDE.md) reads the same instructions. Keep local information out of the reusable skills.

The agent needs the CK3 game directory, user logs, actual mod source directory, launcher descriptor, and an installed [ck3-tiger](https://github.com/amtep/tiger) executable. Workshop sources are optional. The game installation is read-only.

## First task

Start the agent in your mod folder and request a concrete change. For example:

> Add a decision for independent rulers with at least 1000 prestige. It starts a hunting society event and costs 100 prestige.

The agent should read the decision schema and a working native example, implement the decision and event with localization, and run tiger. It should use the actual decision to verify the runtime path. Directly firing the event tests a different part of the feature.

Use ck3-gui for custom windows and layout work. Use ck3-playtest for sustained live checklists. Each loads only the shared references needed for the task.

## Runtime checks

Use a separate non-Ironman test campaign. When authorized controls are available, the agent can operate the game under those tools' rules. Otherwise launch CK3 with -debug_mode and perform the exact steps it supplies. The agent reads logs itself afterwards.

Two console commands produce documentation that helps resolve exact names:

- script_docs writes effects, triggers, scopes, and related lists to the logs directory.
- dump_data_types writes the GUI data-binding API under logs/data_types/.

Check timestamps after generating them. A dump from before a patch can contain obsolete signatures. Keep a baseline save before state-changing debug setup. Record fixes waiting for reload separately from fixes verified in the running game.

## Agents without skill discovery

Supply the main SKILL.md and the reference files for the task as context. For GUI or playtesting, include the relevant specialist skill. Supply machine paths separately; do not alter maintained skill files to insert them.

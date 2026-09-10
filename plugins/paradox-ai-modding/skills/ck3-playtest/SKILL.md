---
name: ck3-playtest
description: Run or resume Crusader Kings III mod playtests, inspect live behavior and UI, and retest fixes with recorded evidence. Use for in-game checklists, runtime verification, and reload tracking. Does not create new features or grant permission to operate the computer.
---

# CK3 Playtesting

Test requested behavior through the running game. Distinguish a source edit from a verified fix. Install alongside `ck3-modding` for shared environment, scripting, and validation references.

## Establish the session

Read project instructions, its playtesting skill if present, latest session notes, and the relevant open checklist. Project skills supply scenarios, navigation, local tools, and prior authorization. Do not copy project details into this reusable skill.

Record worktree state, installed game build, active playset when observable, process/session, log timestamps, and known loaded mod revision. Record unknowns as unknown. Reuse paths or read [environment.md](../ck3-modding/references/environment.md). Do not print full launcher command lines, which may contain session credentials.

Use available controls under their tool instructions and existing user authorization. Check observation and input before a costly launch. If operation is unavailable or the user must launch the game, continue static checks and log analysis, then request the exact missing step. This skill does not authorize bypassing tool restrictions or inventing computer-control fallbacks.

Preserve existing campaigns. Use a separate non-Ironman test campaign and named checkpoints before changing state or testing destructive branches. Confirm the active campaign before state-changing input.

## Run the relevant checks

1. Reconcile the selected checklist with current implementation and later design changes. Mark removed behavior as superseded; do not count it as passed.
2. Start at the normal decision, interaction, scheme, activity, or UI entry point. Use debug fixtures for difficult preconditions, then exercise that normal path. Firing a result event proves only that event, not its caller or timing.
3. Record the immediate baseline, expected outcome, actual outcome, game date, and evidence. Check costs and rewards as deltas. Cover player, AI, failure, cooldown, and persistence paths when relevant to the requested change.
4. For visual work, inspect the rendered game at normal settings: clipping, contrast, art crops, tooltips, scrolling, disabled states, and hit areas. Use fresh observations for input; old coordinates are not durable navigation.
5. Inspect fresh logs after reproduction. Preserve failure evidence before fixing it. An execution acknowledgement proves that control reached the marker, not that the intended state changed.

Fix confirmed bugs when the task authorizes fixes, using [ck3-modding](../ck3-modding/SKILL.md) or [ck3-gui](../ck3-gui/SKILL.md). A review-only request remains review-only. Run static validation after editing, then repeat the affected normal entry path. Do not broaden the session into new features or repeated smoke checks.

## Track reloads separately

Keep the loaded build distinct from source on disk. An edited file, accepted reload command, or tooltip preview does not prove the running caller uses the correction.

Queue fixes awaiting reload or restart and continue outstanding tests that remain possible in the current session. Restart only when no remaining test can continue in that session and restart is authorized. Preserve logs and a checkpoint before recovery because a new launch may replace logs. One observed hot-reload result does not establish behavior for every database or asset.

For each queued fix, record changed files, the required reload action if known, and the normal entry path needed for retest. After reload, assert the actual outcome again.

## Record results

Use the project's existing record format. Otherwise a small table is sufficient:

| Check | Status | Expected / actual | Evidence | Loaded build / retest needed |
|---|---|---|---|---|

Use `NOT RUN`, `PASS`, `FAIL`, `BLOCKED`, or `SUPERSEDED`. Keep a fixed failure awaiting retest as `FAIL` with a retest note. A static pass never changes a runtime check to `PASS`. Separate source-supported inferences from observed outcomes.

Keep reports and captures outside the shipping mod folder. End with what passed, what failed, fixes awaiting reload, and checks still blocked or unrun. Do not describe an entire system as verified when only a fixture or one entry path was exercised.

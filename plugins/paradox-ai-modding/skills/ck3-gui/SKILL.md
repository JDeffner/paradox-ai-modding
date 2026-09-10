---
name: ck3-gui
description: Build and fix Crusader Kings III interfaces, including custom windows, HUD widgets, PdxGui layouts, scripted GUI calls, and data bindings. Use for CK3 clipping, failed clicks, missing widgets, or interface design. Does not cover Victoria 3 GUI or general web design.
---

# CK3 GUI

Build the requested screen with native CK3 widgets and verify both its appearance and game-state bindings. Install alongside `ck3-modding`, which owns the shared environment and scripting references.

## Establish the surface

Read the project's UI rules and relevant existing `.gui` file. Reuse confirmed paths, or read [environment.md](../ck3-modding/references/environment.md). The game and Workshop installations are read-only sources. Keep temporary test UI in a separate test mod or the project's development area outside its shipping folder.

Find the native window or widget closest to the requested behavior. Read its types, templates, and callers. For unfamiliar bindings, inspect fresh `dump_data_types` output and a working vanilla caller. Do not assume an object available in one window exists in another.

Read the relevant sections of [gui.md](../ck3-modding/references/gui.md) for examples and layout findings. Historical measurements guide a reproduction; verify them against the current build when they matter to the change.

## Implement

1. Choose the smallest integration surface. Prefer scripted-widget registration for independent windows or HUD additions. For changes inside vanilla windows, check existing blocks and types. When a whole-file override is necessary, document its source build and compatibility cost. Do not refactor existing integration merely to enforce a blanket ban on overrides.
2. Trace the complete binding: game state, script value or custom localization, GUI data context, displayed value, and action. Pass every scope declared by a scripted GUI through the caller's `AddScope` chain. Match visibility and validity gates to what the control communicates.
3. Keep presentation state in the UI variable system when session-only. Use saved script state when persistence is required. Keep expensive scans out of per-frame bindings.
4. Bound text width, including autoresizing labels and tooltips. Use native skins and components. Check which parent owns positioning before mixing anchors with hbox/vbox layout. Put independently positioned bar layers in a plain widget container.
5. Verify textures and widget types against the intended playset. Workshop examples may use assets absent from vanilla. Add every localization key the screen reads.

For script behavior, follow [ck3-modding](../ck3-modding/SKILL.md). Keep gameplay effects shared when a decision and a panel button expose the same action.

## Verify

Run ck3-tiger with the project's configuration. Inspect the screen in-game when controls are available and authorized. A layout preview helps iteration but does not validate live data contexts or script execution.

Use a separate test campaign for state-changing checks. Confirm the screen reopened after reload and shows the edited build. Check normal display settings, long text, scroll reachability, tooltip occlusion, enabled and disabled states, hit areas, empty lists, and range endpoints when relevant to the change.

Click through the real entry point and compare before/after state. A button animation or successful console call does not prove the GUI action works. Read fresh `error.log` and `gui_warnings.log` entries after reproduction.

For sustained test sessions, use [ck3-playtest](../ck3-playtest/SKILL.md). If live verification is unavailable, complete static work and identify the specific visual or behavioral checks still open.

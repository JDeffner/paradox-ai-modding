# <Mod name>

Crusader Kings III mod. Target build: <version>. Source folder: <path>. Launcher descriptor: <path>. Prefix: <prefix>.

Use ck3-modding for script and content work, ck3-gui for interface work, and ck3-playtest for runtime verification. These skills provide the reusable workflow. This file holds project-specific facts.

## Machine paths

| Resource | Path |
|---|---|
| Installed game directory | <path> |
| CK3 logs | <path> |
| Launcher mod directory | <path> |
| Workshop sources, if used | <path> |
| ck3-tiger executable and project config | <paths> |

## Project conventions

- Design pillars and excluded features: <details>.
- Systems being changed and their entry points: <details>.
- Filename and script-key prefix: <prefix>.
- Script encoding: <project convention>. Localization uses UTF-8 with BOM.
- Compatibility targets and existing overrides: <details>.
- Shipping folder: <path>. Keep test captures and development files outside it.

## Validation and playtesting

- Validator command and accepted baseline diagnostics: <details>.
- Checklist and session-note location: <path>.
- Separate test campaign and named baseline save: <details>.
- Available game-control tools and current authorization: <details>.
- Fixes awaiting reload or a cold-process retest: <details>.

Preserve existing campaigns. Read fresh logs after reproduction. Keep static validation and runtime results separate. This template grants no additional permission to launch, operate, commit, or publish.

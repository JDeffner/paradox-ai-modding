# Contributing

Corrections and additions are welcome. One bar keeps this repo useful: nothing lands on
hearsay.

## Verification discipline

- Every technical claim must be verified against actual files: the vanilla install, the mod
  being described, or a `script_docs` dump. Not the wiki, not model memory. Say what you
  verified against (game patch or mod version, and when).
- Precedence on any conflict: `_*.info` schema docs, `script_docs` dumps, and vanilla files
  outrank the wiki, and they outrank this repo. Finding such a conflict IS a contribution;
  send it with the file path as evidence.

## Style

- No machine-specific paths anywhere. Use the `<game>` / `<logs>` / `<mods>` / `<workshop>` /
  `<tiger>` placeholders defined in `SKILL.md` Step 0.
- No personal or project-specific content; "Application:" sketches in pattern notes stay
  project-neutral.
- LF line endings (enforced via `.gitattributes`).
- Keep the routing structure: `SKILL.md` stays a compact router; depth belongs in
  `references/` and `references/patterns/`.
- Mod pattern notes follow the discipline described in `skills/ck3-modding/mods/README.md`.

## What's especially welcome

- Corrections with file-path evidence, above all after a game patch changes behavior.
- New per-system recipes in `references/patterns/`, following the shape of the existing ones
  (minimal template, full skeleton, pitfall list).
- Pattern notes for other widely-used Workshop mods.
- Guide improvements for agents other than Claude Code.

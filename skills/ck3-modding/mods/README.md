# Mod pattern notes

File-verified study notes on flagship Workshop mods, distilled so an agent can reuse their
architecture without reading thousands of files. The skill routes here for mechanic *design*
questions (meters, hidden societies, AI-driven drama); `references/` covers syntax and systems.

## What's here

| File | Mod | Covers |
|---|---|---|
| `pod.md` | Princes of Darkness (workshop id `2216659254`) | Tiered meters, secrecy/exposure systems, hidden societies, supernatural rulers, custom UI at scale |
| `agot.md` | A Game of Thrones (workshop id `2962333032`) | AI-initiated drama, story cycles, narrated `ai_accept`, duels, secrets, alerts, performance budgeting |

The notes work standalone. When the user subscribes to the mod on the Workshop, the agent can
additionally open the referenced files for detail beyond the summaries.

## Writing your own

The value of these files comes from a strict discipline. If you add notes for another mod,
follow it:

1. **Verify every claim against the files** and stamp the note with the date and mod version.
   No wiki hearsay, no model memory. If a summary and the files ever disagree, the files win,
   and the note gets fixed.
2. **Structure map first**: a table from system (script_values, events, on_actions, GUI, ...)
   to actual file paths inside the mod, so an agent can jump straight to the implementation.
3. **Patterns, not inventory**: each entry names the file that implements it, explains WHY the
   mod built it that way, and ends with a one-line "Application:" sketch showing how to
   transplant the idea into an unrelated mod.
4. **Anti-patterns section**: what NOT to copy, with the reason (usually maintenance tax or
   performance).
5. **Keep shared copies generic.** Notes about your own in-progress mod are the most useful
   files of all, but they belong in a private copy of this folder, not in a public repo.
   In shared notes, keep the Application sketches project-neutral.

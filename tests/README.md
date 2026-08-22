# Tests

Everything here runs offline, in seconds, with no dependency beyond Python 3 and bash.
`.github/workflows/checks.yml` runs all three on every push and pull request.

```bash
python -m unittest discover -s tests -v   # vic3_docs.py parsers and path resolution
bash tests/test_check_compat.sh           # check_compat.sh against two fixture mods
python tests/check_links.py               # every relative markdown link resolves
```

- `fixtures/docs/` holds a trimmed copy of one `script_docs` dump per grammar, including the
  icon control byte that `modifiers.log` embeds. They are fixtures, not a reference: your own
  dumps are the source of truth.
- `fixtures/mod_a/` and `fixtures/mod_b/` are two minimal CK3 mods built to collide in exactly
  the ways `check_compat.sh` reports, and to share the files (`descriptor.mod`,
  `thumbnail.png`) that every mod has and that are not conflicts.

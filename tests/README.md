# Tests

The regression tests run offline with Python 3.11+ and Bash plus standard Unix utilities.
`.github/workflows/checks.yml` runs them on pushes to main and on pull requests. Python tests
run on Windows and Linux; shell tests and ShellCheck run on Linux.

```bash
python -m unittest discover -s tests -v   # vic3_docs.py parsers and path resolution
bash tests/test_check_compat.sh           # check_compat.sh against two fixture mods
python tests/check_links.py               # every relative markdown link resolves
shellcheck plugins/paradox-ai-modding/skills/ck3-modding/scripts/check_compat.sh tests/test_check_compat.sh
```

- `fixtures/docs/` holds a trimmed copy of one `script_docs` dump per grammar, including the
  icon control byte that `modifiers.log` embeds. They are fixtures, not a reference: your own
  dumps are the source of truth.
- `fixtures/mod_a/` and `fixtures/mod_b/` are two minimal CK3 mods built to collide in exactly
  the ways `check_compat.sh` reports, and to share the files (`descriptor.mod`,
  `thumbnail.png`) that every mod has and that are not conflicts.

The shell suite also creates temporary cases for BOMs, indentation, nested database files,
quoted braces, Git metadata, nested thumbnails, and language-separated localization. They
exercise the scanner; the fixtures are not complete playable mods. ShellCheck is a separate
development tool. The link checker does not fetch external URLs or validate heading anchors.

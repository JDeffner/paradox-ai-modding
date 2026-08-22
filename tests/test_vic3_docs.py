"""Parser and resolver tests for vic3_docs.py, against the fixture dumps.

The fixtures in fixtures/docs/ are trimmed copies of real script_docs output,
one per grammar, including the icon control byte that modifiers.log embeds.
"""
import subprocess
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SCRIPT = REPO / "skills" / "vic3-modding" / "scripts" / "vic3_docs.py"
DOCS = Path(__file__).resolve().parent / "fixtures" / "docs"

sys.path.insert(0, str(SCRIPT.parent))
import vic3_docs  # noqa: E402


def parsed(fname, fmt):
    return {name: (body, tier) for name, body, tier in vic3_docs.parse(DOCS / fname, fmt)}


class TestParse(unittest.TestCase):
    def test_md2_heading_and_body(self):
        entries = parsed("effects.log", "md2")
        self.assertEqual(sorted(entries), ["activate_law", "add_modifier"])
        body, tier = entries["add_modifier"]
        self.assertIsNone(tier)
        self.assertIn("**Supported Scopes**: country, state", body)

    def test_md3_heading(self):
        entries = parsed("event_targets.log", "md3")
        self.assertEqual(sorted(entries), ["combat_width", "naval_hq"])
        self.assertIn("Output Scopes: value", entries["combat_width"][0])

    def test_block_tiers_and_icon_stripping(self):
        entries = parsed("modifiers.log", "block")
        self.assertEqual(entries["battle_casualties_mult"][1], "Static modifier types")
        self.assertEqual(
            entries["building_group_bg_agriculture_throughput_add"][1],
            "Potential dynamic modifier types")
        # The 0x16 ... "!" icon token goes, the non-breaking space becomes a
        # plain one, so the name is readable text.
        name_line = [l for l in entries["country_authority_add"][0] if l.startswith("Name:")][0]
        self.assertNotIn("\x16", name_line)
        self.assertNotIn("\xa0", name_line)
        self.assertEqual(name_line.split(), ["Name:", "Authority"])

    def test_delim_records_ignore_inner_colon_lines(self):
        entries = parsed("on_actions.log", "delim")
        # "From Code:" and "Expected Scope:" sit at column 0 too, and must not
        # be read as record names.
        self.assertEqual(sorted(entries), ["elections_monthly_events", "on_law_enactment_fail"])
        self.assertIn("Expected Scope: country", entries["elections_monthly_events"][0])

    def test_load_dumps_covers_every_source(self):
        index, missing = vic3_docs.load_dumps(DOCS)
        self.assertEqual(missing, [])
        kinds = {k for entries in index.values() for k, _, _, _ in entries}
        self.assertEqual(kinds, set(vic3_docs.SOURCES))


class TestResolve(unittest.TestCase):
    def test_explicit_path_without_marker_fails(self):
        with self.assertRaises(SystemExit):
            vic3_docs.resolve(str(REPO), "VIC3_DOCS_UNSET", [], "effects.log")

    def test_explicit_path_with_marker_wins(self):
        self.assertEqual(
            vic3_docs.resolve(str(DOCS), "VIC3_DOCS_UNSET", [], "effects.log"), DOCS)


class TestFindCommand(unittest.TestCase):
    def run_find(self, *args):
        return subprocess.run(
            [sys.executable, str(SCRIPT), "--docs", str(DOCS), "find", *args],
            capture_output=True, text=True)

    def test_known_identifier_exits_zero(self):
        done = self.run_find("add_modifier")
        self.assertEqual(done.returncode, 0)
        self.assertIn("[effect]", done.stdout)

    def test_typo_exits_one_and_suggests(self):
        done = self.run_find("add_modifer")
        self.assertEqual(done.returncode, 1)
        self.assertIn("NOT FOUND", done.stdout)
        self.assertIn("add_modifier", done.stdout)
        self.assertIn("suggestions below", done.stdout)

    def test_nonsense_exits_one_without_promising_suggestions(self):
        done = self.run_find("zzz_not_a_real_identifier")
        self.assertEqual(done.returncode, 1)
        self.assertNotIn("suggestions below", done.stdout)


if __name__ == "__main__":
    unittest.main()

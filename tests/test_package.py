"""Keep both clients pointed at the same portable skill package."""
import json
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLUGIN = REPO / "plugins/paradox-ai-modding"


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


class TestPackage(unittest.TestCase):
    def test_manifests_share_identity_version_and_skills(self):
        codex = read_json(PLUGIN / ".codex-plugin/plugin.json")
        claude = read_json(PLUGIN / ".claude-plugin/plugin.json")
        for field in ("name", "version", "skills", "license"):
            self.assertEqual(codex[field], claude[field], field)
        skills = (PLUGIN / codex["skills"]).resolve()
        self.assertEqual(skills, PLUGIN / "skills")
        self.assertTrue(list(skills.glob("*/SKILL.md")))

    def test_catalogs_resolve_to_the_plugin(self):
        codex = read_json(REPO / ".agents/plugins/marketplace.json")
        claude = read_json(REPO / ".claude-plugin/marketplace.json")
        manifest = read_json(PLUGIN / ".codex-plugin/plugin.json")
        for catalog, field in ((codex, "source"), (claude, "source")):
            entry = next(p for p in catalog["plugins"] if p["name"] == manifest["name"])
            source = entry[field]
            path = source["path"] if isinstance(source, dict) else source
            self.assertEqual((REPO / path).resolve(), PLUGIN)

    def test_standalone_plugin_carries_the_repository_license(self):
        self.assertEqual((REPO / "LICENSE").read_bytes(), (PLUGIN / "LICENSE").read_bytes())


if __name__ == "__main__":
    unittest.main()

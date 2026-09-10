"""Check every relative markdown link in the repo, offline.

External links are not fetched; the point is to catch a moved or renamed file
inside this repo, which is the drift a documentation-only repo is exposed to.
"""
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
LINK = re.compile(r"\[[^\]]*\]\(([^)\s]+)\)")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "#")


def broken_links(md):
    for target in LINK.findall(md.read_text(encoding="utf-8")):
        if target.startswith(SKIP_PREFIXES):
            continue
        path = target.split("#", 1)[0]
        if not path:
            continue
        if not (md.parent / path).exists():
            yield target


def main():
    failures = 0
    for md in sorted(REPO.rglob("*.md")):
        if ".git" in md.parts:
            continue
        for target in broken_links(md):
            print(f"{md.relative_to(REPO).as_posix()}: broken link -> {target}")
            failures += 1
    if failures:
        print(f"\n{failures} broken link(s)")
        return 1
    print("all relative markdown links resolve")
    return 0


if __name__ == "__main__":
    sys.exit(main())

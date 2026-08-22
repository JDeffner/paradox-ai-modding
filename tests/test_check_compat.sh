#!/usr/bin/env bash
#
# Fixture run of check_compat.sh.
#
# The two fixture mods share no file, define the same key in differently named
# files under common/decisions, use the same key name in two different folders
# (which is not a conflict), and mod_b carries its replace_path in a launcher
# stub beside descriptor.mod.

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../skills/ck3-modding/scripts/check_compat.sh"
FAILED=0

expect() {
    local label="$1" needle="$2" haystack="$3"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        echo "ok    $label"
    else
        echo "FAIL  $label: expected to find '$needle'"
        FAILED=1
    fi
}

expect_absent() {
    local label="$1" needle="$2" haystack="$3"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        echo "FAIL  $label: did not expect '$needle'"
        FAILED=1
    else
        echo "ok    $label"
    fi
}

expect_status() {
    local label="$1" want="$2" got="$3"
    if [[ "$want" == "$got" ]]; then
        echo "ok    $label"
    else
        echo "FAIL  $label: expected exit $want, got $got"
        FAILED=1
    fi
}

# ── Two conflicting mods ────────────────────────────────────────────────────

OUT="$(bash "$SCRIPT" "$HERE/fixtures/mod_a" "$HERE/fixtures/mod_b")"
STATUS=$?

expect_status "conflicting mods exit 1" 1 "$STATUS"
expect "descriptor.mod and thumbnail.png are not file conflicts" \
    "File conflicts:          0" "$OUT"
expect "same key in differently named files is reported" \
    "common/decisions: my_decision" "$OUT"
expect_absent "same key name in two different folders is not reported" \
    "shared_name" "$OUT"
expect "replace_path in the launcher stub is found" \
    '[mod_b] replace_path = "common/decisions"' "$OUT"

# ── A clean pair, so exit 0 is reachable ────────────────────────────────────

CLEAN="$(mktemp -d)"
trap 'rm -rf "$CLEAN"' EXIT
mkdir -p "$CLEAN/other/common/traits"
cp "$HERE/fixtures/mod_b/descriptor.mod" "$CLEAN/other/descriptor.mod"
cp "$HERE/fixtures/mod_b/thumbnail.png" "$CLEAN/other/thumbnail.png"
printf 'other_trait = {\n\tindex = 1\n}\n' > "$CLEAN/other/common/traits/other.txt"

OUT="$(bash "$SCRIPT" "$HERE/fixtures/mod_a" "$CLEAN/other")"
STATUS=$?

expect_status "unrelated mods exit 0" 0 "$STATUS"
expect "unrelated mods report no conflicts" "Total issues:            0" "$OUT"

exit "$FAILED"

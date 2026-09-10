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
SCRIPT="$HERE/../plugins/paradox-ai-modding/skills/ck3-modding/scripts/check_compat.sh"
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
expect "localization collides across filenames within a language" \
    'l_english: my_decision' "$OUT"

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

# BOM, indentation, nested folders, strings and unindented nested fields.
mkdir -p "$CLEAN/a/common/decisions/nested" "$CLEAN/b/common/decisions"
printf '\357\273\277  bom_key = {\n nested_only = yes\n text = "} # \\\" still quoted"\n}\n  indented_key = {}\n' \
    > "$CLEAN/a/common/decisions/nested/a.txt"
printf 'bom_key = {}\nindented_key = {}\nnested_only = {}\n' \
    > "$CLEAN/b/common/decisions/b.txt"
printf 'documentation_only = {}\n' > "$CLEAN/a/common/decisions/schema.md"
printf 'documentation_only = {}\n' > "$CLEAN/b/common/decisions/b2.txt"
OUT="$(bash "$SCRIPT" "$CLEAN/a" "$CLEAN/b")"
expect_status "BOM and indented keys exit 1" 1 "$?"
expect "BOM key in nested database folder" 'common/decisions: bom_key' "$OUT"
expect "indented key after quoted braces" 'common/decisions: indented_key' "$OUT"
expect_absent "nested fields are not top-level keys" 'nested_only' "$OUT"
expect_absent "schema docs are not script definitions" 'documentation_only' "$OUT"

# Git worktree metadata is ignored, but nested assets must still collide.
mkdir -p "$CLEAN/asset_a/gfx" "$CLEAN/asset_b/gfx"
printf 'gitdir: elsewhere\n' > "$CLEAN/asset_a/.git"
printf 'gitdir: elsewhere\n' > "$CLEAN/asset_b/.git"
touch "$CLEAN/asset_a/gfx/thumbnail.png" "$CLEAN/asset_b/gfx/thumbnail.png"
OUT="$(bash "$SCRIPT" "$CLEAN/asset_a" "$CLEAN/asset_b")"
expect_status "nested thumbnail collision exits 1" 1 "$?"
expect "only root metadata is ignored" 'File conflicts:          1' "$OUT"
expect "nested thumbnail is reported" 'gfx/thumbnail.png' "$OUT"

# Same key in English and German is not a localization collision.
mkdir -p "$CLEAN/lang_a/localization/english" "$CLEAN/lang_b/localization/german"
printf '\357\273\277l_english:\n shared_key:0 "English"\n' > "$CLEAN/lang_a/localization/english/a.yml"
printf '\357\273\277l_german:\n shared_key:0 "German"\n' > "$CLEAN/lang_b/localization/german/b.yml"
OUT="$(bash "$SCRIPT" "$CLEAN/lang_a" "$CLEAN/lang_b")"
expect_status "different languages exit 0" 0 "$?"
printf '\357\273\277l_english:\n shared_key:0 "Other"\n' > "$CLEAN/lang_b/localization/english_l_english.yml"
OUT="$(bash "$SCRIPT" "$CLEAN/lang_a" "$CLEAN/lang_b")"
expect_status "same language across folders exits 1" 1 "$?"
expect "localization uses header language" 'l_english: shared_key' "$OUT"

exit "$FAILED"

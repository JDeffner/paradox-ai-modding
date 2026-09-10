#!/usr/bin/env bash
#
# check_compat.sh — Compare two CK3 mods for potential file conflicts.
#
# Identifies compatibility issues between mods by checking for:
#   - Files that exist at the same relative path in both mods
#     (root metadata and thumbnail are ignored, every mod has those)
#   - Top-level scripting keys defined by both mods in the same common/
#     database folder, whatever the filenames are
#   - Duplicate localization keys
#   - replace_path directives that hard-override vanilla directories
#
# Usage:
#   check_compat.sh <mod_dir_1> <mod_dir_2>
#
# Exit codes:
#   0 — no conflicts found
#   1 — conflicts found
#   2 — usage/input error

set -euo pipefail
export LC_ALL=C

# ── Usage ────────────────────────────────────────────────────────────────────

usage() {
    cat <<'USAGE'
Usage: check_compat.sh <mod_dir_1> <mod_dir_2>

Compare two CK3 mods for potential file conflicts.

Arguments:
  mod_dir_1   Path to the first mod directory
  mod_dir_2   Path to the second mod directory

The script checks for:
  1. File-level conflicts   — same relative path exists in both mods
  2. Key-level conflicts    — same top-level key in the same common/ folder
  3. Localization conflicts  — same loc keys defined in both mods
  4. replace_path warnings  — directories flagged for hard override

Exit code is 0 when no conflicts are found, 1 when conflicts exist.
USAGE
}

if [[ $# -eq 0 ]] || [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

if [[ $# -ne 2 ]]; then
    echo "Error: expected 2 arguments, got $#." >&2
    usage >&2
    exit 2
fi

MOD1="$1"
MOD2="$2"

# ── Validate paths ──────────────────────────────────────────────────────────

for dir in "$MOD1" "$MOD2"; do
    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' is not a valid directory." >&2
        exit 2
    fi
done

# A repo's mod tree is normally called `mod/`, which makes a useless label.
# Fall back to the parent folder's name in that case.
mod_display_name() {
    local abs name
    abs="$(cd "$1" && pwd)"
    name="$(basename "$abs")"
    if [[ "$name" == "mod" ]]; then
        name="$(basename "$(dirname "$abs")")"
    fi
    printf '%s' "$name"
}

MOD1_NAME="$(mod_display_name "$MOD1")"
MOD2_NAME="$(mod_display_name "$MOD2")"

# ── Temp files ──────────────────────────────────────────────────────────────

TMPDIR_WORK="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_WORK"' EXIT

FILES1="$TMPDIR_WORK/files1.txt"
FILES2="$TMPDIR_WORK/files2.txt"
COMMON_FILES="$TMPDIR_WORK/common_files.txt"

# ── Gather relative file lists ─────────────────────────────────────────────

# List all files relative to mod root, normalised with forward slashes, sorted.
# descriptor.mod and thumbnail.png sit at the root of every mod, so counting
# them as conflicts would make "no conflicts" unreachable.
list_files() {
    local base="$1"
    (cd "$base" && find . -type f \
        ! -path './descriptor.mod' \
        ! -path './thumbnail.png' \
        ! -path './.git' \
        ! -path './.git/*' \
        | sed 's|^\./||' | sort)
}

list_files "$MOD1" > "$FILES1"
list_files "$MOD2" > "$FILES2"

# ── 1. File-level conflicts ────────────────────────────────────────────────

comm -12 "$FILES1" "$FILES2" > "$COMMON_FILES"
FILE_CONFLICT_COUNT=$(wc -l < "$COMMON_FILES" | tr -d ' ')

# ── 2. Key-level conflicts (common/ databases) ──────────────────────────────
#
# CK3 resolves a common/ database per key across the whole folder, so the
# filename does not matter: mod A's common/decisions/a_decisions.txt and mod
# B's common/decisions/b.txt collide when both define the same key.  Collect
# every top-level key of every common/ file from each mod, tagged with its
# folder, then intersect.  Tagging keeps common/traits/x and
# common/decisions/x from being reported against each other.

ALL_KEYS1="$TMPDIR_WORK/all_keys1.txt"
ALL_KEYS2="$TMPDIR_WORK/all_keys2.txt"
KEY_CONFLICTS="$TMPDIR_WORK/key_conflicts.txt"
: > "$ALL_KEYS1"
: > "$ALL_KEYS2"
: > "$KEY_CONFLICTS"

extract_top_keys() {
    # Track braces, comments and quoted strings instead of treating column zero
    # as scope. This is a lightweight scanner, not a full Jomini validator.
    awk '
        NR == 1 { sub(/^\357\273\277/, "") }
        {
            line = $0 "\n"
            for (i = 1; i <= length(line); i++) {
                c = substr(line, i, 1)
                if (quoted) {
                    if (escaped) escaped = 0
                    else if (c == "\\") escaped = 1
                    else if (c == "\"") quoted = 0
                    continue
                }
                if (c == "#") break
                if (c == "\"") { quoted = 1; token = ""; continue }
                if (c == "{") { depth++; token = ""; continue }
                if (c == "}") { depth--; token = ""; continue }
                if (depth != 0) continue
                if (c == "=") {
                    if (token ~ /^[a-zA-Z_][a-zA-Z0-9_]*$/) print token
                    token = ""
                } else if (c !~ /[[:space:]]/) {
                    if (space) token = ""
                    token = token c
                }
                space = (c ~ /[[:space:]]/)
            }
        }
    ' "$1" | sort -u
}

collect_common_keys() {
    local base="$1" filelist="$2" out="$3" relpath folder
    while IFS= read -r relpath; do
        case "$relpath" in
            common/*/*.txt) ;;
            *) continue ;;
        esac
        folder="${relpath#common/}"
        folder="common/${folder%%/*}"
        extract_top_keys "$base/$relpath" \
            | awk -v f="$folder" 'NF { print f "	" $0 }' >> "$out"
    done < "$filelist"
}

collect_common_keys "$MOD1" "$FILES1" "$ALL_KEYS1"
collect_common_keys "$MOD2" "$FILES2" "$ALL_KEYS2"

sort -u "$ALL_KEYS1" -o "$ALL_KEYS1"
sort -u "$ALL_KEYS2" -o "$ALL_KEYS2"

comm -12 "$ALL_KEYS1" "$ALL_KEYS2" \
    | awk -F '	' '{ print $1 ": " $2 }' > "$KEY_CONFLICTS"
KEY_CONFLICT_COUNT=$(wc -l < "$KEY_CONFLICTS" | tr -d ' ')

# ── 3. Localization conflicts ───────────────────────────────────────────────
#
# Compare each (language, key) once across the full trees. A translation in
# another language is not a collision, regardless of file or subfolder names.
LOC_CONFLICTS="$TMPDIR_WORK/loc_conflicts.txt"
ALL_LOC1="$TMPDIR_WORK/all_loc1.txt"
ALL_LOC2="$TMPDIR_WORK/all_loc2.txt"

collect_loc_keys() {
    local base="$1" filelist="$2" relpath
    while IFS= read -r relpath; do
        case "$relpath" in
            localization/*.yml|localisation/*.yml) ;;
            *) continue ;;
        esac
        awk '
            NR == 1 { sub(/^\357\273\277/, "") }
            /^[[:space:]]*l_[a-zA-Z_]+:/ {
                language = $0
                sub(/^[[:space:]]*/, "", language)
                sub(/:.*/, "", language)
                next
            }
            language && /^[[:space:]]+[a-zA-Z_][a-zA-Z0-9_.]*:/ {
                key = $0
                sub(/^[[:space:]]*/, "", key)
                sub(/:.*/, "", key)
                print language "\t" key
            }
        ' "$base/$relpath"
    done < "$filelist" | sort -u
}

collect_loc_keys "$MOD1" "$FILES1" > "$ALL_LOC1"
collect_loc_keys "$MOD2" "$FILES2" > "$ALL_LOC2"
comm -12 "$ALL_LOC1" "$ALL_LOC2" \
    | awk -F '\t' '{ print $1 ": " $2 }' > "$LOC_CONFLICTS"
LOC_CONFLICT_COUNT=$(wc -l < "$LOC_CONFLICTS" | tr -d ' ')


# ── 4. replace_path warnings ───────────────────────────────────────────────

REPLACE_PATHS="$TMPDIR_WORK/replace_paths.txt"
: > "$REPLACE_PATHS"

REPLACE_PATH_COUNT=0

check_replace_path() {
    local mod_dir="$1"
    local mod_name="$2"
    local found="$TMPDIR_WORK/replace_paths_one.txt"
    local f rpath
    : > "$found"

    # Read every .mod at the mod root, not just the first one: descriptor.mod
    # and a launcher stub beside it can each carry replace_path lines, and
    # they do not have to agree.  The glob covers descriptor.mod too.
    for f in "$mod_dir"/*.mod; do
        [[ -f "$f" ]] || continue
        grep -E '^[[:space:]]*replace_path[[:space:]]*=' "$f" 2>/dev/null \
            | sed 's/.*=[[:space:]]*//' \
            | sed 's/^"//' | sed 's/"$//' >> "$found" || true
    done

    sort -u "$found" | while IFS= read -r rpath; do
        [[ -n "$rpath" ]] || continue
        echo "[$mod_name] replace_path = \"$rpath\"" >> "$REPLACE_PATHS"
        # We count inside the subshell, so count after the loop instead.
    done
}

check_replace_path "$MOD1" "$MOD1_NAME"
check_replace_path "$MOD2" "$MOD2_NAME"
REPLACE_PATH_COUNT=$(wc -l < "$REPLACE_PATHS" | tr -d ' ')

# ── Report ──────────────────────────────────────────────────────────────────

TOTAL=$((FILE_CONFLICT_COUNT + KEY_CONFLICT_COUNT + LOC_CONFLICT_COUNT + REPLACE_PATH_COUNT))

echo "============================================================"
echo " CK3 Mod Compatibility Report"
echo "============================================================"
echo ""
echo "  Mod A: $MOD1_NAME  ($MOD1)"
echo "  Mod B: $MOD2_NAME  ($MOD2)"
echo ""

# Section 1
echo "------------------------------------------------------------"
echo " 1. File-Level Conflicts  ($FILE_CONFLICT_COUNT)"
echo "------------------------------------------------------------"
if [[ "$FILE_CONFLICT_COUNT" -gt 0 ]]; then
    echo ""
    echo "The following files exist in both mods (same relative path):"
    echo ""
    while IFS= read -r f; do
        echo "  - $f"
    done < "$COMMON_FILES"
else
    echo ""
    echo "  No file-level conflicts."
fi
echo ""

# Section 2
echo "------------------------------------------------------------"
echo " 2. Key-Level Conflicts  ($KEY_CONFLICT_COUNT)"
echo "------------------------------------------------------------"
if [[ "$KEY_CONFLICT_COUNT" -gt 0 ]]; then
    echo ""
    echo "Both mods define the same top-level key in the same common/ database:"
    echo ""
    while IFS= read -r line; do
        echo "  - $line"
    done < "$KEY_CONFLICTS"
else
    echo ""
    echo "  No key-level conflicts in common/ databases."
fi
echo ""

# Section 3
echo "------------------------------------------------------------"
echo " 3. Localization Conflicts  ($LOC_CONFLICT_COUNT)"
echo "------------------------------------------------------------"
if [[ "$LOC_CONFLICT_COUNT" -gt 0 ]]; then
    echo ""
    echo "Duplicate localization keys in the same language (across all files):"
    echo ""
    while IFS= read -r line; do
        echo "  - $line"
    done < "$LOC_CONFLICTS"
else
    echo ""
    echo "  No localization conflicts."
fi
echo ""

# Section 4
echo "------------------------------------------------------------"
echo " 4. replace_path Warnings  ($REPLACE_PATH_COUNT)"
echo "------------------------------------------------------------"
if [[ "$REPLACE_PATH_COUNT" -gt 0 ]]; then
    echo ""
    echo "These mods use replace_path — this is a hard override that"
    echo "will completely replace a vanilla directory and break other"
    echo "mods that modify files in that path:"
    echo ""
    while IFS= read -r line; do
        echo "  ! $line"
    done < "$REPLACE_PATHS"
else
    echo ""
    echo "  No replace_path directives found."
fi
echo ""

# Summary
echo "============================================================"
echo " Summary"
echo "============================================================"
echo ""
echo "  File conflicts:          $FILE_CONFLICT_COUNT"
echo "  Key conflicts:           $KEY_CONFLICT_COUNT"
echo "  Localization conflicts:  $LOC_CONFLICT_COUNT"
echo "  replace_path warnings:   $REPLACE_PATH_COUNT"
echo "  ─────────────────────────────"
echo "  Total issues:            $TOTAL"
echo ""

if [[ "$TOTAL" -gt 0 ]]; then
    echo "Result: CONFLICTS FOUND — review the report above."
    exit 1
else
    echo "Result: No conflicts detected by these static checks. Verify the playset in-game."
    exit 0
fi

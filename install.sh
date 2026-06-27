#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
Shinka Labs Skills installer

Usage:
  ./install.sh
  ./install.sh --dest "$HOME/.codex/skills"
  ./install.sh --dest "$HOME/.agents/skills"
  ./install.sh --dry-run

Options:
  --dest PATH   Install skills into PATH.
  --dry-run     Show what would be installed without copying files.
  -h, --help    Show this help message.
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}"
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      if [[ $# -lt 2 ]]; then
        echo "Error: --dest requires a path." >&2
        exit 1
      fi
      DEST="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      print_help
      exit 1
      ;;
  esac
done

echo "Shinka Labs Skills"
echo "Source: $SCRIPT_DIR"
echo "Destination: $DEST"
echo

skill_count=0

if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$DEST"
fi

for skill_dir in "$SCRIPT_DIR"/*; do
  [[ -d "$skill_dir" ]] || continue
  [[ -f "$skill_dir/SKILL.md" ]] || continue

  skill_name="$(basename "$skill_dir")"
  skill_count=$((skill_count + 1))

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] Would install: $skill_name"
  else
    rm -rf "$DEST/$skill_name"
    cp -R "$skill_dir" "$DEST/"
    echo "Installed: $skill_name"
  fi
done

echo

if [[ "$skill_count" -eq 0 ]]; then
  echo "No skills found. Expected folders containing SKILL.md inside: $SCRIPT_DIR" >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete. Skills found: $skill_count"
else
  echo "Install complete. Skills installed: $skill_count"
  echo "Restart or reload your agent so it can discover the new skills."
fi

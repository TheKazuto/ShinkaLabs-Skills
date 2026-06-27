#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
Shinka Labs Skills installer

Usage:
  ./install.sh
  ./install.sh --target codex
  ./install.sh --target claude
  ./install.sh --target agents
  ./install.sh --dest "$HOME/.codex/skills"
  ./install.sh --dest "$HOME/.claude/skills"
  ./install.sh --dest "$HOME/.agents/skills"
  ./install.sh --dry-run

Options:
  --target NAME  Use a known destination: codex, claude, or agents.
  --dest PATH    Install skills into PATH. Overrides --target.
  --dry-run      Show what would be installed without copying files.
  -h, --help     Show this help message.
EOF
}

default_dest_for_target() {
  case "$1" in
    codex)
      echo "${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}"
      ;;
    claude)
      echo "${CLAUDE_SKILLS_DIR:-${CLAUDE_HOME:-$HOME/.claude}/skills}"
      ;;
    agents)
      echo "${AGENTS_SKILLS_DIR:-${AGENTS_HOME:-$HOME/.agents}/skills}"
      ;;
    *)
      echo "Error: unknown target: $1" >&2
      echo "Expected one of: codex, claude, agents" >&2
      exit 1
      ;;
  esac
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR/skill"
INSTALL_NAME="shinka-labs-audit-pack"
TARGET="codex"
DEST="$(default_dest_for_target "$TARGET")"
DEST_SET=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      if [[ $# -lt 2 ]]; then
        echo "Error: --target requires a value." >&2
        exit 1
      fi
      TARGET="$2"
      if [[ "$DEST_SET" -eq 0 ]]; then
        DEST="$(default_dest_for_target "$TARGET")"
      fi
      shift 2
      ;;
    --dest)
      if [[ $# -lt 2 ]]; then
        echo "Error: --dest requires a path." >&2
        exit 1
      fi
      DEST="$2"
      DEST_SET=1
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
echo "Source: $SKILLS_SOURCE_DIR"
echo "Target: $TARGET"
echo "Destination: $DEST"
echo "Install name: $INSTALL_NAME"
echo

if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$DEST"
fi

if [[ ! -d "$SKILLS_SOURCE_DIR" ]]; then
  echo "Error: skills source folder not found: $SKILLS_SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -f "$SKILLS_SOURCE_DIR/SKILL.md" ]]; then
  echo "Error: skill entry point not found: $SKILLS_SOURCE_DIR/SKILL.md" >&2
  exit 1
fi

module_count="$(find "$SKILLS_SOURCE_DIR" -type f -name '*.md' ! -name 'SKILL.md' | wc -l | tr -d ' ')"

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[dry-run] Would install: $INSTALL_NAME"
  echo "[dry-run] Entry point: SKILL.md"
  echo "[dry-run] Focused modules: $module_count"
else
  rm -rf "$DEST/$INSTALL_NAME"
  mkdir -p "$DEST/$INSTALL_NAME"
  cp -R "$SKILLS_SOURCE_DIR"/. "$DEST/$INSTALL_NAME/"
  echo "Installed: $INSTALL_NAME"
  echo "Focused modules installed: $module_count"
fi

echo

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete."
else
  echo "Install complete."
  echo "Restart or reload your agent so it can discover the new skills."
fi

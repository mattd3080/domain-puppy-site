#!/bin/sh
# Domain Puppy — universal installer
# Works in any terminal, Claude Code, Codex, Cursor, Gemini CLI, etc.
#
# Usage:
#   curl -sL domainpuppy.com/install | sh              (global — default)
#   curl -sL domainpuppy.com/install | sh -s -- -p     (project only)
set -e

REPO="https://raw.githubusercontent.com/mattd3080/domain-puppy/main/SKILL.md"
NAME="domain-puppy"

# Parse flags — global is default
PROJECT=false
for arg in "$@"; do
  case "$arg" in
    -p | --project) PROJECT=true ;;
  esac
done

if [ "$PROJECT" = true ]; then
  BASE="."
  echo "Installing Domain Puppy to current project..."
else
  BASE="$HOME"
  echo "Installing Domain Puppy globally (~/)..."
fi

# Download
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT
curl -sL "$REPO" -o "$TMPFILE"

if [ ! -s "$TMPFILE" ]; then
  echo "Error: Failed to download. Check your internet connection."
  exit 1
fi

INSTALLED=0

# Universal (.agents/skills/) — Codex, Cursor, Gemini CLI, Amp, GitHub Copilot, Kimi, OpenCode
mkdir -p "$BASE/.agents/skills/$NAME"
cp "$TMPFILE" "$BASE/.agents/skills/$NAME/SKILL.md"
INSTALLED=$((INSTALLED + 1))

# Claude Code
mkdir -p "$BASE/.claude/skills/$NAME"
cp "$TMPFILE" "$BASE/.claude/skills/$NAME/SKILL.md"
INSTALLED=$((INSTALLED + 1))

# Conditional: only install if the agent's config directory already exists
for agent_dir in .windsurf .cline .augment .continue .codebuddy .commandcode; do
  if [ -d "$BASE/$agent_dir" ]; then
    mkdir -p "$BASE/$agent_dir/skills/$NAME"
    cp "$TMPFILE" "$BASE/$agent_dir/skills/$NAME/SKILL.md"
    INSTALLED=$((INSTALLED + 1))
  fi
done

# Antigravity (.agent/ — singular)
if [ -d "$BASE/.agent" ]; then
  mkdir -p "$BASE/.agent/skills/$NAME"
  cp "$TMPFILE" "$BASE/.agent/skills/$NAME/SKILL.md"
  INSTALLED=$((INSTALLED + 1))
fi

# OpenClaw (skills/ — root level)
if [ -d "$BASE/skills" ]; then
  mkdir -p "$BASE/skills/$NAME"
  cp "$TMPFILE" "$BASE/skills/$NAME/SKILL.md"
  INSTALLED=$((INSTALLED + 1))
fi

echo ""
echo "Done! Installed to $INSTALLED location(s)."
echo ""
echo "Try it now: find me a domain for [your idea]"

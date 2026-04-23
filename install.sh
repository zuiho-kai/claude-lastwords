#!/usr/bin/env bash
set -e

COMMANDS_DIR="$HOME/.claude/commands"
REPO="zuiho-kai/claude-lastwords"
TMP_DIR=$(mktemp -d)

echo "🪦 Installing 遗言 (LastWords) skill for Claude Code..."
echo ""

mkdir -p "$COMMANDS_DIR"

if command -v gh &> /dev/null; then
  gh repo clone "$REPO" "$TMP_DIR" -- --depth 1 -q 2>/dev/null
elif command -v git &> /dev/null; then
  git clone --depth 1 -q "https://github.com/$REPO.git" "$TMP_DIR"
else
  echo "Error: gh or git is required."
  rm -rf "$TMP_DIR"
  exit 1
fi

cp "$TMP_DIR/遗言.md" "$COMMANDS_DIR/遗言.md"
cp "$TMP_DIR/lastwords.md" "$COMMANDS_DIR/lastwords.md"
rm -rf "$TMP_DIR"

echo "Installed to $COMMANDS_DIR"
echo ""
echo "  /遗言       中文调用"
echo "  /lastwords  英文调用"
echo ""
echo "Done. 愿你的每个会话都能体面告别。"

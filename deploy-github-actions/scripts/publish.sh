#!/usr/bin/env bash
# Mirror this folder to its own GitHub repository and push to main.
#
# GitHub only runs workflows from .github/workflows at a repository root, so
# this demo is published as a standalone repo whose root is this folder. Every
# publish is a push to main, which triggers the Deploy to Fabric workflow.
#
# The commit is built from this folder's files (honouring its .gitignore), so
# the remote ends up as an exact mirror: deleted files are removed there too.
#
# Usage:
#   ./scripts/publish.sh <owner/repo> ["commit message"]
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <owner/repo> [\"commit message\"]" >&2
  exit 1
fi

REPO="$1"
MESSAGE="${2:-Update from rayfin-demos}"
DEMO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

gh repo clone "$REPO" "$WORK/repo" -- --quiet --no-checkout
cd "$DEMO_DIR"
git_mirror() {
  git --git-dir="$WORK/repo/.git" --work-tree="$DEMO_DIR" "$@"
}

git_mirror add -A
if git_mirror rev-parse --verify -q HEAD >/dev/null && git_mirror diff --cached --quiet HEAD; then
  echo "No changes to publish."
  exit 0
fi

git_mirror commit -q -m "$MESSAGE"
git_mirror push -q origin HEAD:main
echo "Published $(git_mirror rev-parse --short HEAD) to https://github.com/$REPO"

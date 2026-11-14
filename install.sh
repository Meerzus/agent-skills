#!/usr/bin/env bash
# Links the skills of this repository into the skill folders of the agents installed on this machine.
# Nothing is ever deleted: whatever has to make way is moved to ~/.agent-skills-backup/<timestamp>/.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SKILLS_SRC="$REPO/skills"
BACKUP_ROOT="$HOME/.agent-skills-backup/$(date +%Y%m%d-%H%M%S)"

CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
AGENTS_DIR="$HOME/.agents"

usage() {
  cat <<'EOF'
Usage: ./install.sh [options] [skill ...]

Links skills/<name> into each agent's skill folder. With no skill names, every
skill in skills/ is installed.

Agents (default: Claude and Codex, each only if its folder already exists):
  --claude     ~/.claude/skills
  --codex      ~/.codex/skills
  --agents     ~/.agents/skills (shared folder several agents read).
               Never picked by default: an agent that reads both this folder and
               its own would list every skill twice.

Options:
  --force      replace entries that differ from the repository (they are backed up)
  --dry-run    print what would happen, change nothing
  -h, --help   this text

An existing entry is replaced without --force only when nothing would be lost:
it is identical to the repository's copy or a dangling link.
EOF
}

agents=""
force=0
dry=0
names=()

while [ $# -gt 0 ]; do
  case "$1" in
    --claude) agents="$agents claude" ;;
    --codex) agents="$agents codex" ;;
    --agents) agents="$agents agents" ;;
    --force) force=1 ;;
    --dry-run) dry=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 64
      ;;
    *) names+=("$1") ;;
  esac
  shift
done

if [ -z "$agents" ]; then
  [ -d "$CLAUDE_HOME" ] && agents="$agents claude"
  [ -d "$CODEX_DIR" ] && agents="$agents codex"
fi
if [ -z "$agents" ]; then
  echo "No agent folder found (~/.claude, ~/.codex). Name one: --claude, --codex or --agents." >&2
  exit 1
fi

if [ ${#names[@]} -eq 0 ]; then
  for dir in "$SKILLS_SRC"/*/; do
    [ -f "${dir}SKILL.md" ] && names+=("$(basename "$dir")")
  done
fi
if [ ${#names[@]} -eq 0 ]; then
  echo "No skills found in $SKILLS_SRC." >&2
  exit 1
fi
for name in "${names[@]}"; do
  if [ ! -f "$SKILLS_SRC/$name/SKILL.md" ]; then
    echo "No such skill in this repository: $name" >&2
    exit 1
  fi
done

prefix=""
[ "$dry" -eq 1 ] && prefix="[dry-run] "
linked=0
kept=0
skipped=0

say() { printf '%s%s\n' "$prefix" "$*"; }

run() {
  if [ "$dry" -eq 0 ]; then "$@"; fi
}

# True when replacing $2 with a link to $1 loses nothing.
same() {
  [ -e "$2" ] || return 0
  diff -rq -x .DS_Store "$1" "$2" >/dev/null 2>&1
}

backup() {
  local dest="$1"
  local to="$BACKUP_ROOT${dest#"$HOME"}"
  # Two runs within one second share a timestamp: never move into an existing backup.
  while [ -e "$to" ] || [ -L "$to" ]; do to="$to.1"; done
  run mkdir -p "$(dirname "$to")"
  run mv "$dest" "$to"
  say "backup   $dest -> $to"
}

place() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    say "ok       $dest"
    kept=$((kept + 1))
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$force" -eq 1 ] || same "$src" "$dest"; then
      backup "$dest"
    else
      say "SKIPPED  $dest (differs from the repository; compare, then rerun with --force)"
      skipped=$((skipped + 1))
      return
    fi
  fi
  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  say "linked   $dest"
  linked=$((linked + 1))
}

for agent in $agents; do
  case "$agent" in
    claude) skills_dest="$CLAUDE_HOME/skills" ;;
    codex) skills_dest="$CODEX_DIR/skills" ;;
    agents) skills_dest="$AGENTS_DIR/skills" ;;
  esac
  say "== $agent"
  for name in "${names[@]}"; do
    place "$SKILLS_SRC/$name" "$skills_dest/$name"
  done
done

say "Done: $linked linked, $kept already in place, $skipped skipped."
if [ "$skipped" -gt 0 ]; then
  exit 2
fi

#!/usr/bin/env bash
# prepare-plugins.sh — sync plugin cache from host into the Docker build context.
# Run this before `docker build` whenever you want to refresh plugin versions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$SCRIPT_DIR/plugins-snapshot"
SRC="$HOME/.claude/plugins/cache"
CONTAINER_BASE="/home/dev/.claude/plugins/cache"
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Syncing plugin cache into $DEST ..."
mkdir -p "$DEST/cache"

# Sync each plugin directory, stripping node_modules and heavy assets
sync_plugin() {
  local rel_path="$1"
  local src="$SRC/$rel_path"
  local dst="$DEST/cache/$rel_path"
  if [ ! -d "$src" ]; then
    echo "  SKIP $rel_path (not found on host)"
    return
  fi
  echo "  -> $rel_path"
  mkdir -p "$dst"
  rsync -a --delete \
    --exclude='node_modules/' \
    --exclude='.git/' \
    --exclude='*.png' \
    --exclude='*.jpg' \
    --exclude='*.jpeg' \
    --exclude='*.gif' \
    --exclude='*.mp4' \
    --exclude='*.webm' \
    "$src/" "$dst/"
}

sync_plugin "claude-plugins-official/superpowers/5.1.0"
sync_plugin "claude-plugins-official/frontend-design/ef9da693e38f"
sync_plugin "claude-plugins-official/code-review/ef9da693e38f"
sync_plugin "claude-plugins-official/code-simplifier/1.0.0"
sync_plugin "claude-plugins-official/skill-creator/ef9da693e38f"
sync_plugin "gsap-skills/gsap-skills/1.0.0"
sync_plugin "impeccable/impeccable/2.1.1"
sync_plugin "likeahuman/branding-pitch/1.3.0"
sync_plugin "likeahuman/font-hunt/1.1.1"

# Generate installed_plugins.json with container-side paths
python3 - "$DEST" "$CONTAINER_BASE" "$NOW" <<'PYEOF'
import json, os, sys

dest, container_base, now = sys.argv[1], sys.argv[2], sys.argv[3]

entries = [
  ("superpowers@claude-plugins-official",    "claude-plugins-official/superpowers/5.1.0",          "5.1.0",        "8ea39819eed74fe2a0338e71789f06b30e953041"),
  ("frontend-design@claude-plugins-official","claude-plugins-official/frontend-design/ef9da693e38f","ef9da693e38f", "13b3a7c5827a08227fb99b87958b427a11bf8413"),
  ("code-review@claude-plugins-official",    "claude-plugins-official/code-review/ef9da693e38f",    "ef9da693e38f", "13b3a7c5827a08227fb99b87958b427a11bf8413"),
  ("code-simplifier@claude-plugins-official","claude-plugins-official/code-simplifier/1.0.0",       "1.0.0",        "13b3a7c5827a08227fb99b87958b427a11bf8413"),
  ("skill-creator@claude-plugins-official",  "claude-plugins-official/skill-creator/ef9da693e38f",  "ef9da693e38f", "13b3a7c5827a08227fb99b87958b427a11bf8413"),
  ("gsap-skills@gsap-skills",                "gsap-skills/gsap-skills/1.0.0",                       "1.0.0",        "03d9f0c3dbf91e0b60582b64ed040c8911ca0174"),
  ("impeccable@impeccable",                  "impeccable/impeccable/2.1.1",                         "2.1.1",        "00d485659af82982aef0328d0419c49a2716d123"),
  ("branding-pitch@likeahuman",              "likeahuman/branding-pitch/1.3.0",                     "1.3.0",        ""),
  ("font-hunt@likeahuman",                   "likeahuman/font-hunt/1.1.1",                          "1.1.1",        ""),
]

plugins = {}
for name, path, version, sha in entries:
  full_dest = os.path.join(dest, "cache", path)
  if not os.path.isdir(full_dest):
    continue
  entry = {
    "scope": "user",
    "installPath": f"{container_base}/{path}",
    "version": version,
    "installedAt": now,
    "lastUpdated": now,
  }
  if sha:
    entry["gitCommitSha"] = sha
  plugins[name] = [entry]

out = {"version": 2, "plugins": plugins}
out_path = os.path.join(dest, "installed_plugins.json")
with open(out_path, "w") as f:
  json.dump(out, f, indent=2)
print(f"  installed_plugins.json — {len(plugins)} plugins")
PYEOF

echo ""
echo "Done. Plugin snapshot:"
du -sh "$DEST"
echo ""
echo "Run 'docker build .' to rebuild the image."

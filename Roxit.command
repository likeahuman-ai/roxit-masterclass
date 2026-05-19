#!/bin/bash
# Roxit Masterclass launcher — double-click on macOS to start.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─────────────────────────────────────────────────────────────────────────────
#  Configuration
# ─────────────────────────────────────────────────────────────────────────────
# Self-updating launcher: on each run we ask GitHub which release is current
# (the "latest" marker, maintained automatically by `gh release create
# --latest`). An OLD launcher file therefore still pulls the NEWEST image —
# participants never need a fresh zip. If the network is down (offline
# classroom) or GitHub is unreachable we fall back to FALLBACK_VERSION so the
# workshop still runs.
RELEASES_BASE="https://github.com/likeahuman-ai/roxit-releases/releases"
LATEST_API="https://api.github.com/repos/likeahuman-ai/roxit-releases/releases/latest"
FALLBACK_VERSION="v0.5"
WORKDIR_HOST="$HOME/Desktop/roxit-workshop"
CLAUDE_VOLUME="roxit-claude-data"
DESIRED_PORTS=(3000 3001 8080)

case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  arm64)        ARCH=arm64 ;;
  *)            ARCH=amd64 ;;
esac

# Resolve the active version. Explicit overrides win (workshop-day pinning);
# otherwise ask GitHub for the latest release tag; otherwise fall back to the
# baked-in baseline. We grep tag_name rather than add a jq dependency.
resolve_version() {
  if [ -n "$ROXIT_VERSION" ]; then echo "$ROXIT_VERSION"; return; fi
  local v
  v="$(curl -fsSL --max-time 5 "$LATEST_API" 2>/dev/null \
        | grep -m1 '"tag_name"' \
        | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')"
  case "$v" in
    v[0-9]*) echo "$v" ;;
    *)       echo "$FALLBACK_VERSION" ;;
  esac
}
VERSION="$(resolve_version)"
RELEASE_URL="${ROXIT_RELEASE_URL:-$RELEASES_BASE/download/$VERSION}"
IMAGE="${ROXIT_IMAGE:-roxit-masterclass:${VERSION#v}-${ARCH}}"

# ─────────────────────────────────────────────────────────────────────────────
#  Visuals
# ─────────────────────────────────────────────────────────────────────────────
# Roxit brand · forest #143f26 · accent #21683E · lime #26ad6a
if [ -t 1 ]; then
  ESC=$'\033'; R="${ESC}[0m"; B="${ESC}[1m"; D="${ESC}[2m"
  FR="${ESC}[38;5;22m"   # forest (borders)
  AC="${ESC}[38;5;35m"   # accent green
  LM="${ESC}[38;5;41m"   # lime (emphasis, ✓)
  YE="${ESC}[38;5;220m"  # yellow (warn)
  RD="${ESC}[38;5;203m"  # red (error)
  GY="${ESC}[38;5;245m"  # grey (values)
  CR="${ESC}[38;5;230m"  # cream (labels)
else
  R=""; B=""; D=""; FR=""; AC=""; LM=""; YE=""; RD=""; GY=""; CR=""
fi

print_header() {
  printf '\n'
  printf '  %s╭───────────────────────────────────────────────╮%s\n' "$FR" "$R"
  printf '  %s│%s  %s%sROXIT MASTERCLASS%s                            %s│%s\n' "$FR" "$R" "$B" "$AC" "$R" "$FR" "$R"
  printf '  %s│%s  %sOne-click Claude Code sandbox%s                %s│%s\n' "$FR" "$R" "$D" "$R" "$FR" "$R"
  printf '  %s│%s                                               %s│%s\n' "$FR" "$R" "$FR" "$R"
  printf '  %s│%s  %sLike a Human · Amsterdam%s                     %s│%s\n' "$FR" "$R" "$LM" "$R" "$FR" "$R"
  printf '  %s╰───────────────────────────────────────────────╯%s\n' "$FR" "$R"
  printf '\n'
}

step_ok()    { printf '  %s✓%s  %-26s %s%s%s\n' "$LM" "$R" "$1" "$D" "${2:-}" "$R"; }
step_warn()  { printf '  %s!%s  %-26s %s%s%s\n' "$YE" "$R" "$1" "$D" "${2:-}" "$R"; }
step_err()   { printf '  %s✗%s  %-26s %s%s%s\n' "$RD" "$R" "$1" "$D" "${2:-}" "$R"; }
step_run()   { printf '  %s◆%s  %-26s %s%s%s\n' "$AC" "$R" "$1" "$D" "${2:-}" "$R"; }
hint()       { printf '     %s%s%s\n' "$GY" "$1" "$R"; }
divider()    { printf '\n  %s───────────────────────────────────────────────%s\n\n' "$D" "$R"; }
fatal()      { step_err "$1" "${2:-}"; printf '\n'; exit 1; }

# ─────────────────────────────────────────────────────────────────────────────
#  Pre-flight
# ─────────────────────────────────────────────────────────────────────────────
print_header

# 1. Docker present?
step_run "Checking Docker" "docker CLI"
if ! command -v docker >/dev/null 2>&1; then
  step_err "Docker not installed" "see docker.com/products/docker-desktop"
  osascript -e 'display dialog "Docker Desktop is not installed.\n\nInstall it from https://www.docker.com/products/docker-desktop/ then double-click Roxit again." buttons {"OK"} default button 1 with icon caution' >/dev/null 2>&1 || true
  open "https://www.docker.com/products/docker-desktop/" 2>/dev/null || true
  exit 1
fi
step_ok "Docker installed" "$(docker --version | sed 's/Docker version //')"

# 2. Docker daemon running?
if ! docker info >/dev/null 2>&1; then
  step_run "Starting Docker Desktop" "first launch can take ~30s"
  open -a Docker
  for i in {1..40}; do
    sleep 2
    docker info >/dev/null 2>&1 && break
  done
  if ! docker info >/dev/null 2>&1; then
    step_err "Docker did not start in time"
    osascript -e 'display dialog "Docker Desktop did not start in time. Open Docker Desktop manually, wait until it says \"Engine running\", then double-click Roxit again." buttons {"OK"} default button 1 with icon caution' >/dev/null 2>&1 || true
    exit 1
  fi
fi
step_ok "Docker daemon" "engine running"

# 3. Image present? Try the resolved version, then fall back.
#
# Download strategy, in order:
#   1. cached image for the resolved version           -> use it
#   2. download the resolved version's tarball          -> load it
#   3. resolved != fallback: cached fallback image       -> use it
#   4. resolved != fallback: download fallback tarball    -> load it
#   5. nothing worked                                    -> error out
# Steps 3-4 guard against a half-published release (the "latest" marker
# flipped before tarballs finished uploading) bricking every laptop.
TARFILE="$TMPDIR/roxit-${ARCH}.tar.gz"

fetch_and_load() {  # $1 = version tag (e.g. v0.5)
  local ver="$1"
  local img="roxit-masterclass:${ver#v}-${ARCH}"
  [ -n "$ROXIT_IMAGE" ] && img="$ROXIT_IMAGE"
  if docker image inspect "$img" >/dev/null 2>&1; then
    IMAGE="$img"; step_ok "Sandbox image" "$IMAGE (cached)"; return 0
  fi
  local url="${ROXIT_RELEASE_URL:-$RELEASES_BASE/download/$ver}"
  step_run "Downloading sandbox image" "$ver · ~420 MB · one time only"
  curl -fL --progress-bar "$url/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE" || return 1
  step_run "Loading image into Docker"
  docker load -i "$TARFILE" >/dev/null
  rm -f "$TARFILE"
  IMAGE="$img"; step_ok "Sandbox image" "$IMAGE (loaded)"
}

download_failed() {
  step_err "Download failed" "check network, retry"
  osascript -e 'display dialog "Kon de Roxit-image niet downloaden. Check je internet en probeer opnieuw, of vraag de begeleider om hulp." buttons {"OK"} default button 1 with icon caution' >/dev/null 2>&1 || true
  exit 1
}

if ! fetch_and_load "$VERSION"; then
  if [ "$VERSION" != "$FALLBACK_VERSION" ]; then
    step_warn "Latest unavailable" "falling back to $FALLBACK_VERSION"
    fetch_and_load "$FALLBACK_VERSION" || download_failed
  else
    download_failed
  fi
fi

# 4. Workspace + Claude token volume
mkdir -p "$WORKDIR_HOST"
docker volume create "$CLAUDE_VOLUME" >/dev/null

# Seed workspace from bundled starter/ on first run (host-side, before
# container boots). The image entrypoint has a fallback if this is skipped.
if [ -z "$(ls -A "$WORKDIR_HOST" 2>/dev/null)" ] && [ -d "$SCRIPT_DIR/starter" ]; then
  cp -r "$SCRIPT_DIR/starter/." "$WORKDIR_HOST/"
  step_ok "Workspace seeded" "$WORKDIR_HOST"
else
  step_ok "Workspace" "$WORKDIR_HOST"
fi

# ─────────────────────────────────────────────────────────────────────────────
#  Dynamic port allocation
# ─────────────────────────────────────────────────────────────────────────────
port_in_use() { nc -z 127.0.0.1 "$1" 2>/dev/null; }

# Tracks host ports already claimed by earlier iterations so we don't
# double-bind (e.g. 3000 busy → assign 3001 to container:3000, then need
# a different port for container:3001).
ALLOCATED_HOST_PORTS=""

is_allocated() {
  case " $ALLOCATED_HOST_PORTS " in *" $1 "*) return 0 ;; esac
  return 1
}

find_free_port() {
  local desired="$1"
  local candidate="$desired"
  local max=$((desired + 100))
  while [ "$candidate" -lt "$max" ]; do
    if ! port_in_use "$candidate" && ! is_allocated "$candidate"; then
      echo "$candidate"; return 0
    fi
    candidate=$((candidate + 1))
  done
  return 1
}

PORT_FLAGS=()
PORT_DISPLAY=""
PORT_REMAPPED=0
for p in "${DESIRED_PORTS[@]}"; do
  if free=$(find_free_port "$p"); then
    ALLOCATED_HOST_PORTS="$ALLOCATED_HOST_PORTS $free"
    PORT_FLAGS+=( -p "$free:$p" )
    if [ "$free" = "$p" ]; then
      PORT_DISPLAY+="${LM}${p}${R}${D}→${p}${R} "
    else
      PORT_DISPLAY+="${YE}${free}${R}${D}→${p}${R} "
      PORT_REMAPPED=1
    fi
  else
    step_warn "No free port near $p" "container port $p will not be exposed"
  fi
done

if [ "$PORT_REMAPPED" -eq 1 ]; then
  step_warn "Ports" "$PORT_DISPLAY"
  hint "Some ports were busy. Container ports stayed the same;"
  hint "your laptop reaches them on the yellow numbers above."
else
  step_ok "Ports" "$PORT_DISPLAY"
fi

# ─────────────────────────────────────────────────────────────────────────────
#  Run
# ─────────────────────────────────────────────────────────────────────────────
divider
printf '  %sLaunching sandbox...%s   %s(Ctrl+D to exit)%s\n\n' "$B" "$R" "$D" "$R"

# Clean up stale container from a previous force-killed session.
docker rm -f roxit-masterclass >/dev/null 2>&1 || true

exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=macOS" \
  "${PORT_FLAGS[@]}" \
  --name "roxit-masterclass" \
  "$IMAGE"

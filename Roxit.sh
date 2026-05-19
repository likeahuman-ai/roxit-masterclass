#!/usr/bin/env bash
# Roxit Masterclass launcher — Linux. Run with: bash Roxit.sh
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
  x86_64|amd64)   ARCH=amd64 ;;
  aarch64|arm64)  ARCH=arm64 ;;
  *) echo "Onbekende architectuur: $(uname -m). Werkt alleen op x86_64/arm64."; exit 1 ;;
esac

# Resolve the active version. Explicit overrides win (workshop-day pinning);
# otherwise ask GitHub for the latest release tag; otherwise fall back to the
# baked-in baseline. We grep tag_name rather than add a jq dependency.
# NOTE: resolve_version is curl-only; on wget-only boxes it silently uses
# FALLBACK_VERSION (acceptable — the tarball download below has wget fallback).
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

# ─────────────────────────────────────────────────────────────────────────────
#  Visuals
# ─────────────────────────────────────────────────────────────────────────────
# Roxit brand · forest #143f26 · accent #21683E · lime #26ad6a
if [ -t 1 ]; then
  ESC=$'\033'; R="${ESC}[0m"; B="${ESC}[1m"; D="${ESC}[2m"
  FR="${ESC}[38;5;22m"; AC="${ESC}[38;5;35m"; LM="${ESC}[38;5;41m"
  YE="${ESC}[38;5;220m"; RD="${ESC}[38;5;203m"; GY="${ESC}[38;5;245m"
  CR="${ESC}[38;5;230m"
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

# ─────────────────────────────────────────────────────────────────────────────
#  Pre-flight
# ─────────────────────────────────────────────────────────────────────────────
print_header

# 1. Docker present?
if ! command -v docker >/dev/null 2>&1; then
  step_err "Docker not installed"
  hint "Install via package manager or Docker Desktop:"
  hint "  https://docs.docker.com/desktop/install/linux/"
  exit 1
fi
step_ok "Docker installed" "$(docker --version | sed 's/Docker version //')"

# 2. Docker daemon running?
if ! docker info >/dev/null 2>&1; then
  step_err "Docker daemon not running"
  hint "Start it: sudo systemctl start docker"
  exit 1
fi
step_ok "Docker daemon" "engine running"

# 3. Image present? Try the resolved version, then fall back to
#    FALLBACK_VERSION so a half-published release (the "latest" marker flipped
#    before tarballs finished uploading) can't brick every laptop in the room.
TMPDIR_LOCAL="$(mktemp -d)"
TARFILE="$TMPDIR_LOCAL/roxit-${ARCH}.tar.gz"
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

download_tarball() {  # $1 = release URL
  if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar "$1/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE"
  elif command -v wget >/dev/null 2>&1; then
    wget --progress=bar:force "$1/roxit-masterclass-${ARCH}.tar.gz" -O "$TARFILE"
  else
    step_err "curl/wget not found" "install one and retry"
    exit 1
  fi
}

fetch_and_load() {  # $1 = version tag (e.g. v0.5)
  local ver="$1"
  local img="roxit-masterclass:${ver#v}-${ARCH}"
  [ -n "$ROXIT_IMAGE" ] && img="$ROXIT_IMAGE"
  if docker image inspect "$img" >/dev/null 2>&1; then
    IMAGE="$img"; step_ok "Sandbox image" "$IMAGE (cached)"; return 0
  fi
  local url="${ROXIT_RELEASE_URL:-$RELEASES_BASE/download/$ver}"
  step_run "Downloading sandbox image" "$ver · ~420 MB · one time only"
  download_tarball "$url" || return 1
  step_run "Loading image into Docker"
  docker load -i "$TARFILE" >/dev/null
  IMAGE="$img"; step_ok "Sandbox image" "$IMAGE (loaded)"
}

if ! fetch_and_load "$VERSION"; then
  if [ "$VERSION" != "$FALLBACK_VERSION" ]; then
    step_warn "Latest unavailable" "falling back to $FALLBACK_VERSION"
    fetch_and_load "$FALLBACK_VERSION" || { step_err "Download failed" "check network, retry"; exit 1; }
  else
    step_err "Download failed" "check network, retry"
    exit 1
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
port_in_use() {
  if command -v nc >/dev/null 2>&1; then
    nc -z 127.0.0.1 "$1" 2>/dev/null
  elif command -v ss >/dev/null 2>&1; then
    ss -tln "sport = :$1" 2>/dev/null | grep -q ":$1\b"
  else
    (echo > "/dev/tcp/127.0.0.1/$1") 2>/dev/null
  fi
}

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
    step_warn "No free port near $p" "container port $p not exposed"
  fi
done

if [ "$PORT_REMAPPED" -eq 1 ]; then
  step_warn "Ports" "$PORT_DISPLAY"
  hint "Some ports were busy; reach the container on the yellow numbers."
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

# Map host UID/GID so bind-mounted files are owned by the current user.
# Docker Desktop (macOS/Windows) does this transparently; native Linux does not.
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=Linux" \
  --user "$HOST_UID:$HOST_GID" \
  "${PORT_FLAGS[@]}" \
  --name "roxit-masterclass" \
  "$IMAGE"

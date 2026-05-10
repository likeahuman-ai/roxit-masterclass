#!/bin/bash
# Roxit Masterclass launcher — double-click on macOS to start.
set -e

# ─────────────────────────────────────────────────────────────────────────────
#  Configuration
# ─────────────────────────────────────────────────────────────────────────────
RELEASE_URL="${ROXIT_RELEASE_URL:-https://github.com/likeahuman-ai/roxit-releases/releases/download/v0.3}"
WORKDIR_HOST="$HOME/roxit-workshop"
CLAUDE_VOLUME="roxit-claude-data"
DESIRED_PORTS=(3000 3001 8080)

case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  arm64)        ARCH=arm64 ;;
  *)            ARCH=amd64 ;;
esac
IMAGE="${ROXIT_IMAGE:-roxit-masterclass:0.3-${ARCH}}"

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

# 3. Image present?
if docker image inspect "$IMAGE" >/dev/null 2>&1; then
  step_ok "Sandbox image" "$IMAGE (cached)"
else
  step_run "Downloading sandbox image" "~420 MB · one time only"
  TARFILE="$TMPDIR/roxit-${ARCH}.tar.gz"
  if ! curl -fL --progress-bar "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE"; then
    step_err "Download failed" "check network, retry"
    osascript -e 'display dialog "Kon de Roxit-image niet downloaden. Check je internet en probeer opnieuw, of vraag de begeleider om hulp." buttons {"OK"} default button 1 with icon caution' >/dev/null 2>&1 || true
    exit 1
  fi
  step_run "Loading image into Docker"
  docker load -i "$TARFILE" >/dev/null
  rm -f "$TARFILE"
  step_ok "Sandbox image" "$IMAGE (loaded)"
fi

# 4. Workspace + Claude token volume
mkdir -p "$WORKDIR_HOST"
docker volume create "$CLAUDE_VOLUME" >/dev/null
step_ok "Workspace" "$WORKDIR_HOST"

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

exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=macOS" \
  "${PORT_FLAGS[@]}" \
  --name "roxit-$$" \
  "$IMAGE"

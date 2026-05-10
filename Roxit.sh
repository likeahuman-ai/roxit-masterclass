#!/usr/bin/env bash
# Roxit Masterclass launcher — Linux. Run with: bash Roxit.sh
set -e

# ─────────────────────────────────────────────────────────────────────────────
#  Configuration
# ─────────────────────────────────────────────────────────────────────────────
RELEASE_URL="${ROXIT_RELEASE_URL:-https://github.com/likeahuman-ai/roxit-releases/releases/download/v0.3}"
WORKDIR_HOST="$HOME/roxit-workshop"
CLAUDE_VOLUME="roxit-claude-data"
DESIRED_PORTS=(3000 3001 8080)

case "$(uname -m)" in
  x86_64|amd64)   ARCH=amd64 ;;
  aarch64|arm64)  ARCH=arm64 ;;
  *) echo "Onbekende architectuur: $(uname -m). Werkt alleen op x86_64/arm64."; exit 1 ;;
esac
IMAGE="${ROXIT_IMAGE:-roxit-masterclass:0.3-${ARCH}}"

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

# 3. Image present?
if docker image inspect "$IMAGE" >/dev/null 2>&1; then
  step_ok "Sandbox image" "$IMAGE (cached)"
else
  step_run "Downloading sandbox image" "~420 MB · one time only"
  TMPDIR_LOCAL="$(mktemp -d)"
  TARFILE="$TMPDIR_LOCAL/roxit-${ARCH}.tar.gz"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE"
  elif command -v wget >/dev/null 2>&1; then
    wget --progress=bar:force "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -O "$TARFILE"
  else
    step_err "curl/wget not found" "install one and retry"
    exit 1
  fi
  step_run "Loading image into Docker"
  docker load -i "$TARFILE" >/dev/null
  rm -rf "$TMPDIR_LOCAL"
  step_ok "Sandbox image" "$IMAGE (loaded)"
fi

# 4. Workspace + Claude token volume
mkdir -p "$WORKDIR_HOST"
docker volume create "$CLAUDE_VOLUME" >/dev/null
step_ok "Workspace" "$WORKDIR_HOST"

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

find_free_port() {
  local desired="$1" candidate="$desired" max=$((desired + 100))
  while [ "$candidate" -lt "$max" ]; do
    if ! port_in_use "$candidate"; then
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

exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=Linux" \
  "${PORT_FLAGS[@]}" \
  --name "roxit-$$" \
  "$IMAGE"

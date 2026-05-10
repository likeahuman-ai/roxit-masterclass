#!/usr/bin/env bash
# Roxit Masterclass launcher — Linux. Run with: bash Roxit.sh
set -e

IMAGE="${ROXIT_IMAGE:-roxit-masterclass:0.3}"
RELEASE_URL="${ROXIT_RELEASE_URL:-https://github.com/likeahuman-ai/roxit-releases/releases/download/v0.3}"
WORKDIR_HOST="$HOME/roxit-workshop"
CLAUDE_VOLUME="roxit-claude-data"

echo
echo "  Roxit Masterclass · starting your sandbox..."
echo

# Detect arch
case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) echo "  Onbekende architectuur: $(uname -m). Werkt alleen op x86_64/arm64."; exit 1 ;;
esac

# 1. Docker present?
if ! command -v docker >/dev/null 2>&1; then
  echo "  Docker is niet geïnstalleerd."
  echo "  Installeer via je package manager OR Docker Desktop:"
  echo "    https://docs.docker.com/desktop/install/linux/"
  exit 1
fi

# 2. Docker daemon running?
if ! docker info >/dev/null 2>&1; then
  echo "  Docker daemon draait niet. Start hem:"
  echo "    sudo systemctl start docker   # systemd"
  echo "    open -a 'Docker Desktop'      # Docker Desktop"
  exit 1
fi

# 3. Image present? Download + load if missing.
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "  Image laden — eenmalige download (~420 MB)..."
  TMPDIR_LOCAL="$(mktemp -d)"
  TARFILE="$TMPDIR_LOCAL/roxit-${ARCH}.tar.gz"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE"
  elif command -v wget >/dev/null 2>&1; then
    wget --progress=bar:force "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -O "$TARFILE"
  else
    echo "  curl of wget niet gevonden. Installeer er één en probeer opnieuw."
    exit 1
  fi
  echo "  Image laden in Docker..."
  docker load -i "$TARFILE"
  rm -rf "$TMPDIR_LOCAL"
fi

# 4. Persistent host folder for work; named volume for Claude token.
mkdir -p "$WORKDIR_HOST"
docker volume create "$CLAUDE_VOLUME" >/dev/null

# 5. Run.
exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=Linux" \
  -p 3000:3000 \
  -p 3001:3001 \
  -p 8080:8080 \
  --name "roxit-$$" \
  "$IMAGE"

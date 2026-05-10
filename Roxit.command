#!/bin/bash
# Roxit Masterclass launcher — double-click on macOS to start.

set -e
IMAGE="${ROXIT_IMAGE:-roxit-masterclass:0.3}"
RELEASE_URL="${ROXIT_RELEASE_URL:-https://github.com/likeahuman-ai/roxit-releases/releases/download/v0.3}"
WORKDIR_HOST="$HOME/roxit-workshop"
CLAUDE_VOLUME="roxit-claude-data"

case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  arm64) ARCH=arm64 ;;
  *) ARCH=amd64 ;;
esac

echo ""
echo "  Roxit Masterclass · starting your sandbox..."
echo ""
echo "  Eerste keer? Als je net een waarschuwing zag over"
echo "  een 'onbekende ontwikkelaar': sluit dit venster, doe"
echo "  rechtsklik op Roxit.command in Finder, kies 'Open',"
echo "  en bevestig met 'Open' in de dialoog."
echo "  Werkt deze keer al? Negeer deze melding."
echo ""

# 1. Docker present?
if ! command -v docker >/dev/null 2>&1; then
  osascript -e 'display dialog "Docker Desktop is not installed.\n\nInstall it from https://www.docker.com/products/docker-desktop/ then double-click Roxit again." buttons {"OK"} default button 1 with icon caution'
  open "https://www.docker.com/products/docker-desktop/"
  exit 1
fi

# 2. Docker running?
if ! docker info >/dev/null 2>&1; then
  echo "  Starting Docker Desktop... (first time can take ~30 seconds)"
  open -a Docker
  for i in {1..40}; do
    sleep 2
    docker info >/dev/null 2>&1 && break
  done
  if ! docker info >/dev/null 2>&1; then
    osascript -e 'display dialog "Docker Desktop did not start in time. Open Docker Desktop manually, wait until it says \"Engine running\", then double-click Roxit again." buttons {"OK"} default button 1 with icon caution'
    exit 1
  fi
fi

# 3. Image present? Download + load from GitHub Release if missing.
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "  Image laden — eenmalige download (~420 MB)..."
  TARFILE="$TMPDIR/roxit-${ARCH}.tar.gz"
  if curl -fL --progress-bar "$RELEASE_URL/roxit-masterclass-${ARCH}.tar.gz" -o "$TARFILE"; then
    echo "  Image laden in Docker..."
    docker load -i "$TARFILE"
    rm -f "$TARFILE"
  else
    osascript -e 'display dialog "Kon de Roxit-image niet downloaden. Check je internetverbinding en probeer opnieuw, of vraag de workshop-begeleider om hulp." buttons {"OK"} default button 1 with icon caution'
    exit 1
  fi
fi

# 4. Persistent host folder for work; named volume for Claude token.
mkdir -p "$WORKDIR_HOST"
docker volume create "$CLAUDE_VOLUME" >/dev/null

# 5. Run.
exec docker run -it --rm \
  -v "$WORKDIR_HOST:/workspace" \
  -v "$CLAUDE_VOLUME:/home/dev/.claude" \
  -e "ROXIT_HOST_WORKSHOP=$WORKDIR_HOST" \
  -e "ROXIT_HOST_OS=macOS" \
  -p 3000:3000 \
  -p 3001:3001 \
  -p 8080:8080 \
  --name "roxit-$$" \
  "$IMAGE"

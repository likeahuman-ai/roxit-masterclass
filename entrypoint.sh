#!/bin/bash
set -e

# Mode: `entrypoint.sh banner` prints the banner and exits (used by VS Code
# Dev Containers postAttachCommand). Default: seed workspace, print banner,
# exec bash (used by docker run -it from Roxit.command launchers).
MODE="${1:-shell}"

# Sync settings + plugins from image defaults into the volume.
# The volume mount shadows /home/dev/.claude, so baked-in files are invisible
# unless we copy them in. Auth tokens and user-installed plugins are preserved.
mkdir -p /home/dev/.claude/plugins/cache

# Settings: always overwrite (workshop defaults are authoritative)
cp -f /home/dev/.claude-defaults/settings.json /home/dev/.claude/settings.json 2>/dev/null || true

# Plugin cache: copy baked-in plugins without overwriting user-installed ones
cp -rn /home/dev/.claude-defaults/plugins/cache/* /home/dev/.claude/plugins/cache/ 2>/dev/null || true

# Plugin registry: merge baked-in plugins with any the user installed.
# Baked-in entries are added if missing; user entries are never removed.
if [ -f /home/dev/.claude-defaults/plugins/installed_plugins.json ]; then
  if [ -f /home/dev/.claude/plugins/installed_plugins.json ]; then
    # Merge: image defaults as base, user overrides on top
    jq -s '.[0] * .[1] | .plugins = (.[0].plugins * .[1].plugins)' \
      /home/dev/.claude-defaults/plugins/installed_plugins.json \
      /home/dev/.claude/plugins/installed_plugins.json \
      > /tmp/merged-plugins.json 2>/dev/null \
      && mv /tmp/merged-plugins.json /home/dev/.claude/plugins/installed_plugins.json \
      || true
  else
    cp -f /home/dev/.claude-defaults/plugins/installed_plugins.json /home/dev/.claude/plugins/installed_plugins.json 2>/dev/null || true
  fi
fi

if [ "$MODE" = "shell" ]; then
  # First-run: seed the workspace from the starter (don't overwrite existing work)
  if [ -z "$(ls -A /workspace 2>/dev/null)" ]; then
    cp -r /workspace-starter/. /workspace/ 2>/dev/null || true
  fi

  [ -t 1 ] && command -v clear >/dev/null && clear || true
fi

HOST_PATH="${ROXIT_HOST_WORKSHOP:-(unknown — launched without Roxit launcher)}"
HOST_OS="${ROXIT_HOST_OS:-your computer}"

case "$HOST_OS" in
  macOS)   OPEN_CMD="open \"$HOST_PATH\"" ;;
  Windows) OPEN_CMD="explorer \"$HOST_PATH\"" ;;
  Linux)   OPEN_CMD="xdg-open \"$HOST_PATH\"" ;;
  *)       OPEN_CMD="" ;;
esac

# Roxit brand palette · forest #143f26 · accent #21683E · lime #26ad6a
if [ -t 1 ]; then
  E=$'\033'; R="${E}[0m"; B="${E}[1m"; D="${E}[2m"
  FR="${E}[38;5;22m"   # forest (borders)
  AC="${E}[38;5;35m"   # accent green (titles, ✓)
  LM="${E}[38;5;41m"   # lime (emphasis)
  GY="${E}[38;5;245m"  # grey (values)
  CR="${E}[38;5;230m"  # cream (labels)
  YE="${E}[38;5;220m"  # yellow (warn)
else
  R=""; B=""; D=""; FR=""; AC=""; LM=""; GY=""; CR=""; YE=""
fi

# Telemetry status
if [ -n "${CLAUDE_CODE_ENABLE_TELEMETRY:-}" ] && [ "$CLAUDE_CODE_ENABLE_TELEMETRY" != "0" ]; then
  TELEMETRY_LABEL="${LM}ON${R}${D} · exporter: ${OTEL_METRICS_EXPORTER:-console}${R}"
else
  TELEMETRY_LABEL="${GY}OFF${R}"
fi

cat <<EOF

  ${FR}╭───────────────────────────────────────────────╮${R}
  ${FR}│${R}  ${B}${AC}ROXIT MASTERCLASS${R}                            ${FR}│${R}
  ${FR}│${R}  ${D}Claude Code sandbox · /workspace${R}             ${FR}│${R}
  ${FR}╰───────────────────────────────────────────────╯${R}

  ${AC}◆${R}  ${B}${CR}YOUR FILES${R}
     ${D}${HOST_OS}${R}    ${GY}${HOST_PATH}${R}
     ${D}sandbox${R}  ${GY}/workspace${R}
EOF

if [ -n "$OPEN_CMD" ]; then
  printf '     %sopen%s     %s%s%s\n' "$D" "$R" "$LM" "$OPEN_CMD" "$R"
fi

cat <<EOF

  ${AC}◆${R}  ${B}${CR}GET STARTED${R}
     ${LM}claude${R}                                          ${D}log in once via browser${R}
     ${LM}claude${R} ${GY}"explain what's in /workspace"${R}
     ${LM}claude${R} ${GY}"draft a PRD for a permits tracker"${R}

  ${AC}◆${R}  ${B}${CR}PRE-INSTALLED${R}
     ${GY}claude · node · pnpm · vercel · convex · gh${R}
     ${GY}tsx · typescript · create-next-app · rg · jq${R}

  ${AC}◆${R}  ${B}${CR}DEV SERVER${R}
     ${GY}localhost:3000  ·  3001  ·  8080${R}   ${D}open in your browser${R}
     ${D}Servers auto-bind 0.0.0.0 so ports are reachable from your host${R}
EOF

# Detect if ports are actually forwarded by checking ROXIT_HOST_OS (set by
# launchers) or if any of the expected ports show in /proc/net/tcp listening.
# If the container was started with plain `docker run` (no -p flags), warn.
if [ -z "${ROXIT_HOST_OS:-}" ]; then
  cat <<EOF

  ${YE}!${R}  ${B}Ports may not be forwarded${R}
     ${D}It looks like this container was started without the Roxit launcher.${R}
     ${D}Dev servers inside the container won't be reachable from your browser${R}
     ${D}unless you started with: ${R}${LM}docker run -p 3000:3000 -p 3001:3001 -p 8080:8080 ...${R}
     ${D}Or use the launcher: ${R}${LM}bash Roxit.sh${R}${D} / double-click ${R}${LM}Roxit.command${R}
EOF
fi

cat <<EOF

  ${D}╴ Telemetry  ${TELEMETRY_LABEL}
  ${D}╴ Type ${R}${LM}exit${R}${D} to leave the sandbox · files persist${R}

EOF

if [ "$MODE" = "banner" ]; then
  exit 0
fi

exec bash

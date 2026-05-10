#!/bin/bash
set -e

# First-run: seed the workspace from the starter (don't overwrite existing work)
if [ -z "$(ls -A /workspace 2>/dev/null)" ]; then
  cp -r /workspace-starter/. /workspace/ 2>/dev/null || true
fi

[ -t 1 ] && command -v clear >/dev/null && clear || true

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

  ${D}╴ Telemetry  ${TELEMETRY_LABEL}
  ${D}╴ Type ${R}${LM}exit${R}${D} to leave the sandbox · files persist${R}

EOF

exec bash

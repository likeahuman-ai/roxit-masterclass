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
  macOS)   OPEN_HINT="In Finder:  open \"$HOST_PATH\"" ;;
  Windows) OPEN_HINT="In Explorer: explorer \"$HOST_PATH\"" ;;
  *)       OPEN_HINT="" ;;
esac

cat <<EOF
══════════════════════════════════════════════════════════════
  Roxit Masterclass · Claude Code Sandbox
══════════════════════════════════════════════════════════════

  Your files on $HOST_OS:
    $HOST_PATH
  Inside this sandbox they appear as: /workspace

  ${OPEN_HINT}

  First time?   Run:  claude   (follow the login prompt once)
  Then try:           claude "explain what's in /workspace"
                      claude "draft a PRD for a permits tracker"

  Type 'exit' to leave the sandbox. Your files persist.

  Pre-installed: claude, node, pnpm, npx, vercel, convex,
                 tsx, typescript, create-next-app, gh, git, rg, jq
  Dev server:    localhost:3000 / :3001 / :8080 open in your browser
  Telemetry:     ${CLAUDE_CODE_ENABLE_TELEMETRY:+ON}${CLAUDE_CODE_ENABLE_TELEMETRY:-OFF} (exporter: ${OTEL_METRICS_EXPORTER:-none})
══════════════════════════════════════════════════════════════
EOF

exec bash

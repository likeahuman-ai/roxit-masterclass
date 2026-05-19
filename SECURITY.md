# Security & IT review

For Roxit / Visma IT contacts evaluating this sandbox before rollout.

## Boundaries

- **Runs as a non-root user** (`dev`, UID 1000) inside Docker. No `sudo`, no access to the host kernel beyond what Docker namespaces allow.
- **Ephemeral container** (`docker run --rm`). State lives in two places:
  - Mounted host folder (`~/Desktop/roxit-workshop/` on macOS/Linux, `%USERPROFILE%\Desktop\roxit-workshop\` on Windows) — participant work persists here.
  - Named Docker volume `roxit-claude-data` — only stores the Claude Code OAuth refresh token.
- **No host network access**. Container has its own network namespace; reaches the internet via Docker's default bridge.

## Network

Default policy is **unrestricted egress** so participants can fetch npm packages, deploy to Vercel preview URLs, use AI features.

To lock down: layer `/etc/claude-code/managed-settings.json` on top of the image (managed settings always win over project + user settings). See [`starter/.claude/managed-settings.example.jsonc`](starter/.claude/managed-settings.example.jsonc) — commented menu of what's pinnable:

- Internal git / npm registry only
- Block `WebFetch` / `WebSearch`
- Disable deploy commands (`vercel`, `convex deploy`)
- Pin model version
- Redirect telemetry to your OTLP collector

Mount the managed-settings file into the container at runtime — no image rebuild needed.

## Telemetry

**On by default** with the **console exporter** (visible to the participant, not transmitted off-host). Point `OTEL_EXPORTER_OTLP_ENDPOINT` at your collector to centralise.

## Image source

- **Built from** the private `likeahuman-ai/roxit-masterclass` repo
- **Distributed via** `ghcr.io/likeahuman-ai/roxit-masterclass:0.5` (public read, multi-arch) and as `.tar.gz` mirror on `likeahuman-ai/roxit-releases` (public)
- **Base layers:** `node:22-slim` (Debian-based, Anthropic-reviewed)
- **Pre-installed binaries:** Node 22 + pnpm, Vercel CLI, Convex CLI, GitHub CLI, ripgrep, jq, tsx, TypeScript, Claude Code CLI (`@anthropic-ai/claude-code@2.1.143`)
- **No secrets, no API keys baked in.** Participants authenticate via Claude Code's browser OAuth flow at first run.

## Permission rules

Pre-shipped `.claude/settings.json` denies sensitive reads:

```json
{
  "permissions": {
    "deny": [
      "Read(/home/dev/.ssh/**)",
      "Read(/home/dev/.aws/**)",
      "Read(/home/dev/.gnupg/**)",
      "Read(/etc/shadow)"
    ],
    "ask": [
      "Bash(rm -rf /*)",
      "Bash(rm -rf ~/*)",
      "Bash(sudo *)"
    ]
  }
}
```

These can be tightened further via the managed-settings layer.

## Contact

Questions or pre-approval requests: jasper@likeahuman.ai

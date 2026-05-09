<p align="center">
  <h1 align="center">Roxit Masterclass</h1>
  <p align="center"><strong>One-click Claude Code sandbox</strong> — AI Experience Week · May 18–22, 2026</p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Client-Visma_Roxit-0052CC?style=for-the-badge" alt="Visma Roxit">
  <img src="https://img.shields.io/badge/By-Like_a_Human-000?style=for-the-badge" alt="Like a Human">
  <img src="https://img.shields.io/badge/Status-v0.3_experimental-orange?style=for-the-badge" alt="Status">
</p>

<br>

<p align="center">
Participants double-click one file. Docker pulls the image, Claude Code starts, and they're ready to build.<br>
No Node install. No git setup. No config. Works on macOS, Windows, and Linux.
</p>

<br>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-Roxit.command-000?style=flat-square&logo=apple&logoColor=white" alt="macOS">
  &nbsp;
  <img src="https://img.shields.io/badge/Windows-Roxit.bat-0078D6?style=flat-square&logo=windows&logoColor=white" alt="Windows">
  &nbsp;
  <img src="https://img.shields.io/badge/Linux-Roxit.sh-FCC624?style=flat-square&logo=linux&logoColor=black" alt="Linux">
  &nbsp;
  <img src="https://img.shields.io/badge/Arch-arm64_+_amd64-8A2BE2?style=flat-square" alt="Multi-arch">
</p>

---

### What's inside

| | Tool | Why |
|---|---|---|
| 🤖 | **Claude Code CLI** | The workshop tool — AI coding agent in the terminal |
| ⚡ | **Node 22 + pnpm** | Run and build Next.js projects |
| 🔺 | **Vercel CLI** | Deploy to preview URLs during exercises |
| 📦 | **Convex CLI** | Backend-as-a-service used in workshop exercises |
| 🐙 | **GitHub CLI** | Repo management without leaving the terminal |
| 🔍 | **ripgrep + jq** | Fast search and JSON parsing |
| 🌊 | **surf-cli** | AI image generation from the terminal |
| 📝 | **tsx + TypeScript** | Run `.ts` files directly, no compile step |

---

### Participant flow

```
1. Download zip  →  unzip  →  double-click Roxit
2. First run: Docker pulls the image (~500 MB, one time)
3. First run: claude → browser opens → approve → paste code back
4. Work in /workspace  (= ~/roxit-workshop on your laptop)
5. Files survive container restarts — work is never lost
```

---

### For IT / security

The sandbox runs as a **non-root user** (`dev`) inside Docker. Network access is unrestricted by default so participants can fetch docs, deploy previews, and use AI features. Restrictions can be layered on top via `managed-settings.json` without rebuilding the image.

See [`starter/.claude/managed-settings.example.jsonc`](starter/.claude/managed-settings.example.jsonc) for a commented menu of everything you can lock down:

- Internal git / npm registry only
- Block `WebFetch` / `WebSearch`
- Disable deploy commands
- Pin model version
- Redirect telemetry to your OTLP collector

Telemetry is **on by default** (console exporter) so participants can see their own activity. Point `OTEL_EXPORTER_OTLP_ENDPOINT` at your collector to centralise logs.

---

### Build (maintainers)

```bash
# Multi-arch build + push to GHCR
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/likeahuman-ai/roxit-masterclass:0.3 --push .

# Local arm64 only (for testing on Apple Silicon)
docker buildx build --platform linux/arm64 -t roxit-masterclass:0.3 --load .

# Save as tar for GitHub Release
docker save roxit-masterclass:0.3-amd64 | gzip > roxit-masterclass-amd64.tar.gz
docker save roxit-masterclass:0.3-arm64 | gzip > roxit-masterclass-arm64.tar.gz
```

---

### OS security warnings

Both macOS and Windows will warn about unsigned launchers. This is expected.

- **macOS** — Right-click `Roxit.command` → Open → Open
- **Windows** — Click "More info" → "Run anyway"

---

<p align="center">
  Built by <a href="https://likeahuman.ai">Like a Human</a> · Amsterdam
</p>

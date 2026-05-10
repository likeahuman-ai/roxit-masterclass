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

### 🎬 30-second setup walkthrough

<p align="center">
  <img src="walkthrough/roxit-walkthrough.gif" alt="Roxit Masterclass setup walkthrough — install Docker, download zip, double-click launcher, log in to Claude Code" width="720">
</p>

<p align="center">
  <sub>Prefer video? <a href="walkthrough/roxit-walkthrough.mp4">Download the MP4</a> · source under <a href="walkthrough/"><code>walkthrough/</code></a> · built with <a href="https://www.remotion.dev/">Remotion</a></sub>
</p>

---

## 🚀 Quickstart for participants

> **You need to do this once, before the workshop starts.** Allow ~15 minutes the first time (mostly waiting on downloads).

### Step 1 — Install Docker Desktop

Docker is the engine that runs the sandbox. It's free.

- **macOS** → https://www.docker.com/products/docker-desktop/ → choose **Apple Silicon** (M1/M2/M3/M4) or **Intel chip**
- **Windows** → https://www.docker.com/products/docker-desktop/ → choose **Windows**
- **Linux** → install Docker Engine via your package manager

After install, **open Docker Desktop once** and wait until it says "Engine running" (bottom-left, green dot). You can then close the window — Docker keeps running in the background.

> Not sure which Mac chip you have? Click  → **About This Mac**. "Apple M…" = Apple Silicon.

### Step 2 — Download the workshop zip

Grab the latest release: **[github.com/likeahuman-ai/roxit-releases/releases/latest](https://github.com/likeahuman-ai/roxit-releases/releases/latest)**

Download `roxit-masterclass.zip` (~5 KB — just the launchers; the 420 MB image is fetched on first run), then **unzip it** to a folder you'll remember (e.g. `~/Desktop/roxit-masterclass` or `Documents\roxit-masterclass`).

### Step 3 — Double-click the launcher

Inside the unzipped folder you'll see three launchers. Use the one for your OS:

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

The first time, your OS will warn about an "unidentified developer" or SmartScreen. This is expected (we don't pay for code signing certificates).

- **macOS** → Right-click `Roxit.command` → **Open** → confirm **Open** in the dialog
- **Windows** → Click **More info** → **Run anyway**

The launcher then:

1. Checks Docker is installed and running (auto-starts it if needed)
2. Downloads the sandbox image (~420 MB gzipped, **only the first time**)
3. Opens a terminal inside the sandbox

### Step 4 — Log in to Claude Code

Once the terminal opens, type:

```
claude
```

A browser tab opens automatically. **Approve access** with your Anthropic account. The browser shows a code — **copy it and paste it back into the terminal**. Done.

You should now see the Claude Code prompt. Try:

```
What's in this workspace?
```

You're ready for the workshop. ✨

---

## 🆘 Troubleshooting

<details>
<summary><b>"Docker Desktop is not installed"</b></summary>

You skipped Step 1. The launcher will open the Docker download page for you. Install, **open Docker Desktop once** until "Engine running", then double-click Roxit again.
</details>

<details>
<summary><b>"Docker Desktop did not start in time"</b></summary>

Open Docker Desktop manually, wait until you see **Engine running** (bottom-left, green dot). Then double-click Roxit again.

On older Macs, the first start of Docker can take 60+ seconds.
</details>

<details>
<summary><b>"Kon de Roxit-image niet downloaden"</b></summary>

The download from GitHub Releases failed. Check your internet connection. If you're on the Visma corporate network, GitHub access may be restricted — try a personal hotspot.

If it still fails, ask the workshop facilitator for the tar file directly.
</details>

<details>
<summary><b>"Port 3000 is already in use"</b></summary>

Something else on your machine is using port 3000 (commonly: another Node.js app, Grafana, or a previous Roxit container).

Quick fix: quit the other app, or stop other Roxit containers with:
```bash
docker ps             # list running containers
docker stop <name>    # stop the one on port 3000
```
</details>

<details>
<summary><b>The browser tab never opens after typing <code>claude</code></b></summary>

Some corporate machines block the auto-open. Look at the terminal output — it shows a URL like `https://claude.ai/oauth/...`. Copy that URL into a browser manually, approve, and paste the code back into the terminal.
</details>

<details>
<summary><b>"Engine running" never appears in Docker Desktop</b></summary>

On Windows, Docker Desktop requires **WSL 2**. If WSL isn't installed, Docker shows an error on first launch with a one-click installer link. Follow it, restart, and try again.

On macOS, give Docker Desktop **Full Disk Access** in System Settings → Privacy & Security if it gets stuck.
</details>

<details>
<summary><b>I'm on a corporate laptop and IT blocks Docker</b></summary>

Talk to your IT contact and forward them the [For IT / security](#-for-it--security) section below. Docker Desktop is the only requirement, no admin install of Node/npm/git is needed.
</details>

---

## 📦 What's inside the sandbox

| | Tool | Why |
|---|---|---|
| 🤖 | **Claude Code CLI** | The workshop tool — AI coding agent in the terminal |
| ⚡ | **Node 22 + pnpm** | Run and build Next.js projects |
| 🔺 | **Vercel CLI** | Deploy to preview URLs during exercises |
| 📦 | **Convex CLI** | Backend-as-a-service used in workshop exercises |
| 🐙 | **GitHub CLI** | Repo management without leaving the terminal |
| 🔍 | **ripgrep + jq** | Fast search and JSON parsing |
| 📝 | **tsx + TypeScript** | Run `.ts` files directly, no compile step |

Plus pre-installed Claude Code plugins from the LikeAHuman marketplace: `branding-pitch`, `font-hunt`, `superpowers`, `frontend-design`, `code-review`, `code-simplifier`, `skill-creator`, `gsap-skills`, `impeccable`.

---

## 🗂 How files work

```
Your laptop                          Inside the sandbox
─────────────                        ──────────────────
~/roxit-workshop/         ←──→       /workspace/
  └─ my-project/                       └─ my-project/
```

Anything you create in `/workspace` (inside the sandbox) appears in `~/roxit-workshop/` (on your laptop). Files survive container restarts — **your work is never lost**.

You can open that folder in VS Code, Finder, or Explorer like any other folder.

---

## 🔐 For IT / security

The sandbox runs as a **non-root user** (`dev`) inside Docker. Network access is unrestricted by default so participants can fetch docs, deploy previews, and use AI features. Restrictions can be layered on top via `managed-settings.json` without rebuilding the image.

See [`starter/.claude/managed-settings.example.jsonc`](starter/.claude/managed-settings.example.jsonc) for a commented menu of everything you can lock down:

- Internal git / npm registry only
- Block `WebFetch` / `WebSearch`
- Disable deploy commands
- Pin model version
- Redirect telemetry to your OTLP collector

Telemetry is **on by default** (console exporter) so participants can see their own activity. Point `OTEL_EXPORTER_OTLP_ENDPOINT` at your collector to centralise logs.

---

## 🛠 Build (maintainers only)

This source repo is **private**. Participant launchers download release assets unauthenticated, so tarballs + the participant zip ship from the **public mirror**: [`likeahuman-ai/roxit-releases`](https://github.com/likeahuman-ai/roxit-releases).

```bash
# 1. Multi-arch build + push to GHCR
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/likeahuman-ai/roxit-masterclass:0.3 --push .

# 2. Local arm64 only (for testing on Apple Silicon)
docker buildx build --platform linux/arm64 -t roxit-masterclass:0.3 --load .

# 3. Save as gzipped tarballs
docker save roxit-masterclass:0.3-amd64 | gzip > roxit-masterclass-amd64.tar.gz
docker save roxit-masterclass:0.3-arm64 | gzip > roxit-masterclass-arm64.tar.gz

# 4. Build participant zip (just the launchers)
mkdir -p /tmp/roxit-masterclass
cp Roxit.command Roxit.bat Roxit.sh /tmp/roxit-masterclass/
chmod +x /tmp/roxit-masterclass/Roxit.{command,sh}
( cd /tmp && zip -r roxit-masterclass.zip roxit-masterclass/ )

# 5. Publish to the public mirror (creates v0.3 if it doesn't exist)
gh release create v0.3 \
  --repo likeahuman-ai/roxit-releases \
  --title "v0.3 — Roxit Masterclass Sandbox" \
  --notes-file release-notes.md \
  roxit-masterclass-amd64.tar.gz \
  roxit-masterclass-arm64.tar.gz \
  /tmp/roxit-masterclass.zip
```

To update an existing release, replace `gh release create` with `gh release upload v0.3 --clobber <files...>`.

Plugin cache snapshot (run before `docker build` to refresh):

```bash
./prepare-plugins.sh
```

This syncs the host's `~/.claude/plugins/cache/` into `plugins-snapshot/` for the Docker build context. Adjust versions in the script when bumping plugins.

---

<p align="center">
  Built by <a href="https://likeahuman.ai">Like a Human</a> · Amsterdam
</p>

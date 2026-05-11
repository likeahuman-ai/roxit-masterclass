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
  <sub>Prefer video? <a href="walkthrough/roxit-walkthrough.mp4">Download the MP4</a></sub>
</p>

---

## 🚀 Quickstart for participants

> **Two paths** — pick the one that fits. Both run the same sandbox.
>
> - **Path A · VS Code** — recommended for everyone. A real window with file tree, editor, and Claude Code in the side panel.
> - **Path B · Terminal launcher** — fallback for IT-restricted machines or terminal lovers.
>
> Either way: do the install steps **before the workshop starts**.

### Path A · VS Code (recommended)

#### Step 1 — Install three things (one-time, ~10 min)

| | What | Link |
|---|---|---|
| 1 | **Docker Desktop** | https://www.docker.com/products/docker-desktop/ |
| 2 | **VS Code** | https://code.visualstudio.com/ |
| 3 | **Dev Containers extension** | Open VS Code → Extensions panel → search "Dev Containers" → Install (Microsoft) |

After Docker installs, **open it once** and wait for "Engine running" (green dot, bottom-left). You can close the window after.

#### Step 2 — Download + unzip the workshop pack

Grab the latest: **[github.com/likeahuman-ai/roxit-releases/releases/latest](https://github.com/likeahuman-ai/roxit-releases/releases/latest)** → `roxit-masterclass.zip` (~2 MB).

Unzip somewhere memorable, e.g. `~/Desktop/roxit-masterclass`.

#### Step 3 — Open in VS Code

1. VS Code → **File → Open Folder…** → pick the unzipped `roxit-masterclass` folder.
2. A blue toast appears bottom-right: **"Reopen in Container"** → click it.  
   *Missed it?* `F1` → "Reopen in Container" → Enter.
3. First run: VS Code pulls the sandbox image (~420 MB) and starts the container.
4. When the green **ROXIT MASTERCLASS** banner shows up in the integrated terminal, you're in.
5. Type `claude` → approve in browser → paste code back. Ready.

Edit files in VS Code, run commands in the terminal panel — same files, both views live.

---

### Path B · Terminal launcher (fallback)

Use if VS Code isn't an option (corporate IT, preference, etc.). Same sandbox, raw shell.

#### Step 1 — Docker Desktop only

(Just the Docker step from Path A. Skip VS Code + extension.)

#### Step 2 — Download + unzip

Same `roxit-masterclass.zip` from the public mirror.

#### Step 3 — Double-click the launcher

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

First run: macOS prompts "unidentified developer" → right-click → **Open** → confirm. Windows prompts SmartScreen → **More info** → **Run anyway**.

The launcher checks Docker, pulls the image, drops you into the sandbox terminal. Type `claude` → approve → paste code back.

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

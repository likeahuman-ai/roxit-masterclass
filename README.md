<p align="center">
  <h1 align="center">Roxit Masterclass</h1>
  <p align="center"><strong>One-click Claude Code sandbox</strong> — AI Experience Week · May 18–22, 2026</p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Client-Visma_Roxit-0052CC?style=for-the-badge" alt="Visma Roxit">
  <img src="https://img.shields.io/badge/By-Like_a_Human-000?style=for-the-badge" alt="Like a Human">
  <img src="https://img.shields.io/badge/Status-v0.5-brightgreen?style=for-the-badge" alt="Status">
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

> **Do this once before the workshop starts.** ~15 minutes total, mostly waiting on downloads.

### Step 1 — Install Docker Desktop (one-time)

| Your OS | Link |
|---|---|
| 🍎 macOS | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| 🪟 Windows | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| 🐧 Linux | [docs.docker.com/desktop/install/linux](https://docs.docker.com/desktop/install/linux/) |

After installing, **open Docker Desktop once** and wait until it shows **"Engine running"** (green dot, bottom-left). You can close the window after that — Docker keeps running in the background.

> **Mac chip check:** click  → **About This Mac**. "Apple M…" = Apple Silicon. Pick the right installer.

> **Windows:** Docker Desktop requires WSL 2. If it's not installed, Docker shows a one-click installer link on first launch — follow it, restart, and open Docker Desktop again.

---

### Step 2 — Download the workshop pack

**[Download `roxit-masterclass.zip` →](https://github.com/likeahuman-ai/roxit-releases/releases/latest)**

Unzip it somewhere memorable — Desktop or Documents works fine.

---

### Step 3 — Start the sandbox

Open the unzipped folder and double-click your launcher:

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

**First-time OS warning — expected, safe to proceed:**
- **macOS** — Right-click `Roxit.command` → **Open** → confirm **Open**. macOS remembers — no warning next time.
- **Windows** — Click **More info** → **Run anyway**. Windows remembers — no warning next time.

**First run only:** the launcher downloads the sandbox image (~420 MB). This takes 2–5 minutes depending on your connection. After that it starts instantly every time.

A terminal window opens with the Roxit banner. You're inside the sandbox.

---

### Step 4 — Log in to Claude Code

Type this and press Enter:

```
claude
```

A browser tab opens automatically. **Approve access** with your Anthropic account → copy the code → **paste it back into the terminal**.

Try your first prompt:

```
What's in this workspace?
```

You're ready. ✨

---

### (Optional) View your files in VS Code

Your files live at `~/roxit-workshop` (macOS/Linux) or `C:\Users\<name>\roxit-workshop` (Windows). You can open that folder in VS Code, Finder, or Explorer like any normal folder to browse and read files. No extensions needed.

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

Something else on your machine is using port 3000 (commonly: another Node.js app, Grafana, or a previous Roxit container). The launcher picks the next free port automatically and shows the remapping in the terminal.

To clear leftover containers:
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

Talk to your IT contact and forward them the [For IT / security](#-for-it--security) section below. Docker Desktop is the only requirement — no admin install of Node/npm/git is needed.
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

---

## 🔐 For IT / security

Sandbox runs as a non-root `dev` user. Network egress is unrestricted by default; restrictions layer on via managed settings without an image rebuild.

→ Full details in [**SECURITY.md**](SECURITY.md) — share this with your IT contact.

---

## 🛠 Build (maintainers only)

Multi-arch buildx → tarball save → release on the public mirror.

→ Full build pipeline in [**DEPLOY.md**](DEPLOY.md).

---

<p align="center">
  Built by <a href="https://likeahuman.ai">Like a Human</a> · Amsterdam
</p>

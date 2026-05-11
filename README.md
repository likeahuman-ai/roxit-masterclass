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

> **Do this once before the workshop starts.** ~15 minutes total, mostly waiting on downloads.

### The recommended way · VS Code

A real IDE window with file tree, editor, and Claude Code in the integrated terminal. Same sandbox underneath, way friendlier on top.

```
┌──────────────────────────────────────────────────────────────────┐
│  VS Code · Roxit Masterclass [Dev Container]                     │
├──────────┬───────────────────────────────────────────────────────┤
│ EXPLORER │  CLAUDE.md                                            │
│ ▼ roxit  │                                                       │
│  .claude │  # Workshop project context                           │
│  docs    │  ...                                                  │
│  CLAUDE. │                                                       │
│  README. ├───────────────────────────────────────────────────────┤
│  index.  │  TERMINAL                                             │
│          │   ╭───────────────────────────────╮                   │
│          │   │  ROXIT MASTERCLASS            │                   │
│          │   │  Claude Code sandbox          │                   │
│          │   ╰───────────────────────────────╯                   │
│          │   dev@roxit:/workspace$ claude                        │
└──────────┴───────────────────────────────────────────────────────┘
```

#### Step 1 — Install three things (one-time)

| | What | Link |
|---|---|---|
| 1 | **Docker Desktop** | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| 2 | **VS Code** | [code.visualstudio.com](https://code.visualstudio.com/) |
| 3 | **Dev Containers extension** | In VS Code: **Extensions panel** (⌘⇧X / Ctrl+Shift+X) → search **"Dev Containers"** → **Install** (publisher: Microsoft) |

After Docker installs, **open it once** and wait for "Engine running" (green dot, bottom-left). You can close the window — Docker keeps running in the background.

> Mac chip check: click  → **About This Mac**. "Apple M…" = Apple Silicon. Pick the right Docker installer.

#### Step 2 — Download the workshop pack

**[Grab `roxit-masterclass.zip` →](https://github.com/likeahuman-ai/roxit-releases/releases/latest)** (~2 MB, contains the workshop starter + launchers)

Unzip somewhere memorable: `~/Desktop/roxit-masterclass` or `Documents\roxit-masterclass`.

#### Step 3 — Open the folder in VS Code

1. Launch VS Code → **File → Open Folder…** → pick the unzipped `roxit-masterclass` folder.
2. Wait for the blue toast at the bottom-right:

   > 📦 **Folder contains a Dev Container configuration file. Reopen folder to develop in a container.**
   >
   > **\[Reopen in Container\]**  Dismiss

   Click **Reopen in Container**.

   *Missed it?* Open the command palette (`F1` or `⌘⇧P` / `Ctrl+Shift+P`) → type **"Dev Containers: Reopen in Container"** → Enter.

3. **First run only:** VS Code pulls the sandbox image from GitHub (~420 MB). Take a coffee — you'll see "Starting Dev Container" in the status bar.

4. When ready: the integrated terminal opens with the Roxit banner. You're inside the sandbox.

#### Step 4 — Log in to Claude Code

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

<details>
<summary><b>🐚 Alternative path — raw terminal launcher (advanced / IT-restricted)</b></summary>

If VS Code is blocked by your IT, or you prefer a raw shell, the same sandbox boots from a double-clickable launcher.

**Skip step 1.2 and 1.3** above (no VS Code or extension needed). Just install Docker Desktop. Then:

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

First run shows OS security warnings:
- **macOS** → Right-click `Roxit.command` → **Open** → confirm **Open**
- **Windows** → Click **More info** → **Run anyway**

The launcher checks Docker, downloads the image, detects free ports (handles 3000-conflicts automatically), and drops you into the Roxit-branded sandbox terminal. Type `claude` once you see the banner.

</details>

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

In VS Code: ports tab at the bottom shows the active forwards — right-click and "Stop Forwarding Port" if you want to free it. The launcher path handles this automatically: it picks the next free port (3001, 3002…) and shows the remapping.

To clear leftover containers:
```bash
docker ps             # list running containers
docker stop <name>    # stop the one on port 3000
```
</details>

<details>
<summary><b>VS Code: no "Reopen in Container" prompt appears</b></summary>

The **Dev Containers** extension isn't installed. Open the Extensions panel (⌘⇧X / Ctrl+Shift+X) → search **"Dev Containers"** → install the one published by **Microsoft** (the official one — has a blue verified checkmark).

Then either reload VS Code (⌘⇧P → "Reload Window") or re-open the folder.
</details>

<details>
<summary><b>VS Code: "Dev container failed to start"</b></summary>

Usually one of:
1. **Docker isn't running** — open Docker Desktop, wait for "Engine running".
2. **Image pull failed** — first-run pulls ~420 MB from `ghcr.io`. Corporate firewalls sometimes block it. Try a personal hotspot.
3. **Stale container** — open command palette → "Dev Containers: Rebuild Container" to start fresh.
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

Sandbox runs as a non-root `dev` user. Network egress is unrestricted by default; restrictions layer on via managed settings without an image rebuild.

→ Full details in [**SECURITY.md**](SECURITY.md) — share this with your IT contact.

---

## 🛠 Build (maintainers only)

Multi-arch buildx → GHCR push → tarball save → release on the public mirror.

→ Full build pipeline in [**DEPLOY.md**](DEPLOY.md).

---

<p align="center">
  Built by <a href="https://likeahuman.ai">Like a Human</a> · Amsterdam
</p>

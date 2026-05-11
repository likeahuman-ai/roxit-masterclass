# Roxit Masterclass · Welcome

You've unzipped your workshop pack. **Pick the path that fits you.**

---

## Path A · VS Code (recommended for everyone)

A real window with file tree, editor, and Claude Code in the side panel. ~5 minutes setup the first time, instant after.

### One-time install (do this before the workshop)

1. **Docker Desktop** → https://www.docker.com/products/docker-desktop/  
   Open it once, wait for "Engine running" (green dot bottom-left). Then close the window.

2. **VS Code** → https://code.visualstudio.com/  
   Standard installer for your OS.

3. **Dev Containers extension** → Open VS Code → Extensions panel (⌘⇧X / Ctrl+Shift+X) → search **"Dev Containers"** → Install (publisher: Microsoft).

### Open the workshop

1. In VS Code: **File → Open Folder…** → pick this `roxit-masterclass` folder.
2. A blue toast appears bottom-right: **"Reopen in Container"** → click it.  
   *Missed it?* Press `F1` → type **"Reopen in Container"** → Enter.
3. First time: VS Code pulls the sandbox image (~420 MB) and starts the container. Take a coffee.
4. When the terminal panel opens with the **ROXIT MASTERCLASS** banner, you're in.
5. Type `claude` in the terminal → approve in browser → paste the code back. Done.

Your files in this folder are mirrored inside the container at `/workspace`. Edit in VS Code, run in the terminal — same files, both visible.

---

## Path B · Terminal launcher (fallback)

Use this if VS Code is blocked by your IT, or you prefer raw terminal.

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

First-run security warnings:
- **macOS** → Right-click `Roxit.command` → **Open** → confirm **Open**
- **Windows** → Click **More info** → **Run anyway**

The launcher boots the same sandbox in your terminal. Type `claude` once you see the banner.

---

## What's in this folder?

```
.devcontainer/    Docker config — VS Code reads this
.claude/          Pre-installed agents, skills, plugins, settings
docs/             Workshop documentation
CLAUDE.md         Project context for Claude Code
index.html       Visual overview of agents/skills/plugins
Roxit.command/.bat/.sh   Terminal launchers (Path B)
```

---

## Help

Ask the workshop facilitator.

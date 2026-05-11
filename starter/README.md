# Roxit Masterclass · Welcome

You've unzipped the workshop pack. **Now open this folder in VS Code.**

---

## The path · VS Code (recommended)

A real IDE window — file tree, editor, Claude Code in the integrated terminal.

```
┌──────────────────────────────────────────────────────────────────┐
│  VS Code · Roxit Masterclass [Dev Container]                     │
├──────────┬───────────────────────────────────────────────────────┤
│ EXPLORER │  CLAUDE.md ← your workshop context                    │
│ ▼ roxit  │                                                       │
│  .claude │  Edit files here.                                     │
│  docs    ├───────────────────────────────────────────────────────┤
│  ...     │  TERMINAL                                             │
│          │   dev@roxit:/workspace$ claude                        │
│          │   Run Claude Code here.                               │
└──────────┴───────────────────────────────────────────────────────┘
```

### Before the workshop, install three things

1. **Docker Desktop** → https://www.docker.com/products/docker-desktop/  
   Open it once → wait for "Engine running" (green dot bottom-left) → close the window.

2. **VS Code** → https://code.visualstudio.com/

3. **Dev Containers extension** → in VS Code: Extensions panel (`⌘⇧X` / `Ctrl+Shift+X`) → search **"Dev Containers"** → **Install** (publisher: Microsoft).

### To start the workshop

1. **File → Open Folder…** → pick this folder (the one with `CLAUDE.md`).
2. Blue toast bottom-right: **"Reopen in Container"** → click.  
   *Missed it?* `F1` → **"Dev Containers: Reopen in Container"** → Enter.
3. **First run only:** VS Code pulls the sandbox image (~420 MB).
4. Terminal panel opens with the Roxit banner. Type:

   ```
   claude
   ```

   Approve in the browser tab → paste the code back → start building.

---

## Alternative · raw terminal (if VS Code is blocked)

Use this only if your IT blocks VS Code or Dev Containers.

| Your OS | Double-click |
|---|---|
| 🍎 macOS | `Roxit.command` |
| 🪟 Windows | `Roxit.bat` |
| 🐧 Linux | `Roxit.sh` |

First-run security warnings:
- **macOS** → Right-click `Roxit.command` → **Open** → confirm
- **Windows** → Click **More info** → **Run anyway**

Same sandbox, same `claude` command, no IDE.

---

## What's in this folder?

```
.devcontainer/    Tells VS Code to run this folder in a container
.claude/          Pre-installed agents, skills, plugins, settings
docs/             Workshop documentation
CLAUDE.md         Project context Claude Code reads on every prompt
index.html       Visual overview of agents, skills, plugins
Roxit.command/.bat/.sh   Terminal launchers (alternative path)
```

---

## Help

Ask the workshop facilitator.

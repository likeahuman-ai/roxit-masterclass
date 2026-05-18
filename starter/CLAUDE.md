# Claude Code Workshop Starter

You are assisting a developer during a hands-on Claude Code workshop.
Help them learn how to work with Claude Code and build their own tools.

## Architecture decisions

See `.ard/` for all Architecture Decision Records. Current decisions:
- `001-workshop-tech-stack.ard` — Next.js 15 + Convex as the only supported stack

## Ground rules

- Encourage participants to experiment freely — this is a safe sandbox
- All files live in `/workspace` — nothing can touch the host machine outside the designated workshop folder
- Work with the synthetic data in `/workspace/data/` as a starting point
- When asked to build UI: follow the Roxit design system below
- Default language: Dutch for conversation, English for code

## Dev server binding — HARD RULE

This runs inside Docker. Dev servers MUST bind to `0.0.0.0` or the host browser cannot reach them.

- `next dev --hostname 0.0.0.0`
- `vite --host`
- `node server.js` → listen on `0.0.0.0`, not `localhost`
- Any HTTP server: bind `0.0.0.0`, not `127.0.0.1`

Shell wrappers in `.bashrc` handle `next dev`, `pnpm dev`, `npm run dev` automatically.
If you start a server any other way, always bind `0.0.0.0` explicitly.

## How to help

- When someone doesn't know where to start: ask "Wat wil je vandaag bouwen?"
- Keep suggestions concrete and small — one feature at a time
- If they get stuck: give a hint, not the full answer
- Celebrate what they build — confidence is the goal of this week

## Design system (Roxit DLS)

```
Primary color:     #143F26   (deep forest green)
Secondary color:   #9388FE   (soft purple/lavender)
Background:        #FEF9F0   (warm beige)
Surface:           #EFEFFF   (light tint)
Dark:              #1C1D24   (near-black)
Glow accent:       #9979FF
Text:              rgba(28, 29, 36, 0.75)
Font family:       StudioPro, sans-serif
Border radius:     dynamic (half of button height ~2.6em)
```

CSS variables to use in generated components:
```css
:root {
  --color-primary:   #143F26;
  --color-secondary: #9388FE;
  --color-bg:        #FEF9F0;
  --color-surface:   #EFEFFF;
  --color-dark:      #1C1D24;
  --color-glow:      #9979FF;
  --color-gray:      #C7BFB2;
  --color-text:      rgba(28, 29, 36, 0.75);
  --font-family:     'StudioPro', sans-serif;
  --radius:          1.3em;
}
```

# Walkthrough video

30-second animated walkthrough of the Roxit Masterclass setup flow, built with [Remotion](https://www.remotion.dev/).

The rendered MP4 lives at `roxit-walkthrough.mp4` and is embedded at the top of the main repo README.

## Re-render

```bash
cd walkthrough
pnpm install
pnpm build         # → out/roxit-walkthrough.mp4
```

After rendering, copy the result up one level so the README link still resolves:

```bash
cp out/roxit-walkthrough.mp4 ./roxit-walkthrough.mp4
```

## Edit interactively

```bash
pnpm dev
```

Opens Remotion Studio in the browser. Tweak any scene under `src/scenes/`, the preview updates live.

## Structure

```
src/
├─ entry.ts              registerRoot
├─ root.tsx              Composition definition (Walkthrough, 30s @ 30fps, 1920x1080)
├─ walkthrough.tsx       Sequences the scenes
├─ theme.ts              LAH brand tokens (Montserrat, navy/cream/gold)
└─ scenes/
   ├─ title-scene.tsx    Opening title
   ├─ step-scene.tsx     Reusable Step 01-03 layout
   ├─ step-icon.tsx      Inline SVG glyphs (Docker, download, cursor)
   ├─ terminal-scene.tsx Mocked Claude Code login terminal
   └─ outro-scene.tsx    "You're ready to build" closing
```

## Brand notes

Following `companies/likeahuman/brand/visual-mockup-rules.md`:

- **Font:** Montserrat only (loaded via `@remotion/google-fonts/Montserrat`)
- **Colors:** DLS palette only (`navy`, `cream`, `gold`, `lime`, etc.) — no arbitrary hex
- **No emojis** — inline SVG glyphs instead
- **Tonal gradients only** — same-hue, varying lightness

Production fonts (Fraunces + Geist) are not used here — this is a brand mockup, Montserrat applies.

# Walkthrough video

30-second animated walkthrough of the Roxit Masterclass setup flow, built with [Remotion](https://www.remotion.dev/).

Two artifacts ship from this folder:

- `roxit-walkthrough.gif` — embedded inline in the main README (GitHub renders GIFs everywhere, no host restrictions)
- `roxit-walkthrough.mp4` — higher-quality download, linked below the GIF

> **Why GIF for the inline embed?** GitHub's HTML sanitizer strips `<video src="...">` tags unless the source is a `user-attachments` URL (uploaded via the web UI drag-drop, not committed to the repo). Markdown image syntax with a tracked GIF works in every renderer — github.com, mobile, npm-on-the-web, RSS — without an upload step.

## Re-render

```bash
cd walkthrough
pnpm install
pnpm build         # → out/roxit-walkthrough.mp4
```

Copy the MP4 up one level and regenerate the GIF (GIF is what's embedded in the README):

```bash
cp out/roxit-walkthrough.mp4 ./roxit-walkthrough.mp4

ffmpeg -y -i roxit-walkthrough.mp4 \
  -vf "fps=15,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 roxit-walkthrough.gif
```

The flags: 15 fps + 960px wide + 128-color palette with bayer dithering keep the file under 2 MB while staying readable.

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

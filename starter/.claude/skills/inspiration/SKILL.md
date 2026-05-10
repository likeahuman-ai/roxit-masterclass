---
name: inspiration
description: Pull real visual references from cosmos.so (curated by designers, photographers, art directors) for any creative task — inspiration on demand. Returns a masonry HTML gallery + a structured JSON summary Claude can cite. Use proactively whenever visual inspiration would help — fonts, typography, editorial layouts, landing pages, photography, cinematography, motion design, branding, color palettes, posters, packaging, UI/UX moodboards, wireframes, scroll experiences, 3D, shaders. Also invoke when other skills (font-hunt, brand-pitch, ai-product-shoot, frontend-design, scroll-storytelling-patterns, impeccable:*) need real-world references before generating, designing, or recommending.
when_to_use: When the user types `/inspiration <query>`, says "find references", "inspiration for X", "moodboard", "what does X look like", "reference images", "show me examples of", "cosmos", "look up visuals". Also proactively before any visual/creative output — pull refs first, then design.
argument-hint: "<search query — e.g. 'experimental editorial typography', 'liquid glass UI', 'scandinavian product photography'>"
user-invocable: true
---

# /inspiration — Visual inspiration on demand

Pulls curated visual references from cosmos.so (designer/photographer/art-director community boards) and shows them as a masonry gallery in the browser. Also writes a structured JSON summary so you (Claude) can cite specific references in the conversation that follows.

## When to invoke

**User-driven:**
- `/inspiration <query>` — explicit invocation
- "find inspiration for X", "moodboard for X", "show me references for X"

**Proactive (no need to ask):**
- Before designing a landing page, hero, type system, color palette → pull refs first
- When another skill is about to generate visuals (font-hunt, brand-pitch, ai-product-shoot, ai-editorial, frontend-design, impeccable:*) and lacks visual grounding → run cosmos first and feed results in
- When discussing "what would this look like" or comparing creative directions

**Skip when:**
- Pure code/backend/config tasks
- The user has already provided enough references
- Speed matters more than visual grounding (quick prototypes, debugging)

## How to use

Run the helper script. It writes to `/tmp/inspiration-inspo/<timestamp>-<slug>/` and opens the gallery in the browser:

```bash
~/.claude/skills/inspiration/search.sh "<query>" [count]
```

- `<query>` — free-text search. Be specific. "Editorial typography" beats "fonts". "Liquid glass UI 2025" beats "UI inspiration".
- `[count]` — 1..80, default 24. Use 8–12 for a quick look, 24+ for a real moodboard.

The script:
1. POSTs the `searchElements` GraphQL query to `https://api.cosmos.so/graphql`
2. Saves raw response to `results.json` and a compact summary to `summary.json`
3. Builds `index.html` — see gallery design requirements below
4. Opens the HTML in the default browser
5. Prints a top-8 list to stdout (caption, share URL, image URL) — quote these in your reply

## Gallery design requirements

The `index.html` gallery must follow `/high-end-visual-design` and `/frontend-design` principles. Never generate a generic dark grid:

- **Typography:** distinctive Google Font pairing (display + mono) — never Inter, Roboto, Arial
- **Background:** radial-gradient mesh or subtle noise texture — never flat `#111` or `#fff`
- **Card depth:** layered surfaces with low-opacity borders (`rgba(255,255,255,0.06)`), soft glow on hover
- **Layout:** asymmetric masonry with varied column spans — not a uniform rigid grid
- **Color palette:** defined as CSS custom properties, minimum `--bg`, `--surface`, `--border`, `--text`, `--accent`
- **Animation:** staggered fade-in on load, smooth hover scale + shadow transition
- **Image captions:** author, source tag, hover-reveal overlay — not always-visible clutter
- **Header:** large display type, query as headline, result count as subtext
- The gallery should feel like a curated design publication, not a developer tool screenshot

## After running

- **Cite specifics.** Don't just say "found 24 refs." Pick 2–4 standouts from the printed top list, name them by caption/author, and explain *why* they fit the brief.
- **Feed downstream skills.** If a follow-up skill (font-hunt, brand-pitch, frontend-design, impeccable:typeset, etc.) is coming, pass it the share URLs and image URLs from `summary.json` so it has visual grounding instead of pulling from training data.
- **Suggest a refinement.** If results miss the mark, propose a sharper query (more specific era, technique, mood) and offer to re-run.

## Query phrasing tips

Cosmos.so indexes captions like "Swiss Style poster by Armin Hofmann, 1959" — so concrete nouns + named techniques + decade/era beat generic adjectives.

| Weak | Strong |
|------|--------|
| modern fonts | brutalist variable type 2024 |
| nice photography | overcast scandinavian product photography |
| cool animation | scroll-driven WebGL distortion |
| moody UI | dark editorial fashion magazine layout |
| branding | risograph identity system small studio |

## Output structure (for downstream skills)

`summary.json`:
```json
{
  "query": "...",
  "out_dir": "/tmp/inspiration-inspo/...",
  "total": 500,
  "next_cursor": "cursor://...",
  "items": [
    {
      "id": 1742531513,
      "type": "MediaElementTile",
      "caption": "...",
      "image": "https://cdn.cosmos.so/...",
      "video": null,
      "width": 1000,
      "height": 1428,
      "share_url": "https://www.cosmos.so/e/...",
      "cluster_id": 1771806105,
      "source_url": "https://...",
      "source_author": "username"
    }
  ]
}
```

Other skills can read this directly: `jq '.items[].image' /tmp/inspiration-inspo/<dir>/summary.json`.

## Not yet supported (future MCP work)

- Search by curated cluster (boards) by slug — cosmos requires auth for `clusters` filter on free text. Fetch by `categoryId` works unauthenticated but requires a category ID lookup.
- Pagination beyond first page (cursor exists in `summary.json` but skill doesn't expose it yet).
- Filtering by content type (video-only, product-only, website-only).
- Saving favorites locally per project.

These are the natural targets for the MCP version.

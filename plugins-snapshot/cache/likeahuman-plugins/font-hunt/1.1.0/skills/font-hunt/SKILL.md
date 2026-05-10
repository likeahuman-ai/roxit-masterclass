---
name: font-hunt
description: Research and propose genuinely unique fonts for a brand or project — free-first, with paid indie options labelled. Refuses to return Inter/Montserrat/Poppins/Roboto/Playfair/DM Sans/Satoshi/Clash Display defaults. Dispatches 5 parallel research agents against real foundries (Fontshare, Velvetyne, Pangram Pangram, Klim, Grilli, OH no Type, 1001fonts, DaFont, Google Fonts gems, Adobe Fonts) and produces BOTH a visually stunning HTML specimen board AND a structured YAML brief that downstream agents/skills can consume. Make sure to invoke this whenever font selection is in play — never fall back to training-data defaults.
when_to_use: When the user asks for "fonts", "typography", "typefaces", "font pairing", "what font should I use", "pick fonts for", "font recommendations", "replace Montserrat/Inter/etc", "unique/creative/non-default fonts". Also when implementing a design handoff from Claude Design (claude.ai/design) and the design's fonts need locking, when building a landing page or brand identity, or when any other skill is about to pick fonts. Invoke proactively before any visual component work if fonts aren't already decided.
argument-hint: "[brief in quotes] OR empty for micro-interview"
user-invocable: true
---

Hunt for genuinely unique fonts. This skill refuses to return generic AI-default fonts. It dispatches 5 parallel font-researcher subagents against real indie foundries, synthesises their findings, and outputs both a premium HTML specimen board and a structured YAML brief.

## Invocation patterns

```
/font-hunt                                        → 3-question micro-interview, then run
/font-hunt "editorial wellness brand, warm"       → one-shot with brief
/font-hunt --copy "Your real headline"            → override specimen copy
/font-hunt --free-only                            → skip font-researcher-paid-indie
/font-hunt --exclude fontshare,google             → skip specific sources
/font-hunt --out ./custom/path/fonts.html         → override output path
```

## Step 1 — Capture the brief

**If arguments include a brief string:** skip interview, parse args for flags (`--copy`, `--free-only`, `--exclude`, `--out`).

**If arguments are empty OR only flags are provided:** run this micro-interview, one question at a time:

1. *Free only, paid indie welcome, or hybrid?* — determines which agent tiers run. `free` → skip `font-researcher-paid-indie`. `paid` → emphasise paid-indie + experimental, deprioritise Google Fonts. `hybrid` → all 5 agents (default).
2. *What's the project / brand in 3–5 adjectives?* (e.g. "warm, editorial, wellness, slow, confident")
3. *What fonts are you sick of seeing in this space?* (their answers get added to the blocklist for this run only)
4. *Any competitor or reference URL you want to steer away from?* (optional; if provided, skill notes "avoid the direction of {url}" in the dispatch prompts)

**Even when a brief IS provided as args**, if the user hasn't specified `--free-only` / `--paid-only` / `--hybrid`, ask this single gating question before dispatching: *"Free only, paid indie welcome, or hybrid?"* — takes 2 seconds and prevents wasted research on the wrong tier.

**If the current conversation already has clear brand/project context** (brief already stated, references mentioned): infer the brief and ask "dispatching with brief: *{inferred}* — proceed? [Y/n]" before running.

Once captured, extract 3–5 `MOOD_KEYWORDS` from the brief. These drive source routing (see Step 3).

## Step 2 — Load references + cache

Read these files:
- `references/anti-slop-blocklist.md` — static blocklist
- `references/source-map.md` — mood-to-source routing
- `~/.claude/cache/font-hunt-recent.json` — last 20 recommendations (recent-picks blocklist)

Combine the static blocklist + recent-picks cache entries + any user-supplied "sick of" fonts into a single `BLOCKLIST` list that gets passed to every agent.

## Step 3 — Route to agents

From the source map, find the mood keywords that match the brief. Primary agents for those moods always run. If `--free-only` is set, skip `font-researcher-paid-indie`. If `--exclude` is set, drop any agent whose pool consists entirely of excluded sources.

For each agent that runs, pick a **rotating subset of 2–3 sources** from its pool. Rotation uses the recent-picks cache: prefer sources NOT represented in recent picks.

## Step 4 — Dispatch in parallel

Use the `Agent` tool with **all selected agents in a single message** (parallel execution — this is a hard requirement; serial dispatch wastes time and the parallel mandate is explicit in Jasper's global CLAUDE.md).

For each agent, construct a prompt block that contains:

```
BRIEF: {user brief}
MOOD_KEYWORDS: {3-5 extracted keywords}
SOURCES_THIS_RUN: {rotating subset for this agent}
ANTI_SLOP_BLOCKLIST: {static blocklist}
RECENT_PICKS_BLOCKLIST: {last 20 from cache + user's "sick of" list}
SPECIMEN_COPY:
  display: {5 display-size headlines matching brief voice}
  heading: {5 heading-size phrases}
  body: {3 body-copy paragraphs, 2–3 sentences each}

Return YAML matching the output schema defined in your agent file.
```

**Generating SPECIMEN_COPY:** before dispatching, draft 5+ display headlines, 5+ heading phrases, and 3+ body paragraphs that match the brief's voice. Example for "editorial wellness, warm":
- display: "Slowness is a discipline.", "A quiet revolution.", "Rest, rebellion.", "The body remembers.", "Soft power."
- heading: "On becoming less productive", "A field guide to rest", ...
- body: "We believe rest is political. For a decade we've been told that busy is a virtue, but the body keeps a different ledger..."

This copy gets rendered on every specimen so the reader sees the *font* working with the *brief*, not a generic pangram.

## Step 5 — Synthesise

Collect YAML responses from all agents. Parse each. Then:

1. **Flatten** all candidates into a single list.
2. **Dedupe** by exact `name` field (case-insensitive).
3. **Drop** any candidate matching `BLOCKLIST` (defensive — agents should have already filtered).
4. **Rank** candidates by fit with the brief. Ranking heuristics:
   - Strong `why` that connects to brief mood keywords > generic `why`
   - Complete schema (all fields filled) > partial
   - Free license slightly preferred over paid (free-first rule) — but only as a tiebreaker
5. **Build 3 pairings** (heading + body). Pairings should:
   - Use fonts with complementary characters (serif heading + humanist sans body, grotesque heading + editorial serif body, display heading + technical mono body, etc.)
   - Mix tiers where possible — e.g. Pairing 1 could be paid+free, Pairing 2 free+free, Pairing 3 free+google-gem
   - Prefer pairings where both fonts are within each other's `pairs_well_with` archetypes
6. **Pick 2 wildcard heroes** — standalone single fonts too distinctive to pair (display-feral picks, experimental picks, paid-indie statement fonts). These render in the HTML as full-bleed specimens.
7. **Diversity guard** — if the final 5 all come from ≤2 sources, force-swap one pick for a lower-ranked candidate from a different source. Report the swap in chat ("Diversity guard: swapped X for Y to include Velvetyne.").

## Step 6 — Write artefacts

### Artefact A — HTML specimen board

1. Determine output path: `--out` flag if provided, else `~/.claude/font-hunt-results/font-hunt-{slug}.html` (create dir if missing). `{slug}` is the brief slugified and truncated to 60 chars. **Never write to the current working directory** — this skill is global and must not pollute project repos.
2. Build the `candidates.json` object matching the schema in `scripts/build-preview.mjs`. Include:
   - `brief`, `date`, `agents_ran`, `sources_rotated`, `blocklist_summary` (first 6 blocklist items joined by comma)
   - `copy` (generated in Step 4)
   - `pairings` (3 pairing objects)
   - `wildcards` (2 candidate objects)
3. Write `candidates.json` to a temp path, then run:
   ```bash
   node ~/.claude/skills/font-hunt/scripts/build-preview.mjs <tempfile> <outputpath>
   ```
4. Clean up the temp file.

### Artefact B — Structured chat output

Print the following to chat (markdown):

```markdown
## Font Hunt — "{brief}"

**Mood board:** `{outputpath}`
**Agents that ran:** {list}
**Sources this run:** {rotated list}

### Pairings

| # | Heading | Body | Tier | Why |
|---|---------|------|------|-----|
| 1 | {name · foundry} | {name · foundry} | {tier · tier} | {1-line rationale} |
| 2 | ... |
| 3 | ... |

### Wildcard heroes
- **{name}** · {foundry} · {tier} · "{why}"
- **{name}** · {foundry} · {tier} · "{why}"

### For downstream agents
\`\`\`yaml
brief: "..."
timestamp: "..."
pairings: [ ... full schema ... ]
wildcards: [ ... ]
blocklist_applied: [...]
sources_this_run: [...]
\`\`\`
```

Suggest the user open the HTML: `open {outputpath}`.

## Step 7 — Update recent-picks cache

Append the 8 final font names (3 pairings × 2 + 2 wildcards) to `~/.claude/cache/font-hunt-recent.json`:

```json
{
  "version": 1,
  "max_size": 20,
  "entries": [
    { "name": "Fraunces", "added_at": "2026-04-20T14:23:00Z" },
    ...
  ]
}
```

Truncate the `entries` array to the 20 most recent (FIFO). Save atomically (write to temp file, rename).

## Anti-slop guarantees

- **Static blocklist** enforced by every agent AND by the synthesiser (defence in depth).
- **Recent-picks rotation** ensures two back-to-back runs with the same brief produce different fonts.
- **Source rotation per agent** ensures different foundries get hit on repeat runs.
- **Diversity guard** in synthesis prevents all-Google-Fonts or all-Fontshare outputs.
- **Agent voice specialisation** ensures different hunters propose genuinely different fonts.

## Error handling

- **If an agent returns invalid YAML:** log the parse error, skip that agent's output, proceed with remaining agents. Don't fail the whole run.
- **If fewer than 5 total candidates return across all agents:** run fewer pairings (2 instead of 3, 1 wildcard instead of 2). Tell the user why in the chat output.
- **If WebFetch fails for a source:** agent reports `candidates: []` with the fetch error as `reason`. Skill notes this in the chat output.
- **If the cache file is corrupted:** re-init as empty, don't crash.

## Non-goals reminder

- This skill does not HOST fonts. It recommends.
- This skill does not WRITE CSS into the user's project. It outputs snippets the user copies.
- This skill does not REPLACE `typeset` (which fixes typography in code) or `typography-creative-director` (which directs type systems). It feeds them.

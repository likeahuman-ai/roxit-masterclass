# Claude Code Workshop

## Starten

```bash
claude
```

Volg de login-instructies (eenmalig). Daarna ben je klaar om te bouwen.

## Wat staat er klaar?

```
.claude/agents/     @product-owner, @backend-engineer, @frontend-engineer
.claude/skills/     /office-hours, /investigate, /review, /qa en meer
CLAUDE.md           Workshop context + Roxit design system
index.html          Overzicht van alle agents, skills en plugins
```

## Nieuw project aanmaken

```bash
npx create-next-app@latest mijn-app --typescript --tailwind --app --no-git
cd mijn-app && pnpm add convex && npx convex dev
```

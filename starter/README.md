# Claude Code Workshop

## Starten

```bash
claude
```

Volg de login-instructies (eenmalig). Daarna ben je klaar om te bouwen.

## Lokaal model gebruiken (gratis)

Wil je geen API credits verbruiken? Gebruik **Docker Model Runner** — ingebouwd in Docker Desktop.

**Eénmalig op je laptop:**
```bash
docker model pull ai/qwen3-coder
```

**Dan in de container:**
```bash
claude --model qwen3-coder "Analyze this codebase"
```

De container is al geconfigureerd om Docker Model Runner op je laptop te bereiken via `host.docker.internal:12434`. Handig voor verkenning en grote codebase analyses — bewaar je Anthropic credits voor de echte bouwsessies.

> **Linux gebruikers:** voeg `--add-host=host.docker.internal:host-gateway` toe aan je `docker run` commando.

## Wat staat er klaar?

```
.claude/agents/     @product-owner, @backend-engineer, @frontend-engineer,
                    @convex-expert, @saas-stack-architect,
                    @react-component-architect, @form-validation-architect
.claude/skills/     /office-hours, /investigate, /review, /qa en meer
CLAUDE.md           Workshop context + Roxit design system
index.html          Overzicht van alle agents, skills en plugins
```

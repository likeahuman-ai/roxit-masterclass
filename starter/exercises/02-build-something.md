# Oefening 2 — Bouw iets echts

**Doel:** een werkende tool bouwen met Claude Code als co-pilot
**Tijd:** ~45 minuten
**Stack:** Next.js + TypeScript (alles al geïnstalleerd)

---

## De opdracht

Bouw iets wat je zelf zou willen gebruiken. Dat kan van alles zijn:
een dashboard, een interne tool, een kleine automatisering, een generator.

Weet je nog niet wat? Begin hier:

```
claude "Ik werk bij Roxit en wil vandaag iets nuttigs bouwen met Claude Code.
Stel me 3 vragen om te bepalen wat ik ga maken."
```

---

## Stap 1 — Nieuw project aanmaken

```bash
cd /workspace
npx create-next-app@latest mijn-tool --typescript --tailwind --app --no-git
cd mijn-tool
```

---

## Stap 2 — CLAUDE.md schrijven voor je project

```bash
claude
```

```
Maak een CLAUDE.md voor dit project. We bouwen [beschrijving].
De gebruiker is [wie]. De kern is [wat het doet].
```

Een goede CLAUDE.md bespaart je elk gesprek uitleg.

---

## Stap 3 — Iteratief bouwen

Eén prompt per feature. Na elke stap: `pnpm dev` en kijk in de browser.

Vastgelopen? Vraag `@workshop-guide` voor een hint.

---

## Stap 4 — Iets herhaalbaars? Maak een skill

Zie `.claude/skills/build-a-skill.md`.

---

## Klaar?

Ga door naar **oefening 3** of bouw gewoon door op je eigen idee.

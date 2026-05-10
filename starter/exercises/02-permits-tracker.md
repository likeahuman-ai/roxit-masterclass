# Oefening 2 — Vergunningen tracker bouwen

**Doel:** een echte mini-applicatie bouwen met Claude Code als co-pilot
**Tijd:** ~45 minuten
**Stack:** Next.js + TypeScript (alles al geïnstalleerd)

---

## Opdracht

Bouw een vergunningen-tracker voor een behandelaar. Ze wil in één oogopslag zien:
- Welke zaken op haar staan
- Welke aanvullingstermijnen bijna verlopen
- Wat de status is van elk dossier

---

## Stap 1 — Nieuw project aanmaken

```bash
cd /workspace
npx create-next-app@latest permits-tracker --typescript --tailwind --app --no-git
cd permits-tracker
```

---

## Stap 2 — Data beschikbaar maken

Kopieer de testdata naar je project:

```bash
cp /workspace/data/vergunningen.json public/vergunningen.json
```

---

## Stap 3 — Laat Claude bouwen

Start Claude Code in je project:

```bash
claude
```

Geef dit als eerste prompt:

```
Ik bouw een vergunningen-tracker voor een gemeentelijk behandelaar.
De data staat in /public/vergunningen.json.

Bouw een homepage die:
1. Alle vergunningen toont in een tabel met kolommen: zaaknummer, type, status, behandelaar, ingediend_op
2. Statussen kleurcodet: ingediend=grijs, in_behandeling=blauw, aanvulling_gevraagd=oranje, besloten_verleend=groen, besloten_geweigerd=rood, bezwaar=paars
3. Bovenaan een teller toont: hoeveel zaken per status

Gebruik de kleuren en typografie uit de CLAUDE.md in de workspace root.
```

---

## Stap 4 — Draaien

```bash
pnpm dev
```

Open `http://localhost:3000`.

---

## Stap 5 — Itereren

Kies één uitbreiding en vraag Claude om het toe te voegen:

**Optie A:** Filterbalk op behandelaar of status
**Optie B:** Detailpagina per zaak met alle documenten
**Optie C:** Waarschuwingsbadge als aanvulling-deadline < 7 dagen weg is

---

## Stap 6 — Maak er een skill van

Iets wat je steeds herhaalt? Zie `.claude/skills/build-a-skill.md` voor hoe je dat vastlegt.

---

## Klaar?

Ga door naar **oefening 3 (hackathon)** of vraag `@roxit-domain-expert` hoe je dit zou uitbreiden voor een echte gemeente.

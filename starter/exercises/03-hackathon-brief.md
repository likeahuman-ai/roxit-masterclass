# Oefening 3 — Hackathon

**Teams:** 4-5 personen
**Tijd:** 2 dagen
**Pitch:** 3 minuten op woensdag middag

---

## De opdracht

Bouw een tool die écht waarde heeft voor Roxit of je eigen werk.
Geen voorgeschreven scope — jullie bepalen wat je maakt.

---

## Aan de slag

**Stap 1 — Kies wat je bouwt:**
```
claude "Wij zijn een team van [rollen] bij Roxit.
Geef ons 5 concrete tool-ideeën die we in 2 dagen kunnen bouwen met Claude Code."
```

**Stap 2 — Scope het af:**
```
claude "We willen [idee] bouwen. Wat is de kleinste versie
die al nuttig is en we vandaag kunnen afronden?"
```

**Stap 3 — CLAUDE.md voor je project:**
```
claude "Maak een CLAUDE.md voor ons project. We bouwen [beschrijving].
Gebruiker is [wie]. Kernfunctie is [wat]."
```

**Stap 4 — Bouw iteratief:**
Één prompt = één feature. Test na elke stap in de browser.

**Stap 5 — Skills vastleggen:**
Alles wat jullie herhalen → skill. Zie `.claude/skills/build-a-skill.md`.

---

## Testdata

In `/workspace/data/` staat gesimuleerde data als je ergens mee wilt starten:
- `vergunningen.json` — permit cases
- `aanbestedingen.json` — procurement tenders

Of genereer je eigen testdata:
```
claude "Genereer 20 realistische testrecords voor [jouw use case] als JSON"
```

---

## Pitch (3 minuten)

- Wat is het probleem?
- Wie is de gebruiker?
- Wat heb je gebouwd? (demo)
- Wat zou de volgende stap zijn?

---

## Tips

- Liever minder maar werkend dan veel maar kapot
- Vastgelopen? `@workshop-guide`
- Agents en skills die je bouwt zijn herbruikbaar na de week

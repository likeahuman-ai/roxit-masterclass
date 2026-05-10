# Oefening 3 — Hackathon brief

**Doel:** je team kiest een use case en bouwt een werkende demo in 2 dagen
**Teams:** 4-5 personen
**Pitch:** 3 minuten op woensdag middag

---

## De vijf use cases

Kies één. Elke use case heeft testdata klaarstaan in `/workspace/data/`.

---

### Use case A — Vergunningen dashboard
**Voor:** behandelaars en teamleiders
**Wat:** real-time overzicht van alle openstaande zaken per gemeente, met signaleringslogica voor deadlines en aanvullingstermijnen
**Startdata:** `vergunningen.json`
**Uitdaging:** bouw een prioriteringsalgoritme dat behandelaars vertelt wat ze als eerste moeten oppakken

---

### Use case B — Aanbestedingsassistent
**Voor:** sales team
**Wat:** AI-assistent die helpt bij het schrijven van aanbestedingsresponses op basis van eerdere inschrijvingen en productspecificaties
**Startdata:** `aanbestedingen.json`
**Uitdaging:** genereer een conceptreactie op een aanbesteding op basis van gunningscriteria en eigen USPs

---

### Use case C — Behandelaar co-pilot
**Voor:** individuele behandelaars
**Wat:** AI die vergelijkbare historische zaken opzoekt en een conceptbesluit suggereert op basis van precedenten
**Startdata:** `vergunningen.json`
**Uitdaging:** leg uit waarom een besluit wordt gesuggereerd (transparantie voor bezwaar)

---

### Use case D — Handhaving prioritering
**Voor:** handhavingsteam
**Wat:** dashboard dat openstaande handhavingszaken rankt op urgentie (type overtreding, duur, locatie, precedent)
**Startdata:** genereer zelf testdata met Claude
**Uitdaging:** maak de prioriteringslogica uitlegbaar aan de behandelaar

---

### Use case E — Burger-communicatie generator
**Voor:** behandelaars die brieven schrijven naar aanvragers
**Wat:** genereert statusbrieven in begrijpelijke taal op basis van zaakgegevens — van "uw aanvraag is ontvangen" tot "uw bezwaar is ingediend"
**Startdata:** `vergunningen.json`
**Uitdaging:** toon in de UI een voor/na — juridische tekst vs. begrijpelijke taal

---

## Aan de slag

**Stap 1 — Kies een use case en scope af:**
```
@roxit-domain-expert Wij willen use case [X] bouwen. 
Wat is de kleinste versie die al waarde heeft voor een gebruiker?
```

**Stap 2 — Maak een CLAUDE.md in je projectfolder:**
```
Maak een CLAUDE.md voor ons project. We bouwen [beschrijving].
De gebruiker is [rol]. De kern is [kernfunctie].
```

**Stap 3 — Bouw iteratief:**
- Elke prompt = één feature
- Run na elke feature: `pnpm dev` en test in de browser
- Stuck? Vraag `@workshop-guide`

**Stap 4 — Prep de pitch:**
- Wat is het probleem?
- Wie is de gebruiker?
- Wat heb je gebouwd?
- Wat zou de volgende stap zijn?

---

## Tips

- Gebruik de testdata — geen echte Roxit data nodig
- Bouw liever minder maar werkend, dan veel maar kapot
- Skills die je herhaalt → vastleggen in `.claude/skills/`
- Agents die je meerdere keren nodig hebt → vastleggen in `.claude/agents/`

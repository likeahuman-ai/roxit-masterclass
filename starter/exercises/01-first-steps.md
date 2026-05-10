# Oefening 1 — Eerste stappen

**Doel:** terminal leren kennen, eerste gesprek met Claude Code voeren
**Tijd:** ~20 minuten

---

## Stap 1 — Waar ben ik?

```bash
pwd
ls
```

Je zit in `/workspace`. Alles wat je hier maakt, staat op jouw laptop onder `~/roxit-workshop`.

---

## Stap 2 — Verken de startbestanden

```bash
ls data/
```

Je ziet `vergunningen.json` en `aanbestedingen.json` — gesimuleerde Roxit-data waar je vrijelijk mee kunt werken.

---

## Stap 3 — Start Claude Code

```bash
claude
```

Als je voor het eerst inlogt: de URL wordt geprint. Open hem in je browser, keur goed, plak de code terug. Eenmalig.

---

## Stap 4 — Eerste vragen (probeer ze één voor één)

```
Wat staat er in data/vergunningen.json?
```

```
Hoeveel vergunningen hebben de status "in_behandeling"?
```

```
Geef me een samenvatting van zaak Z/2024/002450 in gewone taal.
```

---

## Stap 5 — Iets bouwen

```
Maak een simpel HTML-bestand dat de vergunningen toont als een overzichtstabel.
Gebruik de Roxit DLS kleuren uit CLAUDE.md.
```

Open het bestand daarna:

```bash
# In een apart terminal venster:
python3 -m http.server 3000
```

Ga naar `http://localhost:3000` in je browser.

---

## Klaar?

Ga door naar **oefening 2** of vraag `@workshop-guide` wat je als volgende kunt proberen.

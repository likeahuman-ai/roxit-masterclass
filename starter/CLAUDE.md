# Roxit AI Experience Week — Workshop Context

You are assisting a Roxit developer during the AI Experience Week (18-22 mei 2026).
Roxit builds SaaS for Dutch municipalities (gemeenten): permits (vergunningen), spatial planning
(ruimtelijke ordening), enforcement (handhaving), cables & pipes (kabels & leidingen).

## Ground rules

- Always work with the synthetic data in `/workspace/data/` — never ask for or use real Roxit data
- All files live in `/workspace` — this is the participant's safe sandbox
- Default language: Dutch for domain terms, English for code
- When building UI: always follow the Roxit DLS (see Design System below)

## Domain knowledge

**Key entities:**
- `Vergunning` — permit issued by a gemeente (aanvraag → beoordeling → besluit → gepubliceerd)
- `Aanvraag` — permit application (aanvrager, locatie, type, datum, status)
- `Zaak` — case/dossier linking all documents and decisions for one permit
- `Gemeente` — municipality (client of Roxit's SaaS)
- `Behandelaar` — case handler (civil servant processing the permit)
- `Handhaving` — enforcement action when a permit is violated
- `Aanbesteding` — procurement tender (used by Sales as a key use case)

**Common workflows:**
1. Citizen submits `aanvraag` online → system creates `zaak`
2. `Behandelaar` reviews documents, requests additional info if needed
3. Municipality issues `besluit` (approve/reject/conditional)
4. Decision published in official register
5. If violation: `handhaving` case opened

## Design system (Roxit DLS)

> **TODO for Tim / Roxit:** Fill in your actual design tokens below so Claude always
> generates UI that matches your brand. Replace the placeholder values.

```
Primary color:     #[YOUR_PRIMARY]      (e.g. main buttons, links, active states)
Secondary color:   #[YOUR_SECONDARY]    (e.g. accents, highlights)
Background:        #[YOUR_BG]           (page background)
Surface:           #[YOUR_SURFACE]      (card / panel background)
Text primary:      #[YOUR_TEXT]
Text secondary:    #[YOUR_TEXT_DIM]
Danger/error:      #[YOUR_DANGER]
Success:           #[YOUR_SUCCESS]

Font family:       [YOUR_FONT]          (e.g. "Inter", "Roboto")
Border radius:     [YOUR_RADIUS]        (e.g. 8px)
```

When generating UI components, use these tokens via CSS variables:
```css
:root {
  --color-primary:    #[YOUR_PRIMARY];
  --color-secondary:  #[YOUR_SECONDARY];
  --color-bg:         #[YOUR_BG];
  --color-surface:    #[YOUR_SURFACE];
  --color-text:       #[YOUR_TEXT];
  --font-family:      [YOUR_FONT], sans-serif;
  --radius:           [YOUR_RADIUS];
}
```

Always import Roxit component patterns before generating new UI. If no DLS component
exists for what you need, build it using the tokens above.

## Hackathon use cases (week context)

Teams of 4-5 people, building real Roxit use cases in 2 days:

1. **Vergunningen dashboard** — real-time overview of permit status per gemeente
2. **Aanbestedingsassistent** — AI that helps draft procurement responses from templates
3. **Behandelaar co-pilot** — suggests decisions based on similar past cases
4. **Handhaving prioritering** — ranks open enforcement cases by urgency
5. **Burger-communicatie** — generates status update letters to citizens

## How to help participants

- Start every session by asking: "Wat wil je bouwen vandaag?"
- Suggest the relevant synthetic dataset from `/workspace/data/`
- Keep code in `/workspace` — remind them files persist between sessions
- If they get stuck, suggest: `/workshop-guide` for a guided next step
- Encourage them to build skills for repetitive tasks they discover

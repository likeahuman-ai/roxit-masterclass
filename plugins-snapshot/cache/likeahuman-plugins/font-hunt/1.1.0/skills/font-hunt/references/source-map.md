# Source Map — Mood → Sources

Routes brief mood keywords to the right researcher agents and their rotating source pools.

## Agent source pools

### font-researcher-free-curated
- Fontshare — https://www.fontshare.com/fonts
- Pangram Pangram — https://pangrampangram.com/collections/fonts
- The League of Moveable Type — https://www.theleagueofmoveabletype.com/
- Fontsource — https://fontsource.org/
- Uncut.wtf — https://uncut.wtf/
- Open Foundry — https://open-foundry.com/

### font-researcher-experimental
- Velvetyne — https://velvetyne.fr/fonts/
- Future Fonts — https://www.futurefonts.xyz/
- Use & Modify — http://usemodify.com/
- Collletttivo — https://www.collletttivo.it/

### font-researcher-paid-indie
- Klim Type Foundry — https://klim.co.nz/
- Grilli Type — https://www.grillitype.com/
- Dinamo — https://abcdinamo.com/
- OH no Type Co — https://ohnotype.co/
- Sharp Type — https://sharptype.co/
- Colophon Foundry — https://www.colophon-foundry.org/
- Commercial Type — https://commercialtype.com/
- Production Type — https://productiontype.com/
- Displaay — https://displaay.net/

### font-researcher-display-feral
- 1001fonts — https://www.1001fonts.com/
- DaFont — https://www.dafont.com/
- FontSpace — https://www.fontspace.com/
- Behance Free Fonts (tag search) — https://www.behance.net/search/projects/free%20font

### font-researcher-google-adobe
- Google Fonts (filtered) — https://fonts.google.com/
- Adobe Fonts — https://fonts.adobe.com/
- Fonts In Use (signal source) — https://fontsinuse.com/

## Mood keyword → agent priority

When the brief's mood keywords match a row, the listed agents get dispatched first. "Primary" agents always run; "secondary" agents run if parallel budget allows (default: all 5 run).

| Mood keyword(s) | Primary agents | Secondary agents |
|-----------------|---------------|------------------|
| editorial, magazine, publication | paid-indie, google-adobe | free-curated |
| warm, humanist, organic | free-curated, google-adobe | paid-indie |
| experimental, brutalist, raw | experimental, display-feral | paid-indie |
| technical, developer, tooling | google-adobe, free-curated | paid-indie |
| wellness, slow, soft | free-curated, google-adobe | paid-indie |
| fashion, luxury, premium | paid-indie | free-curated |
| feral, display, poster, hero | display-feral, experimental | paid-indie |
| script, handmade, handwritten | display-feral | experimental |
| retro, vintage, nostalgia | display-feral, experimental | free-curated |
| brutalist, bold, loud | experimental, paid-indie | display-feral |
| elegant, refined, editorial-serif | paid-indie, free-curated | google-adobe |
| grotesque, swiss, neutral | paid-indie, google-adobe | free-curated |

## Default behaviour

If no mood keyword matches, run all 5 agents. The synthesis step's diversity guard ensures tier mixing.

## Known underused gems (for google-adobe agent)

Google Fonts that pass the anti-slop filter:
- Fraunces (variable, optical sizing + SOFT axis)
- Newsreader (editorial serif, underused)
- Instrument Serif (italic is stunning)
- Bricolage Grotesque (variable)
- Syne (display sans)
- Unbounded (variable display)
- Gabarito (variable)
- Literata (reading serif)
- Gidole (geometric sans)
- Anybody (variable width)
- Reem Kufi Fun (Arabic-Latin, variable)
- Bodoni Moda (variable didone)
- Redaction (digital reconstruction of Didot)
- Sometype Mono (humanist mono)
- JetBrains Mono (when mono is needed — beyond the usual)

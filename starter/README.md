# Claude Code Workshop

Welkom in de sandbox! Je bent ingelogd als gebruiker `dev` op `/workspace`.

## Eerste keer: inloggen op Claude Code

Typ in de terminal:

```bash
claude
```

Wat er gebeurt:

1. Een **browser-tab opent automatisch**
2. **Approve** de toegang met je Anthropic-account
3. De browser laat een **code** zien — kopieer die en **plak in de terminal**
4. Klaar — je ziet nu de Claude Code prompt

> **Geen browser-tab?** Sommige corporate laptops blokkeren het. Kijk in de terminal — daar staat een URL die begint met `https://claude.ai/oauth/...`. Open die handmatig in je browser en plak de code terug in de terminal.

## Een eerste prompt

Probeer iets simpels:

```
Wat staat er in deze workspace?
```

of

```
Bouw een landing page voor een fictief bedrijf "Roxit Coffee" met Next.js + Tailwind.
Deploy hem naar Vercel.
```

## Wat staat er klaar?

```
.claude/agents/     @product-owner, @backend-engineer, @frontend-engineer,
                    @convex-expert, @saas-stack-architect,
                    @react-component-architect, @form-validation-architect

.claude/skills/     /office-hours    — vraag ronde voor het hele team
                    /investigate     — root-cause onderzoek
                    /review          — code review met agents
                    /qa              — handmatige QA loop
                    ... en meer

CLAUDE.md           Workshop context + Roxit design system
index.html          Visueel overzicht van alle agents, skills en plugins
```

Open `index.html` in je browser (op je laptop, niet in de sandbox) voor een klikbaar overzicht:

```bash
open /workspace/index.html       # macOS
explorer.exe \\wsl$\...\index.html   # Windows met WSL
```

## Bestanden

Alles wat je maakt in `/workspace` verschijnt op je laptop in `~/roxit-workshop/`. Je werk is nooit weg, ook niet als je de sandbox afsluit.

## Hulp nodig?

- Tijdens de workshop — vraag de begeleider
- Na de workshop — WhatsApp de coordinator

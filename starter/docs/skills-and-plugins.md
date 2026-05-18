# Skills & Plugins Reference

Everything pre-installed in this workshop sandbox. Type any `/command` inside Claude Code.

---

## Agents — invoke with `@name`

| Agent | When to use |
|---|---|
| `@product-owner` | Write PRDs, break features into tickets, define user stories, prioritize scope |
| `@backend-engineer` | Convex schema, queries, mutations, Server Actions, API routes, auth, Zod validation |
| `@frontend-engineer` | React components, Tailwind, animations, responsive layout, accessibility |
| `@convex-expert` | Deep Convex expertise — schema design, real-time queries, indexes, auth patterns |
| `@saas-stack-architect` | App architecture, auth (Clerk), payments, onboarding flows, tech stack decisions |
| `@react-component-architect` | Component API design, prop drilling, composition patterns, reusability review |
| `@form-validation-architect` | React Hook Form, Zod schemas, multi-step forms, server-side validation |

**Example:** `@backend-engineer help me design the schema for a permit tracker`

---

## Skills — invoke with `/name`

### Workflow

| Skill | When to use |
|---|---|
| `/office-hours` | Before starting — six forcing questions to scope and validate your idea. Start here on hackathon day. |
| `/investigate` | Stuck on a bug? Systematic root-cause debugging. Iron law: no fix without a diagnosis first. |
| `/review` | Before committing — staff engineer review of your diff. Catches SQL safety issues, logic bugs, security. |
| `/qa` | App built? Systematically test it, find bugs, fix them one by one. |
| `/plan-eng-review` | Lock in your architecture before building. Walks through data flow, edge cases, test coverage. |
| `/design-review` | Designer's eye on your UI — spacing, hierarchy, AI slop patterns, slow interactions. |
| `/cso` | Security audit — OWASP Top 10, dependency scan, secrets archaeology. |

### Code quality

| Skill | When to use |
|---|---|
| `/lint` | Full code quality audit on any file or directory. Auto-detects your stack. |
| `/organize` | Audit and restructure your file organization into domain-driven layout. |

### Product & design

| Skill | When to use |
|---|---|
| `/prd-builder` | Turn a feature idea into a PRD with epics, tickets, and acceptance criteria. |
| `/visual-explainer` | Generate architecture diagrams, flowcharts, data tables — rendered in the browser. |
| `/inspiration` | Pull real visual references from cosmos.so. Use before designing anything. |

### Frontend patterns

| Skill | When to use |
|---|---|
| `coding-standards` | Reference for naming, file structure, TypeScript rules, component patterns. Auto-loaded. |
| `vercel-react-best-practices` | 65 performance rules for Next.js — waterfalls, bundle size, re-renders. |
| `frontend-patterns` | React composition, custom hooks, state management, virtualization, Framer Motion. |

### Learning

| Skill | When to use |
|---|---|
| `/build-a-skill` | Learned something that keeps coming up? Codify it as a reusable skill. |

---

## Plugins — always active

Plugins extend Claude's capabilities beyond skills. These are pre-installed and auto-loaded.

| Plugin | What it adds |
|---|---|
| **frontend-design** | Layout systems, visual hierarchy, composition principles. Use `/frontend-design` for design guidance. |
| **impeccable** | Agency-tier UI quality. Sub-skills: `/impeccable:typeset`, `/impeccable:colorize`, `/impeccable:layout`, `/impeccable:animate`, `/impeccable:polish`. |
| **code-review** | Structured multi-dimension code review — architecture, security, performance, test coverage. |
| **code-simplifier** | Simplifies over-engineered code. Good for cleaning up before committing. |
| **skill-creator** | Helps you create new skills from scratch. Use on hackathon day to capture reusable patterns. |
| **gsap-skills** | GSAP animation patterns — timelines, ScrollTrigger, SplitText. Use `/gsap` for animation help. |
| **font-hunt** | Typography and font selection. Use when you need to pick the right font for a UI. |
| **branding-pitch** | AI-assisted branding and pitch deck creation. |
| **development** | Full dev pipeline — plan a PRD, break into tickets, build with subagents, multi-agent code review, fix findings. |
| **development-advanced** | Advanced dev pipeline with architectural decision records and living specs. |
| **orientation** | Discover your skill level and get routed to the right starting point — guided survey + track recommendation. |
| **guided-build** | Build your first project with AI in one session — compressed plan-to-deploy for beginners. |
| **coding-standards** | Interview-based coding standards — generates personalised rules and enforces with pre-commit hooks. |

---

## impeccable sub-skills

`impeccable` is a full agency-grade design plugin with focused sub-skills:

| Sub-skill | What it does |
|---|---|
| `/impeccable:typeset` | Typography — scale, rhythm, hierarchy, font pairing |
| `/impeccable:colorize` | Color palette — contrast, harmony, tokens |
| `/impeccable:layout` | Spacing, grid, composition, whitespace |
| `/impeccable:animate` | Micro-interactions, transitions, motion design |
| `/impeccable:polish` | Final QA pass — finds cheap-looking details and fixes them |
| `/impeccable:audit` | Full design audit across all dimensions |
| `/impeccable:critique` | Honest critique of a design with specific improvement suggestions |

---

## Create your own

### Custom skills

Skills are markdown files that teach Claude how to do something. Create them inside your project:

```
/workspace/my-project/.claude/skills/my-skill.md
```

Or use the `/build-a-skill` command to create one interactively. Skills in your project directory are automatically available when you `cd` into that project. They persist in `~/roxit-workshop` on your laptop.

### Custom plugins

Install plugins from the marketplace:

```
/install frontend-design
```

Or install from a GitHub repo:

```
/install github:username/repo-name
```

Installed plugins survive container restarts — they're stored in a persistent volume and merged with the pre-installed set on each boot.

---

## Recommended flows

### Starting a new feature
```
/office-hours → scope it
@product-owner → write the PRD
@backend-engineer → design the schema
@frontend-engineer → build the UI
/review → check before committing
```

### Stuck on a bug
```
/investigate → diagnose root cause
fix it → /review → commit
```

### UI needs polish
```
/inspiration → get references first
/impeccable:audit → find issues
/design-review → designer eye
/impeccable:polish → final pass
```

### Hackathon day
```
/office-hours → validate idea (10 min)
build iteratively with agents →
/qa → find bugs →
/design-review → polish →
pitch
```

# Workshop Tech Stack

- Status: Accepted
- Date: 2026-05-18

## Context and Problem Statement

Developers joining a short workshop (1–3 days) need a single supported stack they can spin up in minutes, build a working internal tool on, and demo the same day. The stack must minimise infrastructure overhead, work inside a Docker sandbox, and be learnable by developers with varying experience levels.

## Decision Drivers

- Zero setup time — developers should be building within 5 minutes of starting
- Real-time UI without a separate API layer
- TypeScript end-to-end so types flow from data model to UI automatically
- Works fully inside the Docker sandbox (no local DB, no migrations, no infra)
- Free tier covers all usage during the workshop

## Considered Options

- Next.js + Convex
- Next.js + Prisma + Postgres
- Next.js + Drizzle + SQLite
- Next.js + tRPC + Prisma

## Decision Outcome

Chosen option: **Next.js 15 (App Router) + Convex**, because it eliminates the entire backend setup phase. Convex provides database + functions + real-time subscriptions with a single `npx convex dev` command, no migrations, no connection strings, and full TypeScript types everywhere.

### Consequences

- Good: participants go from zero to working real-time app in under 10 minutes
- Good: no Postgres/SQLite to provision — Convex cloud handles persistence
- Good: `useQuery()` auto-updates UI when data changes — no polling, no refetch logic
- Good: schema defined once in `convex/schema.ts`, types flow to frontend automatically
- Bad: requires outbound internet for Convex cloud backend (workshop WiFi dependency)
- Bad: Convex is less familiar than Prisma/SQL for developers with relational DB backgrounds
- Neutral: Convex free tier is sufficient; no cost during workshop

### Confirmation

Each project runs `npx convex dev` successfully and `useQuery` data appears in the browser without manual API wiring.

## Pros and Cons of the Options

### Next.js + Convex

- Good: zero infra, real-time by default, full TypeScript, free tier
- Good: `query()` / `mutation()` replace API routes — less code, more type safety
- Bad: requires internet (Convex cloud); not fully offline

### Next.js + Prisma + Postgres

- Good: familiar SQL model, strong ecosystem
- Bad: requires Postgres running locally or provisioned — too much setup for a 3-day workshop
- Bad: migrations add friction; no real-time without extra tooling

### Next.js + Drizzle + SQLite

- Good: fully offline, lightweight
- Bad: no real-time sync; participants would need to implement polling manually
- Bad: Drizzle is newer and less documented than Prisma for beginners

### Next.js + tRPC + Prisma

- Good: strong type safety across client/server boundary
- Bad: additional abstraction layer (tRPC) adds cognitive overhead
- Bad: still requires a database to provision

## More Information

Stack is enforced by:
- `@backend-engineer` agent — Convex schema, queries, mutations, auth patterns
- `@frontend-engineer` agent — Next.js App Router, server/client component split, Tailwind
- `.ard/` folder — all future tech decisions documented here

Quickstart:
```bash
npx create-next-app@latest my-app --typescript --tailwind --app --no-git
cd my-app && pnpm add convex && npx convex dev
```

---
name: build-a-skill
description: Walk the participant through turning a repetitive task into a reusable Claude Code skill. Use when someone has done something manually twice and wants to automate it.
---

# Build a Skill

You just did something manually. Let's turn it into a skill so you (and your team) can run it
with one command next time.

## Step 1 — Name the task

What did you just do? Describe it in one sentence. Example:
> "I generated a status update letter for a vergunning aanvraag"

## Step 2 — Identify the inputs

What did you need to provide each time?
- A specific vergunning ID?
- A template?
- A gemeente name?

These become the skill's parameters.

## Step 3 — Write the skill file

Create `.claude/skills/<skill-name>.md` with this structure:

```markdown
---
name: <skill-name>
description: One sentence — when should Claude use this?
---

# <Skill Title>

## What this does
<plain language description>

## Inputs needed
- <input 1>: <description>
- <input 2>: <description>

## Steps
1. <step 1>
2. <step 2>
3. <step 3>

## Output
<what the skill produces>
```

## Step 4 — Test it

Run: `claude "/<skill-name> [your inputs]"`

Does it do what you expected? If not, edit the skill file and try again.

## Tips

- Skills are just markdown files — anyone on your team can read and improve them
- Good skill names are verbs: `generate-letter`, `check-status`, `summarize-zaak`
- If a skill needs data, point it to `/workspace/data/` explicitly

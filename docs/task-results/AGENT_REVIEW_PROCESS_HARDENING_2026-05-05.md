# Agent Review Process Hardening - 2026-05-05

## Status

Done. The repeated content/listing-page overblocking pattern was diagnosed and the durable agent guidance was updated.

## What Was Going Wrong

The recent Dragon Bridge run exposed a broader workflow failure:

- The copy and canonical import safety gates passed.
- The task then blocked because the hero image was still generic.
- The same task explicitly forbade adding or replacing images.
- Result: the safe approved copy was reverted, leaving weaker live copy in place because of a visual dependency the worker was not allowed to fix.

That is not a healthy review gate. It is an impossible gate.

## Root Causes

1. **The listing-page agent launcher was too thin.**  
   `/Users/jojolim/.codex/skills/speaklocal-listing-pages/agents/openai.yaml` only described the skill. It did not tell the agent how to act when a page is partly ready, when to split follow-ups, or when not to push raw review back to Jojo.

2. **The listing skill had content standards but not enough execution judgment.**  
   It said what good copy looks like, but it did not explicitly say: import the largest safe improvement, do not overblock, and classify issues before stopping.

3. **Review gates were too binary.**  
   A reviewer could say `BLOCK` without distinguishing:
   - a true shipping blocker;
   - a fix that should happen now;
   - a follow-up;
   - an accepted temporary risk.

4. **Reviewers were not consistently acting as first-time travelers.**  
   Some reviews optimized for validator correctness or task literalism rather than asking whether the rendered page helps someone standing in the real situation.

5. **Agents were too willing to send work back to Jojo.**  
   Jojo should review the app on the phone, not raw CSVs, patch files, or implementation artifacts. Agents should use focused review passes for most content quality decisions.

6. **The system encouraged generator/importer safety more than final page quality.**  
   Scripts are useful for importing exact patches, validating links, and scanning slop. They should not become a substitute for page-by-page traveler reasoning.

## What Changed

Updated local skill files:

- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/agents/openai.yaml`
- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`
- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/references/page-standard-and-examples.md`
- `/Users/jojolim/.codex/skills/speaklocal-task-cards/SKILL.md`

Updated repo guidance:

- `AGENTS.md`
- `docs/task-cards/README.md`

## New Operating Rules

Listing/content reviewers must classify issues as:

- `HARD_BLOCK`: shipping would be broken, misleading, legally risky, outside scope, or worse than current behavior.
- `SAFE_FIX_NOW`: fix inside the current task.
- `FOLLOW_UP`: real issue, but separable from the safe improvement.
- `ACCEPTED_TEMPORARY_RISK`: known imperfection explicitly allowed by task scope or steering.

Workers should default to:

- import or commit the largest safe improvement;
- split separable visual/audio/native dependencies into follow-up tasks;
- ask Jojo only for product, brand, legal/licensing, or language-correctness decisions that a strong agent cannot responsibly answer;
- review actual rendered output and current diffs, not just task cards;
- keep final prose page-specific and traveler-first.

## Practical Example

For Dragon Bridge:

- Approved landmark copy and canonical links should import now.
- The generic masthead should be documented as `FOLLOW_UP`.
- A separate Dragon Bridge hero asset task should create/wire the production visual.

The user-facing copy should not stay weak just because the perfect hero image is not ready.

## Expected Impact

Future Content + Listing Page tasks should produce fewer circular blocker reports and more useful committed improvements. Reviewers should still block real safety/correctness issues, but they should stop treating every adjacent imperfection as a reason to preserve the current weaker app.

## Follow-Up

Use the new task card:

- `docs/task-cards/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001.md`

Then handle the visual follow-up separately:

- `docs/task-cards/TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001.md`

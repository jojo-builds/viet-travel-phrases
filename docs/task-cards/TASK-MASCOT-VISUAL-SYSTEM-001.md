# TASK-MASCOT-VISUAL-SYSTEM-001: Chameleon Mascot Visual System And App Flow Concepts

## Task Done

Jojo can review a clear visual direction for the SpeakLocal chameleon mascot: base mascot, Vietnam progression stages, Practice/Quiz integration moments, and app-screen mock screenshots that show how the mascot belongs inside the current native iOS/Liquid Glass product without making it childish or busy.

## Context

Jojo's mascot direction is a chameleon traveler. The chameleon visits each destination, learns to speak local, and gradually camouflages into that country's motif. For Vietnam, the adaptation should feel tasteful: restrained jade/sea-glass tinting, soft red/gold accents, lotus/ceramic/lantern/travel details, and no loud game costume, flag body paint, confetti, XP economy, or mascot takeover.

Existing source truth:

- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md`
- `docs/research/TOOLBOX.md`
- `docs/design/practice-quiz-concepts/README.md`
- current native app screenshots/style from simulator if needed

This task is visual/design first. It should give Jojo something to look at before we wire a mascot deeply into native Practice.

## Worker Judgment

Use GPT-5.5 judgment as a product designer and art director. Use the best available visual tool: Codex image generation, ChatGPT image workflow via Jojo if needed, local HTML mockups, Figma-style boards, or native-screen composite screenshots. Do not bury the output in raw data. Jojo needs to see the progression.

If using ChatGPT/image generation would produce better images, prepare a prompt packet and either use available tools or clearly hand Jojo the prompt plus expected output names. Import any generated images into the repo before closeout.

## Required Outcome

- Produce a visual direction board for the mascot:
  - base neutral chameleon traveler;
  - early Vietnam tint;
  - mid-progress Vietnam motif;
  - high-progress/completion motif;
  - sensitive-context subdued/no-mascot rule.
- Produce app-flow mock screenshots or polished visual composites for at least:
  - Practice hub with mascot;
  - one normal prompt with restrained mascot/progress presence;
  - missed/review feedback with no childish/punitive energy;
  - completion/reward moment with the Vietnam route mark;
  - optional listing-page entry point showing how `Add to practice` relates to mascot/progress without crowding the phrase page.
- Include a short written art-direction document explaining what to keep, what to avoid, and how this should translate into native SwiftUI later.
- Include image prompts used, source references, and final asset paths.
- Use one read-only reviewer focused on visual fit, product taste, and whether Jojo can actually review the output easily.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/design/mascot/**`, `docs/task-results/**`, and prototype/mock assets only.
- Do not implement native Swift code in this task.
- Do not change SQLite/runtime/content data.
- Do not use copyrighted character references or make the mascot look like a known IP.
- Do not send private repo screenshots/context to ChatGPT or other external tools unless Jojo explicitly approves that transfer. If external generation is used, record what context was sent.

## Validation

- Verify all image/mock paths render from the repo.
- If using a local browser board, provide the URL and server command.
- Run `git diff --check`.
- Peer-review the final visual board/mock screenshots.

## Result Contract

Write `docs/task-results/TASK-MASCOT-VISUAL-SYSTEM-001.md` with:

- status: done or blocked;
- commit hash;
- visual artifact paths;
- prompt packet paths;
- what tool(s) were used;
- what context, if any, was sent outside Codex;
- art-direction summary;
- peer review outcome;
- recommended next task.

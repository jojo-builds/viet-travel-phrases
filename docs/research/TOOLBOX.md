# SpeakLocal Research And Design Toolbox

The orchestrator should choose the right tool for the job instead of defaulting
to one Codex thread for everything.

## Default Rule

Every research or design task needs two outputs:

1. a durable source artifact in the repo; and
2. a Jojo-readable review surface.

The durable source artifact is usually Markdown under `docs/research/`,
`docs/design/`, or `docs/practice/`. The review surface can be Markdown, a local
browser page, screenshots, a Google Doc, a Figma board, or imported ChatGPT output.

## Tool Choices

### Codex Worker

Use Codex when the task needs repo context, code changes, SQLite/resource checks,
task cards, simulator proof, or committed artifacts.

Best for:

- reading app source truth;
- writing task cards and decisions;
- creating local prototypes;
- validating generated data;
- committing implementation and result files.

### ChatGPT / Deep Research

Use ChatGPT when the task benefits from a broad external research report, polished
human-readable synthesis, or stronger interactive image/design generation.

Before sending private app context, screenshots, unpublished strategy, or repo
files to ChatGPT, get explicit Jojo approval for that specific context and purpose.

Required workflow:

- save the exact prompt/context packet in the repo first;
- run ChatGPT or have Jojo run it;
- import the resulting report, images, or downloaded files into `docs/research/`,
  `docs/design/`, or `docs/task-results/`;
- add a short `Folded Into` section that says what decisions, task cards, or code
  changed because of it.

Do not treat a ChatGPT conversation as source truth unless its output is imported
back into the repo.

### Image Generation

Use image generation for mascot exploration, visual concept boards, hero assets,
or UI mood directions. For SpeakLocal, prompts must carry the native iOS, Liquid
Glass, restrained travel, and non-childish mascot rules.

Expected output:

- prompt packet;
- generated images or screenshots saved under `docs/design/` or `docs/task-results/assets/`;
- short review notes saying which direction should be kept, rejected, or refined.

### Browser / Side Panel

Use the Codex in-app browser for local prototypes, HTML reports, screenshot review,
and interactive design tests.

If Jojo is expected to review the work visually, the worker should provide a local
URL or file path and make sure the server command is included in the result.

### Google Docs / Drive

Use Google Docs only when the research needs a polished long-form document for
human review outside the repo. The repo still needs a Markdown source or imported
export so the decision history stays versioned.

### Figma

Use Figma when the task is a real design-system or layout exploration that benefits
from visual boards, component comparison, or handoff. Do not use it for small copy
or data tasks.

## Review Surface Checklist

Before a worker says research/design is done, it should answer:

- Where can Jojo read it?
- Where can Jojo see it?
- What source files changed because of it?
- What task cards or next steps came out of it?
- What should not be done based on the research?

If those answers are missing, the research is not folded in yet.

# Task Spec: T-002

## Title
Website preview-manifest sanity check and cleanup pilot

## Objective
Run the first real small repo-local workflow pilot on an isolated website-side surface.
Audit the website phrase-preview manifest and preview JSON seam for obvious integrity issues, fix at most one small low-risk issue if a clear safe fix exists, and write a compact result artifact proving the `.agent` protocol can handle a real task.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/coordination/locks.yaml`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- relevant files under `site/data/phrase-previews/`
- relevant files under `site/public/data/phrase-previews/`

## Scope
### Allowed write scopes
- `.agent/coordination/locks.yaml`
- `.agent/tasks/T-002/**`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`

### Allowed read scopes
- `site/**`
- `content-draft/viet/website-preview.json`
- relevant docs if needed for export-seam truth

### Must not touch
- `app/**`
- `content-draft/**` except read-only inspection of `content-draft/viet/website-preview.json`
- `docs/operations/**`
- `ops/apps/**`
- Apple/TestFlight/build files
- unrelated website conversion copy outside the preview seam

## Source-of-truth notes
- This task is allowed to change website preview seam files only if a safe, obvious integrity cleanup is found.
- It must not redefine website product direction.
- If no safe fix is obvious, report findings only and do not force a change.
- Any result here should be classified as live truth only if an actual seam file is corrected; otherwise planning or prepared-next truth is more accurate.

## Required checks
- verify whether `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` are in sync
- spot-check whether referenced preview JSON files physically exist in both seams
- if a clear low-risk integrity mismatch exists, fix one issue only and verify the seam is cleaner afterward
- keep result output compact and artifact-based

## Review gate
- as currently scoped, this draft is too small for the meaningful queued Codex contract with 3 mandatory review gates
- do not promote or queue this task until it is merged, expanded, or otherwise re-scoped enough to justify 3 review gates with exactly 4 Codex subagents per gate
- if it is later re-scoped into a meaningful Codex task, each gate must loop until all 4 subagents explicitly agree before advancement

## Definition of done
- `state.json` reflects a real task lifecycle
- `result.md` records what was inspected, what changed, and what should happen next
- no app files, Apple-release files, or unrelated website copy changed
- if a fix was made, it is limited, low-risk, and easy to verify from the seam itself

## Blocker rule
- do not widen this into a broad website review
- if the seam looks clean, record that outcome and stop
- if the issue requires broader export-pipeline decisions, record it as a next-step recommendation rather than forcing a larger change

## Token discipline
- treat this file as the main task contract
- do not paste full manifests or large JSON blobs into `result.md`
- use concise file-path evidence and short findings only

## Required result contract
Before stopping, write `result.md` using the repo template shape.

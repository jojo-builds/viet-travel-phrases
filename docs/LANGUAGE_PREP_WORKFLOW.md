# Language Prep Workflow

Use this workflow when we want to prepare future languages in parallel without turning them into live runtime variants too early.

## Boundary

Prep-only work should stay in:

- `content-draft/<variant>`
- `ops/apps/<variant>.json`

Do not wire a new language into `app/family/appRegistry.js` or `app/family/currentApp.ts` until it has:

- the shared 10-scenario baseline reviewed
- translation coverage in `phrase-source.csv`
- pronunciation coverage
- an honest audio posture
- a clear next validation plan

## Commands

Run from `E:\AI\SpeakLocal-App-Family\app`:

- scaffold a new prep lane:
  - `npm run scaffold:language-prep -- --variant <variant> --language "<language>" --country "<country>" --language-code <code> --display-name "<display name>"`
- build a runtime pack once a lane is ready:
  - `npm run build:pack -- --variant <variant>`

Shared neutral traveler baseline source:

- `templates/FAMILY_TRAVELER_BASELINE.json`

Shared-source seam rule:

- rewrite merged dual-intent English glosses and bare shorthand before propagating them into prep lanes; examples: prefer `Excuse me` over `Excuse me sorry`, and prefer `For takeaway` over bare `To go`
- when a shared `english_text` changes, sync both `phrase-source.csv` and `first-wave-priority.csv` anywhere the old wording still drives active prep-lane authoring
- preserve stronger lane-local rewrites instead of flattening them back to the template
- keep clearly lane-specific seams explicit as rewrite-before-translation debt instead of forcing one shared English fix

## Current prepared lanes

- `viet` and `tagalog` are the current active runtime pair.
- `thai` is a prep-only research lane with durable destination research and an initial draft scaffold, but it still needs a ranked first-wave authoring shortlist before translation work should start.
- `japanese` is now an authoring-ready prep lane with durable research, a ranked `24`-row first-wave shortlist, and explicit rewrite-before-translation flags.
- `turkish` is now an authoring-ready prep lane with durable research and a ranked `32`-row first-wave shortlist.
- `spanish` is now an authoring-ready prep lane with durable research and a ranked `30`-row first-wave shortlist.
- `italian` is now effectively translation-complete for the current prep scope, with durable research, a resolved graduation-boundary packet, one explicit later-only bargaining hold, one rewrite-needed cafe-fit hold, and a still-separate medical/native-review caution surface before any runtime graduation claim.
- `french` is now a prep-only research lane with durable France-focused travel research, scenario scaffolding, and a concrete backlog, but it still needs a tighter ranked first-wave shortlist before translation work should start.
- `german` is now an authoring-ready prep lane with a durable scaffold, a ranked `30`-row first-wave shortlist, and a queued first real translation-pack pass.
- `korean` is now an authoring-ready prep lane with a `70`-row scaffold, a ranked `30`-row first-wave shortlist, and explicit risk flags for later native review.
- `indonesian` is now an authoring-ready prep lane with an `82`-row scaffold, a ranked `30`-row first-wave shortlist, and explicit risk flags for later native review.
- `tagalog` v2 prep truth is now an explicit prep-only source pack: `phrase-source.csv`, `first-wave-priority.csv`, scenario quick phrases, and rewrite notes are aligned around a bounded `16` core / `6` holdout / `2` deferred first-wave contract for the next translation pass.

## Working rule

- Until Viet + Tagalog shared search is runtime-validated and frozen as the family baseline, new-language sessions should stay prep-only unless there is a deliberate decision to graduate one of them into the runtime registry.
- Prep-only graduation readiness now requires more than scaffold files:
  - `phrase-source.csv` needs real translation coverage
  - pronunciation needs to be filled
  - audio posture needs to be decided honestly
  - runtime languages must add localized `presentation.search` copy and pass shared-search validation
- Current blocker for future-lane graduation:
  - Thai, Japanese, Turkish, Spanish, Italian, French, German, Korean, Indonesian, and Tagalog v2 still remain prep-only because shortlist/readiness work is not the same as translation coverage, pronunciation completion, audio posture, runtime search proof, or native review on sensitive lines
- Search normalization is only proven today for the current Latin-script pair. Future non-Latin runtime promotion needs a fresh UX/localization review before inheriting the same exact search contract.

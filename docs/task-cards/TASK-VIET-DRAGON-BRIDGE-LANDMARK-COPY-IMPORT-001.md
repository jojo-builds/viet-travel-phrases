Task Done

Import the approved Dragon Bridge / `Cầu Rồng` landmark copy override into runtime content without blocking on the missing Dragon Bridge hero image. The live page should read like a traveler action page, not a generic place/article page, and the missing specific hero image should be recorded as a separate known follow-up.

Context

Previous task result:

- `docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001.md`
- Commit `404bbacb`
- Incoming override packet: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/incoming-chatgpt/`
- Approval/review artifacts: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/`

Important prior evidence:

- Traveler/editorial review: `APPROVE`
- Canonical/import safety review: `APPROVE`
- Live rendered review blocked only because the page still used the generic Vietnam masthead.

That block was over-scoped for the copy task. The previous task also explicitly forbade adding/replacing images, so the missing Dragon Bridge hero image must not prevent the approved copy from replacing the current weaker page structure.

Worker Judgment

Treat this as a content/runtime import task, not an image or native redesign task.

Use the previous approved Dragon Bridge override and import-safety artifacts. Do not re-litigate the copy from scratch unless current source drift makes the prior approval invalid.

The generic Vietnam masthead is accepted as a temporary known issue for this task. Do not fail the live rendered-page review solely because the top image is generic. Instead, document the follow-up as `TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001`.

Required Outcome

- Import the Dragon Bridge override through source-owned content, preserving the current canonical mapping:
  - incoming patch page ID: `viet-phrase-city-danang-place-dragon-bridge`
  - current generated authored page ID: `viet-family-city-danang-place-dragon-bridge`
  - canonical phrase ID: `city-danang-place-dragon-bridge`
- Resolve by `phrase_id` / canonical family mapping. Do not create a duplicate page for the stale incoming `viet-phrase-*` page ID.
- The rendered page should use the task-based landmark structure from the approved override:
  - `Start here`
  - `Say the name`
  - `Getting there`
  - `At the bridge`
  - `Meeting or pickup`
  - `What the name means`
  - `Good to know`
  - `Nearby needs`
- Keep Dragon Bridge rows grouped by traveler task:
  - name row: `Cầu Rồng`
  - getting there: `Đi cầu Rồng`, `Cầu Rồng ở đâu?`
  - meeting/pickup: `Cho tôi xuống gần Cầu Rồng.`, `Dừng ở Cầu Rồng`
  - at the bridge: `Bạn chụp giúp tôi được không?`
  - nearby needs: ATM/food rows only after core landmark actions
- Import or harden validator guardrails from the override so landmark pages do not leak internal/model copy such as:
  - `place name`
  - `anchor`
  - `useful moments`
  - `where-question`
  - `route phrase`
  - `connect to`
  - `this page`
  - `relationship rows`
- Run a live rendered-page review for copy, section order, row grouping, and internal-wording absence.
- In that live review, do not block on the missing Dragon Bridge-specific hero image; record it as a follow-up only.

Boundaries

- Do not add, generate, replace, or edit image assets in this task.
- Do not edit `native-ios/App/**` unless a current importer/model bug makes the approved copy impossible to render.
- Do not generate audio.
- Do not edit signing, provisioning, or Xcode project settings.
- Do not broaden this into all landmark pages.
- Do not import unrelated Batch 001 rows.

Validation

- Dry-run the Dragon Bridge import first and prove only the approved Dragon Bridge rows would apply.
- Apply through source/generator paths only.
- Regenerate required Viet resources.
- Run the relevant editorial import validator and Dragon Bridge/landmark copy checks.
- Run:
  - `node native-ios/scripts/validate-viet-city-library.js`
  - `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `node native-ios/scripts/audit-viet-canonical-content.js --check`
  - `node native-ios/scripts/audit-viet-page-quality.js`
  - `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - `node scripts/practice/generate-viet-practice-deck.js --check`
  - relevant Node tests for touched importer/generator code
  - broad scan for the banned internal/model terms above
  - `git diff --check`
- Build and launch the native simulator, open/search `Cầu Rồng`, and capture screenshots showing:
  - top page with current masthead noted as known visual follow-up
  - section order and first rows
  - lower sections including `What the name means`, `Good to know`, and `Nearby needs`
- Prove no changes to:
  - `native-ios/Resources/Audio/**`
  - `native-ios/Resources/Assets.xcassets/**`
  - signing/provisioning/project settings

Result Contract

Write `docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001.md` with:

- imported source paths and generated resource paths
- prior approval artifacts reused
- exact canonical mapping proof
- section order proof
- row grouping proof
- banned/internal wording scan
- simulator screenshot paths
- explicit note that the generic masthead is an accepted temporary follow-up, not a blocker
- validation results
- final `git status --short`
- commit hash
- phone test term: `Cầu Rồng`

Commit when done.

Task Done

Create and wire a production-quality, app-owned Dragon Bridge / `Cầu Rồng` hero asset so the Dragon Bridge landmark page visually identifies the real place instead of using the generic Vietnam masthead.

Context

Related content task:

- `docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001.md`
- `docs/task-cards/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001.md`

The Dragon Bridge copy should not be blocked by this visual task, but the final product should not ship a major landmark page with a generic Ha Long Bay/Vietnam masthead.

Worker Judgment

This is a tightly scoped visual/native asset task. The goal is one production-safe landmark hero, not a broad hero redesign.

Use app-owned/generated/licensed-safe artwork. Do not use uncertain web-scraped photos. If using generated art, keep it realistic enough to read as Dragon Bridge in Da Nang: dragon-shaped bridge, river/city setting, night or golden-hour lighting, no text baked into the image, no fake logos.

Required Outcome

- Add a Dragon Bridge-specific hero image asset, likely `HeroDragonBridge`.
- Wire page-specific hero metadata for the Dragon Bridge canonical page:
  - canonical phrase ID: `city-danang-place-dragon-bridge`
  - current generated authored page ID: `viet-family-city-danang-place-dragon-bridge`
- Reuse the existing per-page hero metadata/render path created for Bà Nà Hills where possible.
- The Dragon Bridge page should visibly show Dragon Bridge / `Cầu Rồng` at the top in simulator proof.
- Preserve canonical page IDs and titles.

Boundaries

- Do not rewrite the Dragon Bridge copy in this task unless the copy-import task has not landed and a tiny metadata-only adjustment is required.
- Do not generate audio.
- Do not edit signing, provisioning, or unrelated project settings.
- Do not redesign the phrase detail page or global masthead system.
- Do not add ambiguous third-party photo assets without clear license/attribution proof.

Validation

- Run the necessary Viet content generation if hero metadata is source-driven.
- Run relevant SQLite/content validators touched by the metadata path.
- Run a native simulator build.
- Open/search `Cầu Rồng` and capture screenshot proof that the Dragon Bridge-specific hero is visible.
- Run `git diff --check`.
- Prove no audio/signing/provisioning changes.

Result Contract

Write `docs/task-results/TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001.md` with:

- asset source/ownership note
- asset path
- metadata path
- simulator screenshot path
- validation results
- final `git status --short`
- commit hash
- phone test term: `Cầu Rồng`

Commit when done.

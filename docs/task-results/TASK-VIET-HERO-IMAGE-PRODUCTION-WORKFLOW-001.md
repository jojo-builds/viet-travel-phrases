# TASK-VIET-HERO-IMAGE-PRODUCTION-WORKFLOW-001 Result

Status: done

## Summary

Built a durable hero-image production workflow for SpeakLocal Vietnam and seeded it from the current Dragon Bridge/Bà Nà Hills work, existing app assets, and the current hero follow-up audit.

The important workflow correction is now explicit: a generated image is not done just because the standalone file looks good. It is done only after the actual app masthead crop proves the page-specific visual cue is visible.

## Google Sheet

- Title: `SpeakLocal Viet Hero Image Production Tracker 2026-05-05`
- URL: https://docs.google.com/spreadsheets/d/1eP4dGLQa6bCbvdHHFtD7dKkqwOwwFg6Q141yEEgvw3Y/edit
- Native Google Sheets conversion: verified
- Tabs:
  - `README`
  - `Asset Tracker`
  - `Image Queue`
  - `Standards`
  - `Prompt Recipes`
  - `QA Gates`

## Repo Artifacts

- Packet folder: `docs/editorial-exports/viet-image-assets/hero-image-production-001/`
- Export script: `native-ios/scripts/export-viet-hero-image-production-tracker.js`
- Workbook: `docs/editorial-exports/viet-image-assets/hero-image-production-001/speaklocal-viet-hero-image-production-tracker-2026-05-05.xlsx`
- Workbook preview: `docs/task-results/assets/TASK-VIET-HERO-IMAGE-PRODUCTION-WORKFLOW-001/workbook-preview/image-queue-preview.png`

## Current Counts

- `154` tracked rows
- `152` queued rows needing an owned asset, crop audit, or replacement
- `2` shipped page-specific generated hero assets:
  - `HeroBaNaHills`
  - `HeroDragonBridge`
- Current target committed PNG size: `853 x 1844`
- Preferred source master: `>= 1600 x 2400`

## Dragon Bridge Fold-In

Dragon Bridge is recorded as a shipped generated asset, but the tracker keeps the right follow-up pressure on it:

- current asset: `native-ios/Resources/Assets.xcassets/HeroDragonBridge.imageset/hero-dragon-bridge.png`
- current dimensions: `853 x 1844`
- proof: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001/dragon-bridge-hero-simulator.png`
- crop note: review the live phone crop and regenerate if the bridge is too low, too small, or hidden by the masthead fade.

## Immediate P0 Queue Examples

- Da Nang city hub
- Marble Mountains
- Linh Ung Pagoda
- My Khe Beach
- Da Nang Airport
- Nén Đà Nẵng
- Nguyễn Văn Linh Street
- Bạch Đằng Street
- Võ Nguyên Giáp Street
- Bún chả Hương Liên
- Phở Bát Đàn
- Bún bò Huế
- Cao lầu

## Standards Captured

- Specific place pages cannot use generic Vietnam or Ha Long Bay-style imagery.
- Subject must sit in the upper third and center 70% width because `HeroMastheadImage` clips a shallow crop.
- No readable generated text, fake signs, logos, watermarks, or people as the main subject.
- Every shipped asset needs source ownership, metadata wiring, and simulator proof.
- P0 assets should also get physical-phone spot-checks before marking the row done.

## Persistent Skill Update

Updated the local `speaklocal-listing-pages` skill with a `Hero Image Asset Workflow` section so future agents inherit this process:

- use the Sheet/repo tracker;
- treat standalone image approval as insufficient;
- require rendered crop proof;
- classify missing hero images as follow-ups unless the task is specifically hero work;
- block legally unsafe or visibly wrong assets.

## Validation

- `node native-ios/scripts/export-viet-hero-image-production-tracker.js`
- bundled Node syntax check for the export script
- bundled Node syntax check for the workbook builder
- workbook import/inspect:
  - `README!A1:B10`
  - `Image Queue!A1:F8`
  - formula-error scan: `0` matches
- workbook rendered preview for `Image Queue!A1:H18`
- Google Sheet metadata readback confirmed all six tabs
- Google Sheet range readback confirmed `Image Queue` and `Standards` contents
- `git diff --check`

## Next Move

Use the `Image Queue` tab as the production queue. Generate the next assets in small batches, starting with Da Nang city hub, Marble Mountains, Linh Ung Pagoda, My Khe Beach, and the highest-value restaurant/dish pages. Each batch should wire assets through app metadata and capture rendered crop proof before marking rows done.

# Viet Starter Export Contract Audit

Date: 2026-04-21
Task: T-117
Session: task-queue-41-20260421T074240902-0500

## Scope

- Kept the approved 7-module Viet starter export surface intact.
- Kept the approved 4-module Vietnam hub subset intact:
  - `vietnam-arrival-basics`
  - `vietnam-transport-basics`
  - `vietnam-money-basics`
  - `vietnam-phone-basics`
- Kept the approved 3 exported off-hub starter modules intact:
  - `vietnam-essential-basics`
  - `vietnam-understanding-repair`
  - `vietnam-food-drink-basics`

## Hardening applied

- Added a machine-readable `surfaceContract` block to both manifest copies with the approved hub order and off-hub module ids.
- Added per-module `surfacePlacement` metadata so each exported module now declares whether it belongs on the Vietnam country hub or remains off-hub.
- Added a canonical fenced JSON contract block to `docs/website/PHRASE_AUDIO_DELIVERY.md`, wrapped in explicit markers so the validator can read it back.
- Hardened `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` to fail on:
  - `manifest.moduleCount` drift
  - missing or drifted `surfaceContract` metadata
  - drift between the manifest contract and the canonical doc contract block
  - duplicate or overlapping hub/off-hub module ids
  - wrong `surfacePlacement` on any manifest module
  - manifest/module `familyCount` mismatches
  - manifest/module/article parity drift across `articleUrl`, `articleReference.secondaryUrl`, `cta.secondaryUrl`, and phrase `websiteReferences.articleUrl`
  - non-`starter` phrase leakage into the website preview seam
- Updated `docs/website/PHRASE_AUDIO_DELIVERY.md` so the durable doc matches the machine-checkable contract.

## Verification

- `site/data/phrase-previews/manifest.json` SHA-256: `F1852839638C0E4A4B5CF12060601A9115CACDED191A6FE6C47BA22F65F12E29`
- `site/public/data/phrase-previews/manifest.json` SHA-256: `F1852839638C0E4A4B5CF12060601A9115CACDED191A6FE6C47BA22F65F12E29`
- The two manifest copies are byte-identical after the contract update.
- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed after the hardening pass.

## Outcome

The Viet website seam is still export-driven and starter-only, but the on-hub versus off-hub split is now explicit in export metadata and enforced by the validator instead of living only in doc prose.

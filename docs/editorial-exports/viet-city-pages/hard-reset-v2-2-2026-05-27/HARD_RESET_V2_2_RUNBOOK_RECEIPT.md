# SpeakLocal City Pages Hard Reset v2.2 Runbook and Receipt

Date: 2026-05-27

Scope: hard-reset launch wrapper, gate definitions, calibration list, and receipt trail for the V2.2 city/place reset.

This file is the launch wrapper for the city-pages hard reset. It does not approve copy by itself or replace `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`. The current final receipt for the executed reset lives at `HARD_RESET_V2_2_FINAL_RECEIPT.md`.

## Non-Negotiables

- No listing can be `FINAL_PASS` from legacy `city-v1` fields alone.
- No validator-only production claims. Validators, audits, and chunk checks are necessary evidence, not release approval.
- No 500 shortcut if inventory is 500+. The full inventory still needs scoped counts, sampled rendered proof, phone proof, exclusions, and four final signoffs.
- A page is not production-ready until current v2.2 authority, editorial voice, data/catalog/audio mapping, and native runtime/release proof all pass.

## Future Launch Prompt

Use this exact prompt to start the next hard-reset production session:

```text
You are the SpeakLocal city-pages hard-reset production lead. Work in /Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages. Preserve unrelated dirty files and do not revert other agents' changes.

Scope: promote the current Viet city/place inventory to v2.2 FINAL_PASS only if every required gate passes. Do not edit generated legacy runtime files as approval authority. If implementation is reopened, edit first-class V2.2 source, then project/regenerate/validate. Start by reading docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md, docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md, docs/design/city-pages/V2_2_SCREENSHOT_REVIEW_GATE.md, and this runbook.

For any inventory of 500+ listings, do not claim production readiness from validators alone and do not use a 500 shortcut. Record the inventory count, source/runtime provenance, exact commands and outputs, screenshot folder, physical iPhone build/install/launch proof, exclusions, and four FINAL_PASS signoffs: Authority/Scope, Editorial Voice, Data/Catalog/Audio, Native Runtime/Release.
```

## Gate 1: Authority / Scope

- Current authority read: `CURRENT_CITY_PAGE_STANDARD.md`.
- Production gate read: `V2_2_PRODUCTION_REVIEW_GATE.md`.
- Screenshot gate read: `V2_2_SCREENSHOT_REVIEW_GATE.md`.
- Inventory scope recorded with exact count, city coverage, page ID range, and exclusions.
- Worktree, branch, commit, and dirty-state note recorded.
- Legacy `city-v1` fields are treated as input evidence only, not final approval truth.
- `FINAL_PASS` is blocked unless the page or inventory proves v2.2 source shape, story spine, phrase cards, rendered proof, and release evidence.

Signoff: `FINAL_PASS / REVISE / FAIL`

## Gate 2: Editorial Voice

- Each listing has one owned traveler moment.
- Each listing has one truthful story spine in the intro or an early module.
- Visible copy reads like a compact travel briefing, not schema, metadata, QA, or production notes.
- No visible legacy/process labels such as `Reader View`, `Sections`, `Phrase cards`, `check_catalog`, `render`, `reason`, score, source, freshness, row, surface, content role, or destination-role language.
- Restaurant and cafe pages keep concrete room, menu, drink, table, counter, or service cues.
- Similar pages do not share a repeated house cadence unless the place evidence genuinely demands it.
- The 12 gold pages below were used as calibration before broad approval.

Signoff: `FINAL_PASS / REVISE / FAIL`

## Gate 3: Data / Catalog / Audio

- Source files and generated runtime files are named.
- Inventory count matches source, generated resources, SQLite/runtime, and review receipt.
- Every useful phrase card has phrase ID, audio ID/status, and render status.
- Unsupported one-off Vietnamese is hidden, queued, or marked for native-speaker/audio follow-up; it is not rendered as final audio-backed copy.
- Mentioned Here and related cards have real openable targets, user-facing `displaySubtitle`, internal `reason`, and status.
- No internal catalog/status fields render in visible UI.
- Missing audio, planned audio, new phrase needs, and hero-image exclusions are counted and explicitly separated from release blockers.

Signoff: `FINAL_PASS / REVISE / FAIL`

## Gate 4: Native Runtime / Release

- Native resources were regenerated from approved source when implementation scope is open.
- Runtime validators were run and outputs captured.
- Focused native tests were run and outputs captured.
- Fresh rendered screenshots cover the target scope, including top and scrolled states.
- Screenshot review confirms phrase cards, sections, Mentioned Here/related modules, top chrome, sticky audio, and bottom chrome.
- Physical iPhone proof is separated into build, install, and launch results.
- Signing files remain clean of personal team/provisioning data.
- Release exclusions are named, owned, and confirmed non-blocking.

Signoff: `FINAL_PASS / REVISE / FAIL`

## 12 Gold-Page Calibration List

Use these as the taste and proof spread before approving large inventory. They are calibration anchors, not automatic pass examples.

| Category | Gold page | What it tests |
|---|---|---|
| Museum | Museum of Cham Sculpture | Museum-fatigue prevention, exhibit anchors, calm route. |
| Museum | Da Nang Museum | Verification-heavy civic/history copy without overclaiming. |
| Market | Chợ Hàn / Hàn Market | First-bearings market, gifts, food mentions, phrase and card mapping. |
| Market | Chợ Cồn | Food-first market contrast, snack specificity, not duplicating Hàn. |
| Cafe | Cà phê Giảng | Ritual plus origin story, first-order confidence, compact history. |
| Cafe | The Note Coffee | Touristy ritual without shame, physical sequence, crowd expectation. |
| Restaurant | Bà Lễ Well / Bale Well | Shared-table ordering, set-menu confidence, Hội An specificity. |
| Restaurant | Morning Glory Original | Controlled first meal, broad menu restraint, restaurant evidence. |
| Landmark | Dragon Bridge / Cầu Rồng | One real decision, schedule risk, viewpoint/wet-side tradeoff. |
| Transport | Đà Nẵng International Terminal | Arrival/pickup sequence, transport phrases, phone-proof relevance. |
| Shopping | Đường Đồng Khởi | Shopping/street spine, route clarity, old-new city texture. |
| Weather / Outdoor | Vườn quốc gia Bạch Mã | Weather, access, shoes, route, condition-dependent outdoor proof. |

## Final Receipt Template

```md
# City Pages Hard Reset v2.2 Final Receipt

Date:
Reviewer:
Worktree:
Branch:
Commit:
Dirty-state note:

## Inventory

Total listings reviewed:
FINAL_PASS listings:
REVISE listings:
FAIL listings:
Cities covered:
Page ID ranges or manifest:
Inventory is 500+:
500 shortcut used: no

## Sources and Runtime

Source files:
Generated runtime files:
SQLite/runtime files:
Review docs:
Ledger/report files:

## Commands and Output

Command:
Output:

Command:
Output:

Command:
Output:

## Screenshot Proof

Screenshot folder:
Simulator:
Sample/page coverage:
Top-state screenshots:
Scrolled-state screenshots:
Issues found:
Result:

## Phone Proof

Device class:
Build result:
Install result:
Launch result:
Signing scan result:
Notes:

## Exclusions and Non-Blocking Backlog

Excluded files/surfaces:
Missing or planned audio:
Hero/image backlog:
Freshness follow-ups:
Known non-blockers:
Blocking unresolved items:

## FINAL_PASS Signoffs

Authority / Scope: FINAL_PASS / REVISE / FAIL
Editorial Voice: FINAL_PASS / REVISE / FAIL
Data / Catalog / Audio: FINAL_PASS / REVISE / FAIL
Native Runtime / Release: FINAL_PASS / REVISE / FAIL

Final decision: FINAL_PASS / REVISE / FAIL
Promotion status:
Next owner:
```

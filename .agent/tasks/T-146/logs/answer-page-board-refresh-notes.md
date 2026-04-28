# T-146 answer-page board refresh notes

## What changed

- extended `app/scripts/capture-design-preview.ts` so captures can replay workflow-owned interaction recipes, keep richer state/provenance metadata, and report interactive proof runs cleanly
- rebuilt `app/scripts/generate-design-board.ts` around proof-oriented board sections and explicit answer-state targets instead of treating the phrase route as one generic tile
- refreshed `app/docs/app-preview-wireframes.md` so the board workflow now documents section grouping plus route-and-action provenance for repeated `/design-preview/phrase` captures
- regenerated `app/artifacts/design-boards/latest/` after the new interaction-aware board workflow landed

## Runtime facts from this pass

- local loopback review surface `http://127.0.0.1:18790` was available throughout the task
- latest board refresh summary:
  - `19` targets
  - `19` captures rendered
  - `0` failed tiles
- answer-state coverage now includes:
  - default `/design-preview/phrase`
  - same-page hero swap
  - deeper linked-page open
  - shell/search states from both preview and deterministic live seams

## Commands run

```powershell
$env:NODE_PATH='E:\AI\SpeakLocal-App-Family\app\node_modules'
npx --prefix E:\AI\SpeakLocal-App-Family\app tsx scripts\generate-design-board.ts --dashboard-url http://127.0.0.1:18790 --device iphone-15-pro
```

```powershell
$env:NODE_PATH='E:\AI\SpeakLocal-App-Family\app\node_modules'
npx --prefix E:\AI\SpeakLocal-App-Family\app tsx scripts\capture-design-preview.ts --route /design-preview/phrase --dashboard-url http://127.0.0.1:18790 --out artifacts\design-boards\debug\answer-hero-swap.png --interaction-plan-base64 <hero-swap plan>
```

```powershell
$env:NODE_PATH='E:\AI\SpeakLocal-App-Family\app\node_modules'
npx --prefix E:\AI\SpeakLocal-App-Family\app tsx scripts\capture-design-preview.ts --route /design-preview/phrase --dashboard-url http://127.0.0.1:18790 --out artifacts\design-boards\debug\linked-open-pharmacy.png --interaction-plan-base64 <linked-page plan>
```

```powershell
$env:NODE_PATH='E:\AI\SpeakLocal-App-Family\app\node_modules'
npx --prefix E:\AI\SpeakLocal-App-Family\app tsc --noEmit
```

## Validation note

- board regeneration passed after the interaction-aware refresh landed
- targeted hero-swap and linked-page captures also passed once the `scroll-top` helper and hero-swap proof were tightened
- broad `npx --prefix E:\AI\SpeakLocal-App-Family\app tsc --noEmit` still fails in this dependency-thin worktree because local `node_modules` is absent and the worktree `tsconfig.json` cannot resolve `expo/tsconfig.base`

## Review note

- Gate 2 pass 1 surfaced one real blocker: the hero-swap proof originally waited on text that already existed on the pre-click card
- resolved by changing the hero-swap recipe to wait for the swap-only detail string `Adds urgency without becoming long or hard to say.` and by adding an output-path guard to the board cleaner before rerunning the artifact successfully

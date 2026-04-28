# T-138 design board workflow notes

## What changed

- extended `app/scripts/capture-design-preview.ts` so single-route captures now emit richer JSON metadata and can record success or failure without losing the route context
- added `app/scripts/generate-design-board.ts` to parse the current `design-preview` slide list and `design-live` preset list, capture the full set, and render a static `index.html` plus `manifest.json`
- added `generate:design-board` to `app/package.json`
- documented the refresh workflow in `app/docs/app-preview-wireframes.md`
- recorded the new durable review-board seam in `docs/DECISIONS.md`

## Working command used here

```powershell
$env:NODE_PATH='E:\AI\SpeakLocal-App-Family\app\node_modules'
npx --prefix E:\AI\SpeakLocal-App-Family\app tsx scripts/generate-design-board.ts
```

## Runtime facts from this run

- local loopback review surface `http://127.0.0.1:18790` was available and did not require a dashboard token
- hosted `https://dashboard.jayopsai.com` rejected unauthenticated capture attempts in this session
- generated board summary:
  - `17` targets
  - `17` captures rendered
  - `0` failed tiles
- generated artifact root:
  - `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\artifacts\design-boards\latest`

## Validation note

- the new board-generation workflow ran successfully and produced the required artifact set
- `npx --prefix E:\AI\SpeakLocal-App-Family\app tsx scripts/generate-design-board.ts` passed in the dependency-thin worktree without local package installation
- `npx --no-install tsc --noEmit` passed after temporarily binding `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\node_modules` to the canonical `E:\AI\SpeakLocal-App-Family\app\node_modules` for validation, then removing that temporary junction again
- `npm run generate:design-board -- --dashboard-url http://127.0.0.1:18790 --device iphone-15-pro` also passed while that temporary dependency junction was in place

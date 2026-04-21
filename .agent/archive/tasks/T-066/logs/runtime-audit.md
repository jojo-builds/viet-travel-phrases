# T-066 Runtime Audit

## Scope

Bounded Vietnam website runtime audit for the starter preview seam only:

- loader: `site/scripts/phrase-module-loader.js`
- manifest: `site/data/phrase-previews/manifest.json`
- module payloads: `site/data/phrase-previews/vietnam-*.json`
- site audio: `site/data/phrase-audio/vietnam/*.mp3`
- live host pages:
  - `site/index.html`
  - `site/countries/vietnam.html`
  - `site/countries/vietnam/index.html`
  - `site/blog/phrases-tourists-actually-need-in-vietnam.html`
  - `site/blog/phrases-tourists-actually-need-in-vietnam/index.html`
  - `site/blog/vietnam-first-24-hours.html`
  - `site/blog/vietnam-first-24-hours/index.html`
  - `site/blog/vietnam-grab-taxi-confusion.html`
  - `site/blog/vietnam-grab-taxi-confusion/index.html`
  - `site/blog/vietnam-sim-esim-offline-setup.html`
  - `site/blog/vietnam-sim-esim-offline-setup/index.html`

Out of scope:

- upstream `content-draft/viet/**` repair unless runtime evidence proves the defect starts there
- `app/**` or `app/assets/audio/**` repair
- release, TestFlight, or ops surfaces

## Prior context kept bounded

- `T-015` already closed the export-seam integrity question.
- This audit only extends into runtime-facing fetch paths, host-page module loading assumptions, and site-audio reachability.

## Validation checklist

1. Confirm the website preview selection layer still matches the exported manifest.
2. Confirm each live host page mounts only manifest-backed Vietnam starter modules.
3. Confirm the loader still expects the current manifest and payload contract.
4. Confirm all exported module payloads exist in both `site/data` and `site/public/data` and stay byte-identical.
5. Confirm every exported `audioUrl` resolves to a real site-owned file.
6. Confirm the full manifest -> payload -> audio chain returns `200` over local HTTP, not just on-disk existence.

## Evidence gathered

- `content-draft/viet/website-preview.json` and `site/data/phrase-previews/manifest.json` both list the same 7 module ids in the same order:
  - `vietnam-essential-basics`
  - `vietnam-arrival-basics`
  - `vietnam-transport-basics`
  - `vietnam-money-basics`
  - `vietnam-phone-basics`
  - `vietnam-understanding-repair`
  - `vietnam-food-drink-basics`
- `site/scripts/phrase-module-loader.js` still loads `/data/phrase-previews/manifest.json`, then resolves module payloads by manifest `path`, then renders phrase cards and `<audio>` players from phrase-level `audioUrl`.
- Live Vietnam host-page references remain bounded and manifest-backed:
  - home page mounts `vietnam-essential-basics`
  - Vietnam hub mounts `vietnam-arrival-basics`, `vietnam-transport-basics`, `vietnam-money-basics`, `vietnam-phone-basics`
  - Vietnam phrase guide mounts all 7 modules
  - first-24-hours mounts `vietnam-arrival-basics` and `vietnam-phone-basics`
  - Grab/taxi page mounts `vietnam-transport-basics` and `vietnam-money-basics`
  - SIM/eSIM page mounts `vietnam-phone-basics`
  - paired `.html` and routed `index.html` Vietnam outputs remain duplicate runtime surfaces, not divergent module configurations
- All 7 payloads exist under both:
  - `site/data/phrase-previews/`
  - `site/public/data/phrase-previews/`
- Manifest and payload copies are byte-identical across `site/data` and `site/public/data`.
- Every payload currently declares `websiteAudioStatus: "ready"` and `audioStatus: "ready"`.
- Every phrase with `audioUrl` resolves to a real file under both:
  - `site/data/phrase-audio/vietnam/`
  - `site/public/data/phrase-audio/vietnam/`
- Local static-server HTTP validation passed for:
  - manifest: 1/1 `200`
  - module payloads: 7/7 `200`
  - exported audio URLs: 28/28 `200`

## Findings

- No bounded website defect was found in the current Vietnam starter runtime fetch chain.
- The runtime-facing seam is internally consistent:
  - host pages reference real module ids
  - manifest entries point to real payloads
  - payload phrase-level `audioUrl` values point to real site files
  - the same paths serve successfully over HTTP from the built `site/` tree
- The earlier PowerShell mojibake concern is a terminal encoding/display issue, not on-disk JSON corruption. Python UTF-8 reads confirm the Vietnamese strings decode correctly.

## Repair decision

No `site/**` repair was required for this task.

The honest outcome is a no-repair runtime audit with durable evidence proving:

- the current Vietnam starter preview fetch path works
- the current module-host assumptions match the manifest
- the currently exported site audio paths are reachable

## Residual risk

- This audit validates the static website seam and local HTTP reachability. It does not prove CDN behavior, browser autoplay policy, or third-party hosting headers.
- If a future defect appears, it is more likely to be deployment drift or future export changes than a current runtime-path bug in the reviewed surfaces.

# Website Live/Staging Workflow

Last updated: 2026-04-15
Status: current truth from repo/docs/local evidence

## Verified facts

- Live website domain: `https://speaklocal.app/`
- Canonical local website artifact for this repo: `E:\AI\SpeakLocal-App-Family\site`
- Public staging review URL: `http://speaklocal.app:8081/`
- Public raw-IP staging fallback: `http://38.247.143.2:8081/`
- Live Caddy config path: `C:\Users\Administrator\Caddyfile`
- Live deployment root served by Caddy: `E:\AI\Shared\Deployments\speaklocal-site\live-current`
- Staging deployment root served by Caddy: `E:\AI\Shared\Deployments\speaklocal-site\staging-current`
- Staging and live now serve deployment copies, not the repo working tree directly
- Website preview export command exists:
  - `cd app`
  - `npm run export:website-previews`
- Website preview export writes into:
  - `site/public/data/phrase-previews/`
  - `site/data/phrase-previews/`
- Deployment manifests are written to:
  - staging: `/__deployment.json`
  - live: `/__deployment.json`

## Current interpretation

- `site/` is the editable local artifact for new website passes
- local preview, staging review, and live now have distinct surfaces
- staging is intentionally separate from live by URL and deployment root
- live promotion should happen only from the staged deployment copy, not from the repo working tree
- legacy `docs/*.html` remains historical residue and is not the staging lane for the richer site
- older direct-to-repo live serving through `E:\AI\Viet-Travel-Phrases\site` is no longer the intended workflow truth
- the adjacent source-repo deploy path in `E:\AI\SpeakLocal-Platform-OS\marketing\site` still targets the legacy direct path and should not be treated as the live publish lane until it is explicitly rewired

## Exact workflow

1. Treat `site/` as the staging artifact for new website work.
2. Do not treat `docs/*.html` as the target for new conversion passes or as a reliable fallback in this worktree.
3. Keep any edited route pairs in sync:
   - `foo.html`
   - `foo/index.html`
4. If phrase-preview data changes, regenerate it from `app/` instead of hand-editing generated JSON.
   - current export mirrors into both `site/public/data/phrase-previews/` and direct-serve `site/data/phrase-previews/`
5. Validate the static bundle locally before calling it ready.
   - from repo root:
     - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Test-SpeakLocalWebsiteArtifact.ps1`
   - do not use `file://`
   - local preview:
     - `py -m http.server 4173 --directory site`
   - then review `http://127.0.0.1:4173/`
6. Publish the artifact to the real staging surface.
   - from repo root:
     - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Publish-SpeakLocalWebsiteStaging.ps1`
   - review:
     - `http://speaklocal.app:8081/`
     - `http://38.247.143.2:8081/`
   - staging adds `X-Robots-Tag: noindex, nofollow, noarchive` at the host layer so the review lane is not the live SEO lane
7. Promote the same staged artifact to live only after review signoff.
   - from repo root:
     - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Promote-SpeakLocalWebsiteLive.ps1`
   - verify:
     - `https://speaklocal.app/`
     - `https://www.speaklocal.app/`
8. Use the live backup root for rollback if a promotion needs to be undone.
   - backups live under:
     - `E:\AI\Shared\Backups\speaklocal-site\`

## Surface meanings

- local preview:
  - serves directly from the repo working artifact
  - use this for local author QA only
- staging:
  - serves from `E:\AI\Shared\Deployments\speaklocal-site\staging-current`
  - use this for human review and remote inspection
  - this is the only legal pre-live review surface for the current artifact
- live:
  - serves from `E:\AI\Shared\Deployments\speaklocal-site\live-current`
  - only update this surface by promoting the staged artifact

## Current cautions

- do not assume `site/` is a clean authoring source tree
- do not edit the deployment roots directly
- do not reintroduce stale source-unbacked preview JSON
- do not treat `E:\AI\Viet-Travel-Phrases\site` as the live publish root anymore
- do not use legacy `docs/*.html` as the richer-site fallback
- do not describe a local-only `site/` edit as live or reviewed until it has been published to the staging URL

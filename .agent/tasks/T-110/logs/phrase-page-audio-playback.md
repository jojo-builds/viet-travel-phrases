# T-110 Phrase-Page Audio Playback Audit

## Scope

- bounded surface: Viet starter export playback seam only
- kept inside `site/**`, `docs/website/PHRASE_AUDIO_DELIVERY.md`, and `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- no `app/**`, `ops/**`, `docs/operations/**`, or unrelated country-route files edited

## What changed

- `site/scripts/phrase-module-loader.js`
  - added explicit playback opt-in through `data-phrase-audio-mode="playback"`
  - kept module hydration shared, but limited embedded `<audio controls>` and playback-speed UI to playback-enabled wrappers
  - changed non-playback surfaces to keep site-audio readiness visible while replacing embedded players with a bounded “Playback lives on the Viet phrase pages” message
- Viet phrase/article surfaces now opt into playback on both flat and routed copies:
  - `site/blog/phrases-tourists-actually-need-in-vietnam.html:221`
  - `site/blog/phrases-tourists-actually-need-in-vietnam/index.html:221`
  - `site/blog/vietnam-first-24-hours.html:141`
  - `site/blog/vietnam-first-24-hours/index.html:141`
  - `site/blog/vietnam-grab-taxi-confusion.html:141`
  - `site/blog/vietnam-grab-taxi-confusion/index.html:141`
  - `site/blog/vietnam-sim-esim-offline-setup.html:141`
  - `site/blog/vietnam-sim-esim-offline-setup/index.html:141`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
  - documented that playback scope is narrower than export scope
  - named the exact approved Viet phrase/article playback surfaces
  - clarified that home and the Vietnam hub remain preview-first
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
  - added `Test-SpeakLocalPhrasePlaybackScope`
  - validator now fails if `data-phrase-audio-mode="playback"` drifts outside the approved Viet phrase/article files

## Validation

Command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\website\Test-SpeakLocalWebsiteArtifact.ps1
```

Result:

- `Route-pair parity passed.`
- `Internal link integrity passed.`
- `Preview JSON parity and phrase/audio schema checks passed.`
- `Preview audio parity passed.`
- `Phrase playback scope passed.`
- `SpeakLocal website artifact validation passed for E:\AI\SpeakLocal-App-Family\site`

## Working conclusion

- embedded on-demand playback is now explicit and bounded to the current Viet phrase/article surfaces
- home and the Vietnam hub still show starter-export readiness without silently becoming playback surfaces
- the validator now protects this boundary from future drift

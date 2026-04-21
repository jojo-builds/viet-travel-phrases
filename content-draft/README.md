# Content Drafts

This folder holds per-language authored content lanes.

Use these lanes for:

- scenario planning
- source phrase drafting
- pronunciation cleanup
- audio posture decisions
- website-preview slice approval

Safe parallel-work boundary:

- new languages should start in `content-draft/<variant>`
- dashboard visibility should start in `ops/apps/<variant>.json`
- do not touch `app/family/*` for a new language until the draft lane is materially ready
- runtime-backed variants can still keep their authored source of truth here once they move onto the generated-pack path

Current lanes:

- `viet` - active runtime-backed v2 content source
- `tagalog` - active onboarding target
- `spanish` - prep lane
- `italian` - prep lane
- `japanese` - prep lane
- `turkish` - prep lane

Primary commands from `E:\AI\SpeakLocal-App-Family\app`:

- `npm run scaffold:language-prep -- --variant <variant> --language "<language>" --country "<country>" --language-code <code> --display-name "<display name>"`
- `npm run build:pack -- --variant <variant>`

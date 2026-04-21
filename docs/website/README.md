# Website Docs

Use this folder for durable website-side product and workflow truth that supports the SpeakLocal app-family direction.

Read in this order:

1. `docs/website/ALIGNMENT_PLAN.md`
2. `docs/website/LIVE_STAGING_WORKFLOW.md`
3. `docs/website/PHRASE_AUDIO_DELIVERY.md`

Current intent:

- keep the website destination-first, app-aligned, phone-forward, and responsive on desktop
- expose the same starter/free phrase layer on the website that the app exposes for each destination
- use destination articles to reinforce and route back into those same starter phrases
- treat the website as a gateway into the app rather than a disconnected marketing site or a separate product
- keep the app as the fuller searchable/playable travel utility and the first premium sales surface
- keep premium app-first for now, with no website premium, login/account architecture, cross-platform entitlement sync, or code-redemption flow
- support the Viet-first monetization story without pretending non-live lanes already have install-ready apps
- keep new website work landing in `site/`, publish that artifact to staging at `http://speaklocal.app:8081/`, and only then promote the staged bytes to live

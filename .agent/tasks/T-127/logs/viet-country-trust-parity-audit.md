# Viet country-route trust parity audit

## Final contract

- The Vietnam country hub now says the same thing on both routes: start on-web with four live pressure points only.
- The four on-hub starter modules remain arrival, transport, money, and phone.
- Essentials, repair, and food are now called out consistently as off-hub follow-on surfaces on the phrase guide and in the app handoff.
- App-depth copy stays framed as app scope, not website scope.
- The install pitch now reads as escalation to deeper backup once the starter preview stops covering the live problem.

## What changed

- Tightened the backup card so the app handoff starts when the four hub starters stop covering the live problem.
- Rewrote the phrase-library scope note to say the hub is limited to four selected starter preview modules.
- Kept the starter-preview note and module note explicit about essentials, repair, and food staying off-hub.
- Tightened the spotlight trust card so the site promise is four selected starter preview modules, not a broader web layer.
- Reframed the situation-grid heading and support note around four live web pressure points plus off-hub follow-ons.
- Demoted repair and food in the situation grid to explicit off-hub follow-on cards instead of peer on-hub coverage.

## Validation

- `site/countries/vietnam.html` and `site/countries/vietnam/index.html` remain byte-identical after the copy pass.
- Verified parity via matching SHA-256 hashes:
  - `6AA4D48BC63EA154F4127D54C92C12246F91A7EC811FD0DC73E290DBB37CF6FF`
- Gate 1 pass 01: blocked on the situation grid overstating peer web coverage for repair and food.
- Gate 2 pass 01: unanimous `APPROVE` after the off-hub follow-on hardening pass.

## Residual note

- The page still references app depth counts, but the surrounding copy now explicitly anchors those numbers to app scope and keeps the public web promise bounded to the approved four-module starter surface.

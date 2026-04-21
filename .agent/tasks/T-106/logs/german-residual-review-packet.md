# Germany Residual Review Packet

## Release posture

- Germany is prep-only and closed for now.
- Do not reopen the translation queue for already resolved rows.
- Reopen this lane only if native or expert review arrives and changes one of the explicit dispositions below.

## Exact residual packet

### 1. Deferred native-review handoff

| phrase_id | current state | exact disposition |
| --- | --- | --- |
| `german-coffee-shop-4` | untranslated, `deferred-native-review` | Keep out of active coverage until later cafe-context evidence proves either retirement or a stronger Germany-fit replacement. |

### 2. Runtime-blocked expert review

| phrase_id | current state | exact disposition |
| --- | --- | --- |
| `german-simple-problems-6` | translated, medically sensitive | Keep for prep reference only; require expert medical review before any runtime-safe or polished-lane claim. |

### 3. Keep-translated, review-visible before runtime graduation

| review lane | phrase_ids | exact disposition |
| --- | --- | --- |
| Service wording | `german-polite-basics-5`, `german-grab-taxi-1`, `german-simple-problems-3`, `german-hotel-hostel-2`, `german-grab-taxi-3`, `german-convenience-store-7`, `german-simple-problems-7`, `german-coffee-shop-7`, `german-hotel-hostel-7`, `german-convenience-store-5`, `german-grab-taxi-4` | Keep translated and review-visible; later native review should confirm short service phrasing before runtime graduation claims. |
| Transit wording | `german-grab-taxi-2`, `german-directions-1`, `german-directions-5`, `german-directions-6` | Keep translated and review-visible; later native or expert review should confirm traveler-safe station and route-guidance wording. |
| Context wording | `german-simple-problems-4` | Keep translated and review-visible; later review can confirm whether the forgotten-item reading remains the best default nuance. |

### 4. Keep-translated, closed for now unless native register review arrives

| register lane | phrase_ids | exact disposition |
| --- | --- | --- |
| Politeness register | `german-polite-basics-1`, `german-polite-basics-3`, `german-polite-basics-6`, `german-polite-basics-7` | Keep translated, do not reopen drafting, and run a later native register check only if Germany polish work resumes. |
| Social register | `german-small-talk-1`, `german-small-talk-2`, `german-small-talk-3`, `german-small-talk-4`, `german-small-talk-5`, `german-small-talk-6`, `german-small-talk-7` | Keep translated, do not reopen drafting, and run a later native register check only if a polished social layer becomes important. |

## Notes

- Removed stale `rewrite-before-translation` review flags from rows whose rewrite work is already complete and no longer part of the residual packet.
- Promoted the still-sensitive directions follow-up rows into the transit packet so the CSV review flags now match the prose caution.
- Promoted the translated politeness and social sweep into an explicit native-register packet so the lane no longer implies those rows are fully polished.

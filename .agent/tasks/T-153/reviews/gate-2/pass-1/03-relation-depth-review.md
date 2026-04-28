# Gate 2 Pass 1 - Relation Depth Review

Approval: BLOCK

The bounded-subset framing is good, and the default / quick-say plus repair / escalation rails are mostly present, but the `likelyReply` layer is not yet modeled honestly enough. Several selected hubs currently use `likelyReply` for the traveler's own next phrase or a broader follow-up move rather than a likely thing the traveler would actually hear back.

Blockers:
- `tagalog-medical-doctor` used `tagalog-simple-problems-14` as `likelyReply`.
- `tagalog-grab-taxi-10` used `tagalog-asking-price-8` as `likelyReply`.
- `tagalog-asking-price-8` used `tagalog-asking-price-12` as `likelyReply`.
- `tagalog-directions-11` and `tagalog-simple-problems-8` used traveler-action rails as `likelyReply`.

Required fix:
- Reserve `likelyReply` for true heard-back or acknowledgment-style response rails, or explicitly redefine the bucket if broader follow-up behavior is intended.

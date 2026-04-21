Summary: The explicit scope is correct for this pass. `app/lib/searchPhrases.ts` and `app/lib/homeSearchState.ts` contain the shared matcher/query handling and are appropriately kept read-only, while `app/family/presentation/tagalog.ts` is the only app file here that carries Tagalog search copy and other presentation text that could be adjusted without touching normalization logic.

Risks: The main risk is scope creep in the audit narrative: if the writeup implies the matcher was changed or hardware-proofed, it would overstate what this pass can verify. The audit should stay explicit that normalization behavior is deterministic, sandbox-limited, and not device-validated.

Recommendation: Proceed with the bounded scope exactly as stated: matcher read-only, audit the normalization behavior and sandbox limits, and allow edits only in Tagalog search copy plus the required task/docs artifacts.

Approval: APPROVE

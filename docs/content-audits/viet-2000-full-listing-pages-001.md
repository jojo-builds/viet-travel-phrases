# Viet 2000 Full Listing Pages Audit 001

Date: 2026-04-29
Status: BLOCKED before content expansion

## Summary

This audit blocks `TASK-VIET-2000-FULL-LISTING-PAGES-001` under the revised page-by-page authored plan.

The current repo can verify the existing Viet universe, but it does not yet contain the required authored source for a 2,911-page canonical listing graph:

- Source phrase rows: `919`.
- Canonical SQLite phrase pages: `911`.
- Authored page rows in the SQLite fixture: `164`.
- Lower-depth SQLite page statuses remaining: `818`.
- Current Tier 1 authored audit: `150` strong pages, `0` thin/awkward/placeholder/over-templated/negative/missing-link pages.
- Missing audio rows in the current SQLite fixture: `0`.

The requested task requires at least `2,000` net-new, page-by-page authored canonical pages. Producing those pages through a bulk phrase/content generator would violate the accepted plan and Jojo's explicit direction. No bulk-generated content was committed.

## Evidence

Current validation commands run:

```bash
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js
(cd app && npm exec --package=tsx -- tsx scripts/validate-family-variants.ts)
```

Key validation output:

- Tier 1 validator: `strong: 150`, all failure categories `0`.
- SQLite validator: `sourcePhrases: 919`, `canonicalPages: 911`, `resolvedPhrases: 919`, `missingAudioAuditRows: 0`, `bannedFileMatches: 0`.
- SQLite generator test: `pass 1`, `fail 0`.
- Family variant validation: passed.

Read-only SQLite count:

```text
phrase_page count: 911
lower-depth statuses: 818
authored pages: 164
```

## Natural Expansion Candidates Found

The `Xin chào` article already demonstrates the correct page-first expansion pattern. It naturally teaches the following phrases, and exact audio already exists, but these phrases are not yet canonical rows in `content-draft/viet/phrase-source.csv`:

| Phrase | Exact audio key | In phrase source |
| --- | --- | --- |
| Chào bạn | `audio-phrase-chao-ban` | no |
| Dạ, chào anh/chị | `audio-phrase-da-chao-anh-chi` | no |
| Alô | `audio-phrase-alo` | no |
| Chào buổi sáng | `audio-phrase-chao-buoi-sang` | no |
| Chào buổi chiều | `audio-phrase-chao-buoi-chieu` | no |
| Chào anh | `breakdown-viet-hello-anh-full` | no |
| Chào chị | `breakdown-viet-hello-chi-full` | no |
| Chào em | `breakdown-viet-hello-em-full` | no |
| Chào ông | `breakdown-viet-hello-ong-full` | no |
| Chào bà | `breakdown-viet-hello-ba-full` | no |
| Chào chú | `breakdown-viet-hello-chu-full` | no |
| Chào cô | `breakdown-viet-hello-co-full` | no |
| Đi đâu đấy? | `audio-phrase-di-dau-day` | no |
| Rất vui được gặp bạn | `audio-phrase-rat-vui-duoc-gap-ban` | no |

These are good first page-by-page candidates for the next authoring pass because they were discovered by reading the existing flagship page, not by generating a phrase list first.

## Blocker

The current authored-page generator owns only the Tier 1 authored surface and rewrites `content-draft/viet/listing-pages/**` from generator code. Editing generated listing-page JSON directly would not be durable. Appending thousands of phrase rows without writing and validating their pages would create the exact low-quality content problem this task is meant to avoid.

The largest safe subset for this run is therefore a blocked audit/result artifact with verified current counts and a concrete first set of natural page-first candidates. No content expansion was committed because no subset could be promoted without either generated prose, orphan canonical rows, or non-durable hand-edited generated resources.

## Required Next Step

Before attempting the 2,000-page authored expansion again, create the durable authored-source contract for full-universe pages:

- a source directory that is never overwritten by the Tier 1 generator;
- an AI-authored rationale record for every page;
- a validator that rejects any phrase row without an authored page and rationale;
- an assembler that packages those authored pages into native/app/SQLite resources without generating content.

Then author the first page-by-page batch from the `Xin chào` expansion candidates above.

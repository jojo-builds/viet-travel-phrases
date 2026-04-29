# Viet Compound Phrase Row Audit - 2026-04-30

Status: approved, no splits required in this batch.

Inventory query:
`phrase_page.title` or `phrase_page.english_title` containing slash, `and/or`, Vietnamese `và`, Vietnamese `hoặc`, or `anh/chị`.

Result: 14 suspicious canonical rows reviewed. Each remains a single canonical page because the Vietnamese row is one teachable traveler phrase, one relationship-choice notation, or one practical compound request. No duplicate normalized Vietnamese canonical pages were found.

| Page ID | Vietnamese | English | Decision | Rationale |
| --- | --- | --- | --- | --- |
| `viet-phrase-acknowledge-co` | Có | Yes / there is | Keep unified | One Vietnamese word covers both traveler answers; splitting would create duplicate text. |
| `viet-phrase-acknowledge-duoc` | Được | Okay / that works | Keep unified | One response phrase, two natural English glosses. |
| `viet-phrase-hello-chao` | Chào | Hi / hello | Keep unified | One greeting, two English equivalents. |
| `viet-phrase-hello-chao-ban` | Chào bạn | Hi there / hello friend | Keep unified | One friendly greeting; “friend” is the relationship flavor, not a second phrase. |
| `viet-phrase-hello-da-chao-anh-chi` | Dạ, chào anh/chị | Hello, sir or ma'am | Keep as reviewed relationship-choice notation | The slash marks the adult relationship choice for a service opener. Exact `Dạ, chào anh`/`Dạ, chào chị` style pages already exist nearby, so this page teaches the combined choice without duplicating those pages. |
| `viet-phrase-help-1` | Anh/chị giúp tôi với | Can you help me? | Keep as reviewed relationship-choice notation | One help request with an adult addressee choice. Splitting would be useful only as a future authored pair with separate audio. |
| `viet-phrase-polite-3` | Dạ | Yes / polite acknowledgment | Keep unified | One polite particle with two English explanations. |
| `viet-phrase-polite-5` | Xin lỗi | Excuse me / sorry | Keep unified | One Vietnamese phrase used for both attention and apology. |
| `viet-phrase-repair-4` | Ý anh/chị là cái nào? | Which one do you mean? | Keep as reviewed relationship-choice notation | One clarification question; `anh/chị` is the addressee choice, not two intents. |
| `viet-phrase-repair-english-help` | Anh/chị nói tiếng Anh không? | Do you speak English? | Keep as reviewed relationship-choice notation | One yes/no question with an adult addressee choice. |
| `viet-phrase-repair-number-amount` | Anh/chị vừa nói bao nhiêu? | How much did you say? | Keep as reviewed relationship-choice notation | One repeat-number question with an adult addressee choice. |
| `viet-phrase-v900-dire-navi-can-you-call-this-place-and-ask-for-directions` | Bạn có thể gọi đến nơi này và hỏi đường được không? | Can you call this place and ask for directions? | Keep unified | One practical request; “call and ask” is the single task the traveler needs help with. |
| `viet-phrase-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis` | Có bác sĩ hoặc dược sĩ nói tiếng Anh không? | Is there an English-speaking doctor or pharmacist? | Keep unified | One availability question where either role solves the traveler need. |
| `viet-phrase-v900-loca-serv-ever-task-please-print-it-in-black-and-white` | Vui lòng in nó bằng màu đen và trắng | Please print it in black and white | Keep unified | “Black and white” is a single print setting. |

Reviewer gate:
- Copy/learning flow: APPROVED. The rows are intentional lessons, not accidental combined lessons; each phrase has one learner intent.
- Technical/canonical: APPROVED. The reviewed set is now validator-allowlisted, so any future suspicious slash/and-or/dual-pronoun canonical row must be reviewed before validation passes.

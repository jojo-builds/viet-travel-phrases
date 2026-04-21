# Viet High-Risk Phrase Guardrails

Last updated: 2026-04-16
Scope: Viet phrase safety and confidence policy for app, website, and future content lanes when native-human prelaunch review is still incomplete.

## Purpose

This document keeps high-risk Viet phrase work inside a safe, reusable lane.

It is not a rewrite plan, legal guidance, or medical guidance.

Use it to decide:

- what can stay short, simple, and default
- what needs caution framing or nearby fallback support
- what should avoid overconfident wording until native-human review closes the risk

## Current high-risk zones in the live Viet pack

These areas already exist in the current authored/generated pack and deserve stricter handling than ordinary travel phrases:

- `health-pharmacy`
  - current rows include symptoms, doctor/pharmacy requests, allergy language, chronic-condition disclosures, and medicine-related questions
- `emergency-safety`
  - current rows include ambulance, police, hospital, unsafe-situation, theft, passport loss, and official-report language
- `money-numbers-prices`
  - current rows include total disputes, fees, receipts, refunds, ATM failures, and payment clarification
- `food-drink` allergy and ingredient-safety sub-slice
  - current rows include peanut, shellfish, fish-sauce, and ingredient-check language where a wrong phrase can create real safety risk
- `transport`
  - current rows include destination handoff, wrong-route, wrong-car, meter/fare, receipt, and ride correction language
- `airport-border-arrival`
  - current rows include passport/visa handoff, lost luggage reporting, official taxi questions, and written-report language
- `problems-help`
  - current rows include charged-twice, file-a-report, police-station, and insurance-report follow-up
- `understanding-repair`
  - this is not the risky content itself, but it is the main safety layer that keeps risky content from becoming overconfident
- `polite-basics`
  - low direct-harm risk, but still a register-sensitive caution lane because Vietnamese politeness/register can turn a usable phrase into an awkward one if the product overclaims

## Confidence bands

### 1. Safe default

Use as the default visible phrase when the wording is:

- short
- concrete
- action-oriented
- easy to pair with a map, receipt, passport, card, booking, or phone screen
- unlikely to imply expertise or a guaranteed outcome

Typical shapes:

- `Where is ...?`
- `I need ...`
- `Please call ...`
- `Please write it down`
- `Please show me`
- `Take me here`

### 2. Caution required

Allow the phrase, but keep it short and pair it with fallback help when it:

- could trigger an official process
- could escalate conflict
- could create a health or money misunderstanding
- depends on the other person understanding a document, number, route, or symptom correctly
- sounds stronger in English than the product can honestly guarantee in practice

These phrases should usually be paired with one or more of:

- `I don't understand`
- `Please say that again`
- `Please say it slowly`
- `Please write it down`
- `Can you type it on your phone?`
- `Please point to it`
- `Can you show me on the map?`
- `Is there someone who speaks English?`

Neutral request/report phrasing can live in `safe default` or `caution required`.

Accusation, rights, and outcome-claim phrasing should stay secondary-only or review-gated until native-human review closes the gap.

### 3. Do not sound certain

Do not present as confident/default copy when the phrase effectively acts like advice, diagnosis, legal strategy, or an outcome claim.

Until native-human review closes the gap, avoid overconfident wording around:

- dosage or medicine-use instructions
- whether a medicine is safe, compatible, or correct
- legal rights, arrests, liability, or official-procedure claims
- immigration/border explanations with material consequences
- scam accusations or blame-heavy dispute wording
- promises that a phrase will solve an emergency, refund, or police process
- claims about rights, liability, fault, or guaranteed official outcomes

## Area guardrails

## Medical and pharmacy

Safest default:

- short symptom statements
- `I need a doctor`
- `Where is the nearest pharmacy?`
- `Can you call a doctor?`
- `Can you call an ambulance?`

Use caution:

- allergy statements
- pregnancy/chronic-condition disclosure
- medicine compatibility questions
- receipt/report language for insurance

Rules:

- prefer symptom + next step over explanation + diagnosis
- prefer `I need`, `Where is`, `Can you call` over long self-explanations
- do not present medicine-related phrases as treatment advice
- if a medical phrase is promoted on the website or in-app guidance, keep the surrounding copy explicit that SpeakLocal helps the traveler ask for help fast; it does not replace professional medical advice

## Emergency and safety

Safest default:

- `Help!`
- `This is an emergency`
- `Call the police`
- `Call an ambulance`
- `Where is the nearest hospital?`
- `Please take me somewhere safe`

Use caution:

- theft vs. loss distinctions
- passport-loss reporting
- tourist-police wording
- official-report follow-up

Rules:

- default to urgent signal + immediate action
- do not bury the simplest emergency phrase behind longer explanation
- avoid copy that implies the product knows the correct real-world agency, process, or response outcome in every case
- pair emergency content with a nearby repair/escalation phrase whenever practical

## Police, official reporting, and legal-sensitive moments

Safest default:

- `Call the police`
- `Please take me to the police station`
- `I need a report for my lost passport`
- `I need a copy of the report`

Use caution:

- insurance-report phrasing
- tourist-police wording
- any phrase that sounds like a legal claim rather than a practical request

Rules:

- keep these phrases request/report oriented, not rights-assertion oriented
- treat passport, embassy, tourist-police, insurance-report, and official-copy phrases as process-request language only, not as outcome claims
- do not add lawyer/arrest/detention strategy language without stronger review
- do not imply that a phrase guarantees paperwork, reimbursement, or embassy help

## Payment, money, and dispute handling

Safest default:

- `How much is this?`
- `Please write the total down`
- `Can I have a receipt?`
- `What is this fee for?`
- `Is this the final total?`

Use caution:

- `This total is wrong`
- `I was charged twice`
- refund/difference wording
- ATM failure wording

Rules:

- prefer clarification before accusation
- default to total, receipt, fee, or written amount language before stronger dispute language
- keep dispute phrases short and factual
- keep accusation wording such as scams, blame, or agreement disputes secondary-only or review-gated
- avoid scam/blame language as default surface copy without human review

## Food allergy and ingredient safety

Safest default:

- `I am allergic to peanuts`
- `Does this contain peanuts?`
- `Does this have egg or peanuts?`
- `Can you make it without this ingredient?`

Use caution:

- ingredient substitutions
- fish-sauce/shellfish allergy wording
- `Which dish is safest for this allergy?`
- any phrase that can be misread as general dietary preference instead of safety-critical restriction

Rules:

- treat allergy/ingredient phrases as safety content, not ordinary food preference copy
- prefer direct ingredient checks over longer explanations
- when the phrase depends on exact ingredient confirmation, pair it with a showable allergy card, ingredient note, or written fallback when possible
- do not imply the app can verify whether a dish is truly safe; the app can help the traveler ask clearly and confirm again

## Transport and route misunderstanding

Safest default:

- `Take me here`
- `How much is the fare?`
- `Please use the meter`
- `Is this the right pickup point?`
- `This is not my car`
- `This route is wrong`
- `Please turn around`

Use caution:

- official-taxi wording
- long ride instructions
- app-price enforcement wording
- anything that can escalate conflict with a driver

Rules:

- prefer map, address, and route-correction language over spoken directions
- keep transport correction phrases short enough to use under pressure
- default to the phone/map as part of the solution, not speech alone
- avoid long directional sentences as the default phrase when a shown address is safer

## Politeness and register sensitivity

Safest default:

- hello
- thank you
- no, thank you
- excuse me
- sorry
- short respectful acknowledgment

Use caution:

- long formal apologies
- socially strong wording that assumes the right register for every age/status situation
- copy that implies a phrase is universally polite in all Vietnamese contexts

Rules:

- keep default politeness neutral, short, and low-commitment
- do not treat longer English glosses as better or safer by default
- when in doubt, use the shortest socially safe version and let repair language carry the rest

## Repair language is part of the safety system

For high-risk phrase areas, repair/fallback is not optional polish.

Future app, website, and content lanes should keep nearby access to at least some of these:

- `I don't understand`
- `Please say that again`
- `Please say it slowly`
- `Please write it down`
- `Please point to it`
- `Can you show me on the map?`
- `Can you type it on your phone?`
- `Is there someone who speaks English?`

If a high-risk surface cannot realistically support repair, it should stay more conservative in what it promises.

## Wording and presentation rules for future lanes

- Keep the `say-first` phrase shorter than the English explanation around it whenever possible.
- Treat `say-first` as the safest usable travel move, not the most complete English sentence.
- Prefer requests, confirmations, and problem signals over explanations, arguments, or narratives.
- Prefer phrases that can be backed by a shown object:
  - map
  - receipt
  - booking
  - passport
  - card
  - medicine box
  - phone screen
- If a phrase depends on exact numbers, names, times, or addresses, include a written fallback nearby.
- Do not market high-risk phrase areas as if SpeakLocal provides medical, legal, or official-procedure expertise.
- On website/article surfaces, say SpeakLocal helps travelers ask for help fast and recover from misunderstanding; do not imply guaranteed safety or successful outcomes.
- Do not promote unreconciled high-risk wording as a hero claim, trust claim, or proof claim before native-human review.

## Lightweight review checklist for future work

Before expanding or prominently surfacing a Viet high-risk phrase family, check:

1. Is the default phrase short enough to use under stress?
2. Is it asking for help, clarifying, or reporting, rather than giving advice or making a claim?
3. Can the traveler show a map, receipt, ID, booking, or phone screen to reduce speech risk?
4. Is a repair/fallback phrase close enough to use immediately if the first attempt fails?
5. Does the surrounding copy avoid implying native-review certainty that does not yet exist?

If any answer is `no`, keep the phrase family more conservative until review improves.

## Out of scope

This document does not:

- rewrite the whole Viet pack
- certify native correctness
- certify medical safety
- certify legal sufficiency
- replace local emergency, embassy, police, insurance, or pharmacy guidance

It exists to keep SpeakLocal honest, short, and practically useful until stronger review closes the remaining risk.

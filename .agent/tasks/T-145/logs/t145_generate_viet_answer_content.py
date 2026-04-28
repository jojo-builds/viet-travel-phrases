import csv
import json
from pathlib import Path


ROOT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion")
CSV_PATH = ROOT / "content-draft" / "viet" / "phrase-source.csv"
REL_PATH = ROOT / "content-draft" / "viet" / "relation-sample-v1.json"
ANS_PATH = ROOT / "content-draft" / "viet" / "answer-page-sample-v1.json"


with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fieldnames = reader.fieldnames

family_rows = {}
phrase_rows = {}
for row in rows:
    family_rows.setdefault(row["family_id"], []).append(row)
    phrase_rows[row["phrase_id"]] = row


def row_for_phrase(phrase_id):
    if phrase_id not in phrase_rows:
        raise KeyError(f"missing phrase id: {phrase_id}")
    return phrase_rows[phrase_id]


def phrase_for_family(family_id, variant_role="say-first"):
    for row in family_rows.get(family_id, []):
        if row["variant_role"] == variant_role and row["status"] == "approved":
            return row["phrase_id"]
    raise KeyError(f"missing {variant_role} row for {family_id}")


def family_title(family_id):
    return family_rows[family_id][0]["family_title"]


def family_summary(family_id):
    return family_rows[family_id][0]["family_summary"]


def scenario_id(family_id):
    return family_rows[family_id][0]["scenario_id"]


def access_tier(phrase_id):
    return row_for_phrase(phrase_id)["access_tier"]


def dedupe(seq):
    out = []
    seen = set()
    for item in seq:
        if item and item not in seen:
            out.append(item)
            seen.add(item)
    return out


def add_note_token(notes, token):
    parts = [part.strip() for part in notes.split("|") if part.strip()]
    if token not in parts:
        parts.append(token)
    return " | ".join(parts)


MODULE_MIXES = [
    {
        "id": "greetings-social-v1",
        "phraseClass": "greetings-social",
        "moduleTypes": [
            "core-phrase",
            "social-use-case",
            "likely-reply",
            "say-next",
            "graceful-exit",
        ],
        "requiredRelationBuckets": [
            "likelyReply",
            "askNext",
            "repairIfMissed",
            "crossClassExit",
        ],
    },
    {
        "id": "urgent-help-medical-v1",
        "phraseClass": "urgent-help-medical",
        "moduleTypes": [
            "urgent-core",
            "risk-or-symptom-detail",
            "likely-reply",
            "immediate-next-step",
            "local-reality",
            "repair-branch",
            "safety-escalation",
        ],
        "requiredRelationBuckets": [
            "likelyReply",
            "repairIfMissed",
            "askNext",
            "escalateTo",
            "crossClassExit",
        ],
    },
    {
        "id": "repair-clarification-v1",
        "phraseClass": "repair-clarification",
        "moduleTypes": [
            "repair-core",
            "show-or-write",
            "number-check",
            "likely-response",
            "next-try",
            "courtesy-close",
        ],
        "requiredRelationBuckets": [
            "likelyReply",
            "repairIfMissed",
            "askNext",
            "crossClassExit",
        ],
    },
    {
        "id": "practical-service-navigation-v1",
        "phraseClass": "practical-service-navigation",
        "moduleTypes": [
            "task-core",
            "operator-question",
            "confirm-detail",
            "what-to-show",
            "local-reality",
            "next-step",
            "fallback",
        ],
        "requiredRelationBuckets": [
            "likelyReply",
            "repairIfMissed",
            "askNext",
            "crossClassExit",
        ],
    },
]


HUBS = [
    {
        "hubId": "viet-greeting-hello",
        "familyId": "polite-hello",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "greeting",
        "anchorPhraseId": "polite-1",
        "defaultPhraseId": "polite-1",
        "quickSayPhraseId": "polite-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "polite-acknowledge",
                    "reason": "A short acknowledgment is the most common answer before the real request starts.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the other person keeps talking after hello, jump into a repair phrase instead of repeating the opener.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "A quick greeting at pickup usually leads straight into showing the destination.",
                },
                {
                    "targetFamilyId": "social-recommend",
                    "reason": "A friendly opening can move directly into asking for a recommendation.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If the interaction turns practical, switch into a directions question immediately.",
                }
            ],
        },
        "summary": "Use one short hello to open the interaction politely before moving into the real task.",
        "coreBullets": [
            "Use it once to open the exchange, then get straight to the practical ask."
        ],
        "sayNextSummary": "A hello is only useful if it quickly hands off into the real task.",
        "useCases": ["shop counter", "ride pickup", "hotel desk"],
    },
    {
        "hubId": "viet-greeting-thank-you",
        "familyId": "polite-thank-you",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "greeting",
        "anchorPhraseId": "polite-2",
        "defaultPhraseId": "polite-2",
        "quickSayPhraseId": "polite-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": "polite-thank-you-polite",
        "alternatePhraseIds": ["polite-thank-you-polite"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "polite-acknowledge",
                    "reason": "You will often get a light acknowledgment after thanking someone.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the reply keeps going, use a repair phrase instead of staying stuck in the thank-you moment.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "After thanking someone for help, the next useful move may still be a route follow-up.",
                },
                {
                    "targetFamilyId": "social-recommend",
                    "reason": "A warm thank-you can open the door to one more practical recommendation question.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "service-email-file",
                    "reason": "At a service desk, gratitude often turns into one last document or delivery request.",
                }
            ],
        },
        "summary": "Keep this ready after directions, service help, or any small rescue so the interaction ends warmly.",
        "coreBullets": [
            "Use this after the help lands, not as the opener before you ask."
        ],
        "sayNextSummary": "After thanking someone, either close cleanly or use the goodwill for one last practical follow-up.",
        "useCases": [
            "after someone gives directions",
            "after counter help",
            "after a small favor",
        ],
    },
    {
        "hubId": "viet-greeting-acknowledge",
        "familyId": "polite-acknowledge",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "greeting",
        "anchorPhraseId": "polite-3",
        "defaultPhraseId": "polite-3",
        "quickSayPhraseId": "polite-3",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the other person keeps explaining after your acknowledgment, the next move is often a repair phrase.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "This polite acknowledgment is only a bridge; if you lose the thread, move straight into repair.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "After a polite yes, the next practical step is often the destination or request itself.",
                },
                {
                    "targetFamilyId": "social-recommend",
                    "reason": "You can also use the acknowledgment to keep a friendly exchange moving into a recommendation ask.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If the exchange becomes task-focused, pivot into a directions or service question.",
                }
            ],
        },
        "summary": "This is a soft respectful acknowledgment that buys you a second before the real request.",
        "coreBullets": [
            "Use it as a respectful bridge while you listen or prepare the next phrase."
        ],
        "sayNextSummary": "A soft acknowledgment should lead into the real request or a repair branch, not sit on its own.",
        "useCases": [
            "when staff greet you first",
            "when a driver confirms",
            "when you want to sound respectful without over-talking",
        ],
    },
    {
        "hubId": "viet-greeting-no-thanks",
        "familyId": "polite-no-thanks",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "greeting",
        "anchorPhraseId": "polite-4",
        "defaultPhraseId": "polite-4",
        "quickSayPhraseId": "polite-4",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "polite-acknowledge",
                    "reason": "A short acknowledgment is a common way the other person may let the refusal pass.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the seller keeps talking or pushing, move into repair or a firmer follow-up.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "After declining an offer, the next useful move may be asking for directions instead.",
                },
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "You may also need to shift straight into a ride or destination request.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "emergency-not-safe",
                    "reason": "If a polite refusal does not work and the situation feels wrong, escalate fast.",
                }
            ],
        },
        "summary": "Use this to decline offers cleanly without sounding abrupt or confrontational.",
        "coreBullets": [
            "Lead with this only when you truly want the offer to stop and the interaction to reset."
        ],
        "sayNextSummary": "After a refusal, either end the exchange cleanly or pivot straight into the next practical need.",
        "useCases": ["street vendors", "unwanted upsells", "offers you do not want to accept"],
    },
    {
        "hubId": "viet-social-how-are-you",
        "familyId": "social-how-are-you",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "social",
        "anchorPhraseId": "smalltalk-7",
        "defaultPhraseId": "smalltalk-7",
        "quickSayPhraseId": "smalltalk-7",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "polite-acknowledge",
                    "reason": "You may get a short friendly acknowledgment before the conversation moves on.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the answer comes too fast, go to repair instead of forcing small talk.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "social-recommend",
                    "reason": "A quick check-in can open the way to asking what the person recommends.",
                },
                {
                    "targetFamilyId": "polite-thank-you",
                    "reason": "If the exchange stays brief, close it politely and move on.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If small talk is done, pivot into the practical route question you actually need.",
                }
            ],
        },
        "summary": "This is useful only for light warmth after a greeting, not as a replacement for the real traveler ask.",
        "coreBullets": [
            "Use it only when there is room for light warmth; skip it in urgent or high-friction moments."
        ],
        "sayNextSummary": "Keep the small-talk moment brief, then shift into the useful question you actually need answered.",
        "useCases": [
            "casual counter chat",
            "friendly host small talk",
            "brief warm-up before a recommendation request",
        ],
    },
    {
        "hubId": "viet-social-recommend",
        "familyId": "social-recommend",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "social",
        "anchorPhraseId": "social-9",
        "defaultPhraseId": "social-9",
        "quickSayPhraseId": "social-9",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "food-menu",
                    "reason": "A recommendation question often gets answered with a menu item, dish, or place suggestion.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the recommendation name is hard to catch, ask for it in writing.",
                }
            ],
            "askNext": [
                {
                    "targetFamilyId": "food-menu",
                    "reason": "At a restaurant, the natural next move is asking for the menu or confirming the item.",
                },
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If someone recommends a place, the next thing you need is usually how to get there.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If the recommendation becomes a destination, jump straight into the ride phrase.",
                }
            ],
        },
        "summary": "Use this after the opener when you want one strong local suggestion instead of a long conversation.",
        "coreBullets": [
            "Ask this once the other person is engaged and ready to help, not as a cold opener."
        ],
        "sayNextSummary": "Turn the recommendation into a specific item, place, or route before the conversation drifts.",
        "useCases": ["restaurant staff", "hotel front desk", "friendly shopkeeper"],
    },
    {
        "hubId": "viet-urgent-not-safe",
        "familyId": "emergency-not-safe",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "urgent-help",
        "anchorPhraseId": "emergency-4",
        "defaultPhraseId": "emergency-4",
        "quickSayPhraseId": "emergency-4",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "emergency-manager-now",
                    "reason": "At a hotel, cafe, or venue, the helper may call the manager or take you to staff first.",
                },
                {
                    "targetFamilyId": "emergency-call-help",
                    "reason": "A nearby person may react by calling for help immediately.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the urgency is clear but the details are not, ask for English help fast.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If instructions come back too fast, use a repair phrase right away.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "emergency-following-me",
                    "reason": "Be ready to explain the threat if the other person asks what is wrong.",
                },
                {
                    "targetFamilyId": "emergency-get-away",
                    "reason": "If someone starts helping, the next useful phrase may be asking them to get you out of there.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "emergency-police",
                    "reason": "If staff cannot fix the situation, move to police involvement.",
                },
                {
                    "targetFamilyId": "emergency-ambulance",
                    "reason": "If the unsafe situation includes injury or panic, switch to ambulance help immediately.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If you need to leave quickly, the ride phrase becomes the practical next move.",
                }
            ],
        },
        "summary": "This is the plain urgent phrase for any moment where you need another person to notice the danger now.",
        "detailBullets": [
            "Keep the first phrase short and visible.",
            "Be ready to add who is bothering you or where you need to go next.",
        ],
        "localReality": [
            "Staff may move you toward a counter, security point, or better-lit public spot first.",
            "You may need to repeat the problem and then immediately ask for the next concrete action.",
        ],
    },
    {
        "hubId": "viet-urgent-ambulance",
        "familyId": "emergency-ambulance",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "urgent-help",
        "anchorPhraseId": "emergency-2",
        "defaultPhraseId": "emergency-2",
        "quickSayPhraseId": "emergency-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "A helper may answer by asking where to take the patient or by steering you toward a hospital.",
                },
                {
                    "targetFamilyId": "health-doctor",
                    "reason": "You may also need to explain that a doctor is needed now.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the responder needs the address or room number, writing it down is safer than repeating it.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the responder cannot follow the details, ask for someone who can handle English.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "v900-heal-phar-i-have-trouble-breathing",
                    "reason": "Name the symptom if breathing, pain, or collapse is driving the emergency.",
                },
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "You may need to pivot immediately into the hospital destination phrase.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "If transport is already moving, the hospital phrase becomes the next hard destination.",
                }
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If formal emergency transport is not available yet, showing the destination to a driver may still be necessary.",
                }
            ],
        },
        "summary": "Use this only when urgent transport or emergency medical help is needed right now.",
        "detailBullets": [
            "Add the symptom or injury immediately after the first phrase.",
            "Keep location, floor, or room details ready for the next exchange.",
        ],
        "localReality": [
            "People may first try to move you to a vehicle, front desk, or hospital entrance.",
            "The next question is often where the patient is or what the symptom is.",
        ],
    },
    {
        "hubId": "viet-urgent-hospital",
        "familyId": "emergency-hospital",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "urgent-help",
        "anchorPhraseId": "emergency-hospital",
        "defaultPhraseId": "emergency-hospital",
        "quickSayPhraseId": "emergency-hospital",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "health-doctor",
                    "reason": "A helper may answer by offering a doctor or clinic path first.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "If spoken directions are messy, ask for the place on the map.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If you need the address, room, or turn-by-turn details written out, say so fast.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "Once you know the hospital, the next move may be showing that destination to a driver.",
                },
                {
                    "targetFamilyId": "v900-heal-phar-i-have-trouble-breathing",
                    "reason": "Be ready to add the actual symptom once help starts moving.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "emergency-ambulance",
                    "reason": "If getting there alone is not realistic, escalate to ambulance help.",
                }
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If no ride is available, turn the emergency into a direct route question immediately.",
                }
            ],
        },
        "summary": "This is the fast path when the real need is reaching the nearest hospital rather than asking for general medical advice.",
        "detailBullets": [
            "Keep the hospital ask separate from the symptom if the first goal is movement.",
            "Be ready to name the symptom once someone is helping you get there.",
        ],
        "localReality": [
            "The nearest hospital may not be the quietest or easiest location to find on foot.",
            "Helpers often respond better if you can show a map or a ride app next.",
        ],
    },
    {
        "hubId": "viet-urgent-following-me",
        "familyId": "emergency-following-me",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "urgent-help",
        "anchorPhraseId": "emergency-following-me",
        "defaultPhraseId": "emergency-following-me",
        "quickSayPhraseId": "emergency-following-me",
        "clearerPhraseId": "emergency-following-me-clearer",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["emergency-following-me-clearer"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "emergency-manager-now",
                    "reason": "A staff member may answer by bringing a manager or another employee close to you.",
                },
                {
                    "targetFamilyId": "emergency-call-help",
                    "reason": "A bystander may react by calling for help if the threat feels immediate.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the urgency lands but the details do not, ask for English help fast.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If someone starts giving quick instructions, use a repair phrase immediately.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "emergency-not-safe",
                    "reason": "If you need a broader frame, add that the whole situation feels unsafe.",
                },
                {
                    "targetFamilyId": "emergency-get-away",
                    "reason": "If someone offers help, the next useful move may be asking them to get you out of there.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "emergency-police",
                    "reason": "If the threat does not stop, police involvement becomes the next hard step.",
                }
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If you need to leave immediately, showing the ride destination may be the practical exit.",
                }
            ],
        },
        "summary": "Use this when you want another person to understand that the danger is active and nearby, not just abstract.",
        "detailBullets": [
            "The clearer variant helps when you need to sound explicit without over-explaining.",
            "Be ready to point at the person or the direction they are moving.",
        ],
        "localReality": [
            "People often help more quickly if you move toward staff or a brighter public space while speaking.",
            "You may need one more phrase to explain where you want to go next.",
        ],
    },
    {
        "hubId": "viet-medical-pharmacy",
        "familyId": "health-pharmacy",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "anchorPhraseId": "health-pharmacy-clearer",
        "defaultPhraseId": "health-pharmacy-clearer",
        "quickSayPhraseId": "health-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["health-1"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-number",
                    "reason": "Once you find the pharmacy, the next friction is often dosage, floor, or price numbers.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the location or instructions are hard to catch, ask for them in writing.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "If spoken directions are messy, the map pin is faster than repeating street names.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "Written directions help when you need a building name, floor, or landmark.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "v500-heal-phar-how-do-i-take-this",
                    "reason": "After you find the pharmacy, the next useful question is often how to take the medicine.",
                },
                {
                    "targetFamilyId": "v900-heal-phar-please-write-the-instructions",
                    "reason": "If the instructions matter, ask for them in writing before you leave.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "health-doctor",
                    "reason": "If the pharmacy cannot handle the issue, escalate to a doctor or clinic.",
                },
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "If the symptom is too serious for a pharmacy, move to the hospital path fast.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "The first next move is often still a route question if you do not know where the pharmacy is.",
                }
            ],
        },
        "summary": "Use the clearer pharmacy ask when you need the nearest option, not just any pharmacy somewhere nearby.",
        "detailBullets": [
            "The short alternate is useful if you only need a direct location check.",
            "Be ready to switch into dosage or symptom questions once you arrive.",
        ],
        "localReality": [
            "A helper may point you to a street-facing pharmacy, clinic counter, or hospital pharmacy window.",
            "Numbers, landmarks, and floor details are common failure points.",
        ],
    },
    {
        "hubId": "viet-medical-trouble-breathing",
        "familyId": "v900-heal-phar-i-have-trouble-breathing",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "anchorPhraseId": "v900-heal-phar-i-have-trouble-breathing",
        "defaultPhraseId": "v900-heal-phar-i-have-trouble-breathing",
        "quickSayPhraseId": "v900-heal-phar-i-have-trouble-breathing",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "emergency-ambulance",
                    "reason": "A serious breathing problem should trigger ambulance help or a very fast transport decision.",
                },
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "A helper may steer you straight to the nearest hospital.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the first phrase lands but follow-up questions do not, ask for English help fast.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the response comes back too quickly, use a repair phrase immediately.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "health-doctor",
                    "reason": "If a doctor or clinic is the available path, be ready to ask for that next.",
                },
                {
                    "targetFamilyId": "emergency-ambulance",
                    "reason": "If you are getting worse, repeat the emergency transport need clearly.",
                },
            ],
            "escalateTo": [
                {
                    "targetFamilyId": "emergency-ambulance",
                    "reason": "Do not stay in a pharmacy-only flow if breathing is getting harder.",
                },
                {
                    "targetFamilyId": "emergency-hospital",
                    "reason": "Escalate to the hospital path if no quick medicine solution is realistic.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If someone can drive you faster than waiting, the destination phrase may become the practical next step.",
                }
            ],
        },
        "summary": "This is a high-stress symptom phrase, so keep the follow-up short and action-first.",
        "detailBullets": [
            "If you can, add whether it started suddenly or is getting worse.",
            "Use gestures, a medication package, or a phone note if speech is hard.",
        ],
        "localReality": [
            "Helpers may first ask where you need to go or whether you can still travel.",
            "The safest next move is usually transport, doctor, or hospital, not long explanation.",
        ],
    },
    {
        "hubId": "viet-repair-understand",
        "familyId": "repair-understand",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "problems-2",
        "defaultPhraseId": "problems-2",
        "quickSayPhraseId": "problems-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-slower",
                    "reason": "The best answer is often a slower repeat, so keep that branch ready.",
                },
                {
                    "targetFamilyId": "repair-repeat",
                    "reason": "If the other person only needs to say it again, this is the quickest repair follow-up.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If slowing down is not enough, switch to writing or showing.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the conversation is still blocked, ask whether English is available.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "repair-slower",
                    "reason": "Use the slower branch when the speech rate is the main problem.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "Use writing when the problem is a name, number, address, or app screen.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "Once repair works, you can return to the actual route or service question.",
                },
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "This is also the common bridge back into a pharmacy or medical ask.",
                },
            ],
        },
        "summary": "This is the reset button when the conversation is still live but comprehension is gone.",
        "showWrite": [
            "Use it early instead of pretending you understood.",
            "If the topic is a place, name, or number, move quickly to writing or a map.",
        ],
        "numberCheck": [
            "Save number-specific repair for prices, room numbers, and dosage once you know that is the problem."
        ],
        "courtesy": [
            "If the other person slows down or rewrites it, close the repair with a quick thank-you and move on."
        ],
    },
    {
        "hubId": "viet-repair-slower",
        "familyId": "repair-slower",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "problems-3",
        "defaultPhraseId": "problems-3",
        "quickSayPhraseId": "problems-3",
        "clearerPhraseId": None,
        "morePolitePhraseId": "repair-slower-polite",
        "alternatePhraseIds": ["repair-slower-polite"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-repeat",
                    "reason": "A slower repeat is often the next thing the other person will try.",
                },
                {
                    "targetFamilyId": "repair-number",
                    "reason": "If only the number is still unclear, the conversation often narrows to the number branch next.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If slowing down still does not fix it, switch to written or visual support.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If you still cannot follow, ask for English help rather than looping.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "repair-repeat",
                    "reason": "Use the repeat branch when you missed the last line only.",
                },
                {
                    "targetFamilyId": "repair-number",
                    "reason": "Use the number branch when the only missing piece is price, time, or room number.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "Once the pace drops, return to the actual ride or route request.",
                },
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "This slower branch is also common when a pharmacist explains dosage or directions.",
                },
            ],
        },
        "summary": "Use this when the speaker is not wrong, just too fast for the moment.",
        "showWrite": [
            "The polite variant is useful with staff or older speakers if you need a softer tone.",
            "If the pace improves but one detail still fails, jump to repeat or number repair.",
        ],
        "numberCheck": [
            "Prices, dates, and gate numbers often need a second dedicated number repair even after the speaker slows down."
        ],
        "courtesy": [
            "Do not overstay here; once the pace drops, move back to the real question quickly."
        ],
    },
    {
        "hubId": "viet-repair-repeat",
        "familyId": "repair-repeat",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "repair-1",
        "defaultPhraseId": "repair-1",
        "quickSayPhraseId": "repair-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-number",
                    "reason": "The repeated line often still leaves only the number or key noun unclear.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If a second spoken attempt still fails, ask for it in writing.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If repetition is not enough, move to language help.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "repair-slower",
                    "reason": "If the same sentence is still too fast, switch to the slower branch.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the repeated phrase is still muddy, go visual.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "After the repeated line lands, jump back into the actual route or service task.",
                },
                {
                    "targetFamilyId": "service-email-file",
                    "reason": "This branch is also common in document or file handoff conversations.",
                },
            ],
        },
        "summary": "Use this when you missed the last sentence but the conversation is otherwise still intact.",
        "showWrite": [
            "If the second attempt is still unclear, do not ask for a third identical repeat; switch methods.",
            "This is strongest for one missed sentence, not for a whole broken conversation.",
        ],
        "numberCheck": [
            "If the repeated line is mostly clear except for the number, move to the number repair branch immediately."
        ],
        "courtesy": [
            "Once the repeated line lands, move forward instead of repeating the same repair loop."
        ],
    },
    {
        "hubId": "viet-repair-write-down",
        "familyId": "repair-write-down",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "repair-2",
        "defaultPhraseId": "repair-2",
        "quickSayPhraseId": "repair-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-number",
                    "reason": "Once it is written, the next friction is often reading or confirming the number back.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "For places, the written answer often turns into a map or pin next.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If writing still does not fix it, ask for English help.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the person answers with a new spoken explanation, reset the repair quickly.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "Use the map pin next when the place still feels ambiguous after writing.",
                },
                {
                    "targetFamilyId": "service-email-file",
                    "reason": "In document tasks, written details often lead straight into an email or file handoff.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "Written instructions are especially useful once you reach a pharmacy or clinic moment.",
                },
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "A written place name can move straight into showing the destination to a driver.",
                },
            ],
        },
        "summary": "This is the strongest repair when the missing piece is a place, name, number, or instruction that matters.",
        "showWrite": [
            "Use it early for addresses, room numbers, medicine instructions, and ticket details.",
            "A phone screen, note app, or paper slip all work better than another spoken loop.",
        ],
        "numberCheck": [
            "Written numbers still need confirmation if the stakes are price, dosage, floor, gate, or time."
        ],
        "courtesy": [
            "Once the detail is written, read it back or save it before the conversation moves on."
        ],
    },
    {
        "hubId": "viet-repair-number",
        "familyId": "repair-number",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "repair-6",
        "defaultPhraseId": "repair-6",
        "quickSayPhraseId": "repair-6",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["repair-number-amount"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "money-final-price",
                    "reason": "A number repair often resolves into confirming the final total or exact amount.",
                },
                {
                    "targetFamilyId": "transport-fare",
                    "reason": "Ride prices are one of the most common reasons you need this branch.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the number is still unclear, get it written instead of spoken again.",
                },
                {
                    "targetFamilyId": "repair-repeat",
                    "reason": "If you missed more than the number, step back to the broader repeat branch.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "money-final-price",
                    "reason": "Once you catch the number, the next move is often confirming whether that is the final total.",
                },
                {
                    "targetFamilyId": "transport-fare",
                    "reason": "If the number was a fare, jump straight back into the transport money question.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "Number repair often appears in ride, hotel, and ticket flows before the main task continues.",
                },
                {
                    "targetFamilyId": "service-print",
                    "reason": "Page counts, fees, and pickup times make this useful in print or document service moments too.",
                },
            ],
        },
        "summary": "Use this when the only thing that failed was the number, not the whole sentence.",
        "showWrite": [
            "The alternate amount phrasing is useful when the missed number is money-related.",
            "If the number matters for safety or medicine, get it written too.",
        ],
        "numberCheck": [
            "Room numbers, prices, dosage counts, and pickup times are the main targets for this repair."
        ],
        "courtesy": [
            "Read the number back or point at it once you have it so the loop closes cleanly."
        ],
    },
    {
        "hubId": "viet-repair-english-help",
        "familyId": "repair-english-help",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "anchorPhraseId": "repair-english-help",
        "defaultPhraseId": "repair-english-help",
        "quickSayPhraseId": "repair-english-help",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["repair-english-help-self-limit"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If no English is available, the conversation often falls back to writing or showing.",
                }
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the answer is no, move straight to writing or typing instead of getting stuck.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If partial English starts but still breaks down, reset the repair clearly.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "Writing is the safest next method if English is limited or unavailable.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "A map pin or photo often works even when shared language is thin.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "This branch is common at clinics and pharmacies when the explanation matters.",
                },
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "It is also common in rides when an address alone is not enough.",
                },
            ],
        },
        "summary": "Use this to test whether English can simplify the next minute; if not, pivot fast to writing or showing.",
        "showWrite": [
            "The self-limit alternate helps explain the problem without sounding demanding.",
            "Do not stay here too long if the answer is no; change methods immediately.",
        ],
        "numberCheck": [
            "Even if some English is available, prices, dates, and dosage still usually need a visual backup."
        ],
        "courtesy": [
            "Once you find a workable method, move on and keep the conversation focused on the real task."
        ],
    },
    {
        "hubId": "viet-transport-destination",
        "familyId": "transport-destination",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "anchorPhraseId": "taxi-1",
        "defaultPhraseId": "taxi-1",
        "quickSayPhraseId": "taxi-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "transport-fare",
                    "reason": "A driver often answers by moving straight into the fare or route check.",
                },
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the place name is not landing, the next useful move is writing or showing it.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "Show or write the destination if speech alone is not enough.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "A map pin is often faster than repeating the address.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "transport-stop-here",
                    "reason": "Once the ride starts, be ready with the stop phrase for the last turn.",
                },
                {
                    "targetFamilyId": "transport-fare",
                    "reason": "You may need to confirm the fare before you fully commit.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If a driver is not available, the same destination may turn into a walking directions question.",
                }
            ],
        },
        "summary": "This is the fast ride-opener when your phone or note already shows the destination.",
        "confirmDetail": [
            "Have the place name, map pin, or landmark ready before you speak.",
            "The next friction is usually the fare or the exact drop-off point.",
        ],
        "whatToShow": [
            "Show the map pin first if the address is long or hard to pronounce.",
            "If the driver hesitates, switch to a written place name or hotel card.",
        ],
        "localReality": [
            "Drivers may ask about the exact entrance, corner, or side road even when the main destination is clear.",
            "This phrase works best when paired with a visual.",
        ],
    },
    {
        "hubId": "viet-transport-stop-here",
        "familyId": "transport-stop-here",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "anchorPhraseId": "taxi-3",
        "defaultPhraseId": "taxi-3",
        "quickSayPhraseId": "taxi-3",
        "clearerPhraseId": "transport-stop-here-clearer",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["transport-stop-here-clearer"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-number",
                    "reason": "A driver may answer with the fare, remaining distance, or another number-heavy check.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "If the exact spot is still unclear, you may need to show the point on the map.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the stop point is still unclear, writing the building or entrance helps.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the driver starts giving route options you cannot follow, reset with repair.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "After you get out, the next move is often one last directions question.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "If the driver drifts past the place, show the exact point again.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "The stop phrase is often used right before entering a clinic, pharmacy, or hospital area.",
                }
            ],
        },
        "summary": "Use this when you are close enough that the drop-off point matters more than the whole route.",
        "confirmDetail": [
            "The clearer variant is useful when the driver looks likely to roll past the spot.",
            "This is best paired with one obvious landmark or a map dot.",
        ],
        "whatToShow": [
            "Point at the entrance, gate, or corner if it is visible.",
            "If the place is hidden inside a block, have the map ready.",
        ],
        "localReality": [
            "Drivers often need the last few meters clarified more than the main destination.",
            "A good final stop saves you a second directions problem on foot.",
        ],
    },
    {
        "hubId": "viet-directions-how-to-get",
        "familyId": "directions-how-to-get",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "navigation",
        "anchorPhraseId": "directions-1",
        "defaultPhraseId": "directions-1",
        "quickSayPhraseId": "directions-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "Many directions exchanges work best once the place is put on a map or pointed out visually.",
                },
                {
                    "targetFamilyId": "directions-right-route",
                    "reason": "After the first explanation, you often still need to confirm that you are on the correct route.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the route explanation is too dense, get a written landmark or address.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the explanation comes too quickly, repair first before guessing.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "The next strong move is often turning the explanation into a map point.",
                },
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If the walk is too hard, the same place may need a ride instead.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "This route phrase often becomes the bridge into finding a pharmacy, clinic, or emergency place.",
                },
                {
                    "targetFamilyId": "service-print",
                    "reason": "It also applies when you need to find a practical service location such as printing or paperwork help.",
                },
            ],
        },
        "summary": "Use this when you know the place but still need the route, not the translation of the place name.",
        "confirmDetail": [
            "If the destination is visible on your screen, show it while you ask.",
            "Be ready to confirm whether you should walk, ride, or go to a specific entrance.",
        ],
        "whatToShow": [
            "A hotel card, screenshot, or map pin makes the answer much more useful.",
            "If the helper starts pointing, follow up with a map or written landmark.",
        ],
        "localReality": [
            "Route answers often include landmarks, corners, floors, or entrance choices instead of a clean street address.",
            "Do not try to memorize too much at once; capture the next useful chunk.",
        ],
    },
    {
        "hubId": "viet-directions-map-pin",
        "familyId": "directions-map-pin",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "navigation",
        "anchorPhraseId": "directions-map-pin",
        "defaultPhraseId": "directions-map-pin",
        "quickSayPhraseId": "directions-map-pin",
        "clearerPhraseId": "directions-map-pin-clearer",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["directions-map-pin-clearer"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "directions-right-route",
                    "reason": "Once the pin is on the map, the next friction is usually confirming the route.",
                },
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "A map point may also turn directly into the ride destination handoff.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the map does not solve it, get the landmark or address written down.",
                },
                {
                    "targetFamilyId": "repair-understand",
                    "reason": "If the explanation still comes too fast after the map appears, repair the conversation.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "Once the point is clear, you may need to hand that same map to a driver.",
                },
                {
                    "targetFamilyId": "directions-right-route",
                    "reason": "Use route confirmation next if you are already moving.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "service-email-file",
                    "reason": "Map screenshots, booking emails, or shared pins often turn into digital file-sharing moments.",
                },
                {
                    "targetFamilyId": "health-pharmacy",
                    "reason": "A map pin is especially helpful for urgent pharmacy or hospital searches.",
                },
            ],
        },
        "summary": "This is the visual upgrade when the destination or route is easier to point at than to say.",
        "confirmDetail": [
            "The clearer variant is helpful when you need the person to physically point at the map.",
            "Use it after the general route question if speech alone is still too fuzzy.",
        ],
        "whatToShow": [
            "Open the map and zoom enough that the person can tap the exact place.",
            "A screenshot also works when signal is weak.",
        ],
        "localReality": [
            "Visual route help is often faster than repeating long place names or landmarks.",
            "This is one of the best repair exits for navigation problems.",
        ],
    },
    {
        "hubId": "viet-service-print",
        "familyId": "service-print",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "service",
        "anchorPhraseId": "service-8",
        "defaultPhraseId": "service-8",
        "quickSayPhraseId": "service-8",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "money-final-price",
                    "reason": "Print requests often turn quickly into a price or total question.",
                },
                {
                    "targetFamilyId": "repair-number",
                    "reason": "Page counts, pickup times, and fees often need a number repair branch.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "If the staff member needs your booking code, file name, or page count, writing helps.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the service desk process is hard to follow, ask whether English is available.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "service-email-file",
                    "reason": "The next real step is often sending the file by email instead of handing over a device.",
                },
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If this desk cannot print, the next thing you need is where to go instead.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If the print shop is elsewhere, the practical next move is the ride destination phrase.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "A map pin can also help when staff send you to another branch or counter.",
                },
            ],
        },
        "summary": "Keep this for tickets, reservation proofs, visa paperwork, or any file that suddenly needs to become paper.",
        "confirmDetail": [
            "Be ready to confirm color, number of pages, or whether you need the file now.",
            "This hub is strongest when you already have the document open.",
        ],
        "whatToShow": [
            "Show the ticket, booking, or form on your phone before the conversation gets long.",
            "If possible, have the file name or QR code ready.",
        ],
        "localReality": [
            "Small print counters often work through messaging apps, email, or quick USB handoff, not formal print menus.",
            "The real friction is usually price, file delivery, or page count.",
        ],
    },
    {
        "hubId": "viet-service-email-file",
        "familyId": "service-email-file",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "service",
        "anchorPhraseId": "service-email-file",
        "defaultPhraseId": "service-email-file",
        "quickSayPhraseId": "service-email-file",
        "clearerPhraseId": "service-email-file-clearer",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["service-email-file-clearer"],
        "relationBuckets": {
            "likelyReply": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "You may need to write or show the email address if the first exchange is not enough.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the staff workflow is confusing, language help may be the fastest unblocker.",
                },
            ],
            "repairIfMissed": [
                {
                    "targetFamilyId": "repair-write-down",
                    "reason": "Spellings, symbols, and addresses usually work better in writing than in speech.",
                },
                {
                    "targetFamilyId": "repair-english-help",
                    "reason": "If the staff member cannot follow the digital handoff, ask for an English-capable helper.",
                },
            ],
            "askNext": [
                {
                    "targetFamilyId": "service-print",
                    "reason": "The file-email step often exists only because you still need the document printed afterward.",
                },
                {
                    "targetFamilyId": "directions-how-to-get",
                    "reason": "If this desk cannot take the file, you may need directions to the right place.",
                },
            ],
            "crossClassExit": [
                {
                    "targetFamilyId": "transport-destination",
                    "reason": "If the correct desk is elsewhere, the destination phrase becomes the next practical move.",
                },
                {
                    "targetFamilyId": "directions-map-pin",
                    "reason": "A map pin or shared screenshot often helps when the service handoff turns into a location problem.",
                },
            ],
        },
        "summary": "Use this when a file, ticket, or form needs to be transferred digitally before the service can continue.",
        "confirmDetail": [
            "The clearer variant is useful when you need to emphasize email rather than messaging or screenshot sharing.",
            "Be ready to confirm which address, attachment, or format they want.",
        ],
        "whatToShow": [
            "Open the file, booking, or draft email before you ask.",
            "If needed, type the address instead of spelling it aloud.",
        ],
        "localReality": [
            "Digital handoffs at small counters often happen quickly and informally, so visual clarity matters more than perfect wording.",
            "The friction points are usually the email address, attachment, or where the final file should go.",
        ],
    },
]


HUB_MAP = {hub["familyId"]: hub for hub in HUBS}

# Validate family and phrase references.
for hub in HUBS:
    family = hub["familyId"]
    if family not in family_rows:
        raise KeyError(f"missing family: {family}")
    for key in ["anchorPhraseId", "defaultPhraseId", "quickSayPhraseId"]:
        row_for_phrase(hub[key])
    for key in ["clearerPhraseId", "morePolitePhraseId"]:
        if hub.get(key):
            row_for_phrase(hub[key])
    for phrase_id in hub.get("alternatePhraseIds", []):
        row_for_phrase(phrase_id)
    for bucket_items in hub["relationBuckets"].values():
        for item in bucket_items:
            target_family = item["targetFamilyId"]
            item["targetPhraseId"] = phrase_for_family(target_family)


def make_module(module_id, module_type, required, source_phrase_ids, source_family_ids, relation_refs, summary, bullets):
    return {
        "moduleId": module_id,
        "type": module_type,
        "required": required,
        "sourcePhraseIds": dedupe(source_phrase_ids),
        "sourceFamilyIds": dedupe(source_family_ids),
        "relationRefs": relation_refs,
        "content": {
            "summary": summary,
            "bullets": bullets,
        },
    }


def bucket_reasons(hub, bucket_name):
    return [item["reason"] for item in hub["relationBuckets"].get(bucket_name, [])]


def relation_microcopy(bucket_name, items):
    prefixes = {
        "likelyReply": "Be ready for this likely reply branch",
        "repairIfMissed": "If this misses, switch to this repair branch",
        "askNext": "The next practical move is",
        "escalateTo": "If this is still not enough, escalate to",
        "crossClassExit": "If the moment shifts, pivot to",
    }
    prefix = prefixes[bucket_name]
    return [f"{prefix}: {family_summary(item['targetFamilyId'])}" for item in items]


def phrase_sources(hub):
    return dedupe(
        [
            hub["defaultPhraseId"],
            hub["quickSayPhraseId"],
            hub.get("clearerPhraseId"),
            hub.get("morePolitePhraseId"),
            *hub.get("alternatePhraseIds", []),
        ]
    )


def build_modules(hub):
    family = hub["familyId"]
    class_name = hub["phraseClass"]
    common_phrases = phrase_sources(hub)
    if class_name == "greetings-social":
        return [
            make_module(
                "core-phrase",
                "core-phrase",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                hub.get("coreBullets", ["Use the social phrase once, then move into the real traveler need."]),
            ),
            make_module(
                "social-use-case",
                "social-use-case",
                True,
                common_phrases,
                [family],
                [],
                "Keep the social opening short and situational.",
                hub["useCases"],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Be ready for the immediate answer or social acknowledgment.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "say-next",
                "say-next",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                hub.get("sayNextSummary", "Use the social moment to move into the next useful traveler action."),
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "graceful-exit",
                "graceful-exit",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the conversation slips away, exit the social layer and repair it.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    if class_name == "urgent-help-medical":
        return [
            make_module(
                "urgent-core",
                "urgent-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                ["Lead with the urgent phrase first and save extra detail for the next breath."],
            ),
            make_module(
                "risk-or-symptom-detail",
                "risk-or-symptom-detail",
                True,
                common_phrases,
                [family],
                [],
                "Add only the detail that changes the response.",
                hub["detailBullets"],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Be ready for the helper's first practical response.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "immediate-next-step",
                "immediate-next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Have the next actionable phrase ready once someone responds.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                [hub["defaultPhraseId"]],
                [family],
                [],
                "These situations usually turn practical very quickly on the ground.",
                hub["localReality"],
            ),
            make_module(
                "repair-branch",
                "repair-branch",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the responder does not catch the problem cleanly, repair fast.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
            make_module(
                "safety-escalation",
                "safety-escalation",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["escalateTo"]],
                ["escalateTo"],
                "If the first ask is not enough, escalate without delay.",
                relation_microcopy("escalateTo", hub["relationBuckets"]["escalateTo"]),
            ),
        ]
    if class_name == "repair-clarification":
        return [
            make_module(
                "repair-core",
                "repair-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                ["Use the smallest repair that actually fixes the conversation."],
            ),
            make_module(
                "show-or-write",
                "show-or-write",
                True,
                common_phrases,
                [family],
                [],
                "Visual or written backup often solves the problem faster than a third spoken try.",
                hub["showWrite"],
            ),
            make_module(
                "number-check",
                "number-check",
                True,
                common_phrases,
                [family],
                [],
                "Numbers often need their own repair branch even after the rest of the sentence lands.",
                hub["numberCheck"],
            ),
            make_module(
                "likely-response",
                "likely-response",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "These are the most common ways the conversation may move after the repair starts working.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "next-try",
                "next-try",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Once the current repair does its job, move to the next useful branch or back to the original task.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "courtesy-close",
                "courtesy-close",
                True,
                [hub["defaultPhraseId"]],
                [family],
                [],
                "Close the repair loop quickly so the interaction can keep moving.",
                hub["courtesy"],
            ),
        ]
    if class_name == "practical-service-navigation":
        return [
            make_module(
                "task-core",
                "task-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                ["Open with the task phrase while the destination, file, or screen is already visible."],
            ),
            make_module(
                "operator-question",
                "operator-question",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "These are the common follow-up questions or confirmations that come back from the other side.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "confirm-detail",
                "confirm-detail",
                True,
                common_phrases,
                [family],
                [],
                "Have the one detail ready that keeps the task from stalling.",
                hub["confirmDetail"],
            ),
            make_module(
                "what-to-show",
                "what-to-show",
                True,
                common_phrases,
                [family],
                [],
                "A map, ticket, screenshot, or address card often carries more weight than extra speech.",
                hub["whatToShow"],
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                common_phrases,
                [family],
                [],
                "On-the-ground service and navigation moments usually hinge on one practical detail.",
                hub["localReality"],
            ),
            make_module(
                "next-step",
                "next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Keep the next usable traveler move one tap away.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "fallback",
                "fallback",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the task still stalls, move straight into the repair branch instead of looping.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    raise ValueError(f"unknown class: {class_name}")


with REL_PATH.open("r", encoding="utf-8") as f:
    relation_sample = json.load(f)

relation_sample["purpose"] = (
    "Additive relation-ready handoff for phrase-detail, listing-page, and answer-page work across 43 high-value Viet family clusters, "
    "including 24 answer-page-ready hubs, without replacing the current scenario -> family -> phrase-row model."
)
relation_sample["answerPageCoverage"] = {
    "sampleId": "viet-answer-page-sample-v1",
    "hubCount": 24,
    "phraseClassCount": 4,
    "phraseClasses": [
        "greetings-social",
        "urgent-help-medical",
        "repair-clarification",
        "practical-service-navigation",
    ],
    "relationBucketFields": [
        "likelyReply",
        "repairIfMissed",
        "askNext",
        "escalateTo",
        "crossClassExit",
    ],
}
relation_sample["sourceOfTruth"]["precedenceRules"] = dedupe(
    relation_sample["sourceOfTruth"]["precedenceRules"]
    + [
        "For answer-page-ready hubs, relationBuckets remain the single authored home for cross-family reply, repair, escalation, and next-step rails."
    ]
)
relation_types = relation_sample.get("relationTypes", [])
if not any(item["id"] == "escalation_for" for item in relation_types):
    relation_types.append(
        {
            "id": "escalation_for",
            "description": "The target family is the stronger escalation branch when the current family is not enough.",
        }
    )
relation_sample["relationTypes"] = relation_types
relation_sample["relationBucketTypes"] = [
    {
        "id": "likelyReply",
        "description": "The most likely answer, staff question, or immediate follow-up the traveler should be ready for next.",
    },
    {
        "id": "repairIfMissed",
        "description": "The safest repair branch when the first attempt does not land cleanly.",
    },
    {
        "id": "askNext",
        "description": "The next useful traveler phrase once the first phrase works.",
    },
    {
        "id": "escalateTo",
        "description": "The stronger help or urgency branch when the current phrase is not enough.",
    },
    {
        "id": "crossClassExit",
        "description": "A nearby follow-on phrase from another class that keeps the traveler moving forward.",
    },
]

clusters_by_family = {cluster["familyId"]: cluster for cluster in relation_sample["clusters"]}
for hub in HUBS:
    family = hub["familyId"]
    cluster = clusters_by_family.get(family, {})
    cluster.update(
        {
            "clusterId": hub["hubId"],
            "coverageMoment": hub["coverageMoment"],
            "scenarioId": scenario_id(family),
            "familyId": family,
            "familyTitle": family_title(family),
            "familySummary": family_summary(family),
            "accessTier": access_tier(hub["defaultPhraseId"]),
            "phraseClass": hub["phraseClass"],
            "answerPageReady": True,
            "anchorPhraseId": hub["anchorPhraseId"],
            "shortestFormPhraseId": hub["quickSayPhraseId"],
            "clearerFormPhraseId": hub.get("clearerPhraseId"),
            "morePoliteFormPhraseId": hub.get("morePolitePhraseId"),
            "possibleTravelerResponses": [
                {
                    "kind": bucket_name,
                    "familyId": item["targetFamilyId"],
                    "phraseId": item["targetPhraseId"],
                    "note": item["reason"],
                }
                for bucket_name in ["likelyReply", "askNext"]
                for item in hub["relationBuckets"].get(bucket_name, [])
            ],
            "familyRelations": [
                {
                    "relationType": rel_type,
                    "targetFamilyId": item["targetFamilyId"],
                    "reason": item["reason"],
                }
                for bucket_name, rel_type in [
                    ("likelyReply", "likely_answer_to"),
                    ("repairIfMissed", "repair_for"),
                    ("askNext", "next_step_after"),
                    ("escalateTo", "escalation_for"),
                    ("crossClassExit", "see_also"),
                ]
                for item in hub["relationBuckets"].get(bucket_name, [])
            ],
            "relationBuckets": {
                bucket_name: [
                    {
                        "targetFamilyId": item["targetFamilyId"],
                        "targetPhraseId": item["targetPhraseId"],
                        "reason": item["reason"],
                    }
                    for item in items
                ]
                for bucket_name, items in hub["relationBuckets"].items()
            },
            "youMayHearSignals": [
                {
                    "signalText": item["reason"],
                    "sourcePhraseId": hub["defaultPhraseId"],
                    "advisoryOnly": True,
                }
                for item in hub["relationBuckets"].get("likelyReply", [])
            ],
        }
    )
    clusters_by_family[family] = cluster

existing_order = [cluster["familyId"] for cluster in relation_sample["clusters"]]
new_order = existing_order + [hub["familyId"] for hub in HUBS if hub["familyId"] not in existing_order]
relation_sample["clusters"] = [clusters_by_family[family_id] for family_id in new_order]
relation_sample["clusterCount"] = len(relation_sample["clusters"])

answer_sample = {
    "schemaVersion": 1,
    "sampleId": "viet-answer-page-sample-v1",
    "language": "Vietnamese",
    "status": "draft-handoff",
    "hubCount": len(HUBS),
    "phraseClassCount": 4,
    "sourceOfTruth": {
        "authoringCsv": "content-draft/viet/phrase-source.csv",
        "relationSample": "content-draft/viet/relation-sample-v1.json",
        "generatedPack": "app/family/packs/viet.generated.ts",
        "rowMembershipField": "notes",
        "membershipMarkerPrefix": "answer-page-sample=",
        "membershipTokenFormat": "<hubId>:anchor | <hubId>:variant:clearer | <hubId>:variant:more-polite | <hubId>:variant:also-common",
    },
    "contentRules": [
        "Phrase wording stays in phrase-source.csv.",
        "Cross-family relation truth stays in relation-sample-v1.json.",
        "Each module content payload uses only a short summary string plus a short bullets array.",
        "Modules may reference phrase ids and relation bucket names but must not duplicate the relation graph.",
    ],
    "moduleMixes": MODULE_MIXES,
    "hubs": [
        {
            "hubId": hub["hubId"],
            "scenarioId": scenario_id(hub["familyId"]),
            "familyId": hub["familyId"],
            "familyTitle": family_title(hub["familyId"]),
            "phraseClass": hub["phraseClass"],
            "moduleMixId": hub["moduleMixId"],
            "relationClusterId": hub["hubId"],
            "anchorPhraseId": hub["anchorPhraseId"],
            "defaultPhraseId": hub["defaultPhraseId"],
            "quickSayPhraseId": hub["quickSayPhraseId"],
            "clearerPhraseId": hub.get("clearerPhraseId"),
            "morePolitePhraseId": hub.get("morePolitePhraseId"),
            "alternatePhraseIds": hub.get("alternatePhraseIds", []),
            "relationBuckets": list(hub["relationBuckets"].keys()),
            "modules": build_modules(hub),
        }
        for hub in HUBS
    ],
}

# Update CSV note markers.
variant_kinds = {
    "polite-thank-you-polite": "variant:more-polite",
    "health-1": "variant:also-common",
    "emergency-following-me-clearer": "variant:clearer",
    "repair-slower-polite": "variant:more-polite",
    "repair-number-amount": "variant:also-common",
    "repair-english-help-self-limit": "variant:also-common",
    "transport-stop-here-clearer": "variant:clearer",
    "directions-map-pin-clearer": "variant:clearer",
    "service-email-file-clearer": "variant:clearer",
}

for row in rows:
    phrase_id = row["phrase_id"]
    family = row["family_id"]
    if family in HUB_MAP and phrase_id == HUB_MAP[family]["anchorPhraseId"]:
        row["notes"] = add_note_token(row["notes"], f"relation-sample={HUB_MAP[family]['hubId']}:anchor")
        row["notes"] = add_note_token(row["notes"], f"answer-page-sample={HUB_MAP[family]['hubId']}:anchor")
    if phrase_id in variant_kinds:
        owning_hub = None
        for hub in HUBS:
            if (
                phrase_id in hub.get("alternatePhraseIds", [])
                or phrase_id == hub.get("clearerPhraseId")
                or phrase_id == hub.get("morePolitePhraseId")
            ):
                owning_hub = hub
                break
        if owning_hub:
            row["notes"] = add_note_token(
                row["notes"],
                f"relation-sample={owning_hub['hubId']}:{variant_kinds[phrase_id]}",
            )
            row["notes"] = add_note_token(
                row["notes"],
                f"answer-page-sample={owning_hub['hubId']}:{variant_kinds[phrase_id]}",
            )

with REL_PATH.open("w", encoding="utf-8", newline="\n") as f:
    json.dump(relation_sample, f, ensure_ascii=False, indent=2)
    f.write("\n")

with ANS_PATH.open("w", encoding="utf-8", newline="\n") as f:
    json.dump(answer_sample, f, ensure_ascii=False, indent=2)
    f.write("\n")

with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print(
    json.dumps(
        {
            "answerHubCount": len(HUBS),
            "relationClusterCount": relation_sample["clusterCount"],
            "updatedCsvRows": sum(1 for row in rows if "answer-page-sample=" in row["notes"]),
        },
        ensure_ascii=False,
        indent=2,
    )
)

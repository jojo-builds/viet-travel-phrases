from __future__ import annotations

import csv
import json
import re
from collections import OrderedDict
from pathlib import Path


REPO_ROOT = Path(r"E:\AI\SpeakLocal-App-Family")
WORKTREE_ROOT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion")
VIET_DIR = WORKTREE_ROOT / "content-draft" / "viet"

CSV_PATH = VIET_DIR / "phrase-source.csv"
ANSWER_PATH = VIET_DIR / "answer-page-sample-v1.json"
RELATION_PATH = VIET_DIR / "relation-sample-v1.json"
README_PATH = VIET_DIR / "README.md"
SOURCE_NOTES_PATH = VIET_DIR / "source-notes.md"
RELATION_NOTES_PATH = VIET_DIR / "relation-authoring-notes.md"
V2_MODEL_PATH = WORKTREE_ROOT / "docs" / "V2_CONTENT_MODEL.md"
REL_MODEL_PATH = WORKTREE_ROOT / "docs" / "PHRASE_RELATIONSHIP_MODEL.md"

HARVEST_NOTES_PATH = REPO_ROOT / ".agent" / "tasks" / "T-154" / "logs" / "viet-flagship-cluster-harvest-notes.md"
TRIAGE_LEDGER_PATH = REPO_ROOT / ".agent" / "tasks" / "T-154" / "logs" / "viet-flagship-cluster-triage-ledger.md"


def uniq(items):
    seen = set()
    out = []
    for item in items:
        if item and item not in seen:
            seen.add(item)
            out.append(item)
    return out


def ordered_dict(*pairs):
    data = OrderedDict()
    for key, value in pairs:
        data[key] = value
    return data


def load_rows():
    with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        rows = list(reader)
        fieldnames = reader.fieldnames
    if not fieldnames:
        raise ValueError("phrase-source.csv is missing headers")
    return rows, fieldnames


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def note_tokens(notes: str, prefix: str) -> list[str]:
    pattern = rf"{re.escape(prefix)}([^|]+)"
    return [match.strip() for match in re.findall(pattern, notes or "")]


def split_notes(notes: str) -> list[str]:
    if not notes:
        return []
    return [part.strip() for part in notes.split("|") if part.strip()]


def add_notes_token(notes: str, token: str) -> str:
    parts = split_notes(notes)
    if token not in parts:
        parts.append(token)
    return " | ".join(parts)


def remove_notes_token(notes: str, token: str) -> str:
    parts = [part for part in split_notes(notes) if part != token]
    return " | ".join(parts)


def phrase_family(row_map, phrase_id: str) -> str:
    return row_map[phrase_id]["family_id"]


def relation_item(target_family_id: str, target_phrase_id: str, reason: str):
    return ordered_dict(
        ("targetFamilyId", target_family_id),
        ("targetPhraseId", target_phrase_id),
        ("reason", reason),
    )


def response_item(kind: str, family_id: str, phrase_id: str, note: str):
    return ordered_dict(
        ("kind", kind),
        ("familyId", family_id),
        ("phraseId", phrase_id),
        ("note", note),
    )


def signal_item(text: str, source_phrase_id: str):
    return ordered_dict(
        ("signalText", text),
        ("sourcePhraseId", source_phrase_id),
        ("advisoryOnly", True),
    )


def family_relation(relation_type: str, target_family_id: str, reason: str):
    return ordered_dict(
        ("relationType", relation_type),
        ("targetFamilyId", target_family_id),
        ("reason", reason),
    )


def module(module_id: str, module_type: str, source_phrase_ids: list[str], relation_refs: list[str], summary: str, bullets: list[str], row_map):
    source_family_ids = uniq([phrase_family(row_map, phrase_id) for phrase_id in source_phrase_ids])
    return ordered_dict(
        ("moduleId", module_id),
        ("type", module_type),
        ("required", True),
        ("sourcePhraseIds", uniq(source_phrase_ids)),
        ("sourceFamilyIds", source_family_ids),
        ("relationRefs", relation_refs),
        (
            "content",
            ordered_dict(
                ("summary", summary),
                ("bullets", bullets),
            ),
        ),
    )


def relation_type_for_bucket(bucket_name: str) -> str:
    return {
        "likelyReply": "likely_answer_to",
        "repairIfMissed": "repair_for",
        "askNext": "next_step_after",
        "escalateTo": "escalation_for",
        "crossClassExit": "see_also",
    }[bucket_name]


def build_cluster(page):
    buckets = OrderedDict()
    for bucket_name in ["likelyReply", "repairIfMissed", "askNext", "escalateTo", "crossClassExit"]:
        buckets[bucket_name] = page["buckets"].get(bucket_name, [])

    responses = []
    for item in buckets["likelyReply"]:
        responses.append(response_item("likelyReply", item["targetFamilyId"], item["targetPhraseId"], item["reason"]))
    for item in buckets["askNext"]:
        responses.append(response_item("askNext", item["targetFamilyId"], item["targetPhraseId"], item["reason"]))

    family_relations = []
    for bucket_name, items in buckets.items():
        relation_type = relation_type_for_bucket(bucket_name)
        for item in items:
            family_relations.append(family_relation(relation_type, item["targetFamilyId"], item["reason"]))

    signals = [
        signal_item(item["reason"], page["anchorPhraseId"])
        for item in page["buckets"].get("likelyReply", [])[:2]
    ]
    if not signals and page["clusterSignals"]:
        signals = [signal_item(text, page["anchorPhraseId"]) for text in page["clusterSignals"]]

    return ordered_dict(
        ("clusterId", page["clusterId"]),
        ("coverageMoment", page["coverageMoment"]),
        ("scenarioId", page["scenarioId"]),
        ("familyId", page["familyId"]),
        ("familyTitle", page["familyTitle"]),
        ("familySummary", page["familySummary"]),
        ("phraseClass", page["phraseClass"]),
        ("answerPageReady", True),
        ("anchorPhraseId", page["anchorPhraseId"]),
        ("shortestFormPhraseId", page["anchorPhraseId"]),
        ("clearerFormPhraseId", page["clearerPhraseId"]),
        ("morePoliteFormPhraseId", page["morePolitePhraseId"]),
        ("youMayHearSignals", signals),
        ("possibleTravelerResponses", responses),
        ("familyRelations", family_relations),
        ("relationBuckets", buckets),
    )


def build_hub(page, row_map):
    relation_bucket_names = [name for name in ["likelyReply", "repairIfMissed", "askNext", "escalateTo", "crossClassExit"] if page["buckets"].get(name)]

    return ordered_dict(
        ("hubId", page["hubId"]),
        ("scenarioId", page["scenarioId"]),
        ("familyId", page["familyId"]),
        ("familyTitle", page["familyTitle"]),
        ("phraseClass", page["phraseClass"]),
        ("moduleMixId", page["moduleMixId"]),
        ("relationClusterId", page["clusterId"]),
        ("anchorPhraseId", page["anchorPhraseId"]),
        ("defaultPhraseId", page["anchorPhraseId"]),
        ("quickSayPhraseId", page["anchorPhraseId"]),
        ("clearerPhraseId", page["clearerPhraseId"]),
        ("morePolitePhraseId", page["morePolitePhraseId"]),
        ("alternatePhraseIds", uniq(page["alternatePhraseIds"])),
        ("relationBuckets", relation_bucket_names),
        ("modules", [module(*spec, row_map=row_map) for spec in page["modules"]]),
    )


PAGES = [
    {
        "hubId": "viet-polite-hello",
        "clusterId": "viet-greeting-hello",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-hello",
        "familyTitle": "Hello",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-1",
        "clearerPhraseId": "v500-poli-basi-excuse-me",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["polite-5", "v500-poli-basi-excuse-me"],
        "familySummary": "Use hello as the shortest polite opener, then move quickly into the real question.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("polite-acknowledge", "polite-3", "A short acknowledgment is still the most common first answer after a brief hello."),
                relation_item("social-how-are-you", "smalltalk-7", "Friendly staff may answer with one quick social line before the practical question starts."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If the other person keeps talking after the greeting, move straight into repair instead of repeating hello."),
            ],
            "askNext": [
                relation_item("transport-destination", "taxi-1", "At pickups and counters, hello often lands only long enough to bridge into the destination or main request."),
                relation_item("social-recommend", "social-9", "A light hello can also open the door to one practical recommendation question."),
            ],
            "crossClassExit": [
                relation_item("directions-how-to-get", "directions-1", "If the exchange turns practical right away, switch immediately into the route question."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-1", "polite-5", "v500-poli-basi-excuse-me"],
                [],
                "Keep hello short and functional so the real request still arrives fast.",
                [
                    "Use the warmest opener when the interaction is already calm and mutual.",
                    "Shift to an excuse-me style opener when you need attention before the practical ask.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-1", "polite-5", "v500-poli-basi-excuse-me"],
                [],
                "This page now owns both the direct hello and the cleaner attention-getter bridge behind the same traveler moment.",
                [
                    "Hello is enough when the other person is already looking at you.",
                    "Use the attention-getter variant when a driver, vendor, or staff member is busy or turned away.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-1", "polite-3", "smalltalk-7"],
                ["likelyReply"],
                "Expect either a short acknowledgment or one light social reply before the conversation becomes practical.",
                [
                    "A quick yes-style acknowledgment is still the default answer.",
                    "Some friendly exchanges add one short social check before you ask the real question.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-1", "taxi-1", "social-9", "directions-1"],
                ["askNext", "crossClassExit"],
                "Have the next traveler move ready so the opener does not dead-end after one polite word.",
                [
                    "At pickups, the next useful move is usually the destination itself.",
                    "If the conversation stays warm, jump to the recommendation or route question quickly.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-1", "problems-2"],
                ["repairIfMissed"],
                "If the greeting lands but the reply does not, pivot into repair instead of burning time on another opener.",
                [
                    "A repair move is better than repeating hello once the other person has already answered.",
                ],
            ),
        ],
        "answerMarkers": {
            "polite-5": ["variant:also-common"],
            "v500-poli-basi-excuse-me": ["variant:clearer"],
            "smalltalk-7": ["support:likelyReply"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core hello", ["polite-1"], "keep", "Keep the clean default greeting as the flagship anchor."),
            ("attention getter bridge", ["polite-5", "v500-poli-basi-excuse-me"], "keep", "Retain both brief opener variants because they change how you start the interaction when attention still has to be won."),
            ("likely social reply", ["smalltalk-7"], "keep", "Keep the friendly social reply because it reflects a common real-world answer before the practical ask."),
            ("follow-on utility", ["social-9", "directions-1", "taxi-1"], "keep", "Keep the practical exits because hello is only useful when it hands off to the real request."),
            ("goodbye overlap", ["polite-7"], "reject", "Reject goodbye as a hello-side primary keep because it belongs to the closing page instead."),
        ],
    },
    {
        "hubId": "viet-polite-thank-you",
        "clusterId": "viet-greeting-thank-you",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-thank-you",
        "familyTitle": "Thank you",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": "polite-thank-you-polite",
        "alternatePhraseIds": ["polite-thank-you-polite"],
        "familySummary": "Use thank you to close the help moment warmly, then move into the next practical step or exit.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("polite-acknowledge", "polite-3", "A short acknowledgment is still the most common reply after a thank-you."),
                relation_item("polite-its-okay", "polite-6", "People often answer thanks with a quick it's okay / no problem style reassurance."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If the reply keeps going after your thanks, switch into repair instead of repeating gratitude."),
            ],
            "askNext": [
                relation_item("polite-goodbye", "polite-7", "A thank-you often leads straight into the graceful goodbye line."),
                relation_item("v900-time-date-book-great-see-you-then", "v900-time-date-book-great-see-you-then", "Warm service moments often end with a brief see-you-then close."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-2", "polite-thank-you-polite"],
                [],
                "Keep thank you short, then use the stronger gratitude form only when the extra warmth actually matters.",
                [
                    "The base line is enough for routine service help.",
                    "Use the stronger variant when someone really went out of their way for you.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-2", "polite-thank-you-polite", "polite-7", "v900-time-date-book-great-see-you-then"],
                [],
                "This page now keeps the full polite close cluster instead of treating thank you as a dead-end.",
                [
                    "Thank-you moments often turn directly into goodbye or a see-you-then close.",
                    "The page should let the traveler land the social finish without inventing filler wording.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-2", "polite-3", "polite-6"],
                ["likelyReply"],
                "Expect either a quick acknowledgment or a no-problem style reassurance after you thank someone.",
                [
                    "Both answers keep the interaction warm without changing the next traveler need.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-2", "polite-7", "v900-time-date-book-great-see-you-then"],
                ["askNext"],
                "Have the closing line ready so the thank-you can hand off cleanly into the actual goodbye.",
                [
                    "A plain goodbye is enough for most short service interactions.",
                    "Use the see-you-then branch when the exchange naturally points to meeting again later.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-2", "problems-2"],
                ["repairIfMissed"],
                "If the reply after thanks becomes too fast or too long, reset with repair instead of repeating thank you.",
                [
                    "A repair rescue is more useful than stacking extra gratitude once the close is already moving.",
                ],
            ),
        ],
        "answerMarkers": {
            "polite-6": ["support:likelyReply"],
            "v900-time-date-book-great-see-you-then": ["support:askNext"],
            "polite-7": ["support:askNext"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core thanks", ["polite-2"], "keep", "Keep the default thank-you as the everyday flagship anchor."),
            ("stronger gratitude", ["polite-thank-you-polite"], "keep", "Keep the more-polite form because it changes the warmth level for meaningful help."),
            ("reassurance reply", ["polite-6"], "keep", "Keep the common no-problem style reply because it is what many travelers will hear back."),
            ("warm close", ["polite-7", "v900-time-date-book-great-see-you-then"], "keep", "Keep both exit branches because they complete the real-world thank-you flow."),
            ("apology overlap", ["polite-5", "v500-poli-basi-sorry"], "reject", "Reject apology rows here because they solve a different traveler problem."),
        ],
    },
    {
        "hubId": "viet-polite-acknowledge",
        "clusterId": "viet-greeting-acknowledge",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-acknowledge",
        "familyTitle": "Yes / okay",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-3",
        "clearerPhraseId": "v500-poli-basi-okay",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["v500-poli-basi-yes", "v500-poli-basi-okay"],
        "familySummary": "Use the respectful acknowledgment first, then choose the plainer yes or okay branch only when the context really fits.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("social-how-are-you", "smalltalk-7", "A polite acknowledgment still gets followed by one more easy social line in many friendly exchanges."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If your acknowledgment buys time but not understanding, move straight into repair."),
            ],
            "askNext": [
                relation_item("v500-unde-repa-okay-now-i-understand", "v500-unde-repa-okay-now-i-understand", "Once repair works, the next useful move is often a clean okay-now-I-understand exit."),
                relation_item("v500-shop-okay-ill-take-it", "v500-shop-okay-ill-take-it", "A plain okay can also become the commitment line when you are ready to accept the offer."),
            ],
            "crossClassExit": [
                relation_item("transport-destination", "taxi-1", "After the acknowledgment, the real job is often finally saying the destination or request."),
                relation_item("directions-how-to-get", "directions-1", "If the exchange becomes task-focused, pivot into the route question immediately."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-3", "v500-poli-basi-yes", "v500-poli-basi-okay"],
                [],
                "This page now separates respectful acknowledgment from the plainer yes and okay branches that travelers actually need nearby.",
                [
                    "Keep the respectful line as the safest default when someone addresses you first.",
                    "Use the plainer yes or okay when the hierarchy is light and the situation is already moving.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-3", "v500-poli-basi-yes", "v500-poli-basi-okay", "v500-shop-okay-ill-take-it"],
                [],
                "The cluster now covers acknowledgment as response, acceptance, and soft commitment instead of one generic yes card.",
                [
                    "One branch is social and respectful.",
                    "Another branch is the short acceptance line when you are ready to move forward.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-3", "smalltalk-7"],
                ["likelyReply"],
                "A polite acknowledgment often buys one more light social sentence before the real task begins.",
                [
                    "Do not stall there: the next page should already be ready underneath it.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-3", "v500-unde-repa-okay-now-i-understand", "v500-shop-okay-ill-take-it", "taxi-1", "directions-1"],
                ["askNext", "crossClassExit"],
                "Have the follow-on ready so okay can turn into understanding, commitment, or the practical request itself.",
                [
                    "Use the repair exit when the line means you finally understood.",
                    "Use the commitment branch when you are ready to take the item or accept the offer.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-3", "problems-2"],
                ["repairIfMissed"],
                "If yes or okay is hiding confusion, switch to repair before the conversation drifts somewhere expensive or irreversible.",
                [
                    "The page should help the traveler stop nodding before they actually understand.",
                ],
            ),
        ],
        "answerMarkers": {
            "v500-poli-basi-yes": ["variant:also-common"],
            "v500-poli-basi-okay": ["variant:clearer"],
            "v500-unde-repa-okay-now-i-understand": ["support:askNext"],
            "v500-shop-okay-ill-take-it": ["support:crossClassExit"],
        },
        "relationMarkers": {
            "v500-poli-basi-yes": ["variant:also-common"],
            "v500-poli-basi-okay": ["variant:clearer"],
        },
        "slotLedger": [
            ("respectful acknowledgment", ["polite-3"], "keep", "Keep the respectful default because it is still the safest first response."),
            ("plain yes / okay", ["v500-poli-basi-yes", "v500-poli-basi-okay"], "keep", "Keep the plainer variants because they shift tone and context in ways the traveler actually notices."),
            ("understanding exit", ["v500-unde-repa-okay-now-i-understand"], "keep", "Keep the repair-exit branch because it resolves a different moment than a generic yes."),
            ("commitment acceptance", ["v500-shop-okay-ill-take-it"], "keep", "Keep the acceptance line because it moves from acknowledgment into decision."),
            ("reassurance overlap", ["v500-poli-basi-thats-okay", "v900-poli-basi-thats-fine"], "reject", "Reject reassurance rows here because they belong to calming / dismissing, not acknowledging."),
        ],
    },
    {
        "hubId": "viet-polite-no-thanks",
        "clusterId": "viet-greeting-no-thanks",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-no-thanks",
        "familyTitle": "No, thank you",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-4",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use the polite refusal first, then move into the context-specific decline that keeps the interaction calm.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("polite-acknowledge", "polite-3", "Many routine refusals end with one short acknowledgment from the other person."),
                relation_item("polite-goodbye", "polite-7", "When the refusal lands cleanly, the interaction often closes immediately."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If the person keeps talking or pushing after the refusal, move into repair instead of repeating no thanks."),
            ],
            "askNext": [
                relation_item("shopping-just-looking", "shop-4", "In shops and markets, the next useful move is often I'm just looking."),
            ],
            "crossClassExit": [
                relation_item("v900-shop-no-thank-you-ill-look-around-first", "v900-shop-no-thank-you-ill-look-around-first", "A shopper-specific decline can stay polite while still holding the browsing boundary."),
                relation_item("directions-how-to-get", "directions-1", "After declining one offer, the next useful move may be asking where to go instead."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-4", "shop-4", "v900-shop-no-thank-you-ill-look-around-first"],
                [],
                "Keep the short refusal as the flagship anchor, then let the shopper-specific branches handle the real follow-on contexts.",
                [
                    "No thanks is the safest universal decline.",
                    "The market-specific lines help you hold the refusal without sounding abrupt or trapped.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-4", "shop-4", "v900-shop-no-thank-you-ill-look-around-first", "polite-7"],
                [],
                "This page now covers both the refusal and the graceful exit that often has to follow it immediately.",
                [
                    "Use the plain refusal when you want the shortest safe line.",
                    "Use the browsing branch when the other person expects the conversation to keep going.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-4", "polite-3", "polite-7"],
                ["likelyReply"],
                "Expect either a short acknowledgment or a quick close once the refusal is understood.",
                [
                    "The real work is keeping the boundary without escalating the tone.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-4", "shop-4", "v900-shop-no-thank-you-ill-look-around-first", "directions-1"],
                ["askNext", "crossClassExit"],
                "Have the next move ready so the refusal can turn into browsing, leaving, or asking for something else.",
                [
                    "The shopper-specific branch is the main same-context follow-up.",
                    "If you decline one offer, move straight into the new practical ask instead of lingering in refusal mode.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-4", "problems-2"],
                ["repairIfMissed"],
                "If the refusal is not landing, repair is stronger than stacking more no-thank-you wording.",
                [
                    "Keep the boundary clear, then repair the misunderstanding instead of decorating the refusal.",
                ],
            ),
        ],
        "answerMarkers": {
            "shop-4": ["support:askNext"],
            "v900-shop-no-thank-you-ill-look-around-first": ["support:crossClassExit"],
            "polite-7": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core refusal", ["polite-4"], "keep", "Keep the universal polite refusal as the primary anchor."),
            ("shop refusal branch", ["shop-4", "v900-shop-no-thank-you-ill-look-around-first"], "keep", "Keep both browsing-specific branches because they stop vendor pressure without sounding hostile."),
            ("graceful close", ["polite-7"], "keep", "Keep the close because many refusals end with an immediate exit."),
            ("bare no overlap", ["v500-poli-basi-no"], "reject", "Reject generic no-only wording because it loses the politeness that makes the flagship page useful."),
        ],
    },
    {
        "hubId": "viet-polite-excuse-me",
        "clusterId": "viet-greeting-excuse-me",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-excuse-me",
        "familyTitle": "Excuse me / sorry",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-5",
        "clearerPhraseId": "v500-poli-basi-excuse-me",
        "morePolitePhraseId": "v900-poli-basi-im-very-sorry",
        "alternatePhraseIds": ["v500-poli-basi-excuse-me", "v500-poli-basi-sorry", "v900-poli-basi-im-very-sorry"],
        "familySummary": "Use excuse me as the attention-getter anchor, then branch into apology strength only when the situation truly needs it.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("polite-its-okay", "polite-6", "A quick it's okay / no problem style reassurance is the most common response after a light apology."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If the opener works but the reply does not, switch straight into repair."),
            ],
            "askNext": [
                relation_item("directions-how-to-get", "directions-1", "Excuse me is often only the bridge into the actual route or help question."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-5", "v500-poli-basi-excuse-me", "v500-poli-basi-sorry", "v900-poli-basi-im-very-sorry"],
                [],
                "This new flagship page now keeps the real excuse-me cluster together instead of scattering attention-getter and apology rows across tiny single-line families.",
                [
                    "Use the anchor when you need one phrase that can both get attention and apologize lightly.",
                    "Use the pure excuse-me line when you mainly need attention, not apology weight.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-5", "v500-poli-basi-excuse-me", "v500-poli-basi-sorry", "v900-poli-basi-im-very-sorry"],
                [],
                "The page now distinguishes passing-by attention, light apology, and stronger apology without creating decorative duplicates.",
                [
                    "Keep the apology branch only when the situation actually needs regret, not just attention.",
                    "Use the stronger apology only when the mistake or interruption is heavier than ordinary passing-by politeness.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-5", "polite-6"],
                ["likelyReply"],
                "The most common answer is a quick reassurance that clears the path for the real question or correction.",
                [
                    "That reassurance matters because it tells the traveler the interaction can keep moving normally.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-5", "directions-1"],
                ["askNext"],
                "Have the actual help question ready so excuse me does not sit on screen by itself.",
                [
                    "This phrase is strongest when it hands off immediately into directions, service help, or one concrete ask.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-5", "problems-2"],
                ["repairIfMissed"],
                "If the opener lands but the reply still misses, reset with repair instead of escalating the apology.",
                [
                    "A clearer repair line is more useful than piling on more sorry wording.",
                ],
            ),
        ],
        "answerMarkers": {
            "polite-5": ["anchor"],
            "v500-poli-basi-excuse-me": ["variant:clearer"],
            "v500-poli-basi-sorry": ["variant:also-common"],
            "v900-poli-basi-im-very-sorry": ["variant:more-polite"],
            "polite-6": ["support:likelyReply"],
        },
        "relationMarkers": {
            "polite-5": ["anchor"],
            "v500-poli-basi-excuse-me": ["variant:clearer"],
            "v500-poli-basi-sorry": ["variant:also-common"],
            "v900-poli-basi-im-very-sorry": ["variant:more-polite"],
        },
        "slotLedger": [
            ("anchor excuse me", ["polite-5"], "keep", "Promote the mixed excuse-me / sorry line into a full flagship hub because it is the real first-step anchor."),
            ("pure attention getter", ["v500-poli-basi-excuse-me"], "keep", "Keep the cleaner attention-only version because it changes the traveler's intent from apology to simple contact."),
            ("lighter apology", ["v500-poli-basi-sorry"], "keep", "Keep the lighter apology branch because it is more specific than the mixed anchor."),
            ("stronger apology", ["v900-poli-basi-im-very-sorry"], "keep", "Keep the stronger apology because it changes tone and severity in a real way."),
            ("hello / goodbye overlap", ["polite-1", "polite-7"], "reject", "Reject hello and goodbye rows here because they solve different traveler moments."),
        ],
    },
    {
        "hubId": "viet-repair-understand",
        "clusterId": "viet-repair-understand",
        "scenarioId": "understanding-repair",
        "coverageMoment": "repair",
        "familyId": "repair-understand",
        "familyTitle": "I don't understand",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "anchorPhraseId": "problems-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use I don't understand first, then narrow the rescue to repeat, simpler words, writing, or text instead of looping the whole sentence again.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("repair-slower", "problems-3", "The first useful answer is often the slower-speech branch."),
                relation_item("repair-repeat", "repair-1", "If the speech rate is not the issue, the next rescue is often just say it again."),
                relation_item("repair-number", "repair-number-amount", "Once the confusion narrows to one amount, a number-specific repeat is often enough."),
            ],
            "repairIfMissed": [
                relation_item("repair-write-down", "repair-2", "If speech still is not landing, writing is the cleanest rescue."),
                relation_item("repair-simpler-words", "repair-premium-simpler-words", "Simpler-words repair is worth keeping because it changes the next move, not just the wording."),
            ],
            "askNext": [
                relation_item("repair-text-me", "repair-premium-text-me", "Texting the detail can rescue names, addresses, and booking facts without restarting the whole conversation."),
            ],
            "crossClassExit": [
                relation_item("v500-unde-repa-sorry-i-dont-speak-vietnamese", "v500-unde-repa-sorry-i-dont-speak-vietnamese", "A language-limit clarification can reset the exchange when the problem is broader than one missed phrase."),
                relation_item("directions-how-to-get", "directions-1", "Once repair works, jump back to the actual route or task instead of lingering on the repair page."),
            ],
        },
        "modules": [
            (
                "repair-core",
                "repair-core",
                ["problems-2", "problems-3", "repair-1", "repair-premium-simpler-words"],
                [],
                "This page now keeps the real repair cluster together: not understanding, repeat, slower, and simpler all belong to the same rescue lane.",
                [
                    "Lead with the anchor instead of pretending you understood.",
                    "Then pick the smallest repair that fixes the actual problem: speed, repetition, or simpler wording.",
                ],
            ),
            (
                "show-or-write",
                "show-or-write",
                ["problems-2", "repair-2", "repair-premium-text-me"],
                ["repairIfMissed", "askNext"],
                "When speech keeps failing, move quickly into writing or text instead of replaying the same confusion.",
                [
                    "Writing is best for one exact number, code, or name.",
                    "Texting the detail is stronger when the conversation needs to keep moving across phones and screens.",
                ],
            ),
            (
                "number-check",
                "number-check",
                ["problems-2", "repair-number-amount", "repair-1", "problems-3"],
                ["likelyReply"],
                "The cluster now saves the number-specific repair branch instead of hiding it inside generic repetition.",
                [
                    "Use the number branch when the only missing piece is the amount, room number, fare, or time.",
                ],
            ),
            (
                "likely-response",
                "likely-response",
                ["problems-2", "problems-3", "repair-1", "repair-number-amount"],
                ["likelyReply"],
                "The most useful answer is whichever repair gets one exact detail over the line fast enough to act on.",
                [
                    "Slower is often enough.",
                    "If not, repetition or a number-specific repeat is usually the next rescue.",
                ],
            ),
            (
                "next-try",
                "next-try",
                ["problems-2", "repair-premium-text-me", "v500-unde-repa-sorry-i-dont-speak-vietnamese", "directions-1"],
                ["askNext", "crossClassExit"],
                "Once the missing detail is clear enough, jump back into the real traveler need instead of living on the repair page.",
                [
                    "Use the language-limit clarification when the whole exchange needs to reset, not just one sentence.",
                    "Then return to the route, booking, or service question immediately.",
                ],
            ),
            (
                "courtesy-close",
                "courtesy-close",
                ["problems-2", "repair-premium-simpler-words", "repair-premium-text-me"],
                [],
                "A good repair page should rescue one detail cleanly and then get out of the traveler's way.",
                [
                    "The real value is speed and clarity, not collecting endless paraphrases.",
                ],
            ),
        ],
        "answerMarkers": {
            "repair-premium-simpler-words": ["support:repairIfMissed"],
            "repair-premium-text-me": ["support:askNext"],
            "v500-unde-repa-sorry-i-dont-speak-vietnamese": ["support:crossClassExit"],
            "repair-number-amount": ["support:likelyReply"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core repair", ["problems-2"], "keep", "Keep the anchor because it still owns the main repair moment."),
            ("slower / repeat split", ["problems-3", "repair-1"], "keep", "Keep both because speed trouble and full repetition are different rescue moves."),
            ("simpler wording / text", ["repair-premium-simpler-words", "repair-premium-text-me"], "keep", "Keep both because they solve different repair failures."),
            ("language-limit clarification", ["v500-unde-repa-sorry-i-dont-speak-vietnamese"], "keep", "Keep the broader language-limit branch because it resets the whole exchange when necessary."),
            ("duplicate repeat phrasing", ["repair-repeat-alt"], "reject", "Reject decorative repeat variants that do not change the next move."),
        ],
    },
    {
        "hubId": "viet-money-how-much",
        "clusterId": "viet-money-how-much",
        "scenarioId": "money-numbers-prices",
        "coverageMoment": "money",
        "familyId": "money-how-much",
        "familyTitle": "How much is this",
        "phraseClass": "money-transaction",
        "moduleMixId": "money-transaction-v1",
        "anchorPhraseId": "price-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["money-how-much-common"],
        "familySummary": "Use the first price question to anchor the item, then move quickly into total, fee, quantity, or written-number repair.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("money-total", "price-8", "The first useful answer often turns into the total, not just the sticker number."),
            ],
            "repairIfMissed": [
                relation_item("money-write-total", "money-premium-write-total", "Written numbers are the cleanest rescue when spoken totals are fuzzy."),
                relation_item("v500-unde-repa-can-you-write-the-price", "v500-unde-repa-can-you-write-the-price", "If the number still is not trustworthy, ask directly for the price in writing."),
            ],
            "askNext": [
                relation_item("money-what-fee", "money-premium-what-fee", "If the number sounds off, the next honest move is often asking what the fee is for."),
                relation_item("money-price-changed", "money-premium-price-changed", "A changed-price challenge is a real next step once the quoted number no longer matches the object or app."),
                relation_item("money-total-wrong", "money-premium-total-wrong", "Use the wrong-total branch when the bill math is the problem, not the first quote."),
                relation_item("v500-mone-numb-pric-how-much-for-one", "v500-mone-numb-pric-how-much-for-one", "Quantity clarification belongs on the flagship page because many price talks narrow to one item."),
                relation_item("v900-mone-numb-pric-how-much-for-two-of-them", "v900-mone-numb-pric-how-much-for-two-of-them", "Two-of-them is a distinct traveler slot, not a decorative synonym."),
                relation_item("b2-money-itemized-bill", "b2-money-itemized-bill", "If several charges are in play, the next honest move is itemizing the bill instead of guessing."),
            ],
            "crossClassExit": [
                relation_item("money-small-bills", "price-9", "Once the price is clear, the next money problem may be the cash format you can actually pay with."),
                relation_item("b2-money-count-together", "b2-money-count-together", "Counting together is the practical follow-up when the total is clear but trust is still low."),
                relation_item("money-find-atm", "airport-4", "If cash is the only answer, the nearest ATM becomes the real next step."),
            ],
        },
        "modules": [
            (
                "price-core",
                "price-core",
                ["price-1", "money-how-much-common", "v500-mone-numb-pric-how-much-for-one", "v900-mone-numb-pric-how-much-for-two-of-them"],
                [],
                "The flagship price page now keeps the real quantity and total branches instead of pretending one generic price line is enough.",
                [
                    "Point at the exact item first.",
                    "Then move immediately into one-item, two-item, fee, or total checks as the conversation demands.",
                ],
            ),
            (
                "number-check",
                "number-check",
                ["price-1", "price-8", "money-premium-write-total", "b2-money-count-together"],
                [],
                "Keep the exact amount visible on screen, paper, or calculator before money actually moves.",
                [
                    "Written or shared numbers beat repeated speech when the stakes are price and trust.",
                ],
            ),
            (
                "fee-or-total",
                "fee-or-total",
                ["price-1", "price-8", "money-premium-what-fee", "money-premium-price-changed", "money-premium-total-wrong"],
                ["likelyReply", "askNext"],
                "The real price cluster includes total, fee, changed-price, and wrong-total checks because those are the branches travelers actually need.",
                [
                    "Keep the fee question because it changes what the number means.",
                    "Keep both challenge branches because changed price and wrong total are not the same dispute.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["price-1", "price-8"],
                ["likelyReply"],
                "Expect the first useful answer to narrow the conversation into the actual total before the traveler starts pushing back on details.",
                [
                    "Once the total lands, fee and mismatch challenges become the real next-step branches.",
                ],
            ),
            (
                "show-amount",
                "show-amount",
                ["price-1", "money-premium-write-total", "b2-money-count-together", "price-9"],
                [],
                "When the number starts drifting, put it on the page or count it together instead of arguing from memory.",
                [
                    "This page gets stronger when the traveler can point to one exact total, not when it offers more synonyms for the first question.",
                ],
            ),
            (
                "next-money-step",
                "next-money-step",
                ["price-1", "price-8", "money-premium-price-changed", "money-premium-total-wrong", "b2-money-itemized-bill", "price-9", "airport-4"],
                ["askNext", "crossClassExit"],
                "After the first price lands, the next useful step is usually a challenge, total check, or payment-format decision.",
                [
                    "Itemized bill belongs here because it is the clean follow-up when one number is hiding several charges.",
                    "Cash-format exits matter because small bills or an ATM often decide whether the conversation can close cleanly.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["price-1", "money-premium-write-total", "v500-unde-repa-can-you-write-the-price"],
                ["repairIfMissed"],
                "If the number still is not trustworthy, the page should move straight into written-price repair.",
                [
                    "Written numbers are the fastest honesty check in noisy counters and markets.",
                ],
            ),
        ],
        "answerMarkers": {
            "price-8": ["support:likelyReply"],
            "money-premium-what-fee": ["support:askNext"],
            "money-premium-write-total": ["support:repairIfMissed"],
            "money-premium-price-changed": ["support:askNext"],
            "money-premium-total-wrong": ["support:askNext"],
            "v500-mone-numb-pric-how-much-for-one": ["support:askNext"],
            "v900-mone-numb-pric-how-much-for-two-of-them": ["support:askNext"],
            "b2-money-itemized-bill": ["support:askNext"],
            "price-9": ["support:crossClassExit"],
            "b2-money-count-together": ["support:crossClassExit"],
            "b2-money-count-together-clearer": ["support:crossClassExit"],
            "airport-4": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core price ask", ["price-1"], "keep", "Keep the anchor because it still owns the first money question."),
            ("quantity branches", ["v500-mone-numb-pric-how-much-for-one", "v900-mone-numb-pric-how-much-for-two-of-them"], "keep", "Keep both because quantity changes the actual traveler move."),
            ("fee / total / challenge", ["price-8", "money-premium-what-fee", "money-premium-price-changed", "money-premium-total-wrong"], "keep", "Keep the real numeric follow-ons because they create the value moat on the flagship page."),
            ("written / count rescue", ["money-premium-write-total", "b2-money-count-together"], "keep", "Keep both because written-price repair and counting-together solve different trust failures."),
            ("cash exits", ["price-9", "airport-4"], "keep", "Keep the cash exits because price talk often ends with payment-format friction."),
            ("per-kilo duplicates", ["market-price-per-kilo"], "reject", "Reject same-function price rows that do not add a distinct traveler slot on the flagship page."),
        ],
    },
    {
        "hubId": "viet-transport-destination",
        "clusterId": "viet-transport-destination",
        "scenarioId": "transport",
        "coverageMoment": "transport",
        "familyId": "transport-destination",
        "familyTitle": "Take me here",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "anchorPhraseId": "taxi-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use the destination anchor first, then move into fare, stop-here, route-repair, or pickup-fix branches instead of re-saying the same place name.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("transport-fare", "transport-fare", "The first answer often becomes a fare discussion before the ride really starts."),
            ],
            "repairIfMissed": [
                relation_item("directions-map-pin", "directions-map-pin", "When the place name is not landing, a map pin is still the fastest rescue."),
                relation_item("transport-wrong-pickup-point", "transport-premium-wrong-pickup-point", "Pickup-point clarification is a distinct repair branch that matters before the car ever moves."),
            ],
            "askNext": [
                relation_item("transport-main-destination", "taxi-2", "If the exact pin is not enough, the next useful move is often the larger area or landmark."),
                relation_item("transport-stop-here", "taxi-3", "Once the ride is moving, stop-here becomes the most common follow-on phrase."),
                relation_item("transport-route-wrong", "transport-premium-route-wrong", "Route wrong belongs on the flagship page because it changes the traveler's safety and price risk immediately."),
                relation_item("transport-turn-around", "transport-premium-turn-around", "Turn-around is a distinct correction branch once the route has clearly gone off course."),
                relation_item("transport-wait", "taxi-6", "Wait is a real next step when the destination is right but the timing changes."),
            ],
            "crossClassExit": [
                relation_item("transport-cash", "taxi-7", "Cash is the practical payment exit that often follows the destination and fare exchange."),
                relation_item("transport-wait-here", "transport-premium-wait-here", "Wait-here matters when the ride is right but the traveler needs a short stop or pickup handoff."),
                relation_item("b2-airport-taxi-desk", "b2-airport-taxi-desk", "If street pickup is failing, the airport taxi desk becomes the safer reset."),
                relation_item("v900-airp-bord-arri-can-you-help-me-book-a-taxi", "v900-airp-bord-arri-can-you-help-me-book-a-taxi", "When the ride is not secured yet, the next useful move may be asking someone to help book the taxi."),
            ],
        },
        "modules": [
            (
                "task-core",
                "task-core",
                ["taxi-1", "taxi-2", "transport-fare"],
                [],
                "The flagship destination page now keeps the real ride-opening cluster instead of stopping at one pin-showing sentence.",
                [
                    "Say the destination first.",
                    "Then be ready for the area-level fallback or the fare branch that often arrives immediately after it.",
                ],
            ),
            (
                "operator-question",
                "operator-question",
                ["taxi-1", "transport-fare", "taxi-2"],
                ["likelyReply"],
                "The first answer often turns the conversation into fare or area confirmation before the ride fully settles.",
                [
                    "That is why the page needs more than one destination wording.",
                ],
            ),
            (
                "confirm-detail",
                "confirm-detail",
                ["taxi-1", "transport-premium-wrong-pickup-point", "directions-map-pin"],
                [],
                "Keep the destination, pickup point, and route proof visible so the ride stays tied to one concrete target.",
                [
                    "Pins and pickup details matter as much as the spoken destination once the ride app or driver gets involved.",
                ],
            ),
            (
                "what-to-show",
                "what-to-show",
                ["taxi-1", "directions-map-pin", "b2-airport-taxi-desk"],
                [],
                "Show the map or booking proof immediately when the spoken destination is not enough.",
                [
                    "The page should make visual rescue feel like the default, not a last resort.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["taxi-1", "transport-premium-route-wrong", "transport-premium-turn-around", "taxi-6"],
                [],
                "Ride problems usually come from one concrete branch: wrong route, wrong pickup, stop-here timing, or waiting.",
                [
                    "Saving those branches on the flagship page is more valuable than adding decorative rephrasings of take me here.",
                ],
            ),
            (
                "next-step",
                "next-step",
                ["taxi-1", "taxi-3", "transport-premium-route-wrong", "transport-premium-turn-around", "taxi-6", "taxi-7", "transport-premium-wait-here", "b2-airport-taxi-desk", "v900-airp-bord-arri-can-you-help-me-book-a-taxi"],
                ["askNext", "crossClassExit"],
                "Once the destination lands, the next useful move is usually stop, wait, route repair, payment, or a taxi-booking reset.",
                [
                    "Keep those branches together so the ride can stay inside one page cluster instead of bouncing through isolated leaf phrases.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["taxi-1", "directions-map-pin", "transport-premium-wrong-pickup-point"],
                ["repairIfMissed"],
                "If the first destination line is not landing, fall back to the map or pickup clarification immediately.",
                [
                    "Those are the highest-value rescues for real ride friction.",
                ],
            ),
        ],
        "answerMarkers": {
            "taxi-2": ["support:askNext"],
            "transport-fare": ["support:likelyReply"],
            "taxi-7": ["support:crossClassExit"],
            "transport-premium-route-wrong": ["support:askNext"],
            "taxi-3": ["support:askNext"],
            "transport-premium-turn-around": ["support:askNext"],
            "v500-tran-please-turn-around": ["support:askNext"],
            "taxi-6": ["support:askNext"],
            "transport-premium-wait-here": ["support:crossClassExit"],
            "transport-premium-wrong-pickup-point": ["support:repairIfMissed"],
            "b2-airport-taxi-desk": ["support:crossClassExit"],
            "b2-airport-taxi-desk-clearer": ["support:crossClassExit"],
            "v900-airp-bord-arri-can-you-help-me-book-a-taxi": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("destination anchor", ["taxi-1"], "keep", "Keep the core destination anchor because it still owns the ride-start moment."),
            ("area fallback", ["taxi-2"], "keep", "Keep the area-level destination fallback because drivers often need it when the exact place name is not enough."),
            ("fare reply", ["transport-fare"], "keep", "Keep the fare branch because it is a common first answer after the destination."),
            ("route / stop / wait repairs", ["taxi-3", "taxi-6", "transport-premium-route-wrong", "transport-premium-turn-around", "v500-tran-please-turn-around", "transport-premium-wait-here"], "keep", "Keep these branches because they are the real ride-control moves once the car is in motion or briefly paused."),
            ("payment / reset exits", ["taxi-7", "b2-airport-taxi-desk", "v900-airp-bord-arri-can-you-help-me-book-a-taxi"], "keep", "Keep the fare-payment and taxi-reset exits because they are common next utility moves around the same ride cluster."),
            ("pickup clarification", ["transport-premium-wrong-pickup-point"], "keep", "Keep pickup clarification because many failures happen before the ride starts, not during it."),
            ("hotel taxi booking overlap", ["hotel-9"], "reject", "Reject hotel taxi-booking rows as primary destination keeps because they belong on the directions / hotel help side."),
        ],
    },
    {
        "hubId": "viet-health-doctor",
        "clusterId": "viet-rel-health-doctor",
        "scenarioId": "health-pharmacy",
        "coverageMoment": "urgent-help",
        "familyId": "health-doctor",
        "familyTitle": "I need a doctor",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "anchorPhraseId": "problems-6",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use I need a doctor first, then move quickly into clinic, hospital, call-for-help, payment, or language support without diluting the urgency.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("emergency-hospital", "emergency-hospital", "The first useful answer may still be sending you straight to the hospital or doctor room."),
            ],
            "repairIfMissed": [
                relation_item("repair-translate-this", "repair-translate-this", "If the urgent line is not landing, move into direct translation help without losing urgency."),
            ],
            "askNext": [
                relation_item("v500-heal-phar-can-you-call-a-doctor", "v500-heal-phar-can-you-call-a-doctor", "Calling a doctor is the next concrete move when the helper can act but not diagnose."),
                relation_item("v500-heal-phar-i-need-a-clinic", "v500-heal-phar-i-need-a-clinic", "Clinic is a real branch when the traveler needs care fast but not full hospital escalation."),
                relation_item("v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis", "v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis", "Language-capable care is a distinct next step that can change whether the visit is actually usable."),
                relation_item("v900-heal-phar-how-long-is-the-clinic-wait", "v900-heal-phar-how-long-is-the-clinic-wait", "If care is available but delayed, the next practical question is often the clinic wait."),
            ],
            "escalateTo": [
                relation_item("v500-heal-phar-i-need-a-hospital", "v500-heal-phar-i-need-a-hospital", "Hospital belongs on the page because it is the immediate escalation when a doctor is not enough."),
                relation_item("emergency-ambulance", "emergency-2", "If the condition is worsening fast, escalate directly to ambulance help."),
            ],
            "crossClassExit": [
                relation_item("v900-heal-phar-can-i-pay-the-clinic-bill-by-card", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card", "Payment by card becomes a real follow-on once the visit is happening."),
                relation_item("emergency-shared-location", "emergency-shared-location", "If someone else is coordinating care, sharing location can become the most useful next action."),
            ],
        },
        "modules": [
            (
                "urgent-core",
                "urgent-core",
                ["problems-6", "v500-heal-phar-can-you-call-a-doctor", "v500-heal-phar-i-need-a-clinic", "v500-heal-phar-i-need-a-hospital"],
                [],
                "This page now keeps the real care-escalation cluster together instead of flattening doctor, clinic, and hospital into one vague urgent card.",
                [
                    "Lead with the doctor line when you need care fast.",
                    "Then move to clinic or hospital depending on how serious the situation is becoming.",
                ],
            ),
            (
                "risk-or-symptom-detail",
                "risk-or-symptom-detail",
                ["problems-6", "v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis", "v900-heal-phar-how-long-is-the-clinic-wait"],
                [],
                "The page gets stronger when it saves the details that really change care quality: language, wait, and where help is available.",
                [
                    "Those details matter more than adding decorative symptom synonyms to the flagship doctor page.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["problems-6", "emergency-hospital"],
                ["likelyReply"],
                "The first useful answer often tells you where to go next, not whether your grammar was perfect.",
                [
                    "That is why the hospital branch stays directly under the anchor while wait-time stays as a next question.",
                ],
            ),
            (
                "immediate-next-step",
                "immediate-next-step",
                ["problems-6", "v500-heal-phar-can-you-call-a-doctor", "v500-heal-phar-i-need-a-clinic", "v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis"],
                ["askNext"],
                "Have the next care move ready so the page can turn urgency into action instead of more explanation.",
                [
                    "Call-doctor, clinic, and language-capable care are distinct branches worth keeping.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["problems-6", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card", "v900-heal-phar-how-long-is-the-clinic-wait"],
                ["crossClassExit"],
                "Real doctor moments also produce practical side problems like wait time, payment, and how to keep coordination moving.",
                [
                    "Saving those branches is more useful than making the anchor sentence longer.",
                ],
            ),
            (
                "repair-branch",
                "repair-branch",
                ["problems-6", "repair-translate-this"],
                ["repairIfMissed"],
                "If the urgent line is not landing, switch into translation repair without softening the emergency.",
                [
                    "Repair here is about preserving urgency, not smoothing tone.",
                ],
            ),
            (
                "safety-escalation",
                "safety-escalation",
                ["problems-6", "v500-heal-phar-i-need-a-hospital", "emergency-2"],
                ["escalateTo"],
                "When a doctor is not enough, the page must already show the hospital and ambulance escalation paths.",
                [
                    "Those escalations are real traveler safety rails, not edge cases.",
                ],
            ),
        ],
        "answerMarkers": {
            "v500-heal-phar-can-you-call-a-doctor": ["support:askNext"],
            "v500-heal-phar-i-need-a-clinic": ["support:askNext"],
            "v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis": ["support:askNext"],
            "v900-heal-phar-how-long-is-the-clinic-wait": ["support:askNext"],
            "v900-heal-phar-can-i-pay-the-clinic-bill-by-card": ["support:crossClassExit"],
            "v500-heal-phar-i-need-a-hospital": ["support:escalateTo"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core doctor ask", ["problems-6"], "keep", "Keep the doctor anchor because it still owns the immediate medical help moment."),
            ("call / clinic / language", ["v500-heal-phar-can-you-call-a-doctor", "v500-heal-phar-i-need-a-clinic", "v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis"], "keep", "Keep these because they are the real next-step branches once the traveler asks for a doctor."),
            ("wait / payment reality", ["v900-heal-phar-how-long-is-the-clinic-wait", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card"], "keep", "Keep these because they reflect the practical shape of actually getting care."),
            ("hospital escalation", ["v500-heal-phar-i-need-a-hospital"], "keep", "Keep the hospital branch because it materially changes urgency."),
            ("symptom sprawl", ["health-fever-alt", "health-headache-alt"], "reject", "Reject symptom sprawl here because symptom-specific pages should own those details."),
        ],
    },
    {
        "hubId": "viet-bathroom-where",
        "clusterId": "viet-rel-bathroom-where",
        "scenarioId": "bathroom-personal-needs",
        "coverageMoment": "service",
        "familyId": "bathroom-where",
        "familyTitle": "Bathroom",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "anchorPhraseId": "bath-1",
        "clearerPhraseId": "v500-bath-pers-need-where-is-the-toilet",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["v500-bath-pers-need-where-is-the-toilet"],
        "familySummary": "Use the bathroom-location anchor first, then move into access, public-nearby, fee, or urgent child branches instead of drifting into generic hygiene shopping.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("v500-bath-pers-need-is-there-a-public-bathroom-nearby", "v500-bath-pers-need-is-there-a-public-bathroom-nearby", "A common first answer is that there is no usable bathroom here, which pushes the traveler toward the nearby-public option."),
            ],
            "repairIfMissed": [
                relation_item("v500-bath-pers-need-where-is-the-toilet", "v500-bath-pers-need-where-is-the-toilet", "Toilet wording is the cleanest rescue when bathroom wording itself is not landing."),
            ],
            "askNext": [
                relation_item("bathroom-use", "bathroom-use", "Once the bathroom is located, the next live branch is often asking whether you can actually use it."),
                relation_item("v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "Fee becomes a real follow-up once the bathroom exists but access is not free."),
                relation_item("v900-loca-serv-ever-task-my-child-needs-a-bathroom", "v900-loca-serv-ever-task-my-child-needs-a-bathroom", "Child urgency is a real branch that deserves to stay visible on the flagship page."),
            ],
            "crossClassExit": [
                relation_item("bathroom-wash-hands", "bath-4", "Wash-hands is the immediate follow-on when the traveler needs cleanup, not just location."),
                relation_item("bathroom-paper", "bath-2", "Toilet paper belongs as a close follow-on because it often becomes the next ask once the bathroom is found."),
            ],
        },
        "modules": [
            (
                "task-core",
                "task-core",
                ["bath-1", "v500-bath-pers-need-where-is-the-toilet"],
                [],
                "This new flagship page now keeps the real bathroom-location cluster together instead of leaving it as one thin anchor row plus scattered follow-ons.",
                [
                    "Lead with the bathroom anchor.",
                    "Switch to toilet wording when the direct bathroom line is not landing cleanly.",
                ],
            ),
            (
                "operator-question",
                "operator-question",
                ["bath-1", "bathroom-use", "v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "v500-bath-pers-need-is-there-a-public-bathroom-nearby"],
                ["likelyReply", "askNext"],
                "The first answer often forces one quick branch: a nearby-public fallback if there is no usable bathroom here, or one access / fee follow-up if there is.",
                [
                    "That split decides whether the traveler can solve the need in the current venue or has to redirect immediately.",
                ],
            ),
            (
                "confirm-detail",
                "confirm-detail",
                ["bath-1", "v500-bath-pers-need-is-there-a-public-bathroom-nearby", "v900-loca-serv-ever-task-my-child-needs-a-bathroom"],
                [],
                "Bathroom pages are strongest when they keep the next constraint visible: private versus public, ordinary versus urgent child need.",
                [
                    "Those are the real distinctions travelers care about under pressure.",
                ],
            ),
            (
                "what-to-show",
                "what-to-show",
                ["bath-1", "v500-bath-pers-need-where-is-the-toilet"],
                [],
                "If the place is noisy or the wording is missing, the page should let the traveler point to the simpler toilet wording fast.",
                [
                    "That keeps the rescue bounded to the same bathroom task instead of sprawling into every restroom-related context.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["bath-1", "bathroom-use", "v500-bath-pers-need-is-there-a-public-bathroom-nearby", "v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "v900-loca-serv-ever-task-my-child-needs-a-bathroom"],
                [],
                "Real bathroom friction is usually about access, a nearby-public fallback, fee, or urgency, not about fancy bathroom vocabulary.",
                [
                    "That is why the flagship page keeps those branches and rejects shower / soap / water shopping sprawl.",
                ],
            ),
            (
                "next-step",
                "next-step",
                ["bath-1", "bathroom-use", "v500-bath-pers-need-is-there-a-public-bathroom-nearby", "v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "v900-loca-serv-ever-task-my-child-needs-a-bathroom", "bath-4", "bath-2"],
                ["askNext", "crossClassExit"],
                "Once the first bathroom answer lands, the next useful move is usually access, public-nearby, fee, child urgency, or one immediate cleanup follow-on.",
                [
                    "Keep those branches close so the traveler does not have to rediscover the same need under stress.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["bath-1", "v500-bath-pers-need-where-is-the-toilet"],
                ["repairIfMissed"],
                "If the direct bathroom wording fails, the toilet variant is the fastest repair that keeps the task alive.",
                [
                    "That rescue is more useful than repeating the same bathroom line louder.",
                ],
            ),
        ],
        "answerMarkers": {
            "bath-1": ["anchor"],
            "v500-bath-pers-need-where-is-the-toilet": ["variant:clearer"],
            "bathroom-use": ["support:askNext"],
            "v500-bath-pers-need-is-there-a-public-bathroom-nearby": ["support:likelyReply"],
            "v900-bath-pers-need-is-there-a-fee-for-the-bathroom": ["support:askNext"],
            "v900-loca-serv-ever-task-my-child-needs-a-bathroom": ["support:askNext"],
            "bath-4": ["support:crossClassExit"],
            "bath-2": ["support:crossClassExit"],
        },
        "relationMarkers": {
            "bath-1": ["anchor"],
            "v500-bath-pers-need-where-is-the-toilet": ["variant:clearer"],
        },
        "slotLedger": [
            ("core bathroom ask", ["bath-1"], "keep", "Promote the bathroom location ask into a flagship hub."),
            ("toilet wording repair", ["v500-bath-pers-need-where-is-the-toilet"], "keep", "Keep the toilet wording because it is the cleanest rescue when bathroom phrasing misses."),
            ("public-nearby fallback", ["v500-bath-pers-need-is-there-a-public-bathroom-nearby"], "keep", "Keep the nearby-public branch because many first bathroom answers immediately redirect the traveler outside the current venue."),
            ("access / fee / urgency", ["bathroom-use", "v900-bath-pers-need-is-there-a-fee-for-the-bathroom", "v900-loca-serv-ever-task-my-child-needs-a-bathroom"], "keep", "Keep these because they are the real next constraints once a bathroom option is in play."),
            ("cleanup follow-ons", ["bath-4", "bath-2"], "keep", "Keep wash-hands and toilet-paper as immediate follow-ons tied to the same task."),
            ("hygiene shopping", ["bathroom-shower", "bathroom-soap", "bathroom-water"], "reject", "Reject generic hygiene shopping rows because they do not belong on the flagship bathroom-location page."),
        ],
    },
    {
        "hubId": "viet-service-card",
        "clusterId": "viet-rel-service-card",
        "scenarioId": "local-services-everyday-tasks",
        "coverageMoment": "money",
        "familyId": "service-card",
        "familyTitle": "Pay by card?",
        "phraseClass": "money-transaction",
        "moduleMixId": "money-transaction-v1",
        "anchorPhraseId": "store-6",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use can I pay by card first, then keep the real payment cluster nearby: fee, decline, retry, cash fallback, reader trouble, and bounded cross-context exits.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("v1000-money-cash-only", "v1000-money-cash-only", "One of the most common direct answers is still a clean cash-only reply."),
            ],
            "repairIfMissed": [
                relation_item("b2-money-card-reader", "b2-money-card-reader", "Reader or terminal trouble is the clean repair branch when the payment method exists but the hardware fails."),
                relation_item("b2-money-card-reader", "b2-money-card-reader-clearer", "Keep the clearer card-reader variant because hardware failure is often noisy and fast."),
            ],
            "askNext": [
                relation_item("v500-mone-numb-pric-is-there-a-card-fee", "v500-mone-numb-pric-is-there-a-card-fee", "Fee is a real next-step question once the other side says cards are possible but more expensive."),
                relation_item("v500-mone-numb-pric-my-card-was-declined", "v500-mone-numb-pric-my-card-was-declined", "Card declined is a real next branch once payment actually starts."),
                relation_item("v500-mone-numb-pric-can-i-try-another-card", "v500-mone-numb-pric-can-i-try-another-card", "Trying another card is a different traveler move from asking whether cards are accepted."),
            ],
            "crossClassExit": [
                relation_item("v900-airp-bord-arri-can-i-pay-the-driver-by-card", "v900-airp-bord-arri-can-i-pay-the-driver-by-card", "Keep the transport card-payment exit because drivers are a frequent special case."),
                relation_item("v900-food-drin-can-i-pay-the-bill-by-card", "v900-food-drin-can-i-pay-the-bill-by-card", "Keep the food-payment exit because restaurant billing creates the same traveler need in a different context."),
                relation_item("v900-heal-phar-can-i-pay-the-clinic-bill-by-card", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card", "Keep the clinic-payment exit because medical billing creates the same card question under higher stress."),
            ],
        },
        "modules": [
            (
                "price-core",
                "price-core",
                ["store-6", "v500-mone-numb-pric-is-there-a-card-fee"],
                [],
                "This new flagship page now keeps the real card-payment cluster together instead of leaving pay-by-card as a one-line leaf with no recovery path.",
                [
                    "Lead with the card-acceptance question.",
                    "Then move immediately into fee, decline, retry, or fallback once the payment reality shows up.",
                ],
            ),
            (
                "number-check",
                "number-check",
                ["store-6", "v500-mone-numb-pric-is-there-a-card-fee", "v500-mone-numb-pric-my-card-was-declined"],
                [],
                "Card moments still turn on one exact number: the fee, total, or charge that must be trusted before payment goes through.",
                [
                    "Keep the cost consequence visible whenever the payment method changes the amount.",
                ],
            ),
            (
                "fee-or-total",
                "fee-or-total",
                ["store-6", "v500-mone-numb-pric-is-there-a-card-fee", "v500-mone-numb-pric-my-card-was-declined", "v500-mone-numb-pric-can-i-try-another-card"],
                ["likelyReply", "askNext"],
                "The real card cluster includes fee, decline, and retry because those are the branches travelers actually hit at the reader.",
                [
                    "Those branches are materially different and worth keeping on the same flagship page.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["store-6", "v1000-money-cash-only"],
                ["likelyReply"],
                "Expect one of the cleanest direct replies to be a simple cash-only answer.",
                [
                    "Fee and retry branches still matter, but they are the traveler's next questions after the first reply lands.",
                ],
            ),
            (
                "show-amount",
                "show-amount",
                ["store-6", "b2-money-card-reader", "b2-money-card-reader-clearer", "v1000-money-cash-only"],
                ["repairIfMissed", "crossClassExit"],
                "If the payment method is getting tangled, show the machine, the screen, or the cash fallback instead of arguing abstractly about cards.",
                [
                    "The page should make the hardware and fallback branches obvious.",
                ],
            ),
            (
                "next-money-step",
                "next-money-step",
                ["store-6", "v500-mone-numb-pric-my-card-was-declined", "v500-mone-numb-pric-can-i-try-another-card", "v1000-money-cash-only", "v900-airp-bord-arri-can-i-pay-the-driver-by-card", "v900-food-drin-can-i-pay-the-bill-by-card", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card"],
                ["askNext", "crossClassExit"],
                "After the first card question lands, the next useful move is usually retry, fallback, or a context-specific card-payment branch.",
                [
                    "Those cross-context exits are bounded and high-value because the same payment problem shows up in transport, food, and clinic moments.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["store-6", "b2-money-card-reader", "b2-money-card-reader-clearer"],
                ["repairIfMissed"],
                "If the payment should work but still is not landing, move into the reader-trouble branch instead of re-asking the same card question.",
                [
                    "Hardware failure is a different problem from refusal, so the page should keep it visible.",
                ],
            ),
        ],
        "answerMarkers": {
            "store-6": ["anchor"],
            "v500-mone-numb-pric-is-there-a-card-fee": ["support:askNext"],
            "v500-mone-numb-pric-my-card-was-declined": ["support:askNext"],
            "v500-mone-numb-pric-can-i-try-another-card": ["support:askNext"],
            "v1000-money-cash-only": ["support:likelyReply"],
            "b2-money-card-reader": ["support:repairIfMissed"],
            "b2-money-card-reader-clearer": ["support:repairIfMissed"],
            "v900-airp-bord-arri-can-i-pay-the-driver-by-card": ["support:crossClassExit"],
            "v900-food-drin-can-i-pay-the-bill-by-card": ["support:crossClassExit"],
            "v900-heal-phar-can-i-pay-the-clinic-bill-by-card": ["support:crossClassExit"],
        },
        "relationMarkers": {
            "store-6": ["anchor"],
        },
        "slotLedger": [
            ("core card question", ["store-6"], "keep", "Promote pay by card into a full flagship hub."),
            ("fee / decline / retry", ["v500-mone-numb-pric-is-there-a-card-fee", "v500-mone-numb-pric-my-card-was-declined", "v500-mone-numb-pric-can-i-try-another-card"], "keep", "Keep these because they are the real card-payment branches, not decorative alternates."),
            ("cash fallback / reader issue", ["v1000-money-cash-only", "b2-money-card-reader", "b2-money-card-reader-clearer"], "keep", "Keep these because they rescue payment when card acceptance is partial or broken."),
            ("bounded context exits", ["v900-airp-bord-arri-can-i-pay-the-driver-by-card", "v900-food-drin-can-i-pay-the-bill-by-card", "v900-heal-phar-can-i-pay-the-clinic-bill-by-card"], "keep", "Keep these because transport, food, and clinic card moments are common enough to justify a bounded exit rail."),
            ("transfer / debit sprawl", ["b2-money-transfer-fee", "v1000-money-debit-card", "v1000-money-tip-by-card"], "reject", "Reject card-adjacent sprawl that belongs on narrower payment pages instead of the flagship card hub."),
        ],
    },
    {
        "hubId": "viet-hotel-reservation",
        "clusterId": "viet-hotel-reservation",
        "scenarioId": "hotel-accommodation",
        "coverageMoment": "hotel",
        "familyId": "hotel-reservation",
        "familyTitle": "I have a reservation",
        "phraseClass": "hotel-accommodation",
        "moduleMixId": "hotel-accommodation-v1",
        "anchorPhraseId": "hotel-1",
        "clearerPhraseId": "v900-hote-acco-the-reservation-is-under-this-name",
        "morePolitePhraseId": None,
        "alternatePhraseIds": ["v900-hote-acco-the-reservation-is-under-this-name", "v900-time-date-book-the-booking-is-under-this-name"],
        "familySummary": "Reservation now owns booking identity, proof, and confirmation rails before the desk shifts into check-in execution.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("hotel-check-in", "hotel-2", "If the reservation is found, the desk often moves straight into check-in."),
                relation_item("v900-time-date-book-can-you-confirm-my-booking", "v900-time-date-book-can-you-confirm-my-booking", "Confirmation becomes the next useful move when the booking exists but still needs to be verified."),
            ],
            "repairIfMissed": [
                relation_item("b3-repair-booking-code", "b3-repair-booking-code", "Booking-code repair belongs here because reservation identity often fails on one code or reference."),
                relation_item("b2-airport-hotel-booking-proof", "b2-airport-hotel-booking-proof", "Proof-on-screen belongs here because showing the booking is often the fastest rescue."),
            ],
            "askNext": [
                relation_item("v900-hote-acco-the-reservation-is-under-this-name", "v900-hote-acco-the-reservation-is-under-this-name", "Name ownership is a core reservation branch worth keeping directly on the flagship page."),
                relation_item("v500-hote-acco-i-booked-online", "v500-hote-acco-i-booked-online", "Booking source matters when the desk needs to know where the reservation came from."),
                relation_item("hotel-booking-wrong", "hotel-premium-booking-wrong", "Booking wrong belongs here because reservation failure is still a reservation problem before it becomes a room problem."),
            ],
            "crossClassExit": [
                relation_item("v500-time-date-book-do-i-need-a-deposit", "v500-time-date-book-do-i-need-a-deposit", "Deposit is a bounded cross-exit once the reservation is accepted and the desk moves toward check-in execution."),
                relation_item("time-have-booking", "time-4", "Time / booking confirmation belongs as a bounded exit when the desk is still uncertain about whether a booking exists at all."),
            ],
        },
        "modules": [
            (
                "desk-core",
                "desk-core",
                ["hotel-1", "v900-hote-acco-the-reservation-is-under-this-name", "v900-time-date-book-the-booking-is-under-this-name"],
                [],
                "Reservation now owns the identity proof cluster, not the check-in execution details.",
                [
                    "Lead with the reservation line when the desk still needs to find you in the system.",
                    "Then use the under-this-name variants when identity is the real sticking point.",
                ],
            ),
            (
                "room-or-booking-detail",
                "room-or-booking-detail",
                ["hotel-1", "v500-hote-acco-i-booked-online", "v900-time-date-book-can-you-confirm-my-booking"],
                [],
                "Keep the booking source and confirmation branches visible before the desk resets the conversation into generic hotel talk.",
                [
                    "These rows are useful because they narrow the actual lookup problem quickly.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["hotel-1", "hotel-2", "v900-time-date-book-can-you-confirm-my-booking"],
                ["likelyReply"],
                "Once the reservation is found, the next answer usually moves toward check-in or explicit booking confirmation.",
                [
                    "That handoff is why reservation and check-in should stay related but separate.",
                ],
            ),
            (
                "what-to-hand-over",
                "what-to-hand-over",
                ["hotel-1", "b3-repair-booking-code", "b2-airport-hotel-booking-proof"],
                ["repairIfMissed"],
                "Keep the actual proof rails ready so the desk can move from vague booking talk to one concrete confirmation.",
                [
                    "Code and proof-on-screen are the highest-value reservation rescues.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["hotel-1", "v500-hote-acco-i-booked-online", "hotel-premium-booking-wrong"],
                [],
                "Hotel reservation failures are usually about one missing identity fact, not about more hotel small talk.",
                [
                    "This flagship page should make that lookup reality obvious.",
                ],
            ),
            (
                "next-desk-step",
                "next-desk-step",
                ["hotel-1", "v900-hote-acco-the-reservation-is-under-this-name", "v500-hote-acco-i-booked-online", "hotel-premium-booking-wrong", "v500-time-date-book-do-i-need-a-deposit", "time-4"],
                ["askNext", "crossClassExit"],
                "Once the reservation is understood, the next move is usually identity proof, booking-failure repair, or a bounded handoff into deposit / booking-time details.",
                [
                    "Keep the desk moving on one concrete fact at a time instead of mixing reservation and check-in into one page.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["hotel-1", "b3-repair-booking-code", "b2-airport-hotel-booking-proof"],
                ["repairIfMissed"],
                "If the desk still cannot find the booking, move into code or proof rescue immediately.",
                [
                    "That is the cleanest way to keep the reservation problem honest and actionable.",
                ],
            ),
        ],
        "answerMarkers": {
            "v900-hote-acco-the-reservation-is-under-this-name": ["variant:clearer"],
            "v900-time-date-book-the-booking-is-under-this-name": ["variant:also-common"],
            "v500-hote-acco-i-booked-online": ["support:askNext"],
            "v900-time-date-book-can-you-confirm-my-booking": ["support:likelyReply"],
            "b3-repair-booking-code": ["support:repairIfMissed"],
            "b3-repair-booking-code-clearer": ["support:repairIfMissed"],
            "b2-airport-hotel-booking-proof": ["support:repairIfMissed"],
            "hotel-premium-booking-wrong": ["support:askNext"],
            "v500-time-date-book-do-i-need-a-deposit": ["support:crossClassExit"],
            "time-4": ["support:crossClassExit"],
            "hotel-check-in-polite": ["support:likelyReply"],
        },
        "relationMarkers": {
            "v900-hote-acco-the-reservation-is-under-this-name": ["variant:clearer"],
            "v900-time-date-book-the-booking-is-under-this-name": ["variant:also-common"],
        },
        "slotLedger": [
            ("reservation identity", ["hotel-1", "v900-hote-acco-the-reservation-is-under-this-name", "v900-time-date-book-the-booking-is-under-this-name"], "keep", "Keep these because reservation owns booking identity proof."),
            ("booking source / confirmation", ["v500-hote-acco-i-booked-online", "v900-time-date-book-can-you-confirm-my-booking"], "keep", "Keep these because they help the desk find and confirm the booking."),
            ("proof rescue", ["b3-repair-booking-code", "b2-airport-hotel-booking-proof"], "keep", "Keep these because they rescue the exact reservation failure mode."),
            ("booking wrong escalation", ["hotel-premium-booking-wrong"], "keep", "Keep booking wrong here because it still belongs to reservation truth before it becomes a room-execution problem."),
            ("check-in execution rows", ["v500-hote-acco-here-is-my-passport-for-check-in", "v500-hote-acco-do-you-need-a-deposit"], "reject", "Reject these as reservation primaries because they belong on check-in execution instead."),
        ],
    },
    {
        "hubId": "viet-hotel-check-in",
        "clusterId": "viet-hotel-check-in",
        "scenarioId": "hotel-accommodation",
        "coverageMoment": "hotel",
        "familyId": "hotel-check-in",
        "familyTitle": "Check in",
        "phraseClass": "hotel-accommodation",
        "moduleMixId": "hotel-accommodation-v1",
        "anchorPhraseId": "hotel-2",
        "clearerPhraseId": None,
        "morePolitePhraseId": "hotel-check-in-polite",
        "alternatePhraseIds": ["hotel-check-in-polite"],
        "familySummary": "Check-in now owns front-desk execution: passport handoff, deposit, and the practical trouble branch when the desk cannot complete the process.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("v500-hote-acco-here-is-my-passport-for-check-in", "v500-hote-acco-here-is-my-passport-for-check-in", "The desk usually moves straight into passport or document handoff once check-in starts."),
                relation_item("v500-hote-acco-do-you-need-a-deposit", "v500-hote-acco-do-you-need-a-deposit", "Deposit is a common immediate front-desk follow-up once the room is real."),
            ],
            "repairIfMissed": [
                relation_item("b2-airport-hotel-booking-proof", "b2-airport-hotel-booking-proof-clearer", "Keep the clearer booking-proof handoff because check-in often needs a visible screen or proof even after the reservation exists."),
            ],
            "askNext": [
                relation_item("hotel-booking-wrong", "hotel-premium-booking-wrong", "If check-in breaks, the next honest move is the booking-wrong branch."),
            ],
            "crossClassExit": [
                relation_item("v500-time-date-book-do-i-need-a-deposit", "v500-time-date-book-do-i-need-a-deposit", "Deposit detail remains a bounded cross-exit once the desk moves beyond the first check-in line."),
            ],
        },
        "modules": [
            (
                "desk-core",
                "desk-core",
                ["hotel-2", "hotel-check-in-polite"],
                [],
                "Check-in now stays focused on front-desk execution instead of duplicating reservation identity work.",
                [
                    "Use the base line when the desk already has the booking in front of them.",
                    "Use the polite variant when you want the same action with softer tone, not a different traveler step.",
                ],
            ),
            (
                "room-or-booking-detail",
                "room-or-booking-detail",
                ["hotel-2", "v500-hote-acco-here-is-my-passport-for-check-in", "v500-hote-acco-do-you-need-a-deposit"],
                [],
                "This page now keeps the exact check-in execution details visible: document handoff and deposit expectations.",
                [
                    "Those are the real desk branches once the reservation has already been found.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["hotel-2", "v500-hote-acco-here-is-my-passport-for-check-in", "v500-hote-acco-do-you-need-a-deposit"],
                ["likelyReply"],
                "Once the desk understands check-in, the next answer usually asks for passport, proof, or deposit.",
                [
                    "That is what makes check-in execution different from reservation proof.",
                ],
            ),
            (
                "what-to-hand-over",
                "what-to-hand-over",
                ["hotel-2", "v500-hote-acco-here-is-my-passport-for-check-in", "b2-airport-hotel-booking-proof-clearer"],
                ["repairIfMissed"],
                "Keep the handoff proof rails ready so check-in can keep moving in one pass.",
                [
                    "Passport and visible booking proof are the highest-value check-in objects.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["hotel-2", "v500-hote-acco-do-you-need-a-deposit", "hotel-premium-booking-wrong"],
                [],
                "Front-desk execution usually stalls on one proof or payment detail, not on the general idea of checking in.",
                [
                    "This page should make that reality obvious and fast to act on.",
                ],
            ),
            (
                "next-desk-step",
                "next-desk-step",
                ["hotel-2", "hotel-premium-booking-wrong", "v500-time-date-book-do-i-need-a-deposit"],
                ["askNext", "crossClassExit"],
                "Once the first check-in line lands, the next useful move is usually deposit detail or the booking-wrong rescue branch.",
                [
                    "Keep the desk execution path compact so it does not collapse back into reservation identity text.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["hotel-2", "b2-airport-hotel-booking-proof-clearer", "hotel-premium-booking-wrong"],
                ["repairIfMissed"],
                "If check-in still is not moving, show the clearer booking proof or jump straight to the booking-wrong branch.",
                [
                    "Those are the honest rescues when the room is not materializing at the desk.",
                ],
            ),
        ],
        "answerMarkers": {
            "v500-hote-acco-here-is-my-passport-for-check-in": ["support:likelyReply"],
            "v500-hote-acco-do-you-need-a-deposit": ["support:likelyReply"],
            "b2-airport-hotel-booking-proof-clearer": ["support:repairIfMissed"],
            "hotel-premium-booking-wrong": ["support:askNext"],
            "v500-time-date-book-do-i-need-a-deposit": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("core check-in line", ["hotel-2", "hotel-check-in-polite"], "keep", "Keep both because they are the same desk action with distinct tone."),
            ("passport / deposit execution", ["v500-hote-acco-here-is-my-passport-for-check-in", "v500-hote-acco-do-you-need-a-deposit"], "keep", "Keep these because they define front-desk execution after reservation identity is already settled."),
            ("proof handoff rescue", ["b2-airport-hotel-booking-proof-clearer"], "keep", "Keep the clearer proof handoff because it often rescues a stuck desk flow."),
            ("reservation identity overlap", ["v900-hote-acco-the-reservation-is-under-this-name", "v500-hote-acco-i-booked-online"], "reject", "Reject these as check-in primaries because reservation should own booking identity."),
        ],
    },
    {
        "hubId": "viet-polite-goodbye",
        "clusterId": "viet-greeting-goodbye",
        "scenarioId": "polite-basics",
        "coverageMoment": "greeting",
        "familyId": "polite-goodbye",
        "familyTitle": "Goodbye",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "anchorPhraseId": "polite-7",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Use goodbye as the clean closing line, but keep the thanks-before-close and see-you-then branches beside it so the interaction can end naturally.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("polite-acknowledge", "polite-3", "A short acknowledgment still is the most common answer when the closing lands."),
                relation_item("polite-its-okay", "polite-6", "Some goodbyes loop through one quick reassuring reply before the moment ends."),
            ],
            "repairIfMissed": [
                relation_item("repair-understand", "problems-2", "If the other person keeps talking as the close begins, repair is more useful than repeating goodbye."),
            ],
            "askNext": [
                relation_item("polite-thank-you", "polite-2", "Many short service closes still route through a final thank-you before the interaction ends."),
                relation_item("v900-time-date-book-great-see-you-then", "v900-time-date-book-great-see-you-then", "See-you-then is the right branch when the goodbye points toward meeting again later."),
            ],
            "crossClassExit": [
                relation_item("v900-shop-no-thank-you-ill-look-around-first", "v900-shop-no-thank-you-ill-look-around-first", "A polite exit in browsing situations is a bounded close branch worth keeping."),
            ],
        },
        "modules": [
            (
                "core-phrase",
                "core-phrase",
                ["polite-7", "polite-2", "polite-thank-you-polite"],
                [],
                "The goodbye page now keeps the full polite close cluster instead of treating goodbye as one lonely final word.",
                [
                    "Use goodbye as the base close.",
                    "Layer in thanks only when the interaction actually merits one more warm closing beat.",
                ],
            ),
            (
                "social-use-case",
                "social-use-case",
                ["polite-7", "polite-2", "v900-time-date-book-great-see-you-then", "v900-shop-no-thank-you-ill-look-around-first"],
                [],
                "Closing moments vary by context, so the page now keeps the real short close, see-you-later, and polite-exit branches together.",
                [
                    "That is more useful than scattering every close-adjacent row into separate one-line families.",
                ],
            ),
            (
                "likely-reply",
                "likely-reply",
                ["polite-7", "polite-3", "polite-6"],
                ["likelyReply"],
                "Expect the close to draw one last acknowledgment or reassurance, not a whole new conversation branch.",
                [
                    "That is why the page should help the traveler finish cleanly and move on.",
                ],
            ),
            (
                "say-next",
                "say-next",
                ["polite-7", "polite-2", "polite-thank-you-polite", "v900-time-date-book-great-see-you-then", "v900-shop-no-thank-you-ill-look-around-first"],
                ["askNext", "crossClassExit"],
                "Have the final close branch ready so goodbye can turn into thanks, see-you-then, or a polite browsing exit without backtracking.",
                [
                    "These are the real short-closing slots travelers reuse constantly.",
                ],
            ),
            (
                "graceful-exit",
                "graceful-exit",
                ["polite-7", "problems-2"],
                ["repairIfMissed"],
                "If the close is not landing, repair is still stronger than repeating goodbye louder or longer.",
                [
                    "A clean repair keeps the exit calm without reopening the whole interaction.",
                ],
            ),
        ],
        "answerMarkers": {
            "polite-2": ["support:askNext"],
            "polite-thank-you-polite": ["support:askNext"],
            "polite-6": ["support:likelyReply"],
            "v900-time-date-book-great-see-you-then": ["support:askNext"],
            "v900-shop-no-thank-you-ill-look-around-first": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("plain goodbye", ["polite-7"], "keep", "Keep the direct close as the flagship anchor."),
            ("thanks-before-close", ["polite-2", "polite-thank-you-polite"], "keep", "Keep the gratitude branch because many real goodbyes still pass through it."),
            ("future meet close", ["v900-time-date-book-great-see-you-then"], "keep", "Keep see-you-then because it closes a different kind of interaction than plain goodbye."),
            ("shopping exit", ["v900-shop-no-thank-you-ill-look-around-first"], "keep", "Keep the polite browsing exit because it solves a common real-world close branch."),
            ("hello overlap", ["polite-1", "polite-5"], "reject", "Reject hello and excuse-me rows as goodbye primaries because they belong to opening moments."),
        ],
    },
    {
        "hubId": "viet-directions-how-to-get",
        "clusterId": "viet-directions-how-to-get",
        "scenarioId": "directions-navigation",
        "coverageMoment": "navigation",
        "familyId": "directions-how-to-get",
        "familyTitle": "How do I get there",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "anchorPhraseId": "directions-1",
        "clearerPhraseId": None,
        "morePolitePhraseId": None,
        "alternatePhraseIds": [],
        "familySummary": "Lead with the route question, then keep map, turn, platform, pickup, and taxi-exit branches ready so the traveler can keep moving.",
        "clusterSignals": [],
        "buckets": {
            "likelyReply": [
                relation_item("directions-map-pin", "directions-map-pin", "If words alone are not enough, the most useful answer often turns into map-based guidance."),
            ],
            "repairIfMissed": [
                relation_item("directions-map-pin", "directions-map-pin-clearer", "Keep the clearer map-pin branch because route help often has to become visual fast."),
                relation_item("transport-wrong-pickup-point", "transport-premium-wrong-pickup-point", "Pickup clarification is a real repair branch when route words still do not line up with the place."),
            ],
            "askNext": [
                relation_item("directions-turn-right", "directions-5", "Turn-right confirmation is a real next slot once the route explanation starts getting specific."),
                relation_item("transport-platform", "transport-1", "Platform choice belongs here because route questions often end in one exact boarding or platform answer."),
                relation_item("transport-stop-here", "transport-stop-here-clearer", "Stop-here belongs as a bounded next step because route explanations often need one clearer stopping cue."),
            ],
            "crossClassExit": [
                relation_item("hotel-call-taxi", "hotel-9", "If walking or transit directions fail, the next useful move may be asking the hotel to call a taxi."),
                relation_item("transport-destination", "taxi-1", "Sometimes the clean reset is moving back to the ride-destination page and showing the place directly."),
            ],
        },
        "modules": [
            (
                "task-core",
                "task-core",
                ["directions-1", "directions-map-pin", "directions-map-pin-clearer"],
                [],
                "The flagship directions page now keeps the real route-help cluster together instead of stopping at one generic how-do-I-get-there line.",
                [
                    "Lead with the destination or landmark name.",
                    "Then move quickly to the map branch when spoken route detail is not enough.",
                ],
            ),
            (
                "operator-question",
                "operator-question",
                ["directions-1", "directions-map-pin", "directions-5", "transport-1"],
                ["likelyReply"],
                "The first useful answer usually narrows the route into map, turn, or platform detail.",
                [
                    "Those are the branches that actually help the traveler move, so they belong directly on the flagship page.",
                ],
            ),
            (
                "confirm-detail",
                "confirm-detail",
                ["directions-1", "transport-premium-wrong-pickup-point", "transport-stop-here-clearer"],
                [],
                "Keep the exact place, pickup point, or stopping cue visible while the route explanation is live.",
                [
                    "One missing place detail is usually what breaks directions, not the length of the sentence.",
                ],
            ),
            (
                "what-to-show",
                "what-to-show",
                ["directions-1", "directions-map-pin", "directions-map-pin-clearer"],
                [],
                "Showing the pin or screen is often faster than asking for another spoken route summary.",
                [
                    "That visual handoff is a core part of the flagship directions cluster now.",
                ],
            ),
            (
                "local-reality",
                "local-reality",
                ["directions-1", "directions-5", "transport-1", "hotel-9"],
                [],
                "Real route help often collapses into one turn, one platform, or one taxi reset instead of a long perfect explanation.",
                [
                    "Saving those branches is more useful than adding more generic route phrasings.",
                ],
            ),
            (
                "next-step",
                "next-step",
                ["directions-1", "directions-5", "transport-1", "transport-stop-here-clearer", "hotel-9", "taxi-1"],
                ["askNext", "crossClassExit"],
                "Once the first route line lands, the next useful move is usually one turn, one platform choice, one clearer stop cue, or a taxi reset.",
                [
                    "The page should help the traveler keep moving instead of backing out to browse again.",
                ],
            ),
            (
                "fallback",
                "fallback",
                ["directions-1", "directions-map-pin-clearer", "transport-premium-wrong-pickup-point"],
                ["repairIfMissed"],
                "If the spoken route is still muddy, move into the clearer map or pickup repair branch immediately.",
                [
                    "That is the fastest rescue for real navigation friction.",
                ],
            ),
        ],
        "answerMarkers": {
            "directions-map-pin-clearer": ["support:repairIfMissed"],
            "directions-5": ["support:askNext"],
            "transport-1": ["support:askNext"],
            "transport-stop-here-clearer": ["support:askNext"],
            "transport-premium-wrong-pickup-point": ["support:repairIfMissed"],
            "hotel-9": ["support:crossClassExit"],
        },
        "relationMarkers": {},
        "slotLedger": [
            ("map rescue", ["directions-map-pin", "directions-map-pin-clearer"], "keep", "Keep the map rescue because route help often becomes visual immediately."),
            ("turn / platform / stop", ["directions-5", "transport-1", "transport-stop-here-clearer"], "keep", "Keep these because they are the real next route slots after the first directions question."),
            ("pickup clarification", ["transport-premium-wrong-pickup-point"], "keep", "Keep pickup clarification because route problems often start with the wrong meeting point."),
            ("taxi exit", ["hotel-9"], "keep", "Keep the taxi exit because sometimes the right route answer is to stop walking and book a ride."),
            ("destination overlap", ["taxi-1"], "reject", "Reject destination rows as primary directions keeps because the destination page already owns that anchor."),
        ],
    },
]


REMOVE_TOKENS = {
    "money-premium-what-fee": [
        "answer-page-sample=viet-money-how-much:support:likelyReply",
    ],
    "v900-heal-phar-how-long-is-the-clinic-wait": [
        "answer-page-sample=viet-health-doctor:support:likelyReply",
    ],
    "bathroom-use": [
        "answer-page-sample=viet-bathroom-where:support:likelyReply",
    ],
    "v500-bath-pers-need-is-there-a-public-bathroom-nearby": [
        "answer-page-sample=viet-bathroom-where:support:askNext",
    ],
    "v900-bath-pers-need-is-there-a-fee-for-the-bathroom": [
        "answer-page-sample=viet-bathroom-where:support:likelyReply",
    ],
    "v500-dire-navi-where-is-the-nearest-restroom": [
        "answer-page-sample=viet-bathroom-where:support:crossClassExit",
    ],
    "v500-airp-bord-arri-where-are-the-restrooms": [
        "answer-page-sample=viet-bathroom-where:support:crossClassExit",
    ],
    "v500-mone-numb-pric-is-there-a-card-fee": [
        "answer-page-sample=viet-service-card:support:likelyReply",
    ],
    "v1000-money-cash-only": [
        "answer-page-sample=viet-service-card:support:crossClassExit",
    ],
}


def page_by_hub():
    return {page["hubId"]: page for page in PAGES}


def page_by_cluster():
    return {page["clusterId"]: page for page in PAGES}


def required_phrase_ids():
    ids = set()
    for page in PAGES:
        ids.add(page["anchorPhraseId"])
        if page["clearerPhraseId"]:
            ids.add(page["clearerPhraseId"])
        if page["morePolitePhraseId"]:
            ids.add(page["morePolitePhraseId"])
        ids.update(page["alternatePhraseIds"])
        for _, _, source_ids, _, _, _ in page["modules"]:
            ids.update(source_ids)
        for marker_map in [page["answerMarkers"], page["relationMarkers"]]:
            ids.update(marker_map.keys())
        for items in page["buckets"].values():
            for item in items:
                ids.add(item["targetPhraseId"])
    return ids


def replace_or_append(items, key_name, replacements):
    seen = set()
    out = []
    for item in items:
        key = item[key_name]
        if key in replacements:
            out.append(replacements[key])
            seen.add(key)
        else:
            out.append(item)
    for key, replacement in replacements.items():
        if key not in seen:
            out.append(replacement)
    return out


def update_counts(answer_data, relation_data, rows):
    answer_hubs = answer_data["hubs"]
    answer_phrase_classes = []
    for hub in answer_hubs:
        if hub["phraseClass"] not in answer_phrase_classes:
            answer_phrase_classes.append(hub["phraseClass"])

    answer_marked_rows = 0
    support_rows = 0
    for row in rows:
        answer_tokens = note_tokens(row["notes"], "answer-page-sample=")
        if answer_tokens:
            answer_marked_rows += 1
        if any(":support:" in token for token in answer_tokens):
            support_rows += 1

    answer_data["hubCount"] = len(answer_hubs)
    answer_data["phraseClassCount"] = len(answer_phrase_classes)
    answer_data["sourceOfTruth"]["supportingRowCount"] = support_rows

    relation_data["clusterCount"] = len(relation_data["clusters"])
    relation_data["purpose"] = (
        f"Additive relation-ready handoff for phrase-detail, listing-page, and answer-page work across "
        f"{len(answer_hubs)} answer-page-ready Viet hubs plus {len(relation_data['clusters']) - len(answer_hubs)} "
        f"supporting relation-only clusters that keep linked phrase navigation inside the authored relation sample, "
        f"without replacing the current scenario -> family -> phrase-row model."
    )
    relation_data["answerPageCoverage"]["hubCount"] = len(answer_hubs)
    relation_data["answerPageCoverage"]["relationOnlyClusterCount"] = len(relation_data["clusters"]) - len(answer_hubs)
    relation_data["answerPageCoverage"]["totalRelationClusterCount"] = len(relation_data["clusters"])
    relation_data["answerPageCoverage"]["phraseClassCount"] = len(answer_phrase_classes)
    relation_data["answerPageCoverage"]["phraseClasses"] = answer_phrase_classes
    relation_data["answerPageCoverage"]["supportingRowCount"] = support_rows

    return {
        "answer_marked_rows": answer_marked_rows,
        "support_rows": support_rows,
        "hub_count": len(answer_hubs),
        "cluster_count": len(relation_data["clusters"]),
        "relation_only_count": len(relation_data["clusters"]) - len(answer_hubs),
        "phrase_class_count": len(answer_phrase_classes),
    }


def replace_exact(text: str, old: str, new: str) -> str:
    if old not in text:
        raise ValueError(f"Expected text not found: {old}")
    return text.replace(old, new)


def update_docs(stats):
    answer_marked = stats["answer_marked_rows"]
    support_rows = stats["support_rows"]
    hub_count = stats["hub_count"]
    cluster_count = stats["cluster_count"]
    relation_only = stats["relation_only_count"]

    readme = README_PATH.read_text(encoding="utf-8")
    readme = re.sub(r"- `relation-sample-v1\.json` now maps `\d+` current Viet relation clusters:", f"- `relation-sample-v1.json` now maps `{cluster_count}` current Viet relation clusters:", readme)
    readme = re.sub(r"  - `\d+` answer-page-ready hubs:", f"  - `{hub_count}` answer-page-ready hubs:", readme, count=1)
    if "plus `3` more flagship-cluster harvest promotions from T-154" not in readme:
        readme = readme.replace(
            "    - plus `30` more flagship-deepening promotions from T-152 across urgent-help-medical, repair-clarification, money-transaction, hotel-accommodation, and practical service/navigation",
            "    - plus `30` more flagship-deepening promotions from T-152 across urgent-help-medical, repair-clarification, money-transaction, hotel-accommodation, and practical service/navigation\n    - plus `3` more flagship-cluster harvest promotions from T-154: `polite-excuse-me`, `bathroom-where`, and `service-card`",
        )
    readme = re.sub(
        r"- `answer-page-sample-v1\.json` now maps `\d+` answer-page-ready hubs across `7` phrase classes with ordered module mixes and compact module content",
        f"- `answer-page-sample-v1.json` now maps `{hub_count}` answer-page-ready hubs across `7` phrase classes with ordered module mixes and compact module content",
        readme,
    )
    readme = re.sub(
        r"- `phrase-source\.csv` now carries `\d+` answer-page-marked rows total, including `\d+` rows with explicit answer-page support tokens",
        f"- `phrase-source.csv` now carries `{answer_marked}` answer-page-marked rows total, including `{support_rows}` rows with explicit answer-page support tokens",
        readme,
    )
    README_PATH.write_text(readme, encoding="utf-8")

    source_notes = SOURCE_NOTES_PATH.read_text(encoding="utf-8")
    source_notes = re.sub(
        r"- The current relation sample maps `\d+` family clusters across arrival, greeting, social, transport, service, food, money, hotel, phone, repair, and urgent-help / medical moments: `\d+` answer-page-ready hubs plus `\d+` supporting relation-only clusters\.",
        f"- The current relation sample maps `{cluster_count}` family clusters across arrival, greeting, social, transport, service, food, money, hotel, phone, repair, and urgent-help / medical moments: `{hub_count}` answer-page-ready hubs plus `{relation_only}` supporting relation-only clusters.",
        source_notes,
    )
    source_notes = re.sub(
        r"- The current answer-page sample maps `\d+` enriched hubs across `7` phrase classes so listing-page work can use real modular answer data instead of one repeated page shape\.",
        f"- The current answer-page sample maps `{hub_count}` enriched hubs across `7` phrase classes so listing-page work can use real modular answer data instead of one repeated page shape.",
        source_notes,
    )
    source_notes = re.sub(
        r"- `phrase-source\.csv` currently carries `\d+` answer-page-marked rows total, including `\d+` rows with explicit answer-page support tokens for linked reply / repair / next-step rails\.",
        f"- `phrase-source.csv` currently carries `{answer_marked}` answer-page-marked rows total, including `{support_rows}` rows with explicit answer-page support tokens for linked reply / repair / next-step rails.",
        source_notes,
    )
    if "marker declares sidecar membership, not a family merge" not in source_notes:
        source_notes = source_notes.replace(
            "- Use the `notes` field only for lightweight trace markers such as `relation-sample=viet-hotel-check-in:anchor`, `answer-page-sample=viet-service-email-file:variant:clearer`, or `answer-page-sample=viet-money-final-price:support:askNext`.",
            "- Use the `notes` field only for lightweight trace markers such as `relation-sample=viet-hotel-check-in:anchor`, `answer-page-sample=viet-service-email-file:variant:clearer`, or `answer-page-sample=viet-money-final-price:support:askNext`.\n- In flagship-cluster harvest passes, a row may participate in a canonical hub or relation cluster even when its base `family_id` stays a nearby singleton family; the marker declares sidecar membership, not a family merge.",
        )
    if "Some legacy anchors already sit above that historical cap" not in source_notes:
        source_notes = source_notes.replace(
            "- In flagship-cluster harvest passes, a row may participate in a canonical hub or relation cluster even when its base `family_id` stays a nearby singleton family; the marker declares sidecar membership, not a family merge.",
            "- In flagship-cluster harvest passes, a row may participate in a canonical hub or relation cluster even when its base `family_id` stays a nearby singleton family; the marker declares sidecar membership, not a family merge.\n- Some legacy anchors already sit above that historical cap from earlier passes; the rule in later passes is to avoid adding more answer-page markers to those rows.",
        )
    SOURCE_NOTES_PATH.write_text(source_notes, encoding="utf-8")

    relation_notes = RELATION_NOTES_PATH.read_text(encoding="utf-8")
    relation_notes = re.sub(r"The current sample covers `\d+` family-primary relation clusters:", f"The current sample covers `{cluster_count}` family-primary relation clusters:", relation_notes)
    relation_notes = re.sub(r"- `\d+` answer-page-ready hubs:", f"- `{hub_count}` answer-page-ready hubs:", relation_notes, count=1)
    relation_notes = re.sub(
        r"  - plus `30` more flagship-deepening promotions from T-152:\n(?:    - .+\n)+(?:  - plus `3` more flagship-cluster harvest promotions from T-154:\n(?:    - .+\n)+)*",
        "  - plus `30` more flagship-deepening promotions from T-152:\n"
        "    - urgent help / medical: `emergency-manager-now`, `emergency-call-help`, `emergency-get-away`, `emergency-police`, `health-doctor`, `health-allergy`, `emergency-wallet-stolen`\n"
        "    - repair / clarification: `v900-heal-phar-please-write-the-instructions`, `repair-translate-this`, `v500-unde-repa-can-you-write-the-price`, `repair-which-one`, `repair-time-exact`, `repair-type-phone`\n"
        "    - money / transaction: `v900-tran-is-that-the-total-price`, `money-total`, `money-what-fee`, `money-service-included`, `b2-money-itemized-bill`\n"
        "    - hotel / accommodation: `v500-hote-acco-here-is-my-passport-for-check-in`, `hotel-booking-wrong`, `hotel-room-not-ready`, `v500-hote-acco-do-you-need-a-deposit`, `hotel-quiet-room`, `v500-hote-acco-can-someone-come-fix-it`, `hotel-no-hot-water`, `v500-hote-acco-can-i-change-rooms`, `hotel-late-checkout`\n"
        "    - practical service / navigation: `service-water`, `service-receipt`, `directions-right-route`\n"
        "  - plus `3` more flagship-cluster harvest promotions from T-154:\n"
        "    - greeting / social: `polite-excuse-me`\n"
        "    - practical service / navigation: `bathroom-where`\n"
        "    - money / transaction: `service-card`\n",
        relation_notes,
        count=1,
    )
    relation_notes = re.sub(
        r"- `relation-sample-v1\.json`\n  Owns family-level relation edges, typed relation buckets, and phrase-detail guidance for the current `\d+`-cluster sample, including `\d+` answer-page-ready hubs\.",
        f"- `relation-sample-v1.json`\n  Owns family-level relation edges, typed relation buckets, and phrase-detail guidance for the current `{cluster_count}`-cluster sample, including `{hub_count}` answer-page-ready hubs.",
        relation_notes,
    )
    relation_notes = re.sub(
        r"- `answer-page-sample-v1\.json`\n  Owns ordered answer-page module mixes and compact module content for the current `\d+` answer-page-ready hubs across `7` phrase classes\.",
        f"- `answer-page-sample-v1.json`\n  Owns ordered answer-page module mixes and compact module content for the current `{hub_count}` answer-page-ready hubs across `7` phrase classes.",
        relation_notes,
    )
    if "marker expresses sidecar membership, not a family rewrite" not in relation_notes:
        relation_notes = relation_notes.replace(
            "Keep the tokens boring and parseable. Do not turn the notes field into a mini graph database.",
            "Keep the tokens boring and parseable. Do not turn the notes field into a mini graph database.\n\nFlagship-cluster passes may also attach `variant:*` or `support:*` markers to approved rows whose base `family_id` stays separate in the CSV when that row materially sharpens the canonical flagship page. The marker expresses sidecar membership, not a family rewrite.",
        )
    relation_notes = re.sub(
        r"- Keep the sample app-safe and website-safe\. The current `\d+`-cluster relation pack with `\d+` answer-page-ready hubs is still bounded, not a giant public graph dump or a claim that all live Viet families are relation-authored\.",
        f"- Keep the sample app-safe and website-safe. The current `{cluster_count}`-cluster relation pack with `{hub_count}` answer-page-ready hubs is still bounded, not a giant public graph dump or a claim that all live Viet families are relation-authored.",
        relation_notes,
    )
    RELATION_NOTES_PATH.write_text(relation_notes, encoding="utf-8")

    v2_model = V2_MODEL_PATH.read_text(encoding="utf-8")
    v2_model = re.sub(
        r"- `relation-sample-v1\.json` owns family-level relation edges plus typed reply / next-step / repair / escalation buckets for the current `\d+`-cluster high-value sample, including `\d+` answer-page-ready hubs and `\d+` supporting relation-only clusters",
        f"- `relation-sample-v1.json` owns family-level relation edges plus typed reply / next-step / repair / escalation buckets for the current `{cluster_count}`-cluster high-value sample, including `{hub_count}` answer-page-ready hubs and `{relation_only}` supporting relation-only clusters",
        v2_model,
    )
    v2_model = re.sub(
        r"- `answer-page-sample-v1\.json` owns ordered module mixes and compact module content for the current `\d+` answer-page-ready hubs across `7` phrase classes, with lightweight support-row marker grammar in `phrase-source\.csv`",
        f"- `answer-page-sample-v1.json` owns ordered module mixes and compact module content for the current `{hub_count}` answer-page-ready hubs across `7` phrase classes, with lightweight support-row marker grammar in `phrase-source.csv`",
        v2_model,
    )
    v2_model = re.sub(
        r"- manifest-level `relationExport` and module-level `relationCoverage` summarize how much of the current starter export is relation-backed, including the source sample identity and current `\d+`-cluster relation boundary with `\d+` answer-page-ready hubs",
        f"- manifest-level `relationExport` and module-level `relationCoverage` summarize how much of the current starter export is relation-backed, including the source sample identity and current `{cluster_count}`-cluster relation boundary with `{hub_count}` answer-page-ready hubs",
        v2_model,
    )
    V2_MODEL_PATH.write_text(v2_model, encoding="utf-8")

    rel_model = REL_MODEL_PATH.read_text(encoding="utf-8")
    rel_model = re.sub(
        r"- `content-draft/viet/relation-sample-v1\.json` carries a bounded `\d+`-cluster high-value family-level relation sidecar for phrase-detail and listing work, including `\d+` answer-page-ready hubs and `\d+` supporting relation-only follow-on clusters",
        f"- `content-draft/viet/relation-sample-v1.json` carries a bounded `{cluster_count}`-cluster high-value family-level relation sidecar for phrase-detail and listing work, including `{hub_count}` answer-page-ready hubs and `{relation_only}` supporting relation-only follow-on clusters",
        rel_model,
    )
    rel_model = re.sub(
        r"- `content-draft/viet/answer-page-sample-v1\.json` carries ordered module mixes and compact module content for `\d+` answer-page-ready hubs across `7` phrase classes while referencing relation truth instead of restating it",
        f"- `content-draft/viet/answer-page-sample-v1.json` carries ordered module mixes and compact module content for `{hub_count}` answer-page-ready hubs across `7` phrase classes while referencing relation truth instead of restating it",
        rel_model,
    )
    rel_model = re.sub(
        r"(?:- some legacy anchors already sit above that historical cap from earlier passes; the rule in later passes is to avoid pushing those rows higher\n)+",
        "- some legacy anchors already sit above that historical cap from earlier passes; the rule in later passes is to avoid pushing those rows higher\n",
        rel_model,
    )
    if "- some legacy anchors already sit above that historical cap from earlier passes; the rule in later passes is to avoid pushing those rows higher" not in rel_model:
        rel_model = rel_model.replace(
            "- when expanding answer-page support markers, preserve low-density spread: do not add new answer-page markers to legacy rows already carrying `6+` answer-page tokens, and keep newly touched rows below the `8`-token cap",
            "- when expanding answer-page support markers, preserve low-density spread: do not add new answer-page markers to legacy rows already carrying `6+` answer-page tokens, and keep newly touched rows below the `8`-token cap\n- some legacy anchors already sit above that historical cap from earlier passes; the rule in later passes is to avoid pushing those rows higher",
        )
    rel_model = re.sub(r'"sampleClusterCount": \d+,', f'"sampleClusterCount": {cluster_count},', rel_model)
    rel_model = re.sub(
        r"The canonical block above intentionally pins both the source relation sample identity and its current `\d+`-cluster boundary so the validator can fail if the sidecar, docs, or exported manifest drift apart\.",
        f"The canonical block above intentionally pins both the source relation sample identity and its current `{cluster_count}`-cluster boundary so the validator can fail if the sidecar, docs, or exported manifest drift apart.",
        rel_model,
    )
    REL_MODEL_PATH.write_text(rel_model, encoding="utf-8")


def write_json(path: Path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def write_rows(rows, fieldnames):
    with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def build_harvest_notes(stats, newly_touched_ids):
    low_density_rows = [
        "polite-thank-you-polite",
        "money-how-much-common",
        "hotel-check-in-polite",
        "transport-stop-here-clearer",
        "repair-number-amount",
        "v900-time-date-book-the-booking-is-under-this-name",
    ]
    text = f"""# Viet Flagship Cluster Harvest Notes

## Sample delta

- targeted flagship pages audited: `15`
- existing flagship hubs materially deepened: `12`
- new full answer-page hubs promoted: `3`
- answer-page hub count: `80 -> {stats["hub_count"]}`
- relation cluster count: `99 -> {stats["cluster_count"]}`
- relation-only clusters unchanged: `{stats["relation_only_count"]}`
- distinct retained / supporting phrase rows traced by the flagship harvest mapping: `{len(newly_touched_ids)}`
- answer-page-marked rows total: `{stats["answer_marked_rows"]}`
- rows carrying explicit answer-page support markers: `{stats["support_rows"]}`

## New full hubs

- `viet-polite-excuse-me` / `viet-greeting-excuse-me`
- `viet-bathroom-where` / `viet-rel-bathroom-where`
- `viet-service-card` / `viet-rel-service-card`

## Deepened existing hubs

- `viet-polite-hello`
- `viet-polite-thank-you`
- `viet-polite-acknowledge`
- `viet-polite-no-thanks`
- `viet-repair-understand`
- `viet-money-how-much`
- `viet-transport-destination`
- `viet-health-doctor`
- `viet-hotel-reservation`
- `viet-hotel-check-in`
- `viet-polite-goodbye`
- `viet-directions-how-to-get`

## Density discipline

- did not add further answer-page markers to already saturated legacy rows such as `repair-2`, `taxi-1`, `problems-2`, `directions-1`, and `directions-map-pin`; those older high-density anchors still remain in the historical sample
- leaned on lower-density adjacent rows where possible, especially:
  - {", ".join(f"`{row}`" for row in low_density_rows)}
- kept the card hub bounded to acceptance, fee, decline, retry, cash fallback, reader trouble, and a few cross-context exits
- kept the bathroom hub bounded to location, public access, fee, child urgency, and immediate cleanup follow-ons
- kept reservation ownership on booking identity / proof and check-in ownership on front-desk execution

## Rejected / demoted patterns

- reassurance rows like `that's okay` / `that's fine` on the acknowledge page
- shower / soap / water shopping on the bathroom page
- transfer-fee / debit-card / tip-by-card sprawl on the card hub
- same-function per-kilo or decorative price synonyms on the flagship money page
- hotel taxi booking as a primary destination keep on the ride-destination page
"""
    HARVEST_NOTES_PATH.write_text(text, encoding="utf-8")


def build_triage_ledger():
    lines = ["# Viet Flagship Cluster Triage Ledger", "", "Compact keep / reject ledger keyed to the 15 targeted flagship pages.", ""]
    for page in PAGES:
        lines.append(f"## {page['hubId']}")
        lines.append("")
        lines.append("| Slot | Rows | Decision | Rationale |")
        lines.append("| --- | --- | --- | --- |")
        for slot, rows, decision, rationale in page["slotLedger"]:
            row_text = ", ".join(f"`{row}`" for row in rows)
            lines.append(f"| {slot} | {row_text} | {decision} | {rationale} |")
        lines.append("")
    TRIAGE_LEDGER_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def harvested_row_ids():
    ids = set()
    for page in PAGES:
        ids.add(page["anchorPhraseId"])
        if page["clearerPhraseId"]:
            ids.add(page["clearerPhraseId"])
        if page["morePolitePhraseId"]:
            ids.add(page["morePolitePhraseId"])
        ids.update(page["alternatePhraseIds"])
        ids.update(page["answerMarkers"].keys())
        ids.update(page["relationMarkers"].keys())
    return sorted(ids)


def main():
    rows, fieldnames = load_rows()
    row_map = {row["phrase_id"]: row for row in rows}

    missing = sorted(required_phrase_ids() - row_map.keys())
    if missing:
        raise ValueError(f"Missing phrase ids: {missing}")

    answer_data = load_json(ANSWER_PATH)
    relation_data = load_json(RELATION_PATH)

    for phrase_id, tokens in REMOVE_TOKENS.items():
        for token in tokens:
            row_map[phrase_id]["notes"] = remove_notes_token(row_map[phrase_id]["notes"], token)

    for page in PAGES:
        for phrase_id, roles in page["answerMarkers"].items():
            for role in roles:
                token = f"answer-page-sample={page['hubId']}:{role}"
                row_map[phrase_id]["notes"] = add_notes_token(row_map[phrase_id]["notes"], token)
        for phrase_id, roles in page["relationMarkers"].items():
            for role in roles:
                token = f"relation-sample={page['clusterId']}:{role}"
                row_map[phrase_id]["notes"] = add_notes_token(row_map[phrase_id]["notes"], token)

    new_hubs = {page["hubId"]: build_hub(page, row_map) for page in PAGES}
    answer_data["hubs"] = replace_or_append(answer_data["hubs"], "hubId", new_hubs)

    new_clusters = {page["clusterId"]: build_cluster(page) for page in PAGES}
    relation_data["clusters"] = replace_or_append(relation_data["clusters"], "clusterId", new_clusters)

    stats = update_counts(answer_data, relation_data, rows)

    write_rows(rows, fieldnames)
    write_json(ANSWER_PATH, answer_data)
    write_json(RELATION_PATH, relation_data)

    update_docs(stats)

    newly_touched_ids = harvested_row_ids()

    if len(newly_touched_ids) < 90:
        raise ValueError(f"Expected at least 90 newly touched rows, found {len(newly_touched_ids)}")

    build_harvest_notes(stats, newly_touched_ids)
    build_triage_ledger()

    print(json.dumps({
        "newly_touched_rows": len(newly_touched_ids),
        "answer_page_marked_rows": stats["answer_marked_rows"],
        "support_rows": stats["support_rows"],
        "hub_count": stats["hub_count"],
        "cluster_count": stats["cluster_count"],
    }, indent=2))


if __name__ == "__main__":
    main()

import csv
import json
from pathlib import Path


ROOT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion")
TAGALOG_ROOT = ROOT / "content-draft" / "tagalog"
CSV_PATH = TAGALOG_ROOT / "phrase-source.csv"
REL_PATH = TAGALOG_ROOT / "relation-sample-v1.json"
ANS_PATH = TAGALOG_ROOT / "answer-page-sample-v1.json"
FIRST_WAVE_PATH = TAGALOG_ROOT / "first-wave-priority.csv"
MERGED_PATH = TAGALOG_ROOT / "tagalog-v2-first-wave.csv"


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
            "repairIfMissed",
            "askNext",
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
        ],
    },
]


def bucket(target_family_id, reason, target_status=None, target_follow_on_class=None):
    item = {"targetFamilyId": target_family_id, "reason": reason}
    if target_status:
        item["targetStatus"] = target_status
    if target_follow_on_class:
        item["targetFollowOnClass"] = target_follow_on_class
    return item


HUBS = [
    {
        "hubId": "tagalog-greeting-hello",
        "familyId": "tagalog-polite-basics-1",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "greeting",
        "summary": "Open with one short hello, then move straight into the practical reason you stopped the person.",
        "coreBullets": [
            "Best when you need a warm but quick opener at a desk, ride pickup, or casual counter.",
            "Do not let the hello become the whole interaction if you already know the real ask.",
        ],
        "useCases": ["hotel desk", "ride pickup", "shop counter"],
        "sayNextSummary": "Once the greeting lands, pivot immediately into the question or request that actually matters.",
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "A short respectful acknowledgment is the most realistic reply to a quick hello."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If the other person keeps going and you lose the thread, switch into direct repair fast."),
            ],
            "askNext": [
                bucket("tagalog-polite-basics-5", "A soft hello often leads into a polite attention-getter before the real request."),
                bucket("tagalog-grab-taxi-8", "At pickup, the next real need is often confirming the right car or corner."),
                bucket("tagalog-directions-11", "If you stopped someone for help, map-showing is often the next practical move."),
            ],
        },
    },
    {
        "hubId": "tagalog-polite-excuse-me",
        "familyId": "tagalog-polite-basics-5",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "courtesy",
        "summary": "Use this to get attention cleanly before the request, especially when you need help from a stranger or staff member.",
        "coreBullets": [
            "This is the better opener than a full greeting when you need something right away.",
            "Say it first, then have the map, item, or booking already ready to show.",
        ],
        "useCases": ["asking for directions", "starting a counter question", "getting staff attention"],
        "sayNextSummary": "Treat this as a bridge into the real question, not as a phrase that should stand alone.",
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most common response is a short acknowledgment that the person is listening."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If the listener starts responding too quickly, go to the repair lane immediately."),
            ],
            "askNext": [
                bucket("tagalog-directions-11", "A common next move is showing the map or route you need help with."),
                bucket("tagalog-asking-price-1", "In markets or stores, the first real follow-up is often a price question."),
                bucket("tagalog-hotel-hostel-8", "At a front desk, this often turns straight into a reservation or name check."),
            ],
        },
    },
    {
        "hubId": "tagalog-polite-thank-you",
        "familyId": "tagalog-polite-basics-2",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "courtesy",
        "summary": "Keep this ready after directions, a fix, or any small rescue so the interaction ends warmly without dragging on.",
        "coreBullets": [
            "Use it after the help lands, not before the request starts.",
            "A quick thank-you is enough; then either close cleanly or ask one last useful follow-up.",
        ],
        "useCases": ["after directions", "after desk help", "after a small favor"],
        "sayNextSummary": "After thanking someone, either end the exchange cleanly or use the goodwill for one last practical follow-up.",
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "A short acknowledgment is the most natural reply after a thank-you."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If the response keeps going and you lose it, move straight into repair."),
            ],
            "askNext": [
                bucket("tagalog-directions-8", "After help lands, the next useful detail may still be the entrance or exact spot."),
                bucket("tagalog-hotel-hostel-17", "At a hotel desk, gratitude often leads into one more service request such as calling a taxi."),
            ],
        },
    },
    {
        "hubId": "tagalog-polite-acknowledge-answer",
        "familyId": "tagalog-polite-basics-3",
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": "courtesy",
        "summary": "Use this respectful acknowledgment to show you are following before you move into the next request or repair branch.",
        "coreBullets": [
            "It buys you a beat without sounding abrupt when someone older or staff are speaking first.",
            "Do not stay here too long if you still need to ask for something else.",
        ],
        "useCases": ["front desk replies", "ride confirmations", "service-counter acknowledgment"],
        "sayNextSummary": "A polite acknowledgment should hand off into the next task or the repair lane, not become dead air.",
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-2", "A short thanks often closes the moment once the acknowledgment lands."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If you nodded along but still are lost, the repair lane must stay nearby."),
            ],
            "askNext": [
                bucket("tagalog-directions-11", "Once you have the person's attention, map-showing is often the next useful step."),
                bucket("tagalog-hotel-hostel-8", "At a desk, the exchange often turns immediately into a reservation or booking check."),
            ],
        },
    },
    {
        "hubId": "tagalog-medical-doctor",
        "familyId": "tagalog-simple-problems-6",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "summary": "This is the direct medical-help phrase when you need a doctor and cannot waste time on softer wording first.",
        "detailBullets": [
            "Lead with this first, then add the symptom or body detail only if the helper asks.",
            "If you can only manage one phrase cleanly, let it be the doctor request and nothing extra.",
        ],
        "localReality": [
            "People often respond by asking what is wrong or where to take you next.",
            "Be ready to move quickly from the doctor request into pharmacy, symptom, or call-for-help detail.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most realistic first response is a short acknowledgment before the helper asks for more detail."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If the helper cannot follow the request cleanly, ask for an English speaker fast."),
                bucket("tagalog-simple-problems-2", "If the response comes back too quickly, go to direct repair instead of repeating the request."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-13", "A pharmacy question is often the next practical move if a full clinic visit is not immediate."),
                bucket("tagalog-simple-problems-15", "If the pain is stomach-related, have that detail ready as the next thing to say."),
            ],
            "escalateTo": [
                bucket("tagalog-simple-problems-7", "If the first ask is not enough, the stronger next move is asking someone to call for you.", "drafted", "later-only-hold"),
            ],
        },
    },
    {
        "hubId": "tagalog-urgent-pharmacy",
        "familyId": "tagalog-simple-problems-13",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "summary": "Use this when the fastest useful help is a nearby pharmacy, not a long explanation about the whole problem.",
        "detailBullets": [
            "This is strongest when you already know you need medicine or a quick first stop.",
            "Have the symptom ready in case the person helping you asks what the problem is.",
        ],
        "localReality": [
            "On the ground, this often turns into map help, pointing, or a redirect to a clinic.",
            "Keep the request short so the helper can act instead of listening to a long story.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The first practical response is often a quick acknowledgment before the helper points or asks the next question."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If the helper cannot track the request, English help may be the quickest rescue."),
                bucket("tagalog-simple-problems-2", "If the instructions come back too fast, the repair lane matters immediately."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-6", "If the situation feels more serious, the next move is upgrading to a doctor request."),
                bucket("tagalog-simple-problems-15", "A stomach-pain detail can help the helper point you to the right medicine or next stop."),
            ],
            "escalateTo": [
                bucket("tagalog-simple-problems-6", "If the pharmacy route is not enough, move up to the doctor request without delay."),
            ],
        },
    },
    {
        "hubId": "tagalog-urgent-fever",
        "familyId": "tagalog-simple-problems-14",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "summary": "This is the symptom detail to use when fever is the one fact that changes how someone helps you.",
        "detailBullets": [
            "Use it after the first help phrase or when a helper asks what is wrong.",
            "If you are too tired to say much more, the fever detail is enough to move the conversation forward.",
        ],
        "localReality": [
            "People often answer by steering you toward medicine first or a doctor if the fever sounds serious.",
            "This detail is strongest when it stays short and easy to understand on the first pass.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "A short acknowledgment is the safest likely-reply rail before the helper decides whether to send you to a pharmacy or a doctor."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If the helper cannot follow the symptom detail, English help may be the fastest rescue."),
                bucket("tagalog-simple-problems-2", "If the response still does not land, move into direct repair fast."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-6", "If the fever sounds serious, the next move is the doctor request."),
                bucket("tagalog-simple-problems-13", "For moderate symptoms, the pharmacy branch is still a realistic next step."),
            ],
            "escalateTo": [
                bucket("tagalog-simple-problems-6", "Escalate to the doctor phrase if the fever needs more than quick medicine help."),
            ],
        },
    },
    {
        "hubId": "tagalog-urgent-stomach-hurts",
        "familyId": "tagalog-simple-problems-15",
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": "medical",
        "summary": "Use this symptom phrase when the stomach problem itself is the key detail the helper needs to hear next.",
        "detailBullets": [
            "This works best after you already got the person's attention or asked for medical help.",
            "Keep the symptom simple and let the next question pull out the rest of the detail.",
        ],
        "localReality": [
            "Travel stomach problems often turn into a pharmacy stop first and a doctor decision second.",
            "If you feel worse than this phrase sounds, move up to the doctor request quickly.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most realistic first response is a short acknowledgment before the helper decides the next stop."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If the listener cannot follow the symptom detail, ask for an English speaker."),
                bucket("tagalog-simple-problems-2", "If the first explanation still misses, switch into direct repair."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-6", "If the pain sounds serious, the next move is asking for a doctor."),
                bucket("tagalog-simple-problems-13", "If you still can travel normally, the pharmacy branch stays useful."),
            ],
            "escalateTo": [
                bucket("tagalog-simple-problems-6", "Escalate to the doctor phrase if the stomach problem is getting worse or feels unsafe."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-understand-answer",
        "familyId": "tagalog-simple-problems-2",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when you need to stop the conversation cleanly and reset before it gets worse.",
        "showWrite": [
            "If the person keeps pointing or talking, pair this with a map, screen, or written cue immediately.",
            "This is the right reset when nodding along would create a bigger mistake later.",
        ],
        "numberCheck": [
            "After this reset, the next repair often needs a slower repeat or something written down.",
        ],
        "courtesy": [
            "Keep the tone direct and calm; this phrase is about clarity, not sounding perfect.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most honest likely-reply rail here is a short acknowledgment that the listener heard the reset request."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If slowing down still is not enough, shift to written backup."),
                bucket("tagalog-simple-problems-12", "If the language gap is bigger than one repair phrase can handle, ask for English help."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-8", "Writing it down is the strongest next repair once the reset lands."),
                bucket("tagalog-simple-problems-10", "Typing into your phone is the next modern fallback when speech is still failing."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-slower-answer",
        "familyId": "tagalog-simple-problems-3",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when the main problem is speed, not the whole topic.",
        "showWrite": [
            "Try this before you jump to a full reset if the other person is helpful but simply too fast.",
            "If the speech is still not clear after one slower repeat, move to writing or phone typing instead of looping.",
        ],
        "numberCheck": [
            "Numbers, times, and addresses still often need their own follow-up repair even after the speaker slows down.",
        ],
        "courtesy": [
            "One slower-repeat request is enough; if it fails, switch methods instead of asking again and again.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The first thing you usually hear back is a short acknowledgment before the other person tries again."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If slower speech is still not enough, ask for it in writing."),
                bucket("tagalog-simple-problems-12", "If the gap is wider than speed alone, ask for English help."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-9", "Number-repeat is the natural next repair once the overall pace comes down."),
                bucket("tagalog-simple-problems-10", "Phone typing is the next strong fallback when slower speech still does not clear things up."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-write-it-down",
        "familyId": "tagalog-simple-problems-8",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when spoken clarification is burning time and a written version would solve the problem faster.",
        "showWrite": [
            "This is especially strong for names, totals, addresses, and anything you need to screenshot or save.",
            "Ask for writing early if the mistake would cost money, a booking, or a wrong destination.",
        ],
        "numberCheck": [
            "Once something is written, the next check is often the number, spelling, or exact map pin.",
        ],
        "courtesy": [
            "A written reset often feels cleaner than a third spoken repeat for both sides.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a short acknowledgment before the other person starts writing or marking anything."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-10", "If they cannot write it clearly, ask them to type it into your phone instead."),
                bucket("tagalog-simple-problems-12", "If the wording still is not landing, ask for someone who speaks English."),
            ],
            "askNext": [
                bucket("tagalog-asking-price-12", "Written totals are one of the most common practical follow-ons after this repair."),
                bucket("tagalog-directions-13", "A marked location is the next best move when the problem is route or destination clarity."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-number-again",
        "familyId": "tagalog-simple-problems-9",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when the only thing you missed is the number, amount, or other short detail.",
        "showWrite": [
            "This is lighter than a full reset when most of the sentence landed but the number did not.",
            "If the number still misses on the second try, go straight to writing it down.",
        ],
        "numberCheck": [
            "Totals, room numbers, gate numbers, and prices are where this repair earns its keep.",
        ],
        "courtesy": [
            "Use the smallest repair that fits; there is no need to restart the whole conversation for one number.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most honest likely-reply rail is a short acknowledgment before the speaker repeats the number."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "Writing it down is the safest rescue if the number misses again."),
                bucket("tagalog-simple-problems-12", "If the whole exchange is still hard to follow, the English-help branch matters next."),
            ],
            "askNext": [
                bucket("tagalog-asking-price-12", "A written total is the most useful next move in money or checkout moments."),
                bucket("tagalog-asking-price-10", "Once the number is clear, the next practical issue is often whether they have change."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-type-it-into-my-phone",
        "familyId": "tagalog-simple-problems-10",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when you want the other person to bypass speech entirely and put the key detail straight into your phone.",
        "showWrite": [
            "This is strong for place names, pickup corners, Wi-Fi details, or anything you need to save exactly.",
            "Phone typing is often faster than asking for one more spoken repeat in a noisy place.",
        ],
        "numberCheck": [
            "Typed phone details still need a quick glance for the right number, spelling, or map result.",
        ],
        "courtesy": [
            "Offer the phone and make the job easy; the goal is to reduce friction, not add more of it.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a short acknowledgment before the person takes the phone or starts typing."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If they still cannot help through the phone, ask for an English speaker."),
                bucket("tagalog-simple-problems-8", "If typing is not practical, fall back to written proof instead."),
            ],
            "askNext": [
                bucket("tagalog-directions-11", "Phone typing often leads right back into a map-showing step."),
                bucket("tagalog-hotel-hostel-8", "A typed booking name or address can restore hotel or front-desk tasks quickly."),
            ],
        },
    },
    {
        "hubId": "tagalog-repair-english-help",
        "familyId": "tagalog-simple-problems-12",
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": "Use this when one more polite repair phrase will not be enough and you need a language bridge now.",
        "showWrite": [
            "This is the stronger repair branch when the gap is not just speed or one missed number.",
            "Ask early when the stakes are a booking, a route, money, or medical help.",
        ],
        "numberCheck": [
            "Even after an English speaker arrives, totals, addresses, and names may still need writing or phone typing.",
        ],
        "courtesy": [
            "It is better to ask for the language bridge than pretend you followed and create a bigger mistake later.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "A quick acknowledgment is the most realistic immediate response before someone goes to get help."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If nobody useful appears right away, fall back to the simplest direct repair phrase."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-8", "Once help arrives, written backup is still one of the best ways to keep things accurate."),
                bucket("tagalog-simple-problems-10", "Phone typing is often the next practical bridge once someone willing to help is there."),
                bucket("tagalog-simple-problems-11", "It can also help to reset expectations by saying you only speak a little Tagalog."),
            ],
        },
    },
    {
        "hubId": "tagalog-grab-pickup-point-answer",
        "familyId": "tagalog-grab-taxi-8",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "summary": "Use this when the real problem is finding the exact pickup corner or car before you even start the ride.",
        "confirmDetail": [
            "Keep the app screen open so the driver can match the pickup pin, plate, or corner quickly.",
            "This works best before you get in, while there is still time to fix the location cleanly.",
        ],
        "whatToShow": [
            "Show the ride app pin, the pickup map, or the car details instead of adding more speech.",
            "Pointing to the exact corner often solves this faster than repeating the same question.",
        ],
        "localReality": [
            "Busy pickups often fail because of the corner, not because the ride itself is wrong.",
            "A clean pickup-point check prevents the longer route and payment problems that come later.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-grab-taxi-9", "A realistic next response is some version of being told to wait right here."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If the exchange still is not clear, go to direct repair fast."),
                bucket("tagalog-directions-11", "If talking alone is failing, switch to showing the map immediately."),
            ],
            "askNext": [
                bucket("tagalog-grab-taxi-1", "Once the pickup point is solved, the next useful move is showing the destination."),
                bucket("tagalog-grab-taxi-11", "If the ride is already underway, be ready with the entrance drop-off phrase."),
            ],
        },
    },
    {
        "hubId": "tagalog-grab-meter-answer",
        "familyId": "tagalog-grab-taxi-10",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "summary": "Use this early when fare clarity matters more than making the request sound soft.",
        "confirmDetail": [
            "The value of this phrase is timing: say it before the ride settles into the wrong fare setup.",
            "If the meter still is not clear, move fast to totals, change, or written numbers.",
        ],
        "whatToShow": [
            "Point at the meter or price screen so both sides are anchored on the same thing.",
            "If the number is spoken too fast, be ready to ask for the total in writing.",
        ],
        "localReality": [
            "Fare friction grows quickly once the ride is moving, so the earlier this lands, the better.",
            "The clean follow-on is almost always about the total, the route cost, or the next payment detail.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a quick acknowledgment before the fare discussion moves to numbers."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If the number still is not clear, push it into writing."),
                bucket("tagalog-simple-problems-2", "If the driver keeps talking around the point, use the direct repair lane."),
            ],
            "askNext": [
                bucket("tagalog-grab-taxi-16", "Once the fare is clear, route-cost details such as tolls become the next practical question."),
                bucket("tagalog-asking-price-10", "Have the change question ready if the ride will end in cash."),
                bucket("tagalog-grab-taxi-17", "If cash setup becomes the blocker, asking to stop at an ATM is a realistic next move."),
            ],
        },
    },
    {
        "hubId": "tagalog-grab-entrance-answer",
        "familyId": "tagalog-grab-taxi-11",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "summary": "Use this when the last few meters matter and you need the driver to stop at the useful entrance, not just nearby.",
        "confirmDetail": [
            "This is most valuable when the building has multiple doors, a busy curb, or a hard-to-find reception point.",
            "The phrase is stronger when the entrance itself is more important than the street address.",
        ],
        "whatToShow": [
            "Point at the door, hotel sign, or map marker if the driver still looks unsure.",
            "A photo of the entrance can be more useful than another spoken turn instruction.",
        ],
        "localReality": [
            "A clean entrance drop-off saves the awkward walkback that often starts a hotel or venue problem.",
            "This phrase works best when you use it before the driver has already passed the right place.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The most realistic first response is a quick acknowledgment that the entrance request landed."),
            ],
            "repairIfMissed": [
                bucket("tagalog-directions-11", "If the entrance is still unclear, switch straight to map-showing."),
                bucket("tagalog-simple-problems-2", "If the conversation starts slipping, go to direct repair before the car passes the door."),
            ],
            "askNext": [
                bucket("tagalog-hotel-hostel-8", "At a hotel, the next useful move is often immediately checking in under your name."),
                bucket("tagalog-directions-8", "If you still are not at the right door, the entrance question stays relevant as the next step."),
            ],
        },
    },
    {
        "hubId": "tagalog-grab-wrong-road-answer",
        "familyId": "tagalog-grab-taxi-14",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "transport",
        "summary": "Use this when you need to correct the route calmly before a small mistake turns into a bigger ride problem.",
        "confirmDetail": [
            "This is about catching the route drift early, not waiting until you are far off course.",
            "Say it while the driver still has an easy chance to correct the turn or stop for clarification.",
        ],
        "whatToShow": [
            "Switch to the map as soon as you feel the spoken correction may not be enough.",
            "A live route screen is often the fastest proof that something is off.",
        ],
        "localReality": [
            "Wrong-road moments quickly become time, fare, and safety problems if you stay silent too long.",
            "The next useful move is usually map confirmation or another route option, not a long argument.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a quick acknowledgment before the driver or helper follows you onto the map."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-2", "If the spoken correction still is not landing, go to the direct repair line."),
                bucket("tagalog-simple-problems-8", "If route details are still fuzzy, ask for something written or shown clearly."),
            ],
            "askNext": [
                bucket("tagalog-directions-13", "Once the map is out, the next useful move is asking the person to mark the right spot."),
                bucket("tagalog-directions-16", "If the route really is bad, the next question is whether there is another way."),
                bucket("tagalog-grab-taxi-13", "If the route changed because the destination changed, the app-update phrase is the next useful branch."),
            ],
        },
    },
    {
        "hubId": "tagalog-hotel-booking-name-answer",
        "familyId": "tagalog-hotel-hostel-8",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "hotel",
        "summary": "Use this to anchor the hotel check-in around the name on the booking before the desk starts asking for other details.",
        "confirmDetail": [
            "Have the exact booking name ready so the desk can search without guesswork.",
            "This is especially useful after a ride drop-off when you want the hotel handoff to stay clean and fast.",
        ],
        "whatToShow": [
            "Show the booking screen, confirmation email, or ID if the name alone is not enough.",
            "A visible booking reference often saves time faster than repeating the name several times.",
        ],
        "localReality": [
            "Most front-desk friction here is not about grammar; it is about the exact name and proof.",
            "Once the name lands, the next questions are usually about breakfast, Wi-Fi, or room access.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "A quick acknowledgment is the most realistic first desk response before the next question."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If the name is not landing, push it into writing or visible proof."),
                bucket("tagalog-simple-problems-12", "If the front desk conversation is still too hard to follow, ask for English help."),
            ],
            "askNext": [
                bucket("tagalog-hotel-hostel-9", "Breakfast is a common immediate follow-up once the booking is found."),
                bucket("tagalog-hotel-hostel-15", "Wi-Fi help is another realistic next ask once check-in basics are underway."),
                bucket("tagalog-hotel-hostel-10", "If timing is awkward or the room is not ready yet, luggage storage becomes a very practical next branch."),
            ],
        },
    },
    {
        "hubId": "tagalog-hotel-keycard-answer",
        "familyId": "tagalog-hotel-hostel-11",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "hotel",
        "summary": "Use this when the real problem is access right now and you need the front desk to fix it, not just sympathize.",
        "confirmDetail": [
            "This is strongest when you say it with the card in hand and the failed attempt still fresh.",
            "If the staff can fix it quickly, do not over-explain; let the broken card itself carry the point.",
        ],
        "whatToShow": [
            "Show the key card, room number, or the door itself if the desk is nearby.",
            "If the room number is part of the confusion, have it ready in writing or on your phone.",
        ],
        "localReality": [
            "A bad key card is a practical desk problem first and a language problem second.",
            "The next useful move is often a room change or another staff action, not more description.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The desk will usually acknowledge the problem before asking for the card or room details."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-12", "If the staff explanation becomes hard to follow, ask for English help."),
                bucket("tagalog-simple-problems-2", "If the fix still is not landing, use the direct repair line."),
            ],
            "askNext": [
                bucket("tagalog-hotel-hostel-12", "If the problem is bigger than one card reset, asking for a room change is the next useful move."),
                bucket("tagalog-hotel-hostel-19", "If the issue needs staff action elsewhere, housekeeping or another staff dispatch may come next."),
                bucket("tagalog-hotel-hostel-18", "If the room issue is broader than the card itself, noise or another room-quality complaint may be the next branch."),
            ],
        },
    },
    {
        "hubId": "tagalog-hotel-wifi-help-answer",
        "familyId": "tagalog-hotel-hostel-15",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "hotel",
        "summary": "Use this when the connection issue needs staff help now, not one more silent try on the same network.",
        "confirmDetail": [
            "This is the right phrase when the problem is connection help, not a broader complaint about the room.",
            "Have the room number, network name, or the failing login screen ready before you ask.",
        ],
        "whatToShow": [
            "Show the Wi-Fi screen, password page, or error on your phone so the helper sees the issue immediately.",
            "If the password or room number is the sticking point, written proof will help more than extra speech.",
        ],
        "localReality": [
            "Wi-Fi failures often turn into a quick desk fix, a phone handoff, or a move to another staff member.",
            "The more visible the error is on your phone, the faster this usually gets solved.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The first response is usually a quick acknowledgment before staff start troubleshooting."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-10", "If the explanation still is messy, ask them to type the network or password into your phone."),
                bucket("tagalog-simple-problems-12", "If the desk talk is still too hard to follow, ask for English help."),
            ],
            "askNext": [
                bucket("tagalog-simple-problems-12", "If the fix needs another person, an English speaker is often the next helpful branch."),
                bucket("tagalog-simple-problems-10", "Phone typing is the strongest next bridge when the issue is a password or network name."),
            ],
        },
    },
    {
        "hubId": "tagalog-total-answer",
        "familyId": "tagalog-asking-price-8",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "payment",
        "summary": "Use this when the only number that matters now is the real final total, not another partial price.",
        "confirmDetail": [
            "This is strongest when fees, add-ons, or multiple items make the first number feel incomplete.",
            "Ask for the total before you hand over cash so the next payment step starts from the right number.",
        ],
        "whatToShow": [
            "Point at the bill, screen, or grouped items so both sides are looking at the same total.",
            "If the number is spoken too quickly, be ready to push it into writing immediately.",
        ],
        "localReality": [
            "Totals are where small misunderstandings turn into real money mistakes, so visible proof matters.",
            "The clean next branch is usually writing it down, checking change, or confirming cash versus card.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a short acknowledgment before the cashier or driver gives the real total."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If the total still is not clear, push the number into writing."),
                bucket("tagalog-simple-problems-2", "If the explanation keeps slipping, use the direct repair line."),
            ],
            "askNext": [
                bucket("tagalog-asking-price-10", "Once the total is clear, the next practical question is often whether they have change."),
                bucket("tagalog-asking-price-9", "You may also need to confirm whether the payment can be cash."),
                bucket("tagalog-asking-price-11", "If the number still feels wrong, asking them to count it again is the next useful branch."),
                bucket("tagalog-asking-price-15", "If the displayed amount does not match what you heard, the sign-mismatch phrase becomes the next useful branch."),
            ],
        },
    },
    {
        "hubId": "tagalog-change-answer",
        "familyId": "tagalog-asking-price-10",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "payment",
        "summary": "Use this when the total is already clear but the real friction is whether the other side can make the cash payment work.",
        "confirmDetail": [
            "This matters most when you are paying with a large bill and do not want the checkout to stall at the last second.",
            "Have the note visible so the cashier sees the problem immediately.",
        ],
        "whatToShow": [
            "Show the bill you have, not just the wallet or the amount on your screen.",
            "If the conversation becomes number-heavy, a written total or receipt screen can keep it from drifting.",
        ],
        "localReality": [
            "Small counters and drivers often solve this with smaller bills, a changed total, or a quick workaround.",
            "The useful next move is usually about smaller bills or proof of what was just paid.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a short acknowledgment before the other side checks the cash situation."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If the numbers around change still are not clear, ask for them in writing."),
                bucket("tagalog-simple-problems-2", "If the exchange is slipping in general, use the direct repair line."),
            ],
            "askNext": [
                bucket("tagalog-convenience-store-12", "Once the cash issue is solved, asking for the receipt is a realistic next step."),
                bucket("tagalog-asking-price-14", "Smaller bills are often the immediate practical follow-on after a change problem."),
                bucket("tagalog-convenience-store-10", "At a counter, the same friction often becomes a large-bill problem that needs to be named directly."),
                bucket("tagalog-asking-price-11", "If the numbers still feel off, the next useful move is asking them to count it again."),
            ],
        },
    },
    {
        "hubId": "tagalog-map-show-answer",
        "familyId": "tagalog-directions-11",
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": "directions",
        "summary": "Use this when the fastest route to clarity is making the other person look at the map instead of guessing from speech alone.",
        "confirmDetail": [
            "This is one of the strongest recovery moves when route talk, place names, or landmarks are not landing clearly.",
            "Keep the map already open so the person can respond with their finger, not just another spoken direction.",
        ],
        "whatToShow": [
            "Show the live map, saved place, or screenshot of the destination instead of repeating the name again.",
            "If the route is the problem, the pin matters more than the sentence.",
        ],
        "localReality": [
            "Map-showing turns vague spoken directions into something both sides can actually work with.",
            "Once the map is shared, the next useful move is usually a marked point, entrance, or stop detail.",
        ],
        "relationBuckets": {
            "likelyReply": [
                bucket("tagalog-polite-basics-3", "The safest likely-reply rail is a short acknowledgment before the other person points, marks, or explains anything."),
            ],
            "repairIfMissed": [
                bucket("tagalog-simple-problems-8", "If even the map is not enough, ask for something written or marked clearly."),
                bucket("tagalog-simple-problems-10", "Phone typing is the next strong fallback when the place name still is not clear."),
            ],
            "askNext": [
                bucket("tagalog-directions-8", "Once the map is shared, the next useful question is often the exact entrance."),
                bucket("tagalog-directions-10", "For transit, the next practical detail is often which stop to get off at."),
                bucket("tagalog-directions-14", "Travel time by car is a common next detail once the place itself is clear."),
                bucket("tagalog-directions-17", "If safety matters, the next useful branch is asking whether you can walk there safely."),
            ],
        },
    },
]


with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    phrase_fieldnames = reader.fieldnames


def effective_family_id(row):
    return row["family_id"] or row["phrase_id"]


family_rows = {}
phrase_rows = {}
for row in rows:
    fid = effective_family_id(row)
    family_rows.setdefault(fid, []).append(row)
    phrase_rows[row["phrase_id"]] = row


def row_for_phrase(phrase_id):
    if phrase_id not in phrase_rows:
        raise KeyError(f"missing phrase id: {phrase_id}")
    return phrase_rows[phrase_id]


def family_row_list(family_id):
    if family_id not in family_rows:
        raise KeyError(f"missing family id: {family_id}")
    return family_rows[family_id]


def family_first_row(family_id):
    return family_row_list(family_id)[0]


def family_title(family_id):
    return family_first_row(family_id)["family_title"]


def family_summary(family_id):
    return family_first_row(family_id)["family_summary"]


def scenario_id(family_id):
    return family_first_row(family_id)["scenario_id"]


def family_access_tier(family_id):
    for row in family_row_list(family_id):
        if row["access_tier"]:
            return row["access_tier"]
    return "starter"


def row_variant_role(row):
    return row["variant_role"] or "say-first"


def phrase_for_family(family_id, variant_role="say-first"):
    matched = None
    for row in family_row_list(family_id):
        if row_variant_role(row) == variant_role:
            matched = row["phrase_id"]
            break
    if matched:
        return matched
    if variant_role == "say-first":
        return family_first_row(family_id)["phrase_id"]
    return None


def family_phrase_ids(family_id):
    return [row["phrase_id"] for row in family_row_list(family_id)]


def family_target_text(family_id):
    return family_first_row(family_id)["target_text"]


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


def bucket_target_phrase(item):
    return phrase_for_family(item["targetFamilyId"]) or family_first_row(item["targetFamilyId"])["phrase_id"]


def bucket_titles(items):
    return [family_title(item["targetFamilyId"]) for item in items]


def relation_microcopy(bucket_name, items):
    bullets = []
    for item in items:
        title = family_title(item["targetFamilyId"])
        if bucket_name == "likelyReply":
            bullets.append(f'Be ready for "{title}" as the first practical follow-up or confirmation.')
        elif bucket_name == "repairIfMissed":
            bullets.append(f'If this still misses, switch to "{title}" immediately.')
        elif bucket_name == "askNext":
            bullets.append(f'Once this lands, the next useful move is "{title}".')
        elif bucket_name == "escalateTo":
            bullets.append(f'If the first ask is not enough, escalate to "{title}" fast.')
    return bullets


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
            "bullets": dedupe(bullets),
        },
    }


def hub_variant_map(hub):
    family_id = hub["familyId"]
    clearer = phrase_for_family(family_id, "clearer")
    more_polite = phrase_for_family(family_id, "more-polite")
    alternates = []
    for role in ["also-common"]:
        phrase_id = phrase_for_family(family_id, role)
        if phrase_id:
            alternates.append(phrase_id)
    return clearer, more_polite, alternates


def build_modules(hub):
    family_id = hub["familyId"]
    clearer, more_polite, alternates = hub_variant_map(hub)
    common_phrases = dedupe(
        [
            hub["anchorPhraseId"],
            hub["defaultPhraseId"],
            hub["quickSayPhraseId"],
            clearer,
            more_polite,
            *alternates,
        ]
    )
    if hub["phraseClass"] == "greetings-social":
        return [
            make_module(
                "core-phrase",
                "core-phrase",
                True,
                common_phrases,
                [family_id],
                [],
                hub["summary"],
                hub["coreBullets"],
            ),
            make_module(
                "social-use-case",
                "social-use-case",
                True,
                common_phrases,
                [family_id],
                [],
                "Keep the social layer short and useful.",
                [
                    f'Best fit: {", ".join(hub["useCases"])}.',
                    "If the moment is high-friction or urgent, skip extra warmth and move to the task.",
                ],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Expect a short acknowledgment before the real task starts.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "say-next",
                "say-next",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"]],
                ["askNext"],
                hub["sayNextSummary"],
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]),
            ),
            make_module(
                "graceful-exit",
                "graceful-exit",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the social opener slips, switch into repair and keep moving.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    if hub["phraseClass"] == "urgent-help-medical":
        return [
            make_module(
                "urgent-core",
                "urgent-core",
                True,
                common_phrases,
                [family_id],
                [],
                hub["summary"],
                [
                    "Lead with the short urgent line first.",
                    "Add only the detail that changes what help you get next.",
                ],
            ),
            make_module(
                "risk-or-symptom-detail",
                "risk-or-symptom-detail",
                True,
                common_phrases,
                [family_id],
                [],
                "Keep the symptom detail short enough to act on immediately.",
                hub["detailBullets"],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "The first response is usually a triage question or practical redirect.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "immediate-next-step",
                "immediate-next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"]],
                ["askNext"],
                "Have the next useful detail ready once someone starts helping.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                common_phrases,
                [family_id],
                [],
                "Medical help gets practical very quickly in real travel moments.",
                hub["localReality"],
            ),
            make_module(
                "repair-branch",
                "repair-branch",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the first urgent phrase does not land cleanly, repair the exchange fast.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
            make_module(
                "safety-escalation",
                "safety-escalation",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["escalateTo"]],
                ["escalateTo"],
                "If the first ask is not enough, escalate without waiting.",
                relation_microcopy("escalateTo", hub["relationBuckets"]["escalateTo"]),
            ),
        ]
    if hub["phraseClass"] == "repair-clarification":
        return [
            make_module(
                "repair-core",
                "repair-core",
                True,
                common_phrases,
                [family_id],
                [],
                hub["summary"],
                [
                    "Use the smallest repair that actually fixes the conversation.",
                    "The goal is clarity, not sounding perfect.",
                ],
            ),
            make_module(
                "show-or-write",
                "show-or-write",
                True,
                common_phrases,
                [family_id],
                [],
                "Visual backup often works better than repeating the same phrase again.",
                hub["showWrite"],
            ),
            make_module(
                "number-check",
                "number-check",
                True,
                common_phrases,
                [family_id],
                [],
                "Names, totals, and directions often need their own follow-up repair.",
                hub["numberCheck"],
            ),
            make_module(
                "likely-response",
                "likely-response",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Be ready for the next repair or confirmation the other person may force.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "next-try",
                "next-try",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"]],
                ["askNext"],
                "Once this repair starts working, move to the next practical branch right away.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]),
            ),
            make_module(
                "courtesy-close",
                "courtesy-close",
                True,
                common_phrases,
                [family_id],
                [],
                "Close the repair loop quickly so the original task can keep moving.",
                hub["courtesy"],
            ),
        ]
    if hub["phraseClass"] == "practical-service-navigation":
        return [
            make_module(
                "task-core",
                "task-core",
                True,
                common_phrases,
                [family_id],
                [],
                hub["summary"],
                [
                    "Say this while the relevant screen, item, map, or booking is already visible.",
                    "The faster the other side can act, the better this phrase works.",
                ],
            ),
            make_module(
                "operator-question",
                "operator-question",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "The first response is usually a quick confirmation or practical follow-up.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "confirm-detail",
                "confirm-detail",
                True,
                common_phrases,
                [family_id],
                [],
                "One concrete detail keeps this request from stalling.",
                hub["confirmDetail"],
            ),
            make_module(
                "what-to-show",
                "what-to-show",
                True,
                common_phrases,
                [family_id],
                [],
                "A visible screen or written proof often does more work than extra speech.",
                hub["whatToShow"],
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                common_phrases,
                [family_id],
                [],
                "These moments move faster when the other side can solve the exact practical detail.",
                hub["localReality"],
            ),
            make_module(
                "next-step",
                "next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"]],
                ["askNext"],
                "Keep the next useful traveler move one tap away.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]),
            ),
            make_module(
                "fallback",
                "fallback",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the task still stalls, switch into repair instead of looping the same request.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    raise ValueError(f'unknown phrase class: {hub["phraseClass"]}')


for hub in HUBS:
    default_phrase_id = phrase_for_family(hub["familyId"], "say-first")
    hub["anchorPhraseId"] = default_phrase_id
    hub["defaultPhraseId"] = default_phrase_id
    hub["quickSayPhraseId"] = default_phrase_id


with REL_PATH.open("r", encoding="utf-8") as f:
    relation_sample = json.load(f)


hub_map = {hub["familyId"]: hub for hub in HUBS}
hub_by_id = {hub["hubId"]: hub for hub in HUBS}
packet_answer_families = {
    hub["familyId"]
    for hub in HUBS
    if family_first_row(hub["familyId"])["status"].startswith("substantial-expansion")
}

relation_sample["purpose"] = (
    "Additive relation-ready handoff for phrase-detail, listing-page, and answer-page work across 80 Tagalog family clusters, "
    "including 24 answer-page-ready hubs, without replacing the current scenario -> family -> phrase-row model."
)
precedence_rules = relation_sample["sourceOfTruth"].get("precedenceRules", [])
extra_rule = (
    "For answer-page-ready hubs, relationBuckets remain the single authored home for likely reply, repair, escalation, and next-step rails."
)
if extra_rule not in precedence_rules:
    precedence_rules.append(extra_rule)
relation_sample["sourceOfTruth"]["precedenceRules"] = precedence_rules

relation_types = relation_sample.get("relationTypes", [])
if not any(item["id"] == "escalation_for" for item in relation_types):
    relation_types.append(
        {
            "id": "escalation_for",
            "description": "The target family is the stronger escalation branch when the current phrase is not enough.",
        }
    )
relation_sample["relationTypes"] = relation_types
relation_sample["relationBucketTypes"] = [
    {
        "id": "likelyReply",
        "description": "The first practical response, acknowledgment, or follow-up the traveler should be ready for.",
    },
    {
        "id": "repairIfMissed",
        "description": "The safest repair branch when the first try does not land cleanly.",
    },
    {
        "id": "askNext",
        "description": "The next useful traveler move once the first phrase works.",
    },
    {
        "id": "escalateTo",
        "description": "The stronger help or urgency branch when the current phrase is not enough.",
    },
]
relation_sample["answerPageCoverage"] = {
    "sampleId": "tagalog-answer-page-sample-v1",
    "hubCount": len(HUBS),
    "phraseClassCount": 4,
    "moduleMixCount": len(MODULE_MIXES),
    "phraseClasses": [mix["phraseClass"] for mix in MODULE_MIXES],
    "moduleMixIds": [mix["id"] for mix in MODULE_MIXES],
    "answerReadyFamilyIds": [hub["familyId"] for hub in HUBS],
    "relationBucketFields": ["likelyReply", "repairIfMissed", "askNext", "escalateTo"],
}

clusters_by_family = {cluster["familyId"]: cluster for cluster in relation_sample["clusters"]}
for hub in HUBS:
    family_id = hub["familyId"]
    cluster = clusters_by_family.get(family_id, {})
    clearer, more_polite, _ = hub_variant_map(hub)
    relation_cluster_id = cluster.get("clusterId", hub["hubId"])
    bucket_payload = {}
    for bucket_name, items in hub["relationBuckets"].items():
        bucket_payload[bucket_name] = []
        for item in items:
            payload = {
                "targetFamilyId": item["targetFamilyId"],
                "targetPhraseId": bucket_target_phrase(item),
                "reason": item["reason"],
            }
            if "targetStatus" in item:
                payload["targetStatus"] = item["targetStatus"]
            if "targetFollowOnClass" in item:
                payload["targetFollowOnClass"] = item["targetFollowOnClass"]
            bucket_payload[bucket_name].append(payload)

    family_relations = []
    for bucket_name, relation_type in [
        ("likelyReply", "likely_answer_to"),
        ("repairIfMissed", "repair_for"),
        ("askNext", "next_step_after"),
        ("escalateTo", "escalation_for"),
    ]:
        for item in bucket_payload.get(bucket_name, []):
            relation = {
                "relationType": relation_type,
                "targetFamilyId": item["targetFamilyId"],
                "reason": item["reason"],
            }
            if "targetStatus" in item:
                relation["targetStatus"] = item["targetStatus"]
            if "targetFollowOnClass" in item:
                relation["targetFollowOnClass"] = item["targetFollowOnClass"]
            family_relations.append(relation)

    possible_responses = []
    for bucket_name in ["likelyReply", "askNext"]:
        for item in bucket_payload.get(bucket_name, []):
            response = {
                "kind": bucket_name,
                "familyId": item["targetFamilyId"],
                "phraseId": item["targetPhraseId"],
                "note": item["reason"],
            }
            if "targetStatus" in item:
                response["targetStatus"] = item["targetStatus"]
            if "targetFollowOnClass" in item:
                response["targetFollowOnClass"] = item["targetFollowOnClass"]
            possible_responses.append(response)

    cluster.update(
        {
            "clusterId": relation_cluster_id,
            "coverageMoment": hub["coverageMoment"],
            "scenarioId": scenario_id(family_id),
            "familyId": family_id,
            "familyTitle": family_title(family_id),
            "familySummary": family_summary(family_id),
            "accessTier": family_access_tier(family_id),
            "phraseClass": hub["phraseClass"],
            "moduleMixId": hub["moduleMixId"],
            "answerPageReady": True,
            "answerPageHubId": hub["hubId"],
            "anchorPhraseId": hub["anchorPhraseId"],
            "shortestFormPhraseId": hub["quickSayPhraseId"],
            "clearerFormPhraseId": clearer,
            "morePoliteFormPhraseId": more_polite,
            "possibleTravelerResponses": possible_responses,
            "familyRelations": family_relations,
            "relationBuckets": bucket_payload,
            "youMayHearSignals": [
                {
                    "signalText": item["reason"],
                    "sourcePhraseId": hub["defaultPhraseId"],
                    "advisoryOnly": True,
                }
                for item in bucket_payload.get("likelyReply", [])
            ],
        }
    )
    clusters_by_family[family_id] = cluster

existing_order = [cluster["familyId"] for cluster in relation_sample["clusters"]]
for hub in HUBS:
    if hub["familyId"] not in existing_order:
        existing_order.append(hub["familyId"])
relation_sample["clusters"] = [clusters_by_family[family_id] for family_id in existing_order]
relation_sample["clusterCount"] = len(relation_sample["clusters"])

answer_hubs = []
for hub in HUBS:
    family_id = hub["familyId"]
    cluster_id = clusters_by_family[family_id]["clusterId"]
    clearer, more_polite, alternates = hub_variant_map(hub)
    answer_hubs.append(
        {
            "hubId": hub["hubId"],
            "scenarioId": scenario_id(family_id),
            "familyId": family_id,
            "familyTitle": family_title(family_id),
            "phraseClass": hub["phraseClass"],
            "moduleMixId": hub["moduleMixId"],
            "relationClusterId": cluster_id,
            "anchorPhraseId": hub["anchorPhraseId"],
            "defaultPhraseId": hub["defaultPhraseId"],
            "quickSayPhraseId": hub["quickSayPhraseId"],
            "clearerPhraseId": clearer,
            "morePolitePhraseId": more_polite,
            "alternatePhraseIds": alternates,
            "relationBuckets": list(hub["relationBuckets"].keys()),
            "modules": build_modules(hub),
        }
    )

answer_sample = {
    "schemaVersion": 1,
    "sampleId": "tagalog-answer-page-sample-v1",
    "language": "Tagalog",
    "status": "draft-handoff",
    "hubCount": len(HUBS),
    "phraseClassCount": 4,
    "sourceOfTruth": {
        "authoringCsv": "content-draft/tagalog/phrase-source.csv",
        "relationSample": "content-draft/tagalog/relation-sample-v1.json",
        "generatedPack": "app/family/packs/tagalog.generated.ts",
        "rowMembershipField": "notes",
        "membershipMarkerPrefix": "answer-page-sample=",
        "membershipTokenFormat": "<hubId>:anchor | <hubId>:variant:clearer | <hubId>:variant:more-polite | <hubId>:variant:also-common",
    },
    "contentRules": [
        "Phrase wording stays in phrase-source.csv.",
        "Cross-family relation truth stays in relation-sample-v1.json.",
        "Each module content payload uses only a short summary string plus a short bullets array.",
        "Modules may reference phrase ids and relation bucket names but must not duplicate the relation graph.",
        "If a hub has no truly shorter alternate, the same anchor row may serve as both defaultPhraseId and quickSayPhraseId.",
    ],
    "moduleMixes": MODULE_MIXES,
    "hubs": answer_hubs,
}


def add_marker_if_match(row, hub):
    phrase_id = row["phrase_id"]
    clearer, more_polite, alternates = hub_variant_map(hub)
    if phrase_id == hub["anchorPhraseId"]:
        row["notes"] = add_note_token(row["notes"], f'answer-page-sample={hub["hubId"]}:anchor')
    if clearer and phrase_id == clearer:
        row["notes"] = add_note_token(row["notes"], f'answer-page-sample={hub["hubId"]}:variant:clearer')
    if more_polite and phrase_id == more_polite:
        row["notes"] = add_note_token(row["notes"], f'answer-page-sample={hub["hubId"]}:variant:more-polite')
    if phrase_id in alternates:
        row["notes"] = add_note_token(row["notes"], f'answer-page-sample={hub["hubId"]}:variant:also-common')


for row in rows:
    family_id = effective_family_id(row)
    hub = hub_map.get(family_id)
    if hub:
        add_marker_if_match(row, hub)


def update_packet_csv(csv_path):
    with csv_path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        csv_rows = list(reader)
        fieldnames = reader.fieldnames
    extra_fields = [
        "answer_page_hub_id",
        "answer_page_phrase_class",
        "answer_page_module_mix_id",
    ]
    for field in extra_fields:
        if field not in fieldnames:
            fieldnames.append(field)
    for row in csv_rows:
        family_id = row["family_id"]
        hub = hub_map.get(family_id)
        if hub and family_id in packet_answer_families:
            row["answer_page_hub_id"] = hub["hubId"]
            row["answer_page_phrase_class"] = hub["phraseClass"]
            row["answer_page_module_mix_id"] = hub["moduleMixId"]
        else:
            row["answer_page_hub_id"] = ""
            row["answer_page_phrase_class"] = ""
            row["answer_page_module_mix_id"] = ""
    with csv_path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(csv_rows)


update_packet_csv(FIRST_WAVE_PATH)
update_packet_csv(MERGED_PATH)

with REL_PATH.open("w", encoding="utf-8", newline="\n") as f:
    json.dump(relation_sample, f, ensure_ascii=False, indent=2)
    f.write("\n")

with ANS_PATH.open("w", encoding="utf-8", newline="\n") as f:
    json.dump(answer_sample, f, ensure_ascii=False, indent=2)
    f.write("\n")

with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=phrase_fieldnames)
    writer.writeheader()
    writer.writerows(rows)


print(
    json.dumps(
        {
            "answerHubCount": len(HUBS),
            "relationClusterCount": relation_sample["clusterCount"],
            "packetAnswerFamilies": sorted(packet_answer_families),
            "markedAnswerRows": sum(1 for row in rows if "answer-page-sample=" in row["notes"]),
        },
        ensure_ascii=False,
        indent=2,
    )
)

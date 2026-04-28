import csv
import json
from pathlib import Path


ROOT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion")
ANSWER_PATH = ROOT / "content-draft" / "viet" / "answer-page-sample-v1.json"
RELATION_PATH = ROOT / "content-draft" / "viet" / "relation-sample-v1.json"
CSV_PATH = ROOT / "content-draft" / "viet" / "phrase-source.csv"

WRITE = False


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def split_notes(notes: str):
    return [part.strip() for part in (notes or "").split("|") if part.strip()]


def answer_tokens(notes: str):
    return [token for token in split_notes(notes) if token.startswith("answer-page-sample=")]


answer = load_json(ANSWER_PATH)
relations = load_json(RELATION_PATH)
with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as handle:
    rows = list(csv.DictReader(handle))

fieldnames = list(rows[0].keys())
cluster_by_id = {cluster["clusterId"]: cluster for cluster in relations["clusters"]}
rows_by_family = {}
row_by_phrase = {}
for row in rows:
    rows_by_family.setdefault(row["family_id"], []).append(row)
    row_by_phrase[row["phrase_id"]] = row

baseline_answer_counts = {
    row["phrase_id"]: len(answer_tokens(row.get("notes", "")))
    for row in rows
}
baseline_supporting_rows = sum(
    1
    for row in rows
    if any(token.startswith("answer-page-sample=") and ":support:" in token for token in answer_tokens(row.get("notes", "")))
)

VARIANT_TOKEN_MAP = {
    "clearer": "variant:clearer",
    "more-polite": "variant:more-polite",
    "also-common": "variant:also-common",
}
SUPPORT_KINDS = [
    "likelyReply",
    "repairIfMissed",
    "askNext",
    "crossClassExit",
    "escalateTo",
]


def primary_row(family_id: str):
    family_rows = rows_by_family[family_id]
    for role in ("say-first", "clearer", "more-polite", "also-common"):
        for row in family_rows:
            if row["variant_role"] == role:
                return row
    return family_rows[0]


def variant_rows(family_id: str):
    ordered = []
    for role in ("clearer", "more-polite", "also-common"):
        for row in rows_by_family[family_id]:
            if row["variant_role"] == role:
                ordered.append(row)
    return ordered


def family_phrase_id(family_id: str):
    return primary_row(family_id)["phrase_id"]


def join_notes(tokens):
    return " | ".join(tokens)


added_tokens = []
skipped_tokens = []


def add_answer_token(row, token: str):
    tokens = split_notes(row.get("notes", ""))
    if token in tokens:
        return True
    base = baseline_answer_counts[row["phrase_id"]]
    current = len([item for item in tokens if item.startswith("answer-page-sample=")])
    if base >= 6:
        skipped_tokens.append((row["phrase_id"], token, "baseline-saturated"))
        return False
    if current >= 8:
        skipped_tokens.append((row["phrase_id"], token, "current-cap"))
        return False
    tokens.append(token)
    row["notes"] = join_notes(tokens)
    added_tokens.append((row["phrase_id"], token))
    return True


def clean_hub_id(family_id: str):
    return f"viet-{family_id}"


def normalize_answer_marker_prefixes(rows, hub_aliases):
    for row in rows:
        tokens = split_notes(row.get("notes", ""))
        normalized = []
        changed = False
        for token in tokens:
            rewritten = token
            for old_id, new_id in hub_aliases.items():
                old_prefix = f"answer-page-sample={old_id}:"
                if token.startswith(old_prefix):
                    rewritten = f"answer-page-sample={new_id}:{token[len(old_prefix):]}"
                    changed = True
                    break
            normalized.append(rewritten)
        if changed:
            row["notes"] = join_notes(normalized)


reclass_existing = {
    "viet-food-menu": "food-drink",
    "viet-food-not-spicy": "food-drink",
    "viet-food-bottled-water": "food-drink",
    "viet-food-need-table": "food-drink",
    "viet-food-pay-now": "food-drink",
    "viet-hotel-reservation": "hotel-accommodation",
    "viet-hotel-check-in": "hotel-accommodation",
    "viet-hotel-room-hot": "hotel-accommodation",
    "viet-hotel-checkout-time": "hotel-accommodation",
    "viet-hotel-aircon-broken": "hotel-accommodation",
    "viet-money-how-much": "money-transaction",
    "viet-money-final-price": "money-transaction",
}

promotions = [
    ("viet-rel-emergency-manager-now", "urgent-help-medical"),
    ("viet-rel-emergency-call-help", "urgent-help-medical"),
    ("viet-rel-emergency-get-away", "urgent-help-medical"),
    ("viet-rel-emergency-police", "urgent-help-medical"),
    ("viet-rel-health-doctor", "urgent-help-medical"),
    ("viet-rel-health-allergy", "urgent-help-medical"),
    ("viet-rel-emergency-wallet-stolen", "urgent-help-medical"),
    ("viet-rel-v900-heal-phar-please-write-the-instructions", "repair-clarification"),
    ("viet-rel-repair-translate-this", "repair-clarification"),
    ("viet-rel-v500-unde-repa-can-you-write-the-price", "repair-clarification"),
    ("viet-rel-repair-which-one", "repair-clarification"),
    ("viet-rel-repair-time-exact", "repair-clarification"),
    ("viet-rel-repair-type-phone", "repair-clarification"),
    ("viet-rel-v900-tran-is-that-the-total-price", "money-transaction"),
    ("viet-rel-money-total", "money-transaction"),
    ("viet-rel-money-what-fee", "money-transaction"),
    ("viet-rel-money-service-included", "money-transaction"),
    ("viet-rel-b2-money-itemized-bill", "money-transaction"),
    ("viet-rel-v500-hote-acco-here-is-my-passport-for-check-in", "hotel-accommodation"),
    ("viet-rel-hotel-booking-wrong", "hotel-accommodation"),
    ("viet-rel-hotel-room-not-ready", "hotel-accommodation"),
    ("viet-rel-v500-hote-acco-do-you-need-a-deposit", "hotel-accommodation"),
    ("viet-rel-hotel-quiet-room", "hotel-accommodation"),
    ("viet-rel-v500-hote-acco-can-someone-come-fix-it", "hotel-accommodation"),
    ("viet-rel-hotel-no-hot-water", "hotel-accommodation"),
    ("viet-rel-v500-hote-acco-can-i-change-rooms", "hotel-accommodation"),
    ("viet-rel-hotel-late-checkout", "hotel-accommodation"),
    ("viet-rel-service-water", "practical-service-navigation"),
    ("viet-rel-service-receipt", "practical-service-navigation"),
    ("viet-rel-directions-right-route", "practical-service-navigation"),
]
cluster_to_hub = {
    cluster_id: clean_hub_id(cluster_by_id[cluster_id]["familyId"])
    for cluster_id, _ in promotions
}

bucket_configs = {
    "viet-rel-emergency-manager-now": {
        "likelyReply": [("emergency-call-help", "Staff may first pull in someone nearby before the manager arrives.")],
        "repairIfMissed": [("repair-type-phone", "If shouting for the manager is not landing, move the message onto a phone screen.")],
        "askNext": [("emergency-police", "If the manager cannot settle it quickly, move straight to police help.")],
        "escalateTo": [("emergency-police", "If the situation is still unsafe after the manager arrives, escalate to police help.")],
    },
    "viet-rel-emergency-call-help": {
        "likelyReply": [("health-doctor", "The fastest useful response is often pulling in a doctor or trained helper.")],
        "repairIfMissed": [("repair-type-phone", "If the panic phrase is not landing, put the request on a phone immediately.")],
        "askNext": [("emergency-get-away", "If staying here is still unsafe, the next move is getting out right now.")],
        "escalateTo": [("emergency-police", "If nearby help is not enough, escalate straight to police help.")],
    },
    "viet-rel-emergency-get-away": {
        "likelyReply": [("emergency-manager-now", "Staff often answer by calling a manager or guard to move you fast.")],
        "repairIfMissed": [("repair-type-phone", "If the urgency is not landing, show the request on a phone instead of repeating it.")],
        "askNext": [("emergency-police", "If you are still not safe once moved, escalate to police help.")],
        "escalateTo": [("emergency-call-help", "If no one is reacting, push again for immediate help.")],
    },
    "viet-rel-emergency-police": {
        "likelyReply": [("emergency-wallet-stolen", "Police help usually turns quickly to what was taken or what happened.")],
        "repairIfMissed": [("repair-type-phone", "If the phrase is missed, get the request onto a phone screen fast.")],
        "askNext": [("emergency-police-report", "Once police help is real, the next practical step is often the formal report.")],
        "escalateTo": [("emergency-call-help", "If you cannot reach police directly, keep the nearby help chain moving.")],
    },
    "viet-rel-health-doctor": {
        "likelyReply": [("emergency-hospital", "The first useful answer is often sending you straight to the hospital or doctor room.")],
        "repairIfMissed": [("repair-translate-this", "If the symptom ask is not landing, push the wording into direct translation help.")],
        "askNext": [("health-allergy", "Once a doctor is involved, the next practical move is often naming the allergy or trigger clearly.")],
        "escalateTo": [("emergency-ambulance", "If the condition is getting worse fast, escalate to ambulance help.")],
    },
    "viet-rel-health-allergy": {
        "likelyReply": [("v900-heal-phar-please-write-the-instructions", "Staff often answer by moving into written instructions or ingredient details.")],
        "repairIfMissed": [("repair-translate-this", "If the allergy phrase is not landing, push the food or medicine into translation help.")],
        "askNext": [("health-doctor", "If the reaction risk feels bigger than a quick fix, move straight to the doctor page.")],
        "escalateTo": [("emergency-hospital", "If the allergy may turn urgent, escalate to hospital help immediately.")],
    },
    "viet-rel-emergency-wallet-stolen": {
        "likelyReply": [("emergency-police", "A stolen-wallet report usually turns first into police help.")],
        "repairIfMissed": [("repair-type-phone", "If the theft report is not landing, put the key detail on a phone screen.")],
        "askNext": [("emergency-police-report", "After police help starts, the next useful move is the written report.")],
        "escalateTo": [("emergency-manager-now", "If a shop or hotel is involved, escalate to the manager immediately.")],
    },
    "viet-rel-v900-heal-phar-please-write-the-instructions": {
        "likelyReply": [("repair-type-phone", "Staff may answer by typing the dosage or next step into a phone instead.")],
        "repairIfMissed": [("repair-translate-this", "If written instructions are still not enough, push the label or note into translation help.")],
        "askNext": [("health-doctor", "If the instructions still feel unsafe, move straight to the doctor page.")],
        "crossClassExit": [("health-pharmacy", "Once the instructions are visible, loop back to the pharmacy page to finish the medicine step.")],
    },
    "viet-rel-repair-translate-this": {
        "likelyReply": [("repair-which-one", "They may first ask which word, line, or item you mean.")],
        "repairIfMissed": [("repair-type-phone", "If the translation ask is missed, move the exact text onto a phone screen.")],
        "askNext": [("service-receipt", "Once the text is clear, the next practical move may be confirming the receipt or bill line.")],
        "crossClassExit": [("food-menu", "This repair often turns back into reading the menu or sign correctly.")],
    },
    "viet-rel-v500-unde-repa-can-you-write-the-price": {
        "likelyReply": [("money-total", "The answer often shifts straight into the full number or total.")],
        "repairIfMissed": [("repair-type-phone", "If asking for writing is awkward, ask them to type the amount on a phone.")],
        "askNext": [("v900-tran-is-that-the-total-price", "Once the number is visible, the next move is confirming whether it is the real total.")],
        "crossClassExit": [("service-receipt", "If the amount is still messy, move into the receipt page so the charge can be tracked line by line.")],
    },
    "viet-rel-repair-which-one": {
        "likelyReply": [("directions-right-route", "People often answer by pointing to the exact route, stop, or option they meant.")],
        "repairIfMissed": [("repair-type-phone", "If the question is still not landing, put the options onto a phone screen.")],
        "askNext": [("repair-translate-this", "Once the choice is visible, translation help may still be the cleanest next move.")],
        "crossClassExit": [("service-water", "This repair also works when you need someone to point to the exact item at a counter.")],
    },
    "viet-rel-repair-time-exact": {
        "likelyReply": [("hotel-late-checkout", "Time clarifications often bounce straight into how much later you can really stay.")],
        "repairIfMissed": [("repair-type-phone", "If the time is still unclear, get the exact hour onto a phone screen.")],
        "askNext": [("hotel-checkout-time", "Once the number is clear, loop back to the real checkout page.")],
        "crossClassExit": [("directions-right-route", "Exact-time repairs also matter when the route or pickup timing feels wrong.")],
    },
    "viet-rel-repair-type-phone": {
        "likelyReply": [("repair-translate-this", "Typing it out often leads straight into one more translation or clarification step.")],
        "repairIfMissed": [("repair-which-one", "If the phone handoff is still fuzzy, first pin down which item or line is in question.")],
        "askNext": [("service-receipt", "Once the detail is on the screen, the next useful move is often checking the exact receipt or amount.")],
        "crossClassExit": [("hotel-booking-wrong", "Phone-based repair is also a practical bridge when a booking detail is wrong.")],
    },
    "viet-rel-v900-tran-is-that-the-total-price": {
        "likelyReply": [("money-what-fee", "If the amount jumps, the first answer is often about the extra fee or line item.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If the total is still fuzzy, ask for the number in writing.")],
        "askNext": [("b2-money-itemized-bill", "If the total still feels wrong, move straight to the itemized bill.")],
        "crossClassExit": [("service-receipt", "Once the number is settled, the receipt becomes the practical proof point.")],
    },
    "viet-rel-money-total": {
        "likelyReply": [("v900-tran-is-that-the-total-price", "Once you hear the total, the next move is checking whether it is really the final number.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If the total lands too fast, get it written down.")],
        "askNext": [("b2-money-itemized-bill", "If several items are in play, an itemized bill is the clean next branch.")],
        "crossClassExit": [("service-receipt", "After the total is clear, the receipt becomes the practical closeout step.")],
    },
    "viet-rel-money-what-fee": {
        "likelyReply": [("money-service-included", "The first answer is often whether service or another charge is already included.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If the explanation is muddy, ask for the fee detail in writing.")],
        "askNext": [("b2-money-itemized-bill", "If the fee still looks wrong, an itemized bill is the next honest move.")],
        "crossClassExit": [("service-receipt", "If they cannot explain it clearly, anchor the dispute to the receipt.")],
    },
    "viet-rel-money-service-included": {
        "likelyReply": [("service-receipt", "The clean proof point after this question is usually the receipt or bill line.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If the service explanation stays vague, get it written down.")],
        "askNext": [("v900-tran-is-that-the-total-price", "Once service is clear, confirm the true final total before paying.")],
        "crossClassExit": [("hotel-check-in", "This same question can spill into hotel deposit or desk-payment moments too.")],
    },
    "viet-rel-b2-money-itemized-bill": {
        "likelyReply": [("service-receipt", "The conversation usually ends with the bill or receipt line right in front of you.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If they will not break it down verbally, push for the written numbers.")],
        "askNext": [("money-what-fee", "Once the lines are visible, the next move is asking about the fee that still looks wrong.")],
        "crossClassExit": [("food-pay-now", "In restaurant flow, this usually lands back on the meal-payment page.")],
    },
    "viet-rel-v500-hote-acco-here-is-my-passport-for-check-in": {
        "likelyReply": [("hotel-check-in", "Showing the passport usually moves the desk straight into the real check-in step.")],
        "repairIfMissed": [("repair-type-phone", "If the desk still looks lost, move the name or booking detail onto a phone screen.")],
        "askNext": [("v500-hote-acco-do-you-need-a-deposit", "Once your identity is clear, the next desk question is often the deposit.")],
        "crossClassExit": [("service-receipt", "If payment happens immediately, the receipt becomes the useful proof point.")],
    },
    "viet-rel-hotel-booking-wrong": {
        "likelyReply": [("hotel-reservation", "The desk usually answers by pulling the reservation back into view.")],
        "repairIfMissed": [("repair-type-phone", "If the mismatch is still fuzzy, show the booking message or app on a phone.")],
        "askNext": [("hotel-room-not-ready", "Sometimes the reservation exists but the next real issue is that the room still is not ready.")],
        "crossClassExit": [("service-receipt", "If the booking problem turns into a charge dispute, anchor it to the receipt or total.")],
    },
    "viet-rel-hotel-room-not-ready": {
        "likelyReply": [("hotel-late-checkout", "A not-ready room often turns into a timing conversation about when you can really get in.")],
        "repairIfMissed": [("repair-type-phone", "If staff keep missing the problem, show the ready-time or booking detail on a phone.")],
        "askNext": [("hotel-quiet-room", "If you must wait anyway, the next useful move is locking in the room preference that matters.")],
        "crossClassExit": [("hotel-checkout", "If the timing slips badly, the desk may switch into a broader room-timing conversation.")],
    },
    "viet-rel-v500-hote-acco-do-you-need-a-deposit": {
        "likelyReply": [("v900-tran-is-that-the-total-price", "Deposit talk often slides immediately into the total amount you are expected to pay.")],
        "repairIfMissed": [("repair-type-phone", "If the deposit answer is unclear, get the amount or rule onto a phone screen.")],
        "askNext": [("service-receipt", "Once the amount is set, the practical next step is having the receipt or proof ready.")],
        "crossClassExit": [("money-final-price", "If the desk gets vague, move straight to the final-money page.")],
    },
    "viet-rel-hotel-quiet-room": {
        "likelyReply": [("hotel-check-in", "Room-preference questions usually get folded back into the main check-in flow.")],
        "repairIfMissed": [("repair-type-phone", "If the request is missed, show the room note or booking comment on a phone.")],
        "askNext": [("hotel-late-checkout", "Once the room is settled, the next timing question is often checkout.")],
        "crossClassExit": [("hotel-aircon-broken", "If the room itself is the problem, pivot straight into the room-fix page.")],
    },
    "viet-rel-v500-hote-acco-can-someone-come-fix-it": {
        "likelyReply": [("hotel-no-hot-water", "Staff often answer by asking which room problem needs fixing first.")],
        "repairIfMissed": [("repair-type-phone", "If the issue is still unclear, show the broken item on a phone or photo.")],
        "askNext": [("v500-hote-acco-can-i-change-rooms", "If the fix will take too long, the next move is asking to change rooms.")],
        "crossClassExit": [("service-receipt", "If compensation or charges come up, anchor the conversation to the receipt.")],
    },
    "viet-rel-hotel-no-hot-water": {
        "likelyReply": [("v500-hote-acco-can-someone-come-fix-it", "The first useful answer is often sending someone to inspect or fix it.")],
        "repairIfMissed": [("repair-type-phone", "If the complaint is not landing, put the problem into writing on a phone.")],
        "askNext": [("v500-hote-acco-can-i-change-rooms", "If the fix is not fast enough, the next move is asking to change rooms.")],
        "crossClassExit": [("hotel-room-hot", "This usually sits inside the same larger room-comfort problem flow.")],
    },
    "viet-rel-v500-hote-acco-can-i-change-rooms": {
        "likelyReply": [("hotel-quiet-room", "Staff often answer by asking what kind of room change you actually need.")],
        "repairIfMissed": [("repair-type-phone", "If the request is drifting, show the room issue or booking note on a phone.")],
        "askNext": [("hotel-late-checkout", "If the move cannot happen yet, the next practical question is timing.")],
        "crossClassExit": [("service-receipt", "If the room change affects payment or compensation, move into the receipt page.")],
    },
    "viet-rel-hotel-late-checkout": {
        "likelyReply": [("service-receipt", "A late-checkout answer often turns into a charge or payment proof conversation.")],
        "repairIfMissed": [("repair-time-exact", "If the answer is fuzzy, pin down the exact time before agreeing.")],
        "askNext": [("hotel-checkout-time", "Once the later time is real, loop back to the main checkout-time page.")],
        "crossClassExit": [("money-final-price", "If they charge for it, move straight into the money page before saying yes.")],
    },
    "viet-rel-service-water": {
        "likelyReply": [("money-how-much", "At a counter, the immediate follow-up is often the price of the bottle.")],
        "repairIfMissed": [("repair-which-one", "If they are confused, ask them to point to the exact bottle or size.")],
        "askNext": [("food-pay-now", "Once you have the water, the conversation usually slides into payment.")],
        "crossClassExit": [("food-bottled-water", "If you are already in a meal flow, the same need belongs on the food-water page.")],
    },
    "viet-rel-service-receipt": {
        "likelyReply": [("v900-tran-is-that-the-total-price", "The first question after asking for the receipt is often whether the number on it is really the total.")],
        "repairIfMissed": [("v500-unde-repa-can-you-write-the-price", "If the bill line is still hard to follow, get the amount written down clearly.")],
        "askNext": [("b2-money-itemized-bill", "If the receipt still looks wrong, the next move is asking for the itemized bill.")],
        "crossClassExit": [("food-pay-now", "In restaurant flow, the receipt step sits right under the pay-now page.")],
    },
    "viet-rel-directions-right-route": {
        "likelyReply": [("transport-stop-here", "Route checks often get answered with the exact stop or turn you should watch for next.")],
        "repairIfMissed": [("repair-which-one", "If the route answer is vague, ask which line, road, or turn they mean.")],
        "askNext": [("directions-map-pin", "If words are still not enough, the next clean move is a map pin.")],
        "crossClassExit": [("transport-destination", "If you are still not oriented, move back to the destination page and reset the whole ride.")],
    },
}

support_pools = {
    "urgent-help-medical": [
        "emergency-passport-gone",
        "emergency-police-report",
        "help-call-this-number",
        "emergency-embassy",
        "emergency-tourist-police",
        "emergency-police-station",
        "emergency-payment-card",
        "emergency-shared-location",
        "emergency-temporary-doc",
        "emergency-scam",
        "emergency-safe-now",
    ],
    "repair-clarification": [
        "repair-meaning",
        "repair-spell-name",
        "time-what-time",
        "time-have-booking",
        "time-open",
        "time-tomorrow-morning",
        "v900-time-date-book-please-write-down-the-time",
        "v900-time-date-book-please-write-down-the-address",
        "shopping-pay-where",
        "shopping-size",
        "shopping-color",
    ],
    "money-transaction": [
        "b2-money-already-paid",
        "b2-money-card-reader",
        "b2-money-count-together",
        "b2-money-smaller-notes",
        "b2-money-transfer-fee",
        "b2-money-bank-app-transfer",
        "money-find-atm",
        "v500-mone-numb-pric-can-i-have-a-receipt",
        "v500-mone-numb-pric-can-you-give-me-change",
        "v900-mone-numb-pric-can-i-pay-by-qr-code",
        "v900-mone-numb-pric-is-there-an-atm-nearby",
        "v900-mone-numb-pric-what-is-the-exchange-rate",
    ],
    "hotel-accommodation": [
        "hotel-luggage",
        "hotel-checkout",
        "b2-hotel-extra-key",
        "b2-hotel-room-safe",
        "b2-hotel-housekeeping-later",
        "b2-hotel-room-too-cold",
        "v1000-hotel-extra-pillows",
        "v1000-hotel-more-drinking-water",
        "v500-hote-acco-is-breakfast-included",
        "v900-hote-acco-can-i-leave-my-bags-until-check-in",
        "v900-hote-acco-can-you-store-my-luggage-after-check-out",
        "v900-hote-acco-can-you-help-me-with-my-bags",
    ],
    "practical-service-navigation": [
        "transport-stop-here",
        "directions-follow-signs",
        "directions-landmark-nearby",
        "directions-last-turn",
        "directions-platform-check",
        "phone-map-not-working",
        "service-inside-seat",
        "service-quiet-seat",
        "service-receipt-copy",
        "food-need-table",
        "food-pay-now",
    ],
}
cluster_support_pools = {
    "viet-rel-emergency-manager-now": [
        "help-call-this-number",
        "emergency-shared-location",
        "emergency-safe-now",
        "emergency-payment-card",
    ],
    "viet-rel-emergency-call-help": [
        "help-call-this-number",
        "emergency-shared-location",
        "emergency-safe-now",
        "emergency-payment-card",
    ],
    "viet-rel-emergency-get-away": [
        "emergency-shared-location",
        "help-call-this-number",
        "emergency-safe-now",
        "emergency-payment-card",
    ],
    "viet-rel-emergency-police": [
        "emergency-police-station",
        "emergency-tourist-police",
        "emergency-payment-card",
        "emergency-passport-gone",
    ],
    "viet-rel-health-doctor": [
        "help-call-this-number",
        "emergency-shared-location",
        "emergency-safe-now",
        "emergency-payment-card",
    ],
    "viet-rel-health-allergy": [
        "help-call-this-number",
        "emergency-shared-location",
        "emergency-safe-now",
        "emergency-payment-card",
    ],
    "viet-rel-emergency-wallet-stolen": [
        "emergency-payment-card",
        "emergency-passport-gone",
        "emergency-police-report",
        "help-call-this-number",
    ],
    "viet-rel-service-water": [
        "food-bottled-water",
        "food-need-table",
        "service-inside-seat",
        "service-quiet-seat",
        "food-pay-now",
    ],
    "viet-rel-service-receipt": [
        "service-receipt-copy",
        "service-copy-docs",
        "service-scan-docs",
        "service-email-file",
        "food-pay-now",
    ],
    "viet-rel-directions-right-route": [
        "transport-stop-here",
        "directions-map-pin",
        "directions-follow-signs",
        "directions-landmark-nearby",
        "directions-last-turn",
        "directions-platform-check",
        "phone-map-not-working",
    ],
}
cluster_support_counts = {
    "viet-rel-emergency-manager-now": 2,
    "viet-rel-emergency-call-help": 2,
    "viet-rel-emergency-get-away": 2,
    "viet-rel-health-doctor": 2,
    "viet-rel-health-allergy": 2,
    "viet-rel-emergency-police": 1,
    "viet-rel-emergency-wallet-stolen": 1,
}
support_pool_index = {key: 0 for key in support_pools}
support_pool_used = {key: set() for key in support_pools}


def extra_support_reason(phrase_class: str, family_id: str):
    title = primary_row(family_id)["family_title"].lower()
    if phrase_class == "urgent-help-medical":
        return f"If the first urgent line only partly works, the next useful move may be {title}."
    if phrase_class == "repair-clarification":
        return f"If the first clarification is still fuzzy, the next rescue move may be {title}."
    if phrase_class == "money-transaction":
        return f"If the first price answer is still not enough, the next practical move may be {title}."
    if phrase_class == "hotel-accommodation":
        return f"If the desk still has work to do, the next useful branch may be {title}."
    return f"If this step is still not resolved, the next nearby useful page may be {title}."


def extra_support_targets(cluster_id: str, phrase_class: str, existing_family_ids, count: int = 3):
    pool = cluster_support_pools.get(cluster_id)
    use_class_rotation = pool is None
    if use_class_rotation:
        pool = support_pools.get(phrase_class, [])
    if not pool:
        return []
    if use_class_rotation:
        start = support_pool_index[phrase_class]
        ordered = [pool[(start + offset) % len(pool)] for offset in range(len(pool))]
    else:
        start = 0
        ordered = list(pool)
    blocked = set(existing_family_ids)
    selected = []
    last_index = start

    def family_is_eligible(family_id: str):
        if family_id in blocked or family_id not in rows_by_family:
            return False
        row = primary_row(family_id)
        phrase_id = row["phrase_id"]
        return baseline_answer_counts[phrase_id] < 6 and len(answer_tokens(row.get("notes", ""))) < 8

    for require_fresh in (True, False):
        for family_id in ordered:
            if len(selected) >= count:
                break
            if not family_is_eligible(family_id):
                continue
            if use_class_rotation and require_fresh and family_id in support_pool_used[phrase_class]:
                continue
            selected.append(family_id)
            blocked.add(family_id)
            if use_class_rotation:
                last_index = (pool.index(family_id) + 1) % len(pool)
        if len(selected) >= count:
            break

    if use_class_rotation:
        support_pool_index[phrase_class] = last_index
        support_pool_used[phrase_class].update(selected)
    return selected

for cluster in relations["clusters"]:
    if cluster["answerPageReady"]:
        candidate_hub_id = clean_hub_id(cluster["familyId"])
        if candidate_hub_id in reclass_existing:
            cluster["phraseClass"] = reclass_existing[candidate_hub_id]

for cluster_id, phrase_class in promotions:
    cluster = cluster_by_id[cluster_id]
    cluster["answerPageReady"] = True
    cluster["phraseClass"] = phrase_class
    cfg = bucket_configs[cluster_id]
    buckets = {key: [] for key in ["likelyReply", "repairIfMissed", "askNext", "escalateTo", "crossClassExit"]}
    for bucket_name, items in cfg.items():
        for family_id, reason in items:
            buckets[bucket_name].append(
                {
                    "targetFamilyId": family_id,
                    "targetPhraseId": family_phrase_id(family_id),
                    "reason": reason,
                }
            )
    used_target_families = {cluster["familyId"]}
    for entries in buckets.values():
        for entry in entries:
            used_target_families.add(entry["targetFamilyId"])
    extra_count = cluster_support_counts.get(cluster_id, 3)
    for family_id in extra_support_targets(cluster_id, phrase_class, used_target_families, count=extra_count):
        buckets["crossClassExit"].append(
            {
                "targetFamilyId": family_id,
                "targetPhraseId": family_phrase_id(family_id),
                "reason": extra_support_reason(phrase_class, family_id),
            }
        )
    cluster["relationBuckets"] = buckets
    bucket_to_relation = {
        "likelyReply": "likely_answer_to",
        "repairIfMissed": "repair_for",
        "askNext": "next_step_after",
        "escalateTo": "escalation_for",
        "crossClassExit": "see_also",
    }
    family_relations = []
    for bucket_name, relation_type in bucket_to_relation.items():
        for entry in buckets[bucket_name]:
            family_relations.append(
                {
                    "relationType": relation_type,
                    "targetFamilyId": entry["targetFamilyId"],
                    "reason": entry["reason"],
                }
            )
    cluster["familyRelations"] = family_relations
    cluster["youMayHearSignals"] = [
        {
            "signalText": entry["reason"],
            "sourcePhraseId": cluster["anchorPhraseId"],
            "advisoryOnly": True,
        }
        for entry in buckets["likelyReply"][:2]
    ]
    cluster["possibleTravelerResponses"] = [
        {
            "kind": bucket_name,
            "familyId": entry["targetFamilyId"],
            "phraseId": entry["targetPhraseId"],
            "note": entry["reason"],
        }
        for bucket_name in ("likelyReply", "askNext")
        for entry in buckets[bucket_name][:2]
    ]

promoted_prefixes = tuple(f"answer-page-sample={hub_id}:" for hub_id in cluster_to_hub.values())
for row in rows:
    tokens = split_notes(row.get("notes", ""))
    filtered = [token for token in tokens if not token.startswith(promoted_prefixes)]
    if filtered != tokens:
        row["notes"] = join_notes(filtered)
for row in rows:
    baseline_answer_counts[row["phrase_id"]] = len(answer_tokens(row.get("notes", "")))
baseline_supporting_rows = sum(
    1
    for row in rows
    if any(token.startswith("answer-page-sample=") and ":support:" in token for token in answer_tokens(row.get("notes", "")))
)

pending_support_tokens = []
for cluster_id, _ in promotions:
    cluster = cluster_by_id[cluster_id]
    hub_id = cluster_to_hub[cluster_id]
    add_answer_token(primary_row(cluster["familyId"]), f"answer-page-sample={hub_id}:anchor")
    for vrow in variant_rows(cluster["familyId"]):
        token_tail = VARIANT_TOKEN_MAP.get(vrow["variant_role"])
        if token_tail:
            add_answer_token(vrow, f"answer-page-sample={hub_id}:{token_tail}")

for cluster_id, _ in promotions:
    cluster = cluster_by_id[cluster_id]
    hub_id = cluster_to_hub[cluster_id]
    for bucket_name in SUPPORT_KINDS:
        for entry in cluster["relationBuckets"][bucket_name]:
            if entry["targetFamilyId"] not in rows_by_family:
                continue
            pending_support_tokens.append(
                (entry["targetFamilyId"], f"answer-page-sample={hub_id}:support:{bucket_name}")
            )

for family_id, token in pending_support_tokens:
    add_answer_token(primary_row(family_id), token)

existing_mixes = {mix["id"]: mix for mix in answer["moduleMixes"]}
for mix in [
    {
        "id": "money-transaction-v1",
        "phraseClass": "money-transaction",
        "moduleTypes": [
            "price-core",
            "number-check",
            "fee-or-total",
            "likely-reply",
            "show-amount",
            "next-money-step",
            "fallback",
        ],
        "requiredRelationBuckets": ["likelyReply", "repairIfMissed", "askNext"],
    },
    {
        "id": "hotel-accommodation-v1",
        "phraseClass": "hotel-accommodation",
        "moduleTypes": [
            "desk-core",
            "room-or-booking-detail",
            "likely-reply",
            "what-to-hand-over",
            "local-reality",
            "next-desk-step",
            "fallback",
        ],
        "requiredRelationBuckets": ["likelyReply", "repairIfMissed", "askNext"],
    },
    {
        "id": "food-drink-v1",
        "phraseClass": "food-drink",
        "moduleTypes": [
            "order-core",
            "table-or-menu-setup",
            "restriction-or-choice",
            "likely-reply",
            "next-order-step",
            "payment-or-exit",
            "fallback",
        ],
        "requiredRelationBuckets": ["likelyReply", "repairIfMissed", "askNext"],
    },
]:
    existing_mixes[mix["id"]] = mix
answer["moduleMixes"] = list(existing_mixes.values())
guardrail_rule = (
    "Do not add new answer-page markers to saturated legacy rows; spread new support markers across lower-density adjacent rows."
)
if guardrail_rule not in answer["contentRules"]:
    answer["contentRules"].append(guardrail_rule)

flagship_existing = {
    "viet-polite-hello",
    "viet-polite-thank-you",
    "viet-polite-acknowledge",
    "viet-polite-no-thanks",
    "viet-social-how-are-you",
    "viet-emergency-not-safe",
    "viet-emergency-ambulance",
    "viet-emergency-hospital",
    "viet-emergency-following-me",
    "viet-health-pharmacy",
    "viet-v900-heal-phar-i-have-trouble-breathing",
    "viet-repair-understand",
    "viet-repair-repeat",
    "viet-transport-destination",
    "viet-directions-how-to-get",
    "viet-directions-map-pin",
    "viet-money-how-much",
    "viet-money-final-price",
    "viet-hotel-reservation",
    "viet-hotel-check-in",
    "viet-food-menu",
}
target_regenerated = flagship_existing | set(reclass_existing.keys()) | set(cluster_to_hub.values())
hub_marker_aliases = {
    hub["relationClusterId"]: hub["hubId"]
    for hub in answer["hubs"]
    if hub["relationClusterId"] != hub["hubId"]
}
normalize_answer_marker_prefixes(rows, hub_marker_aliases)
class_to_mix = {
    "greetings-social": "greetings-social-v1",
    "urgent-help-medical": "urgent-help-medical-v1",
    "repair-clarification": "repair-clarification-v1",
    "practical-service-navigation": "practical-service-navigation-v1",
    "money-transaction": "money-transaction-v1",
    "hotel-accommodation": "hotel-accommodation-v1",
    "food-drink": "food-drink-v1",
}


def source_phrase_ids(cluster):
    ids = [
        cluster.get("anchorPhraseId"),
        cluster.get("shortestFormPhraseId"),
        cluster.get("clearerFormPhraseId"),
        cluster.get("morePoliteFormPhraseId"),
    ]
    ids.extend([row["phrase_id"] for row in variant_rows(cluster["familyId"])])
    out = []
    for phrase_id in ids:
        if phrase_id and phrase_id not in out:
            out.append(phrase_id)
    return out


def family_ids_from(entries):
    output = []
    for entry in entries:
        if entry["targetFamilyId"] not in output:
            output.append(entry["targetFamilyId"])
    return output


def bullets_from(entries, fallback, limit=3):
    if entries:
        return [entry["reason"] for entry in entries[:limit]]
    return fallback[:limit]


def make_module(module_id, module_type, source_phrase_ids, source_family_ids, relation_refs, summary, bullets):
    return {
        "moduleId": module_id,
        "type": module_type,
        "required": True,
        "sourcePhraseIds": source_phrase_ids,
        "sourceFamilyIds": source_family_ids,
        "relationRefs": relation_refs,
        "content": {
            "summary": summary,
            "bullets": bullets,
        },
    }


def bucket_entries(cluster, name):
    return cluster.get("relationBuckets", {}).get(name, []) or []


def build_hub(cluster):
    phrase_class = cluster["phraseClass"]
    hub_id = cluster_to_hub.get(cluster["clusterId"], clean_hub_id(cluster["familyId"]))
    mix_id = class_to_mix[phrase_class]
    src_ids = source_phrase_ids(cluster)
    likely = bucket_entries(cluster, "likelyReply")
    repair = bucket_entries(cluster, "repairIfMissed")
    ask = bucket_entries(cluster, "askNext")
    esc = bucket_entries(cluster, "escalateTo")
    cross = bucket_entries(cluster, "crossClassExit")
    alt_ids = [row["phrase_id"] for row in variant_rows(cluster["familyId"])]
    if phrase_class == "greetings-social":
        modules = [
            make_module(
                "core-phrase",
                "core-phrase",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} as the warm opener, then move quickly into the real ask.",
                bullets_from([], [cluster["familySummary"], "Keep it brief so the practical question still arrives quickly."]),
            ),
            make_module(
                "social-use-case",
                "social-use-case",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "Treat this as a bridge into the next part of the exchange, not the whole conversation.",
                bullets_from([], ["Use it at counters, desks, pickups, and other fast first-contact moments.", "If the exchange stays friendly, move into the question before the opening loses momentum."]),
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "Be ready for the first social answer so you do not stall out after the opener.",
                bullets_from(likely, ["The most common reply is a short acknowledgment before the real task starts."]),
            ),
            make_module(
                "say-next",
                "say-next",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask + cross),
                ["askNext", "crossClassExit"],
                "Have the next traveler move ready so the page does not dead-end after one polite line.",
                bullets_from(ask + cross, ["The opener should hand off into the next useful phrase immediately."]),
            ),
            make_module(
                "graceful-exit",
                "graceful-exit",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the exchange goes sideways, reset it with the lightest repair move that still keeps you moving.",
                bullets_from(repair, ["If the opener is missed, switch straight into repair instead of repeating it."]),
            ),
        ]
    elif phrase_class == "urgent-help-medical":
        modules = [
            make_module(
                "urgent-core",
                "urgent-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Lead with {cluster['familyTitle'].lower()} when delay makes the situation worse.",
                bullets_from([], [cluster["familySummary"], "Keep the first line short enough to say under stress."]),
            ),
            make_module(
                "risk-or-symptom-detail",
                "risk-or-symptom-detail",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "Name the one fact that raises urgency so the other person understands what must happen next.",
                bullets_from([], ["If there is one concrete risk or loss, say that before adding extra backstory."]),
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "The first answer usually points toward who is coming, what help is possible, or where you must go next.",
                bullets_from(likely, ["Urgent pages work best when the likely answer is already visible before panic takes over."]),
            ),
            make_module(
                "immediate-next-step",
                "immediate-next-step",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask),
                ["askNext"],
                "Keep the next urgent move visible so the user can keep moving without backing out.",
                bullets_from(ask, ["The next step should be obvious even if the first phrase only partly works."]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Under stress, practical movement matters more than perfect wording.",
                bullets_from([], ["One clear urgent line plus the next action is stronger than a long explanation.", "If the first helper is not enough, the page should already show the next escalation."]),
            ),
            make_module(
                "repair-branch",
                "repair-branch",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the first urgent line is not landing, move fast into the repair branch that still preserves urgency.",
                bullets_from(repair, ["Use the shortest repair that gets the message back on track."]),
            ),
            make_module(
                "safety-escalation",
                "safety-escalation",
                [cluster["anchorPhraseId"]],
                family_ids_from(esc),
                ["escalateTo"],
                "When the first response is too slow or too weak, show the harder escalation path immediately.",
                bullets_from(esc, ["If the situation is still unsafe, escalate instead of looping on the first phrase."]),
            ),
        ]
    elif phrase_class == "repair-clarification":
        modules = [
            make_module(
                "repair-core",
                "repair-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} to keep the conversation moving without pretending you understood.",
                bullets_from([], [cluster["familySummary"], "Repair pages work best when they rescue one detail at a time."]),
            ),
            make_module(
                "show-or-write",
                "show-or-write",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "When speech is failing, switch quickly to showing, typing, or writing instead of repeating yourself.",
                bullets_from(repair, ["The repair should narrow the confusion, not restart the whole interaction."]),
            ),
            make_module(
                "number-check",
                "number-check",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely + ask),
                ["likelyReply", "askNext"],
                "Most repair moments end with one exact detail becoming clear enough to act on.",
                bullets_from(likely + ask, ["Use the repair branch to surface the one number, item, or route detail that matters."]),
            ),
            make_module(
                "likely-response",
                "likely-response",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "Be ready for the way people usually answer the clarification request.",
                bullets_from(likely, ["The next answer is often a pointer, a typed detail, or one cleaner restatement."]),
            ),
            make_module(
                "next-try",
                "next-try",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask + cross),
                ["askNext", "crossClassExit"],
                "Once the missing detail is clear, jump straight into the next useful page instead of lingering in repair mode.",
                bullets_from(ask + cross, ["Repair should lead back into action, not trap the user in more repair."]),
            ),
            make_module(
                "courtesy-close",
                "courtesy-close",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "A good repair page gives the user one clean rescue move and then gets out of the way.",
                bullets_from([], ["Keep the repair tight, practical, and tied to the immediate task."]),
            ),
        ]
    elif phrase_class == "practical-service-navigation":
        modules = [
            make_module(
                "task-core",
                "task-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} to move the practical task forward without extra setup.",
                bullets_from([], [cluster["familySummary"], "Keep the first line tied to the exact thing, route, or counter step in front of you."]),
            ),
            make_module(
                "operator-question",
                "operator-question",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "The first reply usually tells you what the operator still needs to know before the task can move.",
                bullets_from(likely, ["Be ready for the first confirmation, route check, or closeout question."]),
            ),
            make_module(
                "confirm-detail",
                "confirm-detail",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "Practical pages work best when one detail stays pinned down the whole time.",
                bullets_from([], ["Keep the item, stop, route, or receipt line visible while you talk about it."]),
            ),
            make_module(
                "what-to-show",
                "what-to-show",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "Showing the exact object or screen is often faster than explaining it twice.",
                bullets_from([], ["Point, show, or hold up the relevant screen whenever that is faster than more speech."]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Most practical failures are about one missing detail, not a lack of vocabulary.",
                bullets_from([], ["The strongest next step is usually the smallest clarification that unlocks action."]),
            ),
            make_module(
                "next-step",
                "next-step",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask + cross),
                ["askNext", "crossClassExit"],
                "Show the next nearby useful page so the user can keep moving once this step lands.",
                bullets_from(ask + cross, ["Practical pages should feel like a dense utility chain, not a dead-end card."]),
            ),
            make_module(
                "fallback",
                "fallback",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the first try misses, use the lightest repair that keeps the task alive.",
                bullets_from(repair, ["If the task stalls, rescue the detail before the interaction resets."]),
            ),
        ]
    elif phrase_class == "money-transaction":
        modules = [
            make_module(
                "price-core",
                "price-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} to pin down the number before money actually moves.",
                bullets_from([], [cluster["familySummary"], "Money pages should protect the user from guessing, nodding, or paying too early."]),
            ),
            make_module(
                "number-check",
                "number-check",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Keep the exact amount, fee, or total visible while the conversation is live.",
                bullets_from([], ["Point at the bill, item, screen, or calculator so the number stays tied to one thing."]),
            ),
            make_module(
                "fee-or-total",
                "fee-or-total",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely + ask),
                ["likelyReply", "askNext"],
                "The first useful branch usually explains what the number means or what part of it still needs checking.",
                bullets_from(likely + ask, ["Money pages should surface fee, total, and receipt branches before the user pays."]),
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "Expect the first answer to be another number, fee explanation, or proof line.",
                bullets_from(likely, ["The best money reply is the one that makes the charge auditable."]),
            ),
            make_module(
                "show-amount",
                "show-amount",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "If the amount is drifting, put it on the page or screen instead of arguing from memory.",
                bullets_from([], ["Cash, screen totals, and printed lines are stronger than repeated spoken numbers."]),
            ),
            make_module(
                "next-money-step",
                "next-money-step",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask + cross),
                ["askNext", "crossClassExit"],
                "After the first number lands, show the next check the traveler is most likely to need.",
                bullets_from(ask + cross, ["Good money pages make the next audit step obvious before payment closes out."]),
            ),
            make_module(
                "fallback",
                "fallback",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the number still is not trustworthy, move into the cleanest repair branch immediately.",
                bullets_from(repair, ["Use writing, typing, or a clearer proof line before you accept the amount."]),
            ),
        ]
    elif phrase_class == "hotel-accommodation":
        modules = [
            make_module(
                "desk-core",
                "desk-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} to keep the desk or room issue moving instead of drifting into vague hospitality talk.",
                bullets_from([], [cluster["familySummary"], "Hotel pages should anchor the guest to one room, one booking, or one timing problem at a time."]),
            ),
            make_module(
                "room-or-booking-detail",
                "room-or-booking-detail",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Keep the exact booking, room, or timing detail visible before staff reset the conversation.",
                bullets_from([], ["Show the booking screen, passport, key card, or room detail that proves what you mean."]),
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "Desk replies usually point to the next verification, payment, or room-status question.",
                bullets_from(likely, ["Hotel pages should make the next desk question feel expected, not surprising."]),
            ),
            make_module(
                "what-to-hand-over",
                "what-to-hand-over",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                "When the desk needs proof, show the right document or screen fast.",
                bullets_from([], ["Passports, booking confirmations, receipts, and room photos are often the real accelerators."]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Hotel conversations stall when one practical proof point is missing.",
                bullets_from([], ["The page should move from room problem to concrete action without making the user backtrack."]),
            ),
            make_module(
                "next-desk-step",
                "next-desk-step",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask + cross),
                ["askNext", "crossClassExit"],
                "Once the desk accepts the first issue, the next useful move should already be on the page.",
                bullets_from(ask + cross, ["Good hotel pages surface the next desk branch before the user gets sent into a new loop."]),
            ),
            make_module(
                "fallback",
                "fallback",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the desk still does not have it, switch to the clearest rescue path available.",
                bullets_from(repair, ["Hotel repair often means writing, typing, or showing the proof rather than talking longer."]),
            ),
        ]
    elif phrase_class == "food-drink":
        modules = [
            make_module(
                "order-core",
                "order-core",
                src_ids[:2],
                [cluster["familyId"]],
                [],
                f"Use {cluster['familyTitle'].lower()} to keep the meal moving toward the exact result you actually need.",
                bullets_from([], [cluster["familySummary"], "Food pages should feel like real ordering, seating, and closeout moments rather than generic restaurant vocabulary."]),
            ),
            make_module(
                "table-or-menu-setup",
                "table-or-menu-setup",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "The strongest meal pages still show the setup step that makes the next ask possible.",
                bullets_from([], ["That may be the table, menu, dish, drink, or bill moment immediately around the phrase."]),
            ),
            make_module(
                "restriction-or-choice",
                "restriction-or-choice",
                [cluster["anchorPhraseId"]],
                [cluster["familyId"]],
                [],
                "Pin down the one dish, ingredient, or payment detail that will change the traveler outcome.",
                bullets_from([], ["One clear food constraint or closeout detail is more useful than a longer restaurant speech."]),
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                [cluster["anchorPhraseId"]],
                family_ids_from(likely),
                ["likelyReply"],
                "Meal replies usually point to the next menu, table, drink, or payment branch.",
                bullets_from(likely, ["The first answer should make the next restaurant move obvious."]),
            ),
            make_module(
                "next-order-step",
                "next-order-step",
                [cluster["anchorPhraseId"]],
                family_ids_from(ask),
                ["askNext"],
                "Once the first food step lands, show the next useful page before the waiter walks away.",
                bullets_from(ask, ["Food pages work best when the next ask is ready while the interaction is still live."]),
            ),
            make_module(
                "payment-or-exit",
                "payment-or-exit",
                [cluster["anchorPhraseId"]],
                family_ids_from(cross),
                ["crossClassExit"],
                "Some meal pages naturally spill into payment, receipts, or the clean exit from the table.",
                bullets_from(cross, ["If the meal is effectively over, the user should see the closeout path immediately."]),
            ),
            make_module(
                "fallback",
                "fallback",
                [cluster["anchorPhraseId"]],
                family_ids_from(repair),
                ["repairIfMissed"],
                "If the food ask is not landing, rescue the missing detail with the simplest repair branch available.",
                bullets_from(repair, ["Pointing, translation, or one exact clarification is usually better than repeating the whole order."]),
            ),
        ]
    else:
        raise RuntimeError(f"Unhandled phrase class {phrase_class}")

    relation_bucket_names = [
        name
        for name, entries in [
            ("likelyReply", likely),
            ("repairIfMissed", repair),
            ("askNext", ask),
            ("escalateTo", esc),
            ("crossClassExit", cross),
        ]
        if entries
    ]
    return {
        "hubId": hub_id,
        "scenarioId": cluster["scenarioId"],
        "familyId": cluster["familyId"],
        "familyTitle": cluster["familyTitle"],
        "phraseClass": phrase_class,
        "moduleMixId": mix_id,
        "relationClusterId": cluster["clusterId"],
        "anchorPhraseId": cluster["anchorPhraseId"],
        "defaultPhraseId": cluster.get("shortestFormPhraseId") or cluster["anchorPhraseId"],
        "quickSayPhraseId": cluster.get("shortestFormPhraseId") or cluster["anchorPhraseId"],
        "clearerPhraseId": cluster.get("clearerFormPhraseId"),
        "morePolitePhraseId": cluster.get("morePoliteFormPhraseId"),
        "alternatePhraseIds": alt_ids,
        "relationBuckets": relation_bucket_names,
        "modules": modules,
    }


new_hubs = []
seen_hubs = set()
for hub in answer["hubs"]:
    cluster = cluster_by_id[hub["relationClusterId"]]
    if hub["hubId"] in target_regenerated:
        rebuilt = build_hub(cluster)
        new_hubs.append(rebuilt)
        seen_hubs.add(rebuilt["hubId"])
    else:
        new_hubs.append(hub)
        seen_hubs.add(hub["hubId"])
for cluster_id, _ in promotions:
    rebuilt = build_hub(cluster_by_id[cluster_id])
    if rebuilt["hubId"] not in seen_hubs:
        new_hubs.append(rebuilt)
        seen_hubs.add(rebuilt["hubId"])

answer["hubs"] = new_hubs
answer["hubCount"] = len(new_hubs)
phrase_classes = []
for hub in new_hubs:
    if hub["phraseClass"] not in phrase_classes:
        phrase_classes.append(hub["phraseClass"])
answer["phraseClassCount"] = len(phrase_classes)

supporting_rows = sum(
    1
    for row in rows
    if any(token.startswith("answer-page-sample=") and ":support:" in token for token in answer_tokens(row.get("notes", "")))
)
unique_added_rows = len({phrase_id for phrase_id, _ in added_tokens})
answer["sourceOfTruth"]["supportingRowCount"] = supporting_rows
relations["answerPageCoverage"]["hubCount"] = len(new_hubs)
relations["answerPageCoverage"]["relationOnlyClusterCount"] = sum(1 for cluster in relations["clusters"] if not cluster["answerPageReady"])
relations["answerPageCoverage"]["totalRelationClusterCount"] = len(relations["clusters"])
relations["answerPageCoverage"]["phraseClassCount"] = len(phrase_classes)
relations["answerPageCoverage"]["phraseClasses"] = phrase_classes
relations["answerPageCoverage"]["supportingRowCount"] = supporting_rows
relations["purpose"] = (
    "Additive relation-ready handoff for phrase-detail, listing-page, and answer-page work across "
    f"{len(new_hubs)} answer-page-ready Viet hubs plus "
    f"{relations['answerPageCoverage']['relationOnlyClusterCount']} supporting relation-only clusters "
    "that keep linked phrase navigation inside the authored relation sample, without replacing the current scenario -> family -> phrase-row model."
)

summary = {
    "hubCount": answer["hubCount"],
    "phraseClassCount": answer["phraseClassCount"],
    "phraseClasses": phrase_classes,
    "relationOnlyClusterCount": relations["answerPageCoverage"]["relationOnlyClusterCount"],
    "supportingRowCount": supporting_rows,
    "supportingRowGrowth": supporting_rows - baseline_supporting_rows,
    "addedAnswerTokens": len(added_tokens),
    "uniqueRowsWithAddedTokens": unique_added_rows,
    "skippedAnswerTokens": len(skipped_tokens),
    "sampleSkipped": skipped_tokens[:12],
}
print(json.dumps(summary, ensure_ascii=False, indent=2))

if WRITE:
    with ANSWER_PATH.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(answer, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    with RELATION_PATH.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(relations, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    with CSV_PATH.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

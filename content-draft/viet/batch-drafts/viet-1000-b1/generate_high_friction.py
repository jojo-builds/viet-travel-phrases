import csv
import re
import unicodedata
from collections import defaultdict
from pathlib import Path

OUT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\batch-drafts\viet-1000-b1\high-friction.csv")

COLS = [
    "phrase_id","scenario_id","family_id","family_title","family_summary","audio_key","english_text","target_text","canonical_target_text","pronunciation","access_tier","variant_role","context","you_may_hear","search_aliases","warning_note_type","audio_status","emoji","notes","status",
]

def deaccent(text: str) -> str:
    text = text.replace("đ", "d").replace("Đ", "D")
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    text = re.sub(r"[^A-Za-z0-9/']+", " ", text)
    return re.sub(r"\s+", " ", text).strip().lower()

rows = []
counts = defaultdict(int)
variants = defaultdict(int)

ROLE_CYCLE = ["clearer", "more-polite", "also-common"]

def add_row(scenario_id, phrase_id, family_id, family_title, family_summary, english_text, target_text, role, context, emoji, notes):
    rows.append({
        "phrase_id": phrase_id,
        "scenario_id": scenario_id,
        "family_id": family_id,
        "family_title": family_title,
        "family_summary": family_summary,
        "audio_key": phrase_id,
        "english_text": english_text,
        "target_text": target_text,
        "canonical_target_text": target_text,
        "pronunciation": deaccent(target_text),
        "access_tier": "premium",
        "variant_role": role,
        "context": context,
        "you_may_hear": "",
        "search_aliases": "",
        "warning_note_type": "",
        "audio_status": "planned",
        "emoji": emoji,
        "notes": notes,
        "status": "approved",
    })
    counts[scenario_id] += 1
    if role != "say-first":
        variants[scenario_id] += 1

def v(template, obj_vn, role):
    maps = {
        "repeat": {"clearer": f"Bạn có thể nhắc lại {obj_vn} đầy đủ không", "more-polite": f"Bạn có thể nhắc lại {obj_vn} giúp tôi không", "also-common": f"Nhắc lại {obj_vn} được không"},
        "spell": {"clearer": f"Bạn có thể đánh vần {obj_vn} không", "more-polite": f"Bạn có thể đánh vần {obj_vn} giúp tôi không", "also-common": f"Đánh vần {obj_vn} được không"},
        "write": {"clearer": f"Bạn có thể viết {obj_vn} xuống không", "more-polite": f"Bạn có thể viết {obj_vn} giúp tôi không", "also-common": f"Viết {obj_vn} xuống được không"},
        "readback": {"clearer": f"Bạn có thể đọc lại {obj_vn} đầy đủ không", "more-polite": f"Bạn có thể đọc lại {obj_vn} giúp tôi không", "also-common": f"Đọc lại {obj_vn} được không"},
        "show": {"clearer": f"Bạn có thể cho tôi xem {obj_vn} không", "more-polite": f"Bạn có thể cho tôi xem {obj_vn} giúp tôi không", "also-common": f"Cho tôi xem {obj_vn} được không"},
        "explain": {"clearer": f"Bạn có thể giải thích {obj_vn} này rõ hơn không", "more-polite": f"Bạn có thể giải thích {obj_vn} này giúp tôi không", "also-common": f"Giải thích {obj_vn} này được không"},
        "exact": {"clearer": f"Chính xác là {obj_vn} nào", "more-polite": f"Bạn có thể nói chính xác {obj_vn} nào không", "also-common": f"Đó là {obj_vn} nào"},
        "which": {"clearer": f"Ý bạn là {obj_vn} nào", "more-polite": f"Bạn có thể nói rõ {obj_vn} nào không", "also-common": f"{obj_vn} nào vậy"},
        "fill": {"clearer": f"Bạn có thể điền {obj_vn} này giúp tôi không", "more-polite": f"Bạn có thể giúp tôi điền {obj_vn} này không", "also-common": f"Điền {obj_vn} này được không"},
        "translate": {"clearer": f"Bạn có thể dịch {obj_vn} này rõ hơn không", "more-polite": f"Bạn có thể dịch {obj_vn} này giúp tôi không", "also-common": f"Dịch {obj_vn} này được không"},
        "check": {"clearer": f"Bạn có thể kiểm tra {obj_vn} này không", "more-polite": f"Bạn có thể kiểm tra {obj_vn} này giúp tôi không", "also-common": f"Kiểm tra {obj_vn} này được không"},
        "take-to": {"clearer": f"Bạn có thể chở tôi tới {obj_vn} không", "more-polite": f"Làm ơn chở tôi tới {obj_vn} nhé", "also-common": f"Chở tôi tới {obj_vn} được không"},
        "drop-at": {"clearer": f"Bạn có thể thả tôi ở {obj_vn} không", "more-polite": f"Làm ơn thả tôi ở {obj_vn} nhé", "also-common": f"Thả tôi ở {obj_vn} được không"},
        "pick-up-at": {"clearer": f"Bạn có thể đón tôi ở {obj_vn} không", "more-polite": f"Làm ơn đón tôi ở {obj_vn} nhé", "also-common": f"Đón tôi ở {obj_vn} được không"},
        "stop-at": {"clearer": f"Bạn có thể dừng ở {obj_vn} không", "more-polite": f"Làm ơn dừng ở {obj_vn} nhé", "also-common": f"Dừng ở {obj_vn} được không"},
        "wait-at": {"clearer": f"Bạn có thể chờ ở {obj_vn} không", "more-polite": f"Làm ơn chờ ở {obj_vn} nhé", "also-common": f"Chờ ở {obj_vn} được không"},
        "avoid": {"clearer": f"Bạn có thể tránh {obj_vn} không", "more-polite": f"Làm ơn tránh {obj_vn} nhé", "also-common": f"Tránh {obj_vn} được không"},
        "follow": {"clearer": f"Bạn có thể đi theo {obj_vn} không", "more-polite": f"Làm ơn đi theo {obj_vn} nhé", "also-common": f"Đi theo {obj_vn} được không"},
        "wrong": {"clearer": f"Tôi nghĩ {obj_vn} này chưa đúng", "more-polite": f"Tôi nghĩ {obj_vn} này chưa đúng đâu", "also-common": f"{obj_vn} này sai rồi"},
        "pay": {"clearer": f"Tôi muốn trả {obj_vn}", "more-polite": f"Làm ơn cho tôi trả {obj_vn} nhé", "also-common": f"Tôi trả {obj_vn} được không"},
        "show-transport": {"clearer": f"Bạn có thể cho tôi xem {obj_vn} không", "more-polite": f"Bạn có thể cho tôi xem {obj_vn} giúp tôi không", "also-common": f"Cho tôi xem {obj_vn} được không"},
        "need-med": {"clearer": f"Tôi cần {obj_vn}", "more-polite": f"Làm ơn cho tôi {obj_vn} nhé", "also-common": f"Tôi cần {obj_vn} này"},
        "how-take": {"clearer": f"Tôi nên dùng {obj_vn} thế nào", "more-polite": f"Bạn có thể nói cách dùng {obj_vn} giúp tôi không", "also-common": f"Tôi uống {obj_vn} thế nào"},
        "with-food": {"clearer": f"Tôi có nên dùng {obj_vn} cùng thức ăn không", "more-polite": f"Bạn có thể nói tôi có nên dùng {obj_vn} cùng thức ăn không", "also-common": f"Dùng {obj_vn} cùng thức ăn được không"},
        "side-effects": {"clearer": f"{obj_vn} này có tác dụng phụ gì", "more-polite": f"Bạn có thể nói {obj_vn} này có tác dụng phụ gì không", "also-common": f"{obj_vn} có tác dụng phụ gì"},
        "alcohol": {"clearer": f"Tôi có thể uống rượu bia khi dùng {obj_vn} không", "more-polite": f"Bạn có thể nói tôi có thể uống rượu bia khi dùng {obj_vn} không", "also-common": f"Dùng {obj_vn} có uống rượu bia được không"},
        "get": {"clearer": f"Tôi có thể lấy {obj_vn} không", "more-polite": f"Làm ơn cho tôi lấy {obj_vn} nhé", "also-common": f"Tôi cần {obj_vn}"},
        "where": {"clearer": f"{obj_vn} gần nhất ở đâu", "more-polite": f"Bạn có thể chỉ cho tôi {obj_vn} gần nhất ở đâu không", "also-common": f"{obj_vn} ở đâu"},
        "lost": {"clearer": f"Tôi làm mất {obj_vn}", "more-polite": f"Tôi bị mất {obj_vn}", "also-common": f"Tôi mất {obj_vn}"},
        "took": {"clearer": f"Ai đó lấy mất {obj_vn} của tôi", "more-polite": f"Có ai lấy mất {obj_vn} của tôi không", "also-common": f"{obj_vn} của tôi bị lấy mất"},
        "call": {"clearer": f"Làm ơn gọi {obj_vn} giúp tôi", "more-polite": f"Bạn có thể gọi {obj_vn} giúp tôi không", "also-common": f"Gọi {obj_vn} giúp tôi"},
        "contact": {"clearer": f"Làm ơn liên hệ {obj_vn} giúp tôi", "more-polite": f"Bạn có thể liên hệ {obj_vn} giúp tôi không", "also-common": f"Liên hệ {obj_vn} giúp tôi"},
        "need-report": {"clearer": f"Tôi cần {obj_vn}", "more-polite": f"Làm ơn cho tôi {obj_vn} nhé", "also-common": f"Tôi muốn {obj_vn}"},
        "help-find": {"clearer": f"Làm ơn giúp tôi tìm {obj_vn}", "more-polite": f"Bạn có thể giúp tôi tìm {obj_vn} không", "also-common": f"Giúp tôi tìm {obj_vn}"},
        "speak-with": {"clearer": f"Tôi cần nói chuyện với {obj_vn}", "more-polite": f"Làm ơn cho tôi nói chuyện với {obj_vn}", "also-common": f"Tôi muốn nói chuyện với {obj_vn}"},
        "check-camera": {"clearer": f"Làm ơn kiểm tra {obj_vn}", "more-polite": f"Bạn có thể kiểm tra {obj_vn} giúp tôi không", "also-common": f"Kiểm tra {obj_vn} giúp tôi"},
        "translate-help": {"clearer": f"Tôi cần giúp dịch {obj_vn}", "more-polite": f"Bạn có thể giúp tôi dịch {obj_vn} không", "also-common": f"Giúp tôi dịch {obj_vn}"},
        "turn-on": {"clearer": f"Bạn có thể bật {obj_vn} không", "more-polite": f"Làm ơn bật {obj_vn} giúp tôi", "also-common": f"Bật {obj_vn} giúp tôi"},
        "need-phone": {"clearer": f"Tôi cần {obj_vn}", "more-polite": f"Làm ơn cho tôi {obj_vn}", "also-common": f"Tôi muốn {obj_vn}"},
        "not-working": {"clearer": f"{obj_vn} không hoạt động", "more-polite": f"{obj_vn} của tôi không hoạt động", "also-common": f"{obj_vn} bị lỗi rồi"},
        "password": {"clearer": f"Mật khẩu {obj_vn} không đúng", "more-polite": f"Mật khẩu {obj_vn} không hoạt động", "also-common": f"Mật khẩu {obj_vn} sai rồi"},
        "page": {"clearer": f"Trang {obj_vn} không tải được", "more-polite": f"Trang {obj_vn} không mở được", "also-common": f"Trang {obj_vn} bị kẹt rồi"},
        "disconnect": {"clearer": f"{obj_vn} cứ bị ngắt", "more-polite": f"{obj_vn} của tôi cứ bị ngắt", "also-common": f"{obj_vn} hay bị ngắt"},
        "no": {"clearer": f"Tôi không có {obj_vn}", "more-polite": f"Tôi không có {obj_vn} đâu", "also-common": f"Không có {obj_vn}"},
        "share-send": {"clearer": f"Bạn có thể {obj_vn} cho tôi không", "more-polite": f"Bạn có thể {obj_vn} giúp tôi không", "also-common": f"Bạn {obj_vn} cho tôi được không"},
        "broken": {"clearer": f"{obj_vn} của tôi bị hỏng", "more-polite": f"{obj_vn} của tôi không dùng được", "also-common": f"{obj_vn} bị hỏng rồi"},
        "dead": {"clearer": f"{obj_vn} của tôi hết pin", "more-polite": f"{obj_vn} của tôi sắp hết pin", "also-common": f"{obj_vn} hết pin rồi"},
    }
    return maps[template][role]

def emit_scenario(scenario_id, specs, primary_limit, variant_limit):
    for idx, (template, slug, title, summary, emoji, english, target, obj_vn, context) in enumerate(specs[:primary_limit]):
        family_id = f"b1-{slug}"
        add_row(scenario_id, family_id, family_id, title, summary, english, target, "say-first", context, emoji, "batch=viet-1000-b1 | kind=anchor")
        if idx < variant_limit:
            role = ROLE_CYCLE[idx % 3]
            add_row(scenario_id, f"{family_id}-{role}", family_id, title, summary, english, v(template, obj_vn, role), role, context, emoji, "batch=viet-1000-b1 | kind=variant")

UNDERSTANDING = [
    ("repeat", "repeat-address", "Repeat the address", "Use this when the address needs to be heard again.", "🔁", "Please repeat the address", "Làm ơn nhắc lại địa chỉ", "địa chỉ", "Use this when the address needs to be heard again."),
    ("repeat", "repeat-street", "Repeat the street name", "Use this when the street name needs to be heard again.", "🔁", "Please repeat the street name", "Làm ơn nhắc lại tên đường", "tên đường", "Use this when the street name needs to be heard again."),
    ("spell", "spell-name", "Spell the name", "Use this when the name has to be spelled out.", "🔤", "Please spell the name", "Làm ơn đánh vần tên", "tên", "Use this when the name has to be spelled out."),
    ("spell", "spell-hotel", "Spell the hotel name", "Use this when the hotel name has to be spelled out.", "🔤", "Please spell the hotel name", "Làm ơn đánh vần tên khách sạn", "tên khách sạn", "Use this when the hotel name has to be spelled out."),
    ("write", "write-time", "Write the time", "Use this when the time should be written down.", "📝", "Please write the time down", "Làm ơn viết thời gian xuống", "thời gian", "Use this when the time should be written down."),
    ("write", "write-date", "Write the date", "Use this when the date should be written down.", "📝", "Please write the date down", "Làm ơn viết ngày xuống", "ngày", "Use this when the date should be written down."),
    ("readback", "read-price", "Read the price", "Use this when the price was spoken too quickly.", "🔊", "Please read the price back", "Làm ơn đọc lại giá", "giá", "Use this when the price was spoken too quickly."),
    ("readback", "read-total", "Read the total", "Use this when the total needs one more check.", "🔊", "Please read the total back", "Làm ơn đọc lại tổng tiền", "tổng tiền", "Use this when the total needs one more check."),
    ("show", "show-message", "Show the message", "Use this when a message or screen is easier to see than hear.", "👀", "Please show me the message", "Làm ơn cho tôi xem tin nhắn", "tin nhắn", "Use this when a message or screen is easier to see than hear."),
    ("show", "show-screen", "Show the screen", "Use this when the screen itself needs to be shown.", "👀", "Please show me the screen", "Làm ơn cho tôi xem màn hình", "màn hình", "Use this when the screen itself needs to be shown."),
    ("explain", "explain-sign", "Explain the sign", "Use this when a sign needs a plain explanation.", "💬", "What does the sign mean", "Biển báo này nghĩa là gì", "biển báo", "Use this when a sign needs a plain explanation."),
    ("explain", "explain-word", "Explain the word", "Use this when a word needs a plain explanation.", "💬", "What does this word mean", "Từ này nghĩa là gì", "từ này", "Use this when a word needs a plain explanation."),
    ("exact", "exact-room", "Exact room number", "Use this when the room number must be exact.", "🔢", "What is the exact room number", "Chính xác là số phòng nào", "số phòng", "Use this when the room number must be exact."),
    ("exact", "exact-gate", "Exact gate number", "Use this when the gate number must be exact.", "🔢", "What is the exact gate number", "Chính xác là số cổng nào", "số cổng", "Use this when the gate number must be exact."),
    ("which", "which-exit", "Which exit", "Use this when you need the right exit.", "👉", "Which exit do you mean", "Ý bạn là lối ra nào", "lối ra", "Use this when you need the right exit."),
]

TRANSPORT = [
    ("take-to", "take-hotel-entrance", "Take me to the hotel entrance", "Use this when the rider should head to the hotel entrance.", "🚕", "Please take me to the hotel entrance", "Làm ơn chở tôi tới lối vào khách sạn", "lối vào khách sạn", "Use this when the rider should head to the hotel entrance."),
    ("take-to", "take-side-entrance", "Take me to the side entrance", "Use this when the rider should head to the side entrance.", "🚕", "Please take me to the side entrance", "Làm ơn chở tôi tới cửa bên", "cửa bên", "Use this when the rider should head to the side entrance."),
    ("take-to", "take-address", "Take me to this address", "Use this when the rider should head to a specific address.", "🚕", "Please take me to this address", "Làm ơn chở tôi tới địa chỉ này", "địa chỉ này", "Use this when the rider should head to a specific address."),
    ("drop-at", "drop-entrance", "Drop me at the entrance", "Use this when you need to be dropped at the entrance.", "🛬", "Please drop me at the entrance", "Làm ơn thả tôi ở lối vào", "lối vào", "Use this when you need to be dropped at the entrance."),
    ("drop-at", "drop-corner", "Drop me at the corner", "Use this when you need to be dropped at the corner.", "🛬", "Please drop me at the corner", "Làm ơn thả tôi ở góc này", "góc này", "Use this when you need to be dropped at the corner."),
    ("drop-at", "drop-pickup", "Drop me at the pickup point", "Use this when you need a very specific drop-off point.", "🛬", "Please drop me at the pickup point", "Làm ơn thả tôi ở điểm đón", "điểm đón", "Use this when you need a very specific drop-off point."),
    ("pick-up-at", "pickup-entrance", "Pick me up at this entrance", "Use this when the pickup should happen at this entrance.", "📍", "Please pick me up at this entrance", "Đón tôi ở lối vào này", "lối vào này", "Use this when the pickup should happen at this entrance."),
    ("pick-up-at", "pickup-lobby", "Pick me up at the hotel lobby", "Use this when the pickup should happen at the hotel lobby.", "📍", "Please pick me up at the hotel lobby", "Đón tôi ở sảnh khách sạn", "sảnh khách sạn", "Use this when the pickup should happen at the hotel lobby."),
    ("pick-up-at", "pickup-side-road", "Pick me up at the side road", "Use this when the pickup should happen on the side road.", "📍", "Please pick me up at the side road", "Đón tôi ở đường bên", "đường bên", "Use this when the pickup should happen on the side road."),
    ("stop-at", "stop-light", "Stop at the next light", "Use this when the driver should stop at the next light.", "🛑", "Please stop at the next light", "Làm ơn dừng ở đèn đỏ tiếp theo", "đèn đỏ tiếp theo", "Use this when the driver should stop at the next light."),
    ("stop-at", "stop-corner", "Stop at the next corner", "Use this when the driver should stop at the next corner.", "🛑", "Please stop at the next corner", "Làm ơn dừng ở góc tiếp theo", "góc tiếp theo", "Use this when the driver should stop at the next corner."),
    ("stop-at", "stop-second-entrance", "Stop at the second entrance", "Use this when the driver should stop at the second entrance.", "🛑", "Please stop at the second entrance", "Làm ơn dừng ở cửa vào thứ hai", "cửa vào thứ hai", "Use this when the driver should stop at the second entrance."),
    ("wait-at", "wait-here", "Wait here", "Use this when the driver should hold position.", "⏱️", "Please wait here", "Làm ơn chờ ở đây", "đây", "Use this when the driver should hold position."),
    ("wait-at", "wait-pickup", "Wait at the pickup point", "Use this when the driver should wait at the pickup point.", "⏱️", "Please wait at the pickup point", "Làm ơn chờ ở điểm đón", "điểm đón", "Use this when the driver should wait at the pickup point."),
    ("wait-at", "wait-entrance", "Wait at the entrance", "Use this when the driver should wait at the entrance.", "⏱️", "Please wait at the entrance", "Làm ơn chờ ở lối vào", "lối vào", "Use this when the driver should wait at the entrance."),
    ("avoid", "avoid-highway", "Avoid the highway", "Use this when the route should avoid the highway.", "⛔", "Please avoid the highway", "Làm ơn tránh đường cao tốc", "đường cao tốc", "Use this when the route should avoid the highway."),
    ("avoid", "avoid-toll", "Avoid the toll road", "Use this when the route should avoid toll roads.", "⛔", "Please avoid the toll road", "Làm ơn tránh đường thu phí", "đường thu phí", "Use this when the route should avoid toll roads."),
    ("avoid", "avoid-bridge", "Avoid the bridge", "Use this when the route should avoid a bridge.", "⛔", "Please avoid the bridge", "Làm ơn tránh cây cầu", "cây cầu", "Use this when the route should avoid a bridge."),
    ("follow", "follow-route", "Follow the app route", "Use this when the driver should follow the app route.", "🗺️", "Please follow the app route", "Làm ơn đi theo lộ trình trên app", "lộ trình trên app", "Use this when the driver should follow the app route."),
    ("follow", "follow-map", "Follow the map", "Use this when the driver should follow the map.", "🗺️", "Please follow the map", "Làm ơn đi theo bản đồ", "bản đồ", "Use this when the driver should follow the map."),
    ("follow", "follow-short-route", "Follow the short route", "Use this when the driver should take the short route.", "🗺️", "Please follow the short route", "Làm ơn đi theo đường ngắn", "đường ngắn", "Use this when the driver should take the short route."),
    ("wrong", "wrong-car", "This is the wrong car", "Use this when the car is not the right one.", "⚠️", "This is the wrong car", "Đây là xe này sai rồi", "xe này", "Use this when the car is not the right one."),
    ("wrong", "wrong-route", "This is the wrong route", "Use this when the route is not the right one.", "⚠️", "This is the wrong route", "Đây là lộ trình này sai rồi", "lộ trình này", "Use this when the route is not the right one."),
    ("wrong", "wrong-address", "This is the wrong address", "Use this when the address is not the right one.", "⚠️", "This is the wrong address", "Đây là địa chỉ này sai rồi", "địa chỉ này", "Use this when the address is not the right one."),
    ("pay", "pay-card", "Pay by card", "Use this when you want to pay by card.", "💳", "I want to pay by card", "Tôi muốn trả bằng thẻ", "bằng thẻ", "Use this when you want to pay by card."),
    ("pay", "pay-cash", "Pay in cash", "Use this when you want to pay in cash.", "💳", "I want to pay in cash", "Tôi muốn trả bằng tiền mặt", "bằng tiền mặt", "Use this when you want to pay in cash."),
    ("pay", "pay-transfer", "Pay by transfer", "Use this when you want to pay by bank transfer.", "💳", "I want to pay by bank transfer", "Tôi muốn trả bằng chuyển khoản", "chuyển khoản", "Use this when you want to pay by bank transfer."),
    ("show-transport", "show-receipt", "Show the receipt", "Use this when the receipt needs to be shown.", "🧾", "Please show me the receipt", "Làm ơn cho tôi xem hóa đơn", "hóa đơn", "Use this when the receipt needs to be shown."),
    ("show-transport", "show-trunk", "Open the trunk", "Use this when the trunk needs to be opened.", "🧾", "Please open the trunk", "Làm ơn mở cốp xe", "cốp xe", "Use this when the trunk needs to be opened."),
    ("show-transport", "show-route", "Show the route", "Use this when the route needs to be shown.", "🧾", "Please show me the route", "Làm ơn cho tôi xem lộ trình", "lộ trình", "Use this when the route needs to be shown."),
]

HEALTH = [
    ("need-med", "need-pain", "Need pain medicine", "Use this when pain medicine is needed.", "💊", "I need pain medicine", "Tôi cần thuốc giảm đau", "thuốc giảm đau", "Use this when pain medicine is needed."),
    ("need-med", "need-cold", "Need cold medicine", "Use this when cold medicine is needed.", "💊", "I need cold medicine", "Tôi cần thuốc cảm", "thuốc cảm", "Use this when cold medicine is needed."),
    ("need-med", "need-allergy", "Need allergy medicine", "Use this when allergy medicine is needed.", "💊", "I need allergy medicine", "Tôi cần thuốc dị ứng", "thuốc dị ứng", "Use this when allergy medicine is needed."),
    ("how-take", "how-this-medicine", "How do I take this medicine", "Use this when you need the instructions for this medicine.", "🩺", "How do I take this medicine", "Tôi nên dùng thuốc này thế nào", "thuốc này", "Use this when you need the instructions for this medicine."),
    ("how-take", "how-these-pills", "How do I take these pills", "Use this when you need the instructions for these pills.", "🩺", "How do I take these pills", "Tôi nên dùng những viên này thế nào", "những viên này", "Use this when you need the instructions for these pills."),
    ("how-take", "how-this-syrup", "How do I take this syrup", "Use this when you need the instructions for this syrup.", "🩺", "How do I take this syrup", "Tôi nên dùng si rô này thế nào", "si rô này", "Use this when you need the instructions for this syrup."),
    ("with-food", "with-food", "Take with food", "Use this when you need food timing guidance.", "🍽️", "Should I take it with food", "Tôi có nên dùng cùng thức ăn không", "cùng thức ăn", "Use this when you need food timing guidance."),
    ("with-food", "before-bed", "Take before bed", "Use this when you need bedtime timing guidance.", "🍽️", "Should I take it before bed", "Tôi có nên dùng trước khi ngủ không", "trước khi ngủ", "Use this when you need bedtime timing guidance."),
    ("with-food", "after-meals", "Take after meals", "Use this when you need after-meal timing guidance.", "🍽️", "Should I take it after meals", "Tôi có nên dùng sau bữa ăn không", "sau bữa ăn", "Use this when you need after-meal timing guidance."),
    ("side-effects", "side-medicine", "Side effects for this medicine", "Use this when you need the side effects for this medicine.", "⚠️", "What side effects does this medicine have", "Thuốc này có tác dụng phụ gì", "thuốc này", "Use this when you need the side effects for this medicine."),
    ("side-effects", "side-pill", "Side effects for this pill", "Use this when you need the side effects for this pill.", "⚠️", "What side effects does this pill have", "Viên này có tác dụng phụ gì", "viên này", "Use this when you need the side effects for this pill."),
    ("side-effects", "side-syrup", "Side effects for this syrup", "Use this when you need the side effects for this syrup.", "⚠️", "What side effects does this syrup have", "Si rô này có tác dụng phụ gì", "si rô này", "Use this when you need the side effects for this syrup."),
    ("alcohol", "alcohol-medicine", "Can I drink alcohol with this medicine", "Use this when alcohol safety is the question.", "🥂", "Can I drink alcohol with this medicine", "Tôi có thể uống rượu bia khi dùng thuốc này không", "thuốc này", "Use this when alcohol safety is the question."),
    ("alcohol", "alcohol-pills", "Can I drink alcohol with these pills", "Use this when alcohol safety is the question.", "🥂", "Can I drink alcohol with these pills", "Tôi có thể uống rượu bia khi dùng những viên này không", "những viên này", "Use this when alcohol safety is the question."),
    ("alcohol", "alcohol-treatment", "Can I drink alcohol with this treatment", "Use this when alcohol safety is the question.", "🥂", "Can I drink alcohol with this treatment", "Tôi có thể uống rượu bia khi dùng liệu trình này không", "liệu trình này", "Use this when alcohol safety is the question."),
    ("get", "get-receipt", "Get a receipt", "Use this when you need a receipt.", "🧾", "Can I get a receipt", "Tôi có thể lấy hóa đơn không", "hóa đơn", "Use this when you need a receipt."),
    ("get", "get-note", "Get a clinic note", "Use this when you need a clinic note.", "🧾", "Can I get a clinic note", "Tôi có thể lấy giấy xác nhận không", "giấy xác nhận", "Use this when you need a clinic note."),
    ("get", "get-report", "Get a medical report", "Use this when you need a medical report.", "🧾", "Can I get a medical report", "Tôi có thể lấy giấy khám không", "giấy khám", "Use this when you need a medical report."),
    ("where", "where-clinic", "Where is the nearest clinic", "Use this when you need the nearest clinic.", "🏥", "Where is the nearest clinic", "Phòng khám gần nhất ở đâu", "phòng khám gần nhất", "Use this when you need the nearest clinic."),
    ("where", "where-hospital", "Where is the nearest hospital", "Use this when you need the nearest hospital.", "🏥", "Where is the nearest hospital", "Bệnh viện gần nhất ở đâu", "bệnh viện gần nhất", "Use this when you need the nearest hospital."),
]

PROBLEMS = [
    ("lost", "passport", "I lost my passport", "Use this when a passport is missing.", "🪪", "I lost my passport", "Tôi làm mất hộ chiếu", "hộ chiếu", "Use this when a passport is missing."),
    ("lost", "wallet", "I lost my wallet", "Use this when a wallet is missing.", "🪪", "I lost my wallet", "Tôi làm mất ví tiền", "ví tiền", "Use this when a wallet is missing."),
    ("took", "phone", "Someone took my phone", "Use this when a phone may have been stolen.", "📱", "Someone took my phone", "Ai đó lấy mất điện thoại của tôi", "điện thoại của tôi", "Use this when a phone may have been stolen."),
    ("took", "bag", "Someone took my bag", "Use this when a bag may have been stolen.", "📱", "Someone took my bag", "Ai đó lấy mất túi của tôi", "túi của tôi", "Use this when a bag may have been stolen."),
    ("call", "police", "Call the police", "Use this when the police should be called.", "☎️", "Please call the police", "Làm ơn gọi cảnh sát", "cảnh sát", "Use this when the police should be called."),
    ("call", "hotel", "Call the hotel", "Use this when the hotel should be called.", "☎️", "Please call the hotel", "Làm ơn gọi khách sạn", "khách sạn", "Use this when the hotel should be called."),
    ("contact", "embassy", "Contact my embassy", "Use this when the embassy should be contacted.", "🏛️", "Please contact my embassy", "Làm ơn liên hệ đại sứ quán của tôi", "đại sứ quán", "Use this when the embassy should be contacted."),
    ("contact", "airline", "Contact my airline", "Use this when the airline should be contacted.", "🏛️", "Please contact my airline", "Làm ơn liên hệ hãng hàng không của tôi", "hãng hàng không của tôi", "Use this when the airline should be contacted."),
    ("need-report", "report", "I need a report", "Use this when an incident report is needed.", "📄", "I need a report", "Tôi cần báo cáo", "báo cáo", "Use this when an incident report is needed."),
    ("need-report", "copy-report", "I need a copy of the report", "Use this when you need a copy of the report.", "📄", "I need a copy of the report", "Tôi cần bản sao báo cáo", "bản sao báo cáo", "Use this when you need a copy of the report."),
    ("help-find", "find-it", "Help me find it", "Use this when a lost item needs help being found.", "🔎", "Please help me find it", "Làm ơn giúp tôi tìm nó", "nó", "Use this when a lost item needs help being found."),
    ("help-find", "find-place", "Help me find the place", "Use this when a place needs help being found.", "🔎", "Please help me find the place", "Làm ơn giúp tôi tìm chỗ đó", "chỗ đó", "Use this when a place needs help being found."),
]

PHONE = [
    ("turn-on", "turn-hotspot", "Turn on the hotspot", "Use this when a phone setting needs to be turned on.", "📡", "Please turn on the hotspot", "Làm ơn bật điểm phát sóng", "điểm phát sóng", "Use this when a phone setting needs to be turned on."),
    ("turn-on", "turn-airplane", "Turn off airplane mode", "Use this when airplane mode needs to be turned off.", "📡", "Please turn off airplane mode", "Làm ơn tắt chế độ máy bay", "chế độ máy bay", "Use this when airplane mode needs to be turned off."),
    ("need-phone", "need-hotspot", "Need a hotspot", "Use this when a hotspot is needed.", "🔋", "I need a hotspot", "Tôi cần điểm phát sóng", "điểm phát sóng", "Use this when a hotspot is needed."),
    ("need-phone", "need-powerbank", "Need a power bank", "Use this when a power bank is needed.", "🔋", "I need a power bank", "Tôi cần pin sạc dự phòng", "pin sạc dự phòng", "Use this when a power bank is needed."),
    ("not-working", "hotspot-broken", "Hotspot not working", "Use this when the hotspot is failing.", "📵", "The hotspot is not working", "Điểm phát sóng không hoạt động", "điểm phát sóng", "Use this when the hotspot is failing."),
    ("not-working", "network-broken", "Mobile network not working", "Use this when the mobile network is failing.", "📵", "The mobile network is not working", "Mạng di động không hoạt động", "mạng di động", "Use this when the mobile network is failing."),
    ("password", "wifi-password", "Wi-Fi password", "Use this when the Wi-Fi password is wrong.", "🔑", "The Wi-Fi password is not working", "Mật khẩu Wi-Fi không đúng", "mật khẩu Wi-Fi", "Use this when the Wi-Fi password is wrong."),
    ("password", "hotspot-password", "Hotspot password", "Use this when the hotspot password is wrong.", "🔑", "The hotspot password is not working", "Mật khẩu điểm phát sóng không đúng", "mật khẩu điểm phát sóng", "Use this when the hotspot password is wrong."),
    ("page", "app-wont-open", "App will not open", "Use this when an app will not open.", "🌐", "The app will not open", "Ứng dụng không mở được", "ứng dụng", "Use this when an app will not open."),
    ("page", "browser-wont-open", "Browser will not open", "Use this when the browser will not open.", "🌐", "The phone browser will not open", "Trình duyệt không mở được", "trình duyệt", "Use this when the browser will not open."),
    ("disconnect", "wifi-disconnect", "Wi-Fi keeps disconnecting", "Use this when the Wi-Fi keeps dropping.", "📶", "The Wi-Fi keeps disconnecting", "Wi-Fi cứ bị ngắt", "Wi-Fi", "Use this when the Wi-Fi keeps dropping."),
    ("disconnect", "call-disconnect", "Call keeps dropping", "Use this when the call keeps dropping.", "📶", "The call keeps dropping", "Cuộc gọi cứ bị ngắt", "cuộc gọi", "Use this when the call keeps dropping."),
    ("no", "no-signal", "No signal", "Use this when there is no signal.", "📶", "I have no signal", "Tôi không có sóng", "sóng", "Use this when there is no signal."),
    ("no", "no-battery", "No battery left", "Use this when the battery is empty.", "📶", "I have no battery left", "Tôi không còn pin", "pin", "Use this when the battery is empty."),
    ("share-send", "share-location", "Share your location", "Use this when location should be shared.", "📍", "Can you share your location", "Bạn có thể chia sẻ vị trí không", "chia sẻ vị trí", "Use this when location should be shared."),
    ("share-send", "send-address", "Send me the address", "Use this when an address should be sent.", "📍", "Can you send me the address", "Bạn có thể gửi địa chỉ cho tôi không", "gửi địa chỉ cho tôi", "Use this when an address should be sent."),
]

emit_scenario("understanding-repair", UNDERSTANDING, 15, 7)
emit_scenario("transport", TRANSPORT, 21, 9)
emit_scenario("health-pharmacy", HEALTH, 14, 6)
emit_scenario("problems-help", PROBLEMS, 8, 4)
emit_scenario("phone-internet-power", PHONE, 12, 4)

assert len(rows) == 100, len(rows)
assert counts["understanding-repair"] == 22 and variants["understanding-repair"] == 7
assert counts["transport"] == 30 and variants["transport"] == 9
assert counts["health-pharmacy"] == 20 and variants["health-pharmacy"] == 6
assert counts["problems-help"] == 12 and variants["problems-help"] == 4
assert counts["phone-internet-power"] == 16 and variants["phone-internet-power"] == 4

OUT.parent.mkdir(parents=True, exist_ok=True)
with OUT.open("w", encoding="utf-8", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=COLS, quoting=csv.QUOTE_ALL, lineterminator="\n")
    for row in rows:
        writer.writerow(row)

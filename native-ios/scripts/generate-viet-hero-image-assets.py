#!/usr/bin/env python3

import argparse
import csv
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw


REPO_ROOT = Path(__file__).resolve().parents[2]
CITY_LIBRARY_PATH = REPO_ROOT / "content-draft" / "viet" / "city-library" / "v1.json"
ASSET_ROOT = REPO_ROOT / "native-ios" / "Resources" / "Assets.xcassets"
REPORT_DIR = REPO_ROOT / "docs" / "editorial-exports" / "viet-image-assets" / "hero-image-production-001"
REPORT_JSON = REPORT_DIR / "generated_hero_assets.json"
REPORT_CSV = REPORT_DIR / "generated_hero_assets.csv"

WIDTH = 853
HEIGHT = 1844
SCENE_BOTTOM = 520

CITY_HEROES = {
    "hanoi": ("HeroCityHanoi", "city_hanoi"),
    "hcmc": ("HeroCityHcmc", "city_hcmc"),
    "danang": ("HeroCityDanang", "city_danang"),
    "hoian": ("HeroCityHoian", "city_hoian"),
    "hue": ("HeroCityHue", "city_hue"),
}

CATEGORY_HEROES = {
    "HeroCountryVietnam": "country_vietnam",
    "HeroCategoryGreetings": "category_greetings",
    "HeroCategoryEssentials": "category_essentials",
    "HeroCategoryEmergency": "category_emergency",
    "HeroCategoryQuestions": "category_questions",
    "HeroCategoryPoliteRepair": "category_polite_repair",
    "HeroCategoryFirstDay": "category_first_day",
    "HeroCategoryGettingAround": "category_getting_around",
    "HeroCompactPhraseMasthead": "compact_phrase",
}

PRESERVED_HAND_AUTHORED_HEROES = {
    "HeroBaNaHills",
    "HeroDragonBridge",
    "HeroHanMarket",
    "HeroLinhUngPagoda",
    "HeroMarbleMountains",
    "HeroMyKheBeach",
    "HeroNguyenVanLinhStreet",
    "HeroVietnamMasthead",
    "HeroXinChao",
}


PALETTE = {
    "sky_top": (205, 235, 247),
    "sky_bottom": (245, 249, 250),
    "mist": (255, 255, 255, 172),
    "ink": (34, 47, 58),
    "red": (247, 49, 60),
    "red_dark": (198, 47, 44),
    "gold": (219, 142, 9),
    "gold_light": (246, 216, 146),
    "green": (49, 143, 99),
    "green_dark": (28, 120, 82),
    "blue": (45, 135, 190),
    "blue_dark": (31, 97, 143),
    "cream": (246, 233, 205),
    "sand": (229, 217, 194),
    "stone": (175, 186, 182),
    "road": (82, 100, 96),
    "white": (255, 255, 255),
}


def hero_name_for_page_id(page_id):
    parts = page_id.replace("viet-family-", "").replace("browse-", "").replace("_", "-").split("-")
    return "Hero" + "".join(part[:1].upper() + part[1:] for part in parts if part)


def kebab_from_hero(hero_name):
    out = []
    for index, char in enumerate(hero_name):
        if char.isupper() and index:
            out.append("-")
        out.append(char.lower())
    return "".join(out)


def lerp(a, b, t):
    return int(a + (b - a) * t)


def gradient_background(image, top=PALETTE["sky_top"], bottom=PALETTE["sky_bottom"]):
    draw = ImageDraw.Draw(image, "RGBA")
    for y in range(HEIGHT):
        t = y / (HEIGHT - 1)
        color = tuple(lerp(top[i], bottom[i], t) for i in range(3))
        draw.line([(0, y), (WIDTH, y)], fill=color)


def draw_cloud(draw, x, y, scale=1.0, fill=(255, 255, 255, 210)):
    circles = [
        (x, y + 18 * scale, 36 * scale),
        (x + 34 * scale, y, 44 * scale),
        (x + 78 * scale, y + 14 * scale, 34 * scale),
        (x + 112 * scale, y + 24 * scale, 28 * scale),
    ]
    for cx, cy, r in circles:
        draw.ellipse([cx, cy, cx + r, cy + r], fill=fill)


def draw_mist(draw):
    for y, alpha in [(340, 88), (395, 132), (455, 176), (520, 210)]:
        draw.rectangle([0, y, WIDTH, y + 90], fill=(255, 255, 255, alpha))
    draw.rectangle([0, 610, WIDTH, HEIGHT], fill=(247, 249, 250, 245))


def draw_mountain(draw, x, y, w, h, fill, shadow=None):
    points = [(x, y + h), (x + w * 0.48, y), (x + w, y + h)]
    draw.polygon(points, fill=fill)
    if shadow:
        draw.polygon([(x + w * 0.48, y), (x + w, y + h), (x + w * 0.64, y + h)], fill=shadow)


def draw_water(draw, y=300, color=(118, 197, 214, 210)):
    draw.rectangle([0, y, WIDTH, SCENE_BOTTOM], fill=color)
    for offset in range(0, WIDTH, 90):
        draw.arc([offset - 80, y + 34, offset + 90, y + 92], 20, 160, fill=(255, 255, 255, 92), width=3)


def draw_bridge(draw, y, color=PALETTE["red"], supports=True):
    draw.line([120, y, WIDTH - 120, y], fill=color, width=18)
    for i in range(5):
        x0 = 130 + i * 120
        draw.arc([x0, y - 120, x0 + 150, y + 120], 180, 360, fill=color, width=12)
    if supports:
        for x in range(150, WIDTH - 140, 120):
            draw.line([x, y, x, y + 90], fill=(180, 169, 148), width=8)


def draw_building(draw, x, y, w, h, fill, roof=None, columns=3):
    draw.rounded_rectangle([x, y, x + w, y + h], radius=8, fill=fill)
    if roof:
        draw.polygon([(x - 18, y), (x + w / 2, y - 48), (x + w + 18, y)], fill=roof)
    for i in range(columns):
        cx = x + 24 + i * ((w - 48) / max(columns - 1, 1))
        draw.rounded_rectangle([cx - 12, y + 42, cx + 12, y + h - 22], radius=7, fill=(255, 255, 255, 120))


def draw_market(draw, title_hint=""):
    draw.rounded_rectangle([92, 210, WIDTH - 92, 405], radius=24, fill=(238, 213, 169))
    awning_y = 185
    stripe_w = 72
    x = 112
    colors = [PALETTE["red"], PALETTE["gold_light"], PALETTE["red_dark"], (255, 238, 160)]
    index = 0
    while x < WIDTH - 120:
        draw.polygon([(x, awning_y + 70), (x + stripe_w / 2, awning_y), (x + stripe_w, awning_y + 70)], fill=colors[index % len(colors)])
        x += stripe_w
        index += 1
    for x in range(145, WIDTH - 160, 95):
        draw.rounded_rectangle([x, 270, x + 54, 382], radius=12, fill=(79, 83, 72))
    if "night" in title_hint.lower():
        for x in range(140, WIDTH - 120, 92):
            draw.ellipse([x, 135, x + 34, 169], fill=(252, 165, 74))
            draw.line([x + 17, 169, x + 17, 190], fill=(159, 103, 52), width=2)


def draw_food_bowl(draw, title_hint=""):
    draw.ellipse([178, 174, WIDTH - 178, 438], fill=(245, 244, 233))
    draw.ellipse([208, 196, WIDTH - 208, 382], fill=(196, 116, 65))
    draw.ellipse([236, 214, WIDTH - 236, 346], fill=(224, 178, 94))
    for x in range(280, 585, 58):
        draw.arc([x, 210, x + 90, 304], 190, 340, fill=(255, 230, 135), width=7)
    for x, y in [(286, 254), (380, 234), (500, 270), (560, 236)]:
        draw.ellipse([x, y, x + 42, y + 42], fill=PALETTE["green"])
    if "coffee" in title_hint.lower() or "cafe" in title_hint.lower() or "cà phê" in title_hint.lower():
        draw.rounded_rectangle([310, 214, 528, 364], radius=34, fill=(250, 248, 240), outline=(211, 196, 170), width=5)
        draw.arc([500, 250, 620, 330], -70, 75, fill=(211, 196, 170), width=12)
        draw.ellipse([335, 238, 500, 338], fill=(119, 73, 42))


def draw_restaurant(draw):
    draw.rounded_rectangle([150, 178, WIDTH - 150, 425], radius=26, fill=(244, 226, 199))
    draw_building(draw, 220, 198, WIDTH - 440, 200, (235, 205, 166), roof=(157, 91, 62), columns=4)
    draw_food_bowl(draw)
    draw.rectangle([0, 392, WIDTH, 440], fill=(255, 255, 255, 155))


def draw_road(draw):
    draw.polygon([(260, 160), (593, 160), (760, 500), (95, 500)], fill=PALETTE["road"])
    draw.polygon([(420, 160), (433, 160), (455, 500), (398, 500)], fill=(236, 222, 130))
    for x in [110, 730]:
        draw.rounded_rectangle([x, 230, x + 38, 430], radius=18, fill=PALETTE["green_dark"])
        draw.ellipse([x - 24, 180, x + 62, 266], fill=PALETTE["green"])
    draw.rounded_rectangle([585, 212, 700, 310], radius=18, fill=(245, 248, 248))
    draw.rounded_rectangle([604, 230, 682, 294], radius=10, fill=(190, 209, 205))


def draw_terminal(draw, train=False):
    if train:
        draw.rounded_rectangle([160, 202, WIDTH - 160, 382], radius=22, fill=(188, 218, 225), outline=(126, 182, 199), width=5)
        for x in range(215, WIDTH - 220, 74):
            draw.rectangle([x, 248, x + 42, 330], fill=(151, 195, 210))
        draw.line([100, 418, WIDTH - 90, 380], fill=(116, 169, 189), width=7)
    else:
        draw_building(draw, 160, 220, WIDTH - 320, 150, (188, 218, 225), roof=(170, 210, 224), columns=6)
        draw.rectangle([120, 336, WIDTH - 120, 370], fill=(151, 195, 210))
        draw.polygon([(505, 370), (680, 330), (705, 360), (540, 420)], fill=(162, 203, 222))
        draw.line([378, 372, 560, 460], fill=(115, 178, 205), width=6)
        draw.line([525, 458, 725, 420], fill=(115, 178, 205), width=6)


def draw_pagoda(draw, title_hint=""):
    draw_mountain(draw, 90, 245, 280, 190, (96, 157, 119), (67, 128, 93))
    draw_mountain(draw, 480, 230, 300, 205, (102, 164, 132), (72, 137, 106))
    x = WIDTH // 2
    if "linh" in title_hint.lower() or "buddha" in title_hint.lower():
        draw.ellipse([x - 58, 180, x + 58, 296], fill=(247, 247, 238))
        draw.rounded_rectangle([x - 48, 268, x + 48, 420], radius=42, fill=(247, 247, 238))
        draw.line([x - 92, 320, x - 22, 350], fill=(247, 247, 238), width=22)
        draw.line([x + 22, 350, x + 92, 320], fill=(247, 247, 238), width=22)
    else:
        for level in range(4):
            y = 182 + level * 58
            w = 210 - level * 28
            draw.polygon([(x - w / 2 - 24, y + 28), (x, y), (x + w / 2 + 24, y + 28)], fill=PALETTE["red_dark"])
            draw.rounded_rectangle([x - w / 2, y + 28, x + w / 2, y + 70], radius=8, fill=(241, 221, 178))


def draw_cathedral(draw):
    x = WIDTH // 2
    draw_building(draw, x - 175, 222, 350, 210, (245, 215, 170), roof=PALETTE["red_dark"], columns=5)
    draw.rectangle([x - 40, 145, x + 40, 222], fill=(240, 207, 160))
    draw.polygon([(x - 58, 145), (x, 84), (x + 58, 145)], fill=PALETTE["red_dark"])
    draw.line([x, 68, x, 100], fill=PALETTE["red_dark"], width=6)
    draw.line([x - 13, 82, x + 13, 82], fill=PALETTE["red_dark"], width=5)


def draw_museum(draw):
    x = WIDTH // 2
    draw.polygon([(x - 230, 224), (x, 112), (x + 230, 224)], fill=(222, 203, 172))
    draw.rectangle([x - 196, 224, x + 196, 420], fill=(238, 225, 201))
    for i in range(5):
        cx = x - 130 + i * 65
        draw.rectangle([cx - 16, 246, cx + 16, 410], fill=(185, 174, 152))
    draw.rectangle([x - 220, 420, x + 220, 444], fill=(199, 187, 163))


def draw_landscape(draw, title_hint=""):
    if "river" in title_hint.lower() or "lake" in title_hint.lower() or "sông" in title_hint.lower() or "hồ" in title_hint.lower():
        draw_water(draw, 245)
    else:
        draw.rectangle([0, 390, WIDTH, 520], fill=(130, 184, 117))
    draw_mountain(draw, -40, 150, 360, 265, (92, 154, 124), (65, 126, 95))
    draw_mountain(draw, 475, 166, 330, 250, (104, 163, 136), (77, 135, 109))
    for x in range(105, 760, 130):
        draw.rectangle([x, 320, x + 12, 430], fill=(107, 115, 82))
        draw.ellipse([x - 30, 270, x + 46, 346], fill=PALETTE["green"])


def draw_beach(draw):
    draw.rectangle([0, 250, WIDTH, 392], fill=(96, 194, 212))
    draw.rectangle([0, 390, WIDTH, 520], fill=(245, 221, 172))
    draw.line([150, 120, 118, 352], fill=(76, 137, 103), width=8)
    for angle in range(-60, 80, 22):
        x2 = 150 + math.cos(math.radians(angle)) * 100
        y2 = 130 + math.sin(math.radians(angle)) * 55
        draw.line([150, 130, x2, y2], fill=(76, 137, 103), width=8)
    for x, color in [(510, PALETTE["red"]), (645, PALETTE["gold"])]:
        draw.polygon([(x, 360), (x + 120, 360), (x + 60, 300)], fill=color)
        draw.line([x + 60, 360, x + 60, 430], fill=(118, 107, 92), width=5)


def draw_city(draw, city_key):
    if city_key == "city_hcmc":
        draw_water(draw, 335, (120, 202, 220, 200))
        draw_building(draw, 125, 250, 180, 170, (245, 223, 180), roof=PALETTE["red_dark"], columns=3)
        draw.rectangle([190, 162, 240, 250], fill=(237, 211, 168))
        draw.polygon([(176, 162), (215, 96), (254, 162)], fill=PALETTE["red_dark"])
        draw.line([215, 111, 215, 153], fill=(255, 245, 210), width=6)
        draw.polygon([(568, 105), (620, 420), (516, 420)], fill=(142, 191, 208))
        draw.rectangle([410, 235, 462, 420], fill=(142, 191, 208))
        draw.rectangle([650, 220, 715, 420], fill=(168, 206, 218))
    elif city_key == "city_danang":
        draw_water(draw, 330)
        draw_mountain(draw, -20, 130, 250, 280, (113, 174, 146), (84, 145, 115))
        draw_bridge(draw, 330, PALETTE["red"])
    elif city_key == "city_hoian":
        draw_water(draw, 330, (137, 202, 202, 210))
        draw_building(draw, 90, 245, 220, 150, (246, 211, 139), roof=PALETTE["red_dark"], columns=2)
        draw_building(draw, 545, 245, 220, 150, (247, 218, 153), roof=(137, 90, 55), columns=2)
        draw.arc([290, 270, 565, 440], 180, 360, fill=(112, 91, 66), width=18)
        for x, c in [(220, PALETTE["red"]), (320, PALETTE["gold"]), (520, PALETTE["red"]), (635, PALETTE["gold"])]:
            draw.ellipse([x, 165, x + 36, 206], fill=c)
    elif city_key == "city_hue":
        draw_water(draw, 350, (123, 194, 196, 180))
        draw_building(draw, 226, 210, 400, 180, (224, 188, 130), roof=PALETTE["red_dark"], columns=4)
        draw.rectangle([382, 140, 470, 210], fill=(224, 188, 130))
        draw.polygon([(360, 140), (426, 84), (492, 140)], fill=PALETTE["red_dark"])
    elif city_key == "city_hanoi":
        draw_water(draw, 350, (156, 207, 204, 190))
        draw_building(draw, 235, 214, 382, 180, (238, 214, 174), roof=PALETTE["red_dark"], columns=4)
        draw_mountain(draw, 15, 190, 185, 230, (102, 158, 124), (74, 132, 99))


def draw_category(draw, kind):
    if kind == "country_vietnam":
        draw_water(draw, 350)
        draw_mountain(draw, 40, 155, 300, 260, (108, 168, 136), (80, 139, 108))
        draw_mountain(draw, 465, 166, 280, 240, (121, 178, 148), (88, 145, 116))
        draw_bridge(draw, 345, PALETTE["gold"], supports=False)
    elif kind == "category_greetings":
        for x, y, c in [(152, 175, PALETTE["red"]), (482, 145, PALETTE["green"])]:
            draw.rounded_rectangle([x, y, x + 225, y + 130], radius=50, fill=(*c, 42), outline=(*c, 130), width=4)
            draw.polygon([(x + 45, y + 126), (x + 88, y + 126), (x + 48, y + 170)], fill=(*c, 42), outline=(*c, 110))
        for x, c in [(230, PALETTE["red"]), (560, PALETTE["green"])]:
            draw.arc([x - 36, 310, x + 36, 382], 200, 340, fill=c, width=13)
            draw.line([x - 25, 342, x - 70, 292], fill=c, width=12)
            draw.line([x + 25, 342, x + 70, 292], fill=c, width=12)
    elif kind == "category_emergency":
        draw.rounded_rectangle([270, 170, 583, 390], radius=36, fill=(255, 238, 238), outline=PALETTE["red"], width=8)
        draw.rectangle([402, 215, 451, 346], fill=PALETTE["red"])
        draw.rectangle([361, 256, 492, 305], fill=PALETTE["red"])
        draw.rounded_rectangle([132, 252, 242, 382], radius=28, fill=(246, 216, 146))
        draw.rounded_rectangle([618, 252, 728, 382], radius=28, fill=(206, 231, 220))
    elif kind == "category_questions":
        for x, y, c in [(136, 185, PALETTE["blue"]), (438, 145, PALETTE["gold"])]:
            draw.rounded_rectangle([x, y, x + 280, y + 145], radius=55, fill=(*c, 36), outline=(*c, 135), width=5)
            draw.arc([x + 92, y + 34, x + 160, y + 100], 210, 520, fill=c, width=12)
            draw.ellipse([x + 124, y + 112, x + 139, y + 127], fill=c)
    elif kind == "category_polite_repair":
        draw.rounded_rectangle([178, 154, 675, 394], radius=38, fill=(247, 245, 235), outline=(211, 201, 181), width=5)
        for y in [210, 268, 326]:
            draw.line([230, y, 625, y], fill=(188, 198, 194), width=5)
        draw.line([560, 150, 695, 285], fill=PALETTE["red"], width=18)
        draw.polygon([(692, 282), (720, 342), (660, 314)], fill=PALETTE["gold_light"])
    elif kind == "category_first_day":
        draw_terminal(draw, train=False)
        draw.rounded_rectangle([585, 220, 700, 380], radius=24, fill=(246, 238, 218), outline=PALETTE["gold"], width=5)
        draw.line([642, 260, 642, 365], fill=PALETTE["gold"], width=7)
    elif kind == "category_getting_around":
        draw_road(draw)
        draw_bridge(draw, 260, PALETTE["blue"], supports=False)
    else:
        draw.rounded_rectangle([220, 175, 632, 390], radius=44, fill=(255, 255, 255, 120), outline=(210, 220, 218), width=4)


def draw_scene(draw, profile, title, page_id):
    text = f"{title} {page_id}".lower()
    if page_id.startswith("browse-city-"):
        draw_city(draw, page_id.replace("browse-", "").replace("-", "_"))
    elif profile == "cityHub":
        draw_city(draw, page_id.replace("browse-", ""))
    elif profile == "dish":
        draw_food_bowl(draw, text)
    elif profile == "restaurant":
        draw_restaurant(draw)
    elif profile == "streetDriver" or "street" in text or "đường" in text:
        draw_road(draw)
    elif "airport" in text or "sân bay" in text:
        draw_terminal(draw, train=False)
    elif "railway" in text or "station" in text or "ga " in text:
        draw_terminal(draw, train=True)
    elif "beach" in text or "biển" in text:
        draw_beach(draw)
    elif "market" in text or "chợ" in text:
        draw_market(draw, text)
    elif "restaurant" in text or "nhà hàng" in text or profile == "restaurant":
        draw_restaurant(draw)
    elif "bún" in text or "phở" in text or "cơm" in text or "cao lầu" in text or profile == "dish":
        draw_food_bowl(draw, text)
    elif "pagoda" in text or "chùa" in text or "temple" in text:
        draw_pagoda(draw, text)
    elif "cathedral" in text or "church" in text or "nhà thờ" in text:
        draw_cathedral(draw)
    elif "museum" in text or "bảo tàng" in text:
        draw_museum(draw)
    elif "bridge" in text or "cầu" in text:
        if "golden" in text or "vàng" in text:
            draw.line([130, 268, WIDTH - 130, 210], fill=PALETTE["gold"], width=18)
            draw.arc([120, 190, 270, 420], 210, 330, fill=(206, 190, 160), width=22)
            draw.arc([560, 150, 720, 390], 210, 330, fill=(206, 190, 160), width=22)
        else:
            draw_water(draw, 315)
            draw_bridge(draw, 330, PALETTE["red"])
    else:
        draw_landscape(draw, text)


def render_hero(hero_name, profile, title, page_id):
    image = Image.new("RGBA", (WIDTH, HEIGHT), PALETTE["sky_bottom"])
    gradient_background(image)
    draw = ImageDraw.Draw(image, "RGBA")
    draw_cloud(draw, 78, 80, 0.9)
    draw_cloud(draw, 585, 58, 0.78)
    if page_id.startswith("category:"):
        draw_category(draw, profile)
    else:
        draw_scene(draw, profile, title, page_id)
    draw_mist(draw)
    return image.convert("RGB")


def write_imageset(hero_name, image):
    image_set = ASSET_ROOT / f"{hero_name}.imageset"
    image_set.mkdir(parents=True, exist_ok=True)
    filename = f"{kebab_from_hero(hero_name)}.png"
    image.save(image_set / filename, optimize=True)
    contents = {
        "images": [
            {
                "filename": filename,
                "idiom": "universal",
                "scale": "1x",
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1,
        },
    }
    (image_set / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n", encoding="utf-8")
    return image_set / filename


def page_profile(page):
    if page.get("placeKind") == "restaurant":
        return "restaurant"
    if page.get("contentRole") == "dish" or page.get("placeKind") == "dish":
        return "dish"
    if page.get("placeKind") == "street":
        return "streetDriver"
    return "landmark"


def generate_assets(write_source=True):
    library = json.loads(CITY_LIBRARY_PATH.read_text(encoding="utf-8"))
    generated = []

    for page in library["pages"]:
        if page.get("status") != "approved" or page.get("kind") != "place":
            continue
        if page.get("editorialImport", {}).get("heroImageName"):
            continue
        existing_hero_name = page.get("heroImageName")
        if existing_hero_name in PRESERVED_HAND_AUTHORED_HEROES:
            continue
        hero_name = existing_hero_name or hero_name_for_page_id(f"viet-family-{page['id']}")
        if not existing_hero_name:
            page["heroImageName"] = hero_name
        title = f"{page.get('targetText', '')} / {page.get('englishText', '')}".strip(" /")
        profile = page_profile(page)
        path = write_imageset(hero_name, render_hero(hero_name, profile, title, f"viet-family-{page['id']}"))
        generated.append({
            "heroImageName": hero_name,
            "pageID": f"viet-family-{page['id']}",
            "title": title,
            "profile": profile,
            "assetPath": str(path.relative_to(REPO_ROOT)),
            "sourceOwnership": "app-owned generated illustration",
        })

    for city_id, (hero_name, scene_key) in CITY_HEROES.items():
        city = next((city for city in library["cities"] if city["id"] == city_id), None)
        title = city["title"] if city else city_id
        path = write_imageset(hero_name, render_hero(hero_name, "cityHub", title, f"browse-city-{city_id}"))
        generated.append({
            "heroImageName": hero_name,
            "pageID": f"browse-city-{city_id}",
            "title": title,
            "profile": "cityHub",
            "assetPath": str(path.relative_to(REPO_ROOT)),
            "sourceOwnership": "app-owned generated illustration",
        })

    for hero_name, scene_key in CATEGORY_HEROES.items():
        path = write_imageset(hero_name, render_hero(hero_name, scene_key, hero_name, f"category:{scene_key}"))
        generated.append({
            "heroImageName": hero_name,
            "pageID": f"category:{scene_key}",
            "title": hero_name,
            "profile": "categoryHub",
            "assetPath": str(path.relative_to(REPO_ROOT)),
            "sourceOwnership": "app-owned generated illustration",
        })

    if write_source:
        CITY_LIBRARY_PATH.write_text(json.dumps(library, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    REPORT_JSON.write_text(json.dumps({
        "schemaVersion": 1,
        "targetPixelSize": f"{WIDTH} x {HEIGHT}",
        "generatedCount": len(generated),
        "sourceLibraryUpdated": write_source,
        "items": generated,
    }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    with REPORT_CSV.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=[
            "heroImageName",
            "pageID",
            "title",
            "profile",
            "assetPath",
            "sourceOwnership",
        ], lineterminator="\n")
        writer.writeheader()
        writer.writerows(generated)
    return generated


def main():
    parser = argparse.ArgumentParser(description="Generate owned SpeakLocal Viet hero masthead assets.")
    parser.add_argument("--no-source-update", action="store_true", help="Generate assets/report without updating city-library heroImageName fields.")
    args = parser.parse_args()
    generated = generate_assets(write_source=not args.no_source_update)
    print(f"generated {len(generated)} hero assets")
    print(REPORT_JSON.relative_to(REPO_ROOT))


if __name__ == "__main__":
    main()

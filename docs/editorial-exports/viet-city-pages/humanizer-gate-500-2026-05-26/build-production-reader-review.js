#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..", "..", "..");
const sourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const outputDir = path.join(__dirname, "reader-review");
const cities = ["danang", "hanoi", "hcmc", "hoian", "hue"];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function esc(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function cityLabel(cityID) {
  return {
    danang: "Da Nang",
    hanoi: "Hanoi",
    hcmc: "Ho Chi Minh City",
    hoian: "Hoi An",
    hue: "Hue",
  }[cityID] ?? cityID;
}

function pageTitle(pageID) {
  return pageID
    .replace(/^city-[^-]+-place-/, "")
    .split("-")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

function renderEntry(cityID, entry, index) {
  const sections = (entry.sections ?? [])
    .map((section) => {
      if (section.id === "quick-say" && Array.isArray(section.phraseIDs)) {
        return `<section class="phrases">
          <h3>${esc(section.title)}</h3>
          <div class="phraseids">${section.phraseIDs.map(esc).join(" · ")}</div>
        </section>`;
      }
      return `<section>
        <h3>${esc(section.title)}</h3>
        ${section.body ? `<p>${esc(section.body)}</p>` : ""}
      </section>`;
    })
    .join("\n");

  return `<article class="phone-card" id="${esc(entry.pageID)}">
    <div class="meta">${esc(cityLabel(cityID))} · ${String(index + 1).padStart(3, "0")} · ${esc(entry.pageID)}</div>
    <h2>${esc(pageTitle(entry.pageID))}</h2>
    <p class="summary">${esc(entry.summary)}</p>
    <section>
      <h3>Briefing</h3>
      <p>${esc(entry.context)}</p>
    </section>
    <section>
      <h3>Tip</h3>
      <p>${esc(entry.tip)}</p>
    </section>
    <section>
      <h3>Why It Belongs</h3>
      <p>${esc(entry.rationale)}</p>
    </section>
    ${sections}
  </article>`;
}

function renderHTML(entries) {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>SpeakLocal City Pages - 500 Listing Reader Review</title>
<style>
  :root { color-scheme: light; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
  body { margin: 0; background: #f4f2ec; color: #111; }
  header { position: sticky; top: 0; z-index: 2; padding: 16px 22px; background: rgba(244,242,236,.94); backdrop-filter: blur(12px); border-bottom: 1px solid rgba(0,0,0,.08); }
  h1 { margin: 0; font-size: 20px; }
  .note { margin-top: 6px; color: #666; font-size: 13px; }
  main { display: grid; grid-template-columns: repeat(auto-fit, minmax(360px, 1fr)); gap: 18px; padding: 18px; align-items: start; }
  .phone-card { background: #fff; border: 1px solid rgba(0,0,0,.08); border-radius: 22px; padding: 22px; box-shadow: 0 18px 50px rgba(0,0,0,.08); max-width: 430px; min-height: 760px; }
  .meta { color: #888; font-size: 12px; font-weight: 650; letter-spacing: .02em; }
  h2 { font-family: Georgia, "Times New Roman", serif; font-size: 42px; line-height: .98; margin: 18px 0 14px; letter-spacing: 0; }
  .summary { color: #777; font-size: 22px; line-height: 1.28; font-weight: 560; }
  section { margin-top: 24px; }
  h3 { font-size: 21px; line-height: 1.15; margin: 0 0 10px; }
  p { margin: 0; color: #777; font-size: 21px; line-height: 1.36; }
  .phrases { border-radius: 20px; background: #f8f8f7; padding: 16px; border: 1px solid rgba(0,0,0,.06); }
  .phraseids { color: #a33; font-size: 14px; font-weight: 650; line-height: 1.5; }
  @media (max-width: 500px) {
    main { display: block; padding: 12px; }
    .phone-card { max-width: none; min-height: 0; margin-bottom: 14px; border-radius: 18px; }
    h2 { font-size: 34px; }
    p, .summary { font-size: 19px; }
  }
</style>
</head>
<body>
<header>
  <h1>SpeakLocal City Pages - 500 Listing Reader Review</h1>
  <div class="note">Static reader surface for full-copy review. It does not replace native screenshots for chrome/overlap checks.</div>
</header>
<main>
${entries.join("\n")}
</main>
</body>
</html>`;
}

function main() {
  fs.mkdirSync(outputDir, { recursive: true });
  const rendered = [];
  let count = 0;
  for (const cityID of cities) {
    const data = readJSON(path.join(sourceDir, `${cityID}.json`));
    (data.entries ?? []).forEach((entry, index) => {
      count += 1;
      rendered.push(renderEntry(cityID, entry, index));
    });
  }
  const html = renderHTML(rendered);
  const htmlPath = path.join(outputDir, "speaklocal-city-pages-500-reader-review.html");
  fs.writeFileSync(htmlPath, html);
  console.log(`Wrote ${htmlPath}`);
  console.log(`entries=${count}`);
}

main();

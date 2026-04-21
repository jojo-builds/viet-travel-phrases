(() => {
  const HOST_SELECTOR = "[data-phrase-module-id]";
  const WRAPPER_SELECTOR = "[data-phrase-module-manifest]";
  const DEFAULT_MANIFEST_PATH = "/data/phrase-previews/manifest.json";
  const AUDIO_MODE_ATTRIBUTE = "data-phrase-audio-mode";
  const AUDIO_MODE_PLAYBACK = "playback";
  const PLAYBACK_SPEED_STORAGE_KEY = "speaklocal-phrase-playback-speed";
  const PLAYBACK_SPEED_OPTIONS = {
    "0.5x": {
      label: "0.5x",
      rate: 0.5,
    },
    "0.75x": {
      label: "0.75x",
      rate: 0.75,
    },
    "1.0x": {
      label: "1.0x",
      rate: 1,
    },
  };
  let activePlaybackSpeed = readStoredPlaybackSpeed();

  document.addEventListener("DOMContentLoaded", () => {
    void hydratePhraseModules();
  });

  async function hydratePhraseModules() {
    const hosts = Array.from(document.querySelectorAll(HOST_SELECTOR));
    if (!hosts.length) {
      return;
    }

    const groups = new Map();
    for (const host of hosts) {
      const manifestPath =
        host.closest(WRAPPER_SELECTOR)?.getAttribute("data-phrase-module-manifest") || DEFAULT_MANIFEST_PATH;
      const existing = groups.get(manifestPath) || [];
      existing.push(host);
      groups.set(manifestPath, existing);
    }

    await Promise.all(
      Array.from(groups.entries()).map(async ([manifestPath, groupedHosts]) => {
        let manifest;
        try {
          manifest = await fetchJson(manifestPath);
        } catch (error) {
          for (const host of groupedHosts) {
            renderError(host, "Phrase modules could not load from the website export.");
          }
          console.error(error);
          return;
        }

        const modulesById = new Map((manifest.modules || []).map((module) => [module.moduleId, module]));

        await Promise.all(
          groupedHosts.map(async (host) => {
            const moduleId = host.getAttribute("data-phrase-module-id");
            if (!moduleId) {
              renderError(host, "Phrase module ID is missing from the page markup.");
              return;
            }

            const manifestEntry = modulesById.get(moduleId);
            if (!manifestEntry?.path) {
              renderError(host, "This phrase module is not present in the website export manifest.");
              return;
            }

            try {
              const modulePayload = await fetchJson(manifestEntry.path);
              renderModule(host, modulePayload);
            } catch (error) {
              renderError(host, "This phrase module could not be read from the website export.");
              console.error(error);
            }
          }),
        );
      }),
    );
  }

  async function fetchJson(path) {
    const response = await fetch(path, { credentials: "same-origin" });
    if (!response.ok) {
      throw new Error(`Failed to fetch ${path}: ${response.status}`);
    }

    return response.json();
  }

  function renderModule(host, modulePayload) {
    const renderOptions = resolveRenderOptions(host);
    const phrases = Array.isArray(modulePayload.phrases) ? modulePayload.phrases : [];
    const coverage = normalizeCoverage(modulePayload.audioCoverage, phrases.length);
    const audioReadiness = describeAudioCoverage(coverage, renderOptions);
    const phraseCount = phrases.length;
    const familyCount = Number.isFinite(modulePayload.familyCount) ? modulePayload.familyCount : phraseCount;
    const hasPlayableAudio = renderOptions.playbackEnabled && phrases.some((phrase) => Boolean(phrase.audioUrl));
    const moduleMeta = [
      renderMetaPill("Scope", "Starter preview only"),
      renderMetaPill("Source", modulePayload.trust?.sourceLabel),
      renderMetaPill("Site audio", formatSiteAudioCoverage(coverage, renderOptions)),
      renderMetaPill("Exported", formatDateLabel(modulePayload.exportedAt)),
      renderMetaPill("Trip moment", modulePayload.travelerStage),
      renderMetaPill("Difficulty", modulePayload.difficulty),
      renderMetaPill("Tone", modulePayload.formality),
      renderMetaPill(
        "Transcript",
        modulePayload.transcriptChecked === true ? "Checked" : modulePayload.transcriptChecked === false ? "Unverified" : null,
      ),
    ]
      .filter(Boolean)
      .join("");

    host.innerHTML = `
      <article class="phrase-module phrase-module--${escapeAttribute(audioReadiness.tone)}">
        <div class="phrase-module-frame">
          <div class="phrase-module-kicker-row">
            <div class="phrase-module-kickers">
              <span class="label-pill">Phrase module</span>
              <span class="phrase-status-pill phrase-status-pill--${escapeAttribute(audioReadiness.tone)}">${escapeHtml(audioReadiness.badge)}</span>
            </div>
            <span class="phrase-module-status-copy">${escapeHtml(modulePayload.editorialStatus || "Preview ready")}</span>
          </div>
          <div class="phrase-module-head">
            <div class="phrase-module-copy">
              <p class="phrase-module-overline">${escapeHtml(modulePayload.scenarioName || "Phrase module")}</p>
              <h3>${escapeHtml(modulePayload.headline || "Phrase module")}</h3>
              <p>${escapeHtml(modulePayload.summary || "")}</p>
            </div>
            <div class="phrase-module-stats" aria-label="Phrase module summary">
              ${renderStatBlock(String(phraseCount), `starter phrase${phraseCount === 1 ? "" : "s"}`)}
              ${renderStatBlock(String(familyCount), `travel moment${familyCount === 1 ? "" : "s"}`)}
              ${renderStatBlock(
                `${coverage.readyPhraseCount}/${coverage.totalPhraseCount}`,
                coverage.readyPhraseCount === coverage.totalPhraseCount ? "clips ready on site" : "clips ready on site",
              )}
            </div>
          </div>
          ${moduleMeta ? `<div class="phrase-module-chip-row">${moduleMeta}</div>` : ""}
          <div class="phrase-honesty-banner phrase-honesty-banner--${escapeAttribute(audioReadiness.tone)}">
            <strong>${escapeHtml(audioReadiness.title)}</strong>
            <p>${escapeHtml(audioReadiness.body)}</p>
          </div>
          ${hasPlayableAudio ? renderPlaybackSpeedControls() : ""}
          <div class="phrase-preview-grid phrase-module-grid">
            ${phrases.map((phrase) => renderPhraseCard(phrase, renderOptions)).join("")}
          </div>
          <div class="phrase-module-footer">
            <p>Starter preview only. Open the app when you want deeper follow-up phrases, searchable backup, saved phrases, and offline access for the same trip moments.</p>
            ${renderModuleTrustLinks(modulePayload)}
          </div>
        </div>
      </article>
    `;

    if (renderOptions.playbackEnabled) {
      bindPlaybackSpeedControls(host);
      applyPlaybackRateToHost(host, activePlaybackSpeed);
    }
  }

  function renderPhraseCard(phrase, renderOptions) {
    const audioTone = phrase.audioUrl ? "ready" : "planned";
    const statusLabel = phrase.audioUrl
      ? renderOptions.playbackEnabled
        ? "Site audio ready here"
        : "Site audio ready on Viet phrase pages"
      : "Text only on site";
    const pronunciationBlock = phrase.pronunciation
      ? `
          <p class="phrase-pronunciation">
            <span>How it sounds</span>
            <strong>${escapeHtml(phrase.pronunciation)}</strong>
          </p>
        `
      : "";
    const familySummary = phrase.familySummary
      ? `<p class="phrase-family-summary">${escapeHtml(phrase.familySummary)}</p>`
      : "";
    const contextBlock = phrase.context
      ? `<p class="phrase-context"><strong>Use this when:</strong> ${escapeHtml(phrase.context)}</p>`
      : "";
    const hearBlock = phrase.youMayHear
      ? `<p class="phrase-hear"><strong>You may hear:</strong> ${escapeHtml(phrase.youMayHear)}</p>`
      : "";
    const warningBlock = phrase.warningNoteType
      ? `<p class="phrase-warning"><strong>Note:</strong> ${escapeHtml(formatWarningNoteType(phrase.warningNoteType))}</p>`
      : "";

    return `
      <article class="phrase-card">
        <div class="phrase-card-top">
          <span class="phrase-label">${escapeHtml(phrase.familyTitle || phrase.scenarioName || "Phrase")}</span>
          <span class="phrase-card-status phrase-card-status--${audioTone}">
            ${escapeHtml(statusLabel)}
          </span>
        </div>
        <p class="phrase-role">${escapeHtml(phrase.variantLabel || "Say this first")}</p>
        <h4 class="phrase-target">${escapeHtml(phrase.targetText || "")}</h4>
        <p class="phrase-source-kicker">In English</p>
        <p class="phrase-source">${escapeHtml(phrase.englishText || phrase.sourceText || "")}</p>
        ${pronunciationBlock}
        ${familySummary}
        ${contextBlock}
        ${hearBlock}
        ${warningBlock}
        ${renderAudioBlock(phrase, renderOptions)}
      </article>
    `;
  }

  function renderAudioBlock(phrase, renderOptions) {
    if (phrase.audioUrl && renderOptions.playbackEnabled) {
      const audioFacts = [
        renderMetaPill("Clip length", phrase.audioDurationMs != null ? formatDuration(phrase.audioDurationMs) : null),
        renderMetaPill(
          "Transcript",
          phrase.transcriptChecked === true ? "Checked" : phrase.transcriptChecked === false ? "Unverified" : null,
        ),
      ]
        .filter(Boolean)
        .join("");

      return `
        <div class="phrase-card-audio">
          <audio controls preload="none" src="${escapeAttribute(phrase.audioUrl)}">
            Your browser does not support audio playback.
          </audio>
          ${audioFacts ? `<div class="phrase-card-audio-meta">${audioFacts}</div>` : ""}
        </div>
      `;
    }

    if (phrase.audioUrl) {
      return `
        <div class="phrase-card-audio">
          <span class="phrase-audio-pill phrase-audio-pill--ready">Playback lives on the Viet phrase pages</span>
        </div>
      `;
    }

    return `
      <div class="phrase-card-audio">
        <span class="phrase-audio-pill phrase-audio-pill--planned">Text only on the site right now</span>
      </div>
    `;
  }

  function renderMetaPill(label, value) {
    if (!value) {
      return "";
    }

    return `<span class="phrase-meta-pill"><strong>${escapeHtml(label)}:</strong> ${escapeHtml(String(value))}</span>`;
  }

  function renderStatBlock(value, label) {
    return `
      <div class="phrase-module-stat">
        <strong>${escapeHtml(value)}</strong>
        <span>${escapeHtml(label)}</span>
      </div>
    `;
  }

  function renderModuleTrustLinks(modulePayload) {
    const trust = modulePayload.trust || {};
    const notes = [
      trust.sourceNote ? `<span class="phrase-module-trust-note">${escapeHtml(trust.sourceNote)}</span>` : "",
      trust.appBoundary ? `<span class="phrase-module-trust-note">${escapeHtml(trust.appBoundary)}</span>` : "",
    ]
      .filter(Boolean)
      .join("");

    const links = [
      renderModuleTrustLink(trust.methodologyUrl, trust.methodologyLabel),
      renderModuleTrustLink(trust.correctionsUrl, trust.correctionsLabel),
    ]
      .filter(Boolean)
      .join("");

    if (!notes && !links) {
      return "";
    }

    return `
      <div class="phrase-module-trust-row">
        ${notes ? `<div class="phrase-module-trust-notes">${notes}</div>` : ""}
        ${links ? `<div class="phrase-module-trust-links">${links}</div>` : ""}
      </div>
    `;
  }

  function renderModuleTrustLink(url, label) {
    if (!url || !label) {
      return "";
    }

    return `<a class="phrase-module-trust-link" href="${escapeAttribute(url)}">${escapeHtml(label)}</a>`;
  }

  function normalizeCoverage(coverage, phraseCount) {
    const totalPhraseCount = Number.isFinite(coverage?.totalPhraseCount) ? coverage.totalPhraseCount : phraseCount;
    const readyPhraseCount = Number.isFinite(coverage?.readyPhraseCount) ? coverage.readyPhraseCount : 0;
    const plannedPhraseCount = Number.isFinite(coverage?.plannedPhraseCount)
      ? coverage.plannedPhraseCount
      : Math.max(totalPhraseCount - readyPhraseCount, 0);

    return {
      status: coverage?.status || "planned",
      readyPhraseCount,
      plannedPhraseCount,
      totalPhraseCount,
    };
  }

  function describeAudioCoverage(coverage, renderOptions) {
    if (coverage.status === "ready") {
      if (!renderOptions.playbackEnabled) {
        return {
          tone: "ready",
          badge: `All ${coverage.totalPhraseCount} site clips ready`,
          title: "Site clips are ready, but this surface stays preview-first.",
          body: "The clips live in the site-owned export, but on-demand playback is intentionally limited to the Viet phrase pages that teach these starter blocks in context.",
        };
      }

      return {
        tone: "ready",
        badge: `All ${coverage.totalPhraseCount} site clips ready`,
        title: "Every phrase in this block has playable site audio.",
        body: "These are selected starter clips for this module only. Use the app when you want the deeper do-not-get-stuck backup for the same travel moments.",
      };
    }

    if (coverage.status === "mixed") {
      if (!renderOptions.playbackEnabled) {
        return {
          tone: "mixed",
          badge: `${coverage.readyPhraseCount} of ${coverage.totalPhraseCount} clips ready`,
          title: "Some site clips are ready, but this surface stays preview-first.",
          body: `${coverage.readyPhraseCount} starter phrase${coverage.readyPhraseCount === 1 ? "" : "s"} already have site-owned clips. On-demand playback is still limited to the Viet phrase pages that need it.`,
        };
      }

      return {
        tone: "mixed",
        badge: `${coverage.readyPhraseCount} of ${coverage.totalPhraseCount} clips ready`,
        title: "This block mixes playable audio with text-only phrases.",
        body: `${coverage.readyPhraseCount} starter phrase${coverage.readyPhraseCount === 1 ? "" : "s"} can play on the site now. The other ${coverage.plannedPhraseCount} stay text-only until site audio is editorially ready.`,
      };
    }

    return {
      tone: "planned",
      badge: "Text only for now",
      title: "This block is still text-first on the site.",
      body: "The phrases are approved for the starter preview, but site audio has not been published for this block yet.",
    };
  }

  function formatSiteAudioCoverage(coverage, renderOptions) {
    if (coverage.status === "ready") {
      return renderOptions.playbackEnabled ? "Ready for this module only" : "Ready on Viet phrase pages";
    }

    if (coverage.status === "mixed") {
      return renderOptions.playbackEnabled
        ? `${coverage.readyPhraseCount} of ${coverage.totalPhraseCount} clips ready here`
        : `${coverage.readyPhraseCount} of ${coverage.totalPhraseCount} clips ready on Viet phrase pages`;
    }

    return "Text only on site";
  }

  function resolveRenderOptions(host) {
    const wrapper = host.closest(WRAPPER_SELECTOR);
    const audioMode = wrapper?.getAttribute(AUDIO_MODE_ATTRIBUTE)?.trim().toLowerCase() || "";

    return {
      playbackEnabled: audioMode === AUDIO_MODE_PLAYBACK,
    };
  }

  function formatWarningNoteType(value) {
    const mapping = {
      formal: "A more formal phrasing",
      bookish: "A bookish phrasing that may sound less natural in quick travel use",
      "harder-to-say": "A harder-to-say phrase worth double-checking before live use",
      "recognition-only": "Most useful for recognition rather than for saying first",
    };

    return mapping[value] || value;
  }

  function formatDuration(durationMs) {
    const totalSeconds = Math.max(Math.round(Number(durationMs) / 1000), 1);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    if (!minutes) {
      return `${seconds}s`;
    }

    return `${minutes}m ${String(seconds).padStart(2, "0")}s`;
  }

  function formatDateLabel(value) {
    if (!value) {
      return null;
    }

    const parsed = new Date(value);
    if (Number.isNaN(parsed.getTime())) {
      return null;
    }

    return parsed.toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
      timeZone: "UTC",
    });
  }

  function renderError(host, message) {
    host.innerHTML = `<p class="phrase-module-error">${escapeHtml(message)}</p>`;
  }

  function renderPlaybackSpeedControls() {
    return `
      <div class="phrase-module-controls">
        <div>
          <p class="phrase-module-controls-label">Playback speed</p>
          <p class="phrase-module-controls-copy">Use the same site clip at 0.5x for careful listening, 0.75x for slower practice, or 1.0x for normal pace.</p>
        </div>
        <div class="phrase-speed-toggle" role="group" aria-label="Phrase audio playback speed">
          ${Object.entries(PLAYBACK_SPEED_OPTIONS)
            .map(([option, config]) => {
              const isActive = option === activePlaybackSpeed;
              return `
                <button
                  type="button"
                  class="phrase-speed-button${isActive ? " phrase-speed-button--active" : ""}"
                  data-phrase-speed-option="${escapeAttribute(option)}"
                  aria-pressed="${isActive ? "true" : "false"}"
                >
                  ${escapeHtml(config.label)}
                </button>
              `;
            })
            .join("")}
        </div>
      </div>
    `;
  }

  function bindPlaybackSpeedControls(host) {
    const buttons = Array.from(host.querySelectorAll("[data-phrase-speed-option]"));
    if (!buttons.length) {
      return;
    }

    for (const button of buttons) {
      button.addEventListener("click", () => {
        const nextSpeed = normalizePlaybackSpeedOption(button.getAttribute("data-phrase-speed-option"));
        setActivePlaybackSpeed(nextSpeed);
      });
    }
  }

  function setActivePlaybackSpeed(nextSpeed) {
    activePlaybackSpeed = normalizePlaybackSpeedOption(nextSpeed);
    persistPlaybackSpeed(activePlaybackSpeed);
    syncPlaybackSpeedControls();
    applyPlaybackRateToDocument(getPlaybackRate(activePlaybackSpeed));
  }

  function syncPlaybackSpeedControls() {
    const buttons = Array.from(document.querySelectorAll("[data-phrase-speed-option]"));
    for (const button of buttons) {
      const option = normalizePlaybackSpeedOption(button.getAttribute("data-phrase-speed-option"));
      const isActive = option === activePlaybackSpeed;
      button.classList.toggle("phrase-speed-button--active", isActive);
      button.setAttribute("aria-pressed", isActive ? "true" : "false");
    }
  }

  function applyPlaybackRateToDocument(playbackRate) {
    const audioElements = Array.from(document.querySelectorAll(".phrase-module audio"));
    for (const audioElement of audioElements) {
      applyPlaybackRate(audioElement, playbackRate);
    }
  }

  function applyPlaybackRateToHost(host, playbackSpeed) {
    const playbackRate = getPlaybackRate(playbackSpeed);
    const audioElements = Array.from(host.querySelectorAll("audio"));
    for (const audioElement of audioElements) {
      applyPlaybackRate(audioElement, playbackRate);
    }
  }

  function applyPlaybackRate(audioElement, playbackRate) {
    audioElement.defaultPlaybackRate = playbackRate;
    audioElement.playbackRate = playbackRate;
  }

  function normalizePlaybackSpeedOption(value) {
    if (!value) {
      return "1.0x";
    }

    const normalizedValue = String(value).trim().toLowerCase();
    if (normalizedValue === "slow") {
      return "0.75x";
    }

    if (normalizedValue === "normal") {
      return "1.0x";
    }

    if (normalizedValue === "0.5x" || normalizedValue === "0.50x" || normalizedValue === "0.5") {
      return "0.5x";
    }

    if (normalizedValue === "0.75x" || normalizedValue === "0.75") {
      return "0.75x";
    }

    if (
      normalizedValue === "1.0x" ||
      normalizedValue === "1x" ||
      normalizedValue === "1.0" ||
      normalizedValue === "1"
    ) {
      return "1.0x";
    }

    const parsedRate = Number.parseFloat(normalizedValue.replace(/x$/i, ""));
    if (Number.isFinite(parsedRate) && parsedRate > 0) {
      return Object.entries(PLAYBACK_SPEED_OPTIONS).reduce((closestOption, currentOption) => {
        const [, closestConfig] = closestOption;
        const [, currentConfig] = currentOption;
        return Math.abs(parsedRate - currentConfig.rate) < Math.abs(parsedRate - closestConfig.rate)
          ? currentOption
          : closestOption;
      })[0];
    }

    return "1.0x";
  }

  function getPlaybackRate(playbackSpeed) {
    return PLAYBACK_SPEED_OPTIONS[normalizePlaybackSpeedOption(playbackSpeed)].rate;
  }

  function readStoredPlaybackSpeed() {
    try {
      const storedValue = window.localStorage.getItem(PLAYBACK_SPEED_STORAGE_KEY);
      const normalizedValue = normalizePlaybackSpeedOption(storedValue);

      if (storedValue != null && storedValue !== normalizedValue) {
        persistPlaybackSpeed(normalizedValue);
      }

      return normalizedValue;
    } catch {
      return "1.0x";
    }
  }

  function persistPlaybackSpeed(playbackSpeed) {
    try {
      if (playbackSpeed === "1.0x") {
        window.localStorage.removeItem(PLAYBACK_SPEED_STORAGE_KEY);
        return;
      }

      window.localStorage.setItem(PLAYBACK_SPEED_STORAGE_KEY, normalizePlaybackSpeedOption(playbackSpeed));
    } catch {
      // Ignore storage failures and keep the in-memory selection for the current page.
    }
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function escapeAttribute(value) {
    return escapeHtml(value);
  }

})();

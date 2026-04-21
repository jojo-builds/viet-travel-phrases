(() => {
  const HOST_SELECTOR = "[data-trust-panel-id]";
  const DEFAULT_TRUST_PATH = "/data/trust-panels.json";

  document.addEventListener("DOMContentLoaded", () => {
    void hydrateTrustPanels();
  });

  async function hydrateTrustPanels() {
    const hosts = Array.from(document.querySelectorAll(HOST_SELECTOR));
    if (!hosts.length) {
      return;
    }

    let payload;
    try {
      payload = await fetchJson(DEFAULT_TRUST_PATH);
    } catch (error) {
      for (const host of hosts) {
        renderError(host, "Trust notes could not load.");
      }
      console.error(error);
      return;
    }

    const panelsById = new Map((payload.panels || []).map((panel) => [panel.panelId, panel]));

    for (const host of hosts) {
      const panelId = host.getAttribute("data-trust-panel-id");
      const panel = panelId ? panelsById.get(panelId) : null;

      if (!panel) {
        renderError(host, "This trust panel is missing from the site data.");
        continue;
      }

      renderPanel(host, panel);
    }
  }

  async function fetchJson(path) {
    const response = await fetch(path, { credentials: "same-origin" });
    if (!response.ok) {
      throw new Error(`Failed to fetch ${path}: ${response.status}`);
    }

    return response.json();
  }

  function renderPanel(host, panel) {
    const facts = Array.isArray(panel.facts) ? panel.facts : [];
    const actions = Array.isArray(panel.actions) ? panel.actions : [];

    host.innerHTML = `
      <article class="trust-panel">
        <div class="trust-panel-head">
          <div>
            <span class="label-pill">${escapeHtml(panel.eyebrow || "Trust")}</span>
            <h2>${escapeHtml(panel.title || "Trust panel")}</h2>
            <p>${escapeHtml(panel.summary || "")}</p>
          </div>
          ${actions.length ? `<div class="inline-actions">${actions.map(renderAction).join("")}</div>` : ""}
        </div>
        ${facts.length ? `<div class="trust-fact-grid">${facts.map(renderFact).join("")}</div>` : ""}
      </article>
    `;
  }

  function renderFact(fact) {
    return `
      <article class="trust-fact">
        <strong>${escapeHtml(fact.label || "")}</strong>
        <span>${escapeHtml(fact.body || "")}</span>
      </article>
    `;
  }

  function renderAction(action) {
    return `<a class="button-secondary" href="${escapeAttribute(action.url || "/")}">${escapeHtml(action.label || "Open")}</a>`;
  }

  function renderError(host, message) {
    host.innerHTML = `<p class="phrase-module-error">${escapeHtml(message)}</p>`;
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

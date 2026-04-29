const state = {
  deck: null,
  itemByID: new Map(),
  flow: null,
  flowItems: [],
  index: 0,
  selectedOptionID: "",
  selectedChunkIDs: [],
  checked: false,
  correct: 0,
  missed: 0,
  readyPromptIDs: new Set(),
  readyPhraseIDs: new Set(),
  reviewPhraseIDs: new Set(),
};

const els = {
  backButton: document.querySelector("#backButton"),
  progressPill: document.querySelector("#progressPill"),
  hubView: document.querySelector("#hubView"),
  sessionView: document.querySelector("#sessionView"),
  completeView: document.querySelector("#completeView"),
  deckCount: document.querySelector("#deckCount"),
  rewardSummary: document.querySelector("#rewardSummary"),
  flowList: document.querySelector("#flowList"),
  flowLabel: document.querySelector("#flowLabel"),
  promptTitle: document.querySelector("#promptTitle"),
  routeMeterLabel: document.querySelector("#routeMeterLabel"),
  routeMeterFill: document.querySelector("#routeMeterFill"),
  questionType: document.querySelector("#questionType"),
  audioButton: document.querySelector("#audioButton"),
  promptText: document.querySelector("#promptText"),
  sourceLine: document.querySelector("#sourceLine"),
  mascotNote: document.querySelector("#mascotNote"),
  answerArea: document.querySelector("#answerArea"),
  feedback: document.querySelector("#feedback"),
  sourceButton: document.querySelector("#sourceButton"),
  nextButton: document.querySelector("#nextButton"),
  completeLabel: document.querySelector("#completeLabel"),
  completeTitle: document.querySelector("#completeTitle"),
  correctCount: document.querySelector("#correctCount"),
  missedCount: document.querySelector("#missedCount"),
  rewardUnlock: document.querySelector("#rewardUnlock"),
  keepGoingButton: document.querySelector("#keepGoingButton"),
  chooseFlowButton: document.querySelector("#chooseFlowButton"),
};

const TYPE_LABELS = {
  listening_choice: "Listen and choose",
  english_to_vietnamese: "English to Vietnamese",
  vietnamese_to_english: "Vietnamese to English",
  situation_pick: "Situation pick",
  pronoun_variant_choice: "Pronoun coach",
  phrase_chunk_rebuild: "Chunk rebuild",
  natural_phrase_choice: "Natural choice",
};

function setView(view) {
  els.hubView.hidden = view !== "hub";
  els.sessionView.hidden = view !== "session";
  els.completeView.hidden = view !== "complete";
  els.backButton.style.visibility = view === "hub" ? "hidden" : "visible";
}

function currentItem() {
  return state.flowItems[state.index];
}

function flowSessionItems(flow) {
  return flow.itemIDs
    .map((id) => state.itemByID.get(id))
    .filter(Boolean)
    .slice(0, flow.defaultSessionLength || 5);
}

function renderHub() {
  setView("hub");
  els.progressPill.textContent = "Practice";
  els.deckCount.textContent = `${state.deck.metadata.itemCount} real phrase prompts from ${state.deck.metadata.scenarioCount} scenarios`;
  const mascotEligibleCount = state.deck.items.filter((item) => item.tags && item.tags.mascotEligible).length;
  els.rewardSummary.textContent = `${mascotEligibleCount} gentle moments can show the Vietnam travel companion; sensitive prompts stay focused on the phrase.`;
  els.flowList.innerHTML = "";

  for (const flow of state.deck.practiceFlows) {
    const button = document.createElement("button");
    button.className = "flow-card";
    button.type = "button";
    button.innerHTML = `
      <span>
        <strong>${flow.title}</strong>
        <span>${flow.summary}</span>
      </span>
      <span class="flow-meta">${Math.min(flow.itemIDs.length, flow.defaultSessionLength || 5)}</span>
    `;
    button.addEventListener("click", () => startFlow(flow.id));
    els.flowList.appendChild(button);
  }
}

function startFlow(flowID) {
  state.flow = state.deck.practiceFlows.find((flow) => flow.id === flowID);
  state.flowItems = flowSessionItems(state.flow);
  state.index = 0;
  state.selectedOptionID = "";
  state.selectedChunkIDs = [];
  state.checked = false;
  state.correct = 0;
  state.missed = 0;
  state.readyPromptIDs = new Set();
  state.readyPhraseIDs = new Set();
  state.reviewPhraseIDs = new Set();
  renderItem();
}

function renderItem() {
  const item = currentItem();
  if (!item) {
    renderComplete();
    return;
  }

  setView("session");
  els.feedback.hidden = true;
  els.feedback.innerHTML = "";
  els.progressPill.textContent = `${state.index + 1} of ${state.flowItems.length}`;
  els.flowLabel.textContent = state.flow.title;
  els.promptTitle.textContent = item.answer.english;
  els.questionType.textContent = TYPE_LABELS[item.questionType] || item.questionType;
  els.promptText.textContent = item.prompt.text;
  els.sourceLine.textContent = `${item.source.pageEnglishTitle} · ${item.source.scenarioTitle}`;
  els.nextButton.textContent = item.questionType === "phrase_chunk_rebuild" ? "Check" : "Check";
  els.nextButton.disabled = false;
  updateReadinessStrip();
  renderMascotNote(item);
  els.sourceButton.onclick = () => showSourceFeedback(item);

  if (item.prompt.audioKey) {
    els.audioButton.hidden = false;
    els.audioButton.onclick = () => playAudio(item.prompt.audioKey);
  } else {
    els.audioButton.hidden = true;
    els.audioButton.onclick = null;
  }

  if (item.questionType === "phrase_chunk_rebuild") {
    renderChunkAnswer(item);
  } else {
    renderChoiceAnswers(item);
  }
}

function updateReadinessStrip() {
  const total = Math.max(state.flowItems.length, 1);
  const readyPromptCount = state.readyPromptIDs.size;
  const readyCount = state.readyPhraseIDs.size;
  const reviewCount = state.reviewPhraseIDs.size;
  const percent = Math.min(100, Math.round((readyPromptCount / total) * 100));
  els.routeMeterLabel.textContent = `${readyPromptCount} ready prompts / ${reviewCount} review`;
  els.routeMeterFill.style.width = `${percent}%`;
}

function renderMascotNote(item) {
  const shouldShow = item.tags && item.tags.mascotEligible && item.tags.sensitivity !== "sensitive";
  els.mascotNote.hidden = !shouldShow;
  if (!shouldShow) {
    els.mascotNote.innerHTML = "";
    return;
  }
  els.mascotNote.innerHTML = `
    <span class="mini-mascot" aria-hidden="true"></span>
    <span>Route mark available for this source phrase.</span>
  `;
}

function renderChoiceAnswers(item) {
  els.answerArea.innerHTML = "";
  for (const option of item.options) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "answer-button";
    button.dataset.optionID = option.id;
    button.innerHTML = `<strong>${option.displayText}</strong><span>${secondaryForOption(item, option, false)}</span>`;
    button.addEventListener("click", () => {
      if (state.checked) return;
      state.selectedOptionID = option.id;
      for (const child of els.answerArea.querySelectorAll(".answer-button")) {
        child.classList.toggle("is-selected", child.dataset.optionID === option.id);
      }
    });
    els.answerArea.appendChild(button);
  }
  els.nextButton.onclick = () => checkChoice(item);
}

function renderChunkAnswer(item) {
  els.answerArea.innerHTML = "";
  const label = document.createElement("div");
  label.className = "chunk-label";
  label.textContent = "Build the phrase";
  const selected = document.createElement("div");
  selected.className = "selected-chunks";
  selected.id = "selectedChunks";
  const bankLabel = document.createElement("div");
  bankLabel.className = "chunk-label";
  bankLabel.textContent = "Available pieces";
  const bank = document.createElement("div");
  bank.className = "chunk-bank";

  const chunks = [...item.answer.correctSequence, ...item.distractors]
    .filter((chunk, index, array) => array.findIndex((entry) => entry.id === chunk.id) === index)
    .sort((a, b) => stableSortKey(`${item.id}-${a.id}`) - stableSortKey(`${item.id}-${b.id}`));

  for (const chunk of chunks) {
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "chip";
    chip.dataset.chunkId = chunk.id;
    chip.textContent = chunk.vietnamese;
    chip.addEventListener("click", () => toggleChunk(chunk, chip));
    bank.appendChild(chip);
  }

  els.answerArea.append(label, selected, bankLabel, bank);
  els.nextButton.onclick = () => checkChunks(item);
}

function toggleChunk(chunk, chip) {
  if (state.checked) return;
  const existingIndex = state.selectedChunkIDs.indexOf(chunk.id);
  if (existingIndex >= 0) {
    state.selectedChunkIDs.splice(existingIndex, 1);
    chip.classList.remove("is-selected");
  } else {
    state.selectedChunkIDs.push(chunk.id);
    chip.classList.add("is-selected");
  }
  renderSelectedChunks();
}

function renderSelectedChunks() {
  const item = currentItem();
  const selected = document.querySelector("#selectedChunks");
  if (!selected || !item) return;
  selected.innerHTML = "";
  for (const chunkID of state.selectedChunkIDs) {
    const chunk = item.answer.correctSequence.find((entry) => entry.id === chunkID) || item.distractors.find((entry) => entry.id === chunkID);
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "chip";
    chip.textContent = chunk ? chunk.vietnamese : chunkID;
    chip.addEventListener("click", () => {
      state.selectedChunkIDs = state.selectedChunkIDs.filter((id) => id !== chunkID);
      const bankChip = document.querySelector(`[data-chunk-id="${chunkID}"]`);
      if (bankChip) bankChip.classList.remove("is-selected");
      renderSelectedChunks();
    });
    selected.appendChild(chip);
  }
}

function checkChoice(item) {
  if (state.checked) {
    goNext();
    return;
  }
  if (!state.selectedOptionID) return;
  state.checked = true;
  const isCorrect = state.selectedOptionID === item.correctOptionID;
  recordResult(item, isCorrect);
  for (const button of els.answerArea.querySelectorAll(".answer-button")) {
    const option = item.options.find((entry) => entry.id === button.dataset.optionID);
    const secondary = button.querySelector("span");
    if (option && secondary) secondary.textContent = secondaryForOption(item, option, true);
    button.classList.toggle("is-correct", option && option.isCorrect);
    button.classList.toggle("is-wrong", button.dataset.optionID === state.selectedOptionID && !isCorrect);
  }
  showFeedback(item, isCorrect);
}

function secondaryForOption(item, option, checked) {
  if (checked) {
    return `${option.vietnamese} · ${option.english}`;
  }
  if (item.questionType === "english_to_vietnamese" || item.questionType === "situation_pick" || item.questionType === "pronoun_variant_choice" || item.questionType === "natural_phrase_choice") {
    return option.pronunciation || "Vietnamese phrase";
  }
  if (item.questionType === "listening_choice") {
    return "Meaning choice";
  }
  return "English meaning";
}

function checkChunks(item) {
  if (state.checked) {
    goNext();
    return;
  }
  const expected = item.answer.correctSequence.map((chunk) => chunk.id).join("|");
  const actual = state.selectedChunkIDs.join("|");
  if (!actual) return;
  state.checked = true;
  const isCorrect = actual === expected;
  recordResult(item, isCorrect);
  showFeedback(item, isCorrect);
}

function recordResult(item, isCorrect) {
  if (isCorrect) {
    state.correct += 1;
    state.readyPromptIDs.add(item.id);
    state.readyPhraseIDs.add(item.source.phraseID);
    state.reviewPhraseIDs.delete(item.source.phraseID);
  } else {
    state.missed += 1;
    state.reviewPhraseIDs.add(item.source.phraseID);
  }
  updateReadinessStrip();
}

function showFeedback(item, isCorrect) {
  els.feedback.hidden = false;
  els.feedback.innerHTML = `
    <strong>${isCorrect ? "Ready mark added" : "Saved for calm review"}</strong>
    <p>${item.feedback.correct} ${item.feedback.contrast}</p>
    <p>${isCorrect ? "This source phrase counts toward the Vietnam route mark." : "No penalty. It will come back before new prompts."}</p>
    <p>${item.feedback.source}</p>
  `;
  els.nextButton.textContent = state.index === state.flowItems.length - 1 ? "Finish" : "Next";
}

function showSourceFeedback(item) {
  els.feedback.hidden = false;
  els.feedback.innerHTML = `
    <strong>${item.source.pageEnglishTitle}</strong>
    <p>Source page ID: ${item.source.pageID}. Phrase ID: ${item.source.phraseID}.</p>
  `;
}

function goNext() {
  state.index += 1;
  state.selectedOptionID = "";
  state.selectedChunkIDs = [];
  state.checked = false;
  renderItem();
}

function renderComplete() {
  setView("complete");
  els.progressPill.textContent = "Session";
  els.completeLabel.textContent = state.flow.title;
  els.completeTitle.textContent = "Vietnam route updated";
  els.correctCount.textContent = String(state.correct);
  els.missedCount.textContent = String(state.missed);
  const unlocked = state.readyPromptIDs.size >= Math.min(3, state.flowItems.length) && state.readyPhraseIDs.size >= Math.min(2, state.flowItems.length);
  els.rewardUnlock.innerHTML = `
    <div class="mascot-avatar mascot-vietnam small" aria-hidden="true">
      <span class="mascot-eye"></span>
      <span class="mascot-pack"></span>
      <span class="mascot-tail"></span>
    </div>
    <div>
      <strong>${unlocked ? "Jade route mark unlocked" : "Route mark still in progress"}</strong>
      <p>${unlocked ? `${state.readyPromptIDs.size} source-anchored prompts reached ready across ${state.readyPhraseIDs.size} phrase pages.` : "Review missed prompts to finish this route without losing progress."}</p>
    </div>
  `;
  els.keepGoingButton.textContent = state.missed ? "Review this route" : "Practice this route again";
  els.chooseFlowButton.textContent = "Choose another route";
}

function stableSortKey(input) {
  let hash = 0;
  for (const char of input) {
    hash = (hash * 31 + char.charCodeAt(0)) >>> 0;
  }
  return hash;
}

function playAudio(audioKey) {
  const audio = new Audio(`../../native-ios/Resources/Audio/${audioKey}.mp3`);
  audio.play().catch(() => {
    els.feedback.hidden = false;
    els.feedback.innerHTML = `
      <strong>Audio cue</strong>
      <p>${audioKey}.mp3 is the bundled audio key. Browser playback can be blocked until the prototype is served from the repo root.</p>
    `;
  });
}

els.backButton.addEventListener("click", () => {
  if (!els.sessionView.hidden) {
    renderHub();
  } else if (!els.completeView.hidden) {
    renderHub();
  }
});

els.keepGoingButton.addEventListener("click", () => {
  if (state.flow) startFlow(state.flow.id);
});

els.chooseFlowButton.addEventListener("click", renderHub);

fetch("practice-deck.sample.json")
  .then((response) => response.json())
  .then((deck) => {
    state.deck = deck;
    state.itemByID = new Map(deck.items.map((item) => [item.id, item]));
    renderHub();
  })
  .catch((error) => {
    els.deckCount.textContent = `Could not load practice-deck.sample.json: ${error.message}`;
  });

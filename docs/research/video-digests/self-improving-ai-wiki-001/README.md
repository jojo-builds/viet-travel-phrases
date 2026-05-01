# Self-Improving AI Wiki Video Digest

Research date: 2026-05-01
Research question: Can the SpeakLocal Research / Product Strategy lane use an OpenAI/Codex-native workflow to digest YouTube videos into transcript, visual evidence, and fold-in recommendations?
Decision this should inform: Whether to keep building a reusable video-digest workflow and future Codex skill for recurring SpeakLocal research.
Assignment source: Jojo request to test `https://youtu.be/nilNHl4uZcU?si=k-KNWfw7IiB1Dvwb`.
Research owner: Research / Product Strategy lane

## Executive Takeaway

Yes. This pilot proves the lane can process a public YouTube video without installing `claude-video` as a dependency: local `yt-dlp` captured metadata and captions, local `ffmpeg` extracted timestamped frames, Codex read the transcript and visual frames, and the report can now turn the video into concrete process recommendations.

The useful strategy from the video is not the exact Claude/Appify/Obsidian stack. The durable idea is: human taste selects trusted sources; automation fetches recurring source material; Codex turns raw source artifacts into linked, reviewable research notes; and the lane keeps a log of what was adopted, held, or rejected. That maps cleanly to SpeakLocal if we keep it scoped, public, cited, and repo-native.

## Audience And Source Map

| Source | How Used | Notes |
| --- | --- | --- |
| [YouTube video: Build Your Own Self Improving AI Wiki in 11 Minutes](https://www.youtube.com/watch?v=nilNHl4uZcU) | Primary source | Public video by Brad \| AI & Automation, uploaded 2026-04-15. |
| `transcript.md`, `transcript.vtt`, `transcript.json` | Evidence extraction | Captions found; OpenAI transcription was not needed. |
| `frames/` and `contact-sheet.jpg` | Visual evidence | Eight sampled frames show the wiki, graph view, Claude Code commands, and setup flow. |
| [bradautomates/claude-video](https://github.com/bradautomates/claude-video) | Reference pattern | Confirms the extraction pattern: `yt-dlp`, `ffmpeg`, captions first, model transcription fallback, frames plus transcript. |
| [OpenAI speech-to-text docs](https://developers.openai.com/api/docs/guides/speech-to-text) | OpenAI fallback design | Official basis for `gpt-4o-mini-transcribe`, `gpt-4o-transcribe`, `whisper-1`, and 25 MB file limit handling. |
| [OpenAI images and vision docs](https://developers.openai.com/api/docs/guides/images-vision) | Visual analysis design | Official basis for image inputs and multimodal frame analysis. |
| [OpenAI Responses API docs](https://developers.openai.com/api/docs/guides/migrate-to-responses#about-the-responses-api) | Future workflow design | Official basis for a unified text/image, tool-using agent loop. |

## Findings

### 1. The core pain is stale context, not wiki structure

The video opens by arguing that a manually maintained AI wiki decays as soon as the user stops feeding it new source material. That is directly relevant to SpeakLocal research: a one-off report is useful, but recurring market, competitor, Reddit/forum, and video research needs a repeatable ingestion loop.

Product meaning: keep the report artifact, raw source evidence, and lane notes together so future sessions do not have to rediscover the same workflow.

### 2. Separate human source selection from automated fetching

The strongest concept in the video is the source-quality boundary. The speaker argues that humans should decide which sources are worth trusting, while agents handle repeated fetching after that decision. This is a good fit for SpeakLocal because Jojo and the lane can choose source lists intentionally instead of letting automation scrape broad noisy surfaces.

Product meaning: future "context farmer" work should start with an approved source registry, not a generic internet crawler.

### 3. Raw source plus digest plus index/log is a good repo pattern

The video describes a raw folder, wiki folder, index, and log. For SpeakLocal, the equivalent should stay inside the repo rather than Obsidian-specific:

- raw/source artifacts: `docs/research/video-digests/<slug>/transcript.*`, `frames/`, `metadata.json`, and `video-digest-manifest.json`;
- digest: `docs/research/video-digests/<slug>/README.md`;
- lane log: `docs/research/RESEARCH_LANE_NOTES.md`;
- future index: a small video/source registry only after several pilots prove the recurring shape.

### 4. Visual frames add real value for tool/process videos

The transcript alone captures the argument, but the frames show how the process feels: a graph view with linked nodes, a Claude Code command running against a wiki, a folder tree with raw thumbnails, and a skill setup prompt. Those visuals make the workflow more concrete than a transcript-only summary.

Product meaning: for tool demos, UI walkthroughs, competitor onboarding videos, and app-review videos, store frames and a contact sheet. For podcasts/talking-head videos, transcript-only may be enough.

### 5. The scheduling idea is useful, but the exact cloud stack is not portable

The video leans on Claude scheduled agents, Claude Code Cloud, Appify, Obsidian Git, and Claude-specific skills. SpeakLocal should not copy those dependencies blindly. The transferable pattern is scheduled source refresh plus commit-backed artifacts.

Product meaning: create a future task for an OpenAI/Codex-compatible scheduled research lane only after the manual video-digest loop is reliable.

### 6. The `claude-video` repo is a useful reference, not the implementation

The repo's README describes a strong video digestion pattern: download with `yt-dlp`, extract frames with `ffmpeg`, prefer captions, fall back to transcription only when needed, and pass frames plus transcript to the model. It also defaults to Groq as a preferred Whisper fallback, which does not match Jojo's request to keep the model layer OpenAI-native.

Product meaning: keep our helper local and OpenAI-oriented. Do not install `claude-video` as the lane dependency.

## Evidence Table

| Signal | Source | Evidence | Product Meaning | Confidence |
| --- | --- | --- | --- | --- |
| Manual context entry is the bottleneck | Video transcript 00:00-00:01 | The speaker frames stale wikis as an update problem and shows automatic transcript/thumbnail ingestion. | Build repeatable ingestion around research artifacts, not ad hoc chat summaries. | High |
| Human taste should choose sources | Video transcript 00:05:35-00:06:26 | The speaker separates source selection from fetching and treats fetching as scheduled work. | Require approved source lists before recurring research automation. | High |
| Raw, wiki, index, and log are the core structure | Video transcript 00:01:55-00:02:19 | The video describes raw inputs, generated pages, an index, and a log. | Map this to repo-local source artifacts, reports, lane notes, and optional future index. | High |
| Graph and backlink views make the knowledge layer inspectable | Frame `frame_02_00-01-49.jpg` and transcript 00:01:08-00:01:32 | The visual shows many linked content nodes around an index. | Future source registries should expose relationships, but a Markdown table may be enough before a graph UI exists. | Medium |
| The model must see frames when visuals matter | Frames 00:03:19, 00:04:49, 00:09:18 | Frames reveal IDE structure, command flow, and setup prompts that captions alone flatten. | Keep visual extraction for UI/workflow videos. | High |
| Captions-first avoids unnecessary paid transcription | Local manifest and `claude-video` README | Captions were available; OpenAI transcription status is `skipped`. The reference repo also treats captions as the free first path. | Make OpenAI transcription a fallback, not a default cost. | High |
| Claude-specific scheduling does not directly transfer | Video transcript 00:07:19-00:08:35 | The video uses Claude cloud/local scheduled agents and Appify. | Hold recurring automation until there is a Codex/OpenAI-compatible task design. | Medium-high |

## Visual Notes

| Timestamp | Artifact | What It Shows | Why It Matters |
| --- | --- | --- | --- |
| 00:00:20 | `frames/frame_01_00-00-20.jpg` | A scheduled YouTube-farmer run in Claude-like UI. | Useful pattern: agent prompt, source task, capture count, issue report. |
| 00:01:49 | `frames/frame_02_00-01-49.jpg` | Obsidian graph view with wiki nodes and creator/video pages. | Shows why visual evidence matters for process videos. |
| 00:03:19 | `frames/frame_03_00-03-19.jpg` | IDE folder structure with raw thumbnails and wiki creator pages. | Reinforces raw-plus-digest folder pattern. |
| 00:04:49 | `frames/frame_04_00-04-49.jpg` | Claude Code querying the wiki from the terminal. | Maps to Codex using repo artifacts as durable context. |
| 00:09:18 | `frames/frame_07_00-09-18.jpg` | Skill setup prompt in an IDE. | Supports a future skill only after the workflow is proven. |

## OpenAI/Codex Workflow Tested

- Installed local extraction dependencies with Homebrew: `yt-dlp` 2026.03.17, `ffmpeg` 8.1, and `ffprobe` 8.1.
- Added `scripts/research-video-digest.py` as the repo-local helper.
- Ran the helper on the test YouTube URL.
- Captions were available, so OpenAI transcription was skipped.
- No `OPENAI_API_KEY` was visible in the environment; if captions had been missing, the run would have been partial unless `--allow-openai-transcribe` and an API key were available.
- Extracted eight timestamped frames and a contact sheet.
- Trimmed volatile `yt-dlp` info JSON from the committed artifacts; retained durable metadata in `metadata.json`.

## SpeakLocal Opportunities

1. Add video digestion as a standard research source category.
2. Treat trusted source selection as a Jojo/lane decision, not an autonomous scraping task.
3. Keep raw evidence and digest reports adjacent so future sessions can re-check claims.
4. Add a future source registry only after repeated video/research pilots identify the recurring fields.
5. Create a future Codex skill once the lane has at least two or three successful video passes.

## Recommendations

- Adopt now: keep the repo-local helper and artifact shape for video-digest research.
- Adopt now: use captions first and OpenAI transcription only as explicit fallback.
- Adopt now: include frame references in reports when visuals affect the conclusion.
- Create task card: build a `speaklocal-video-digest` or expanded `speaklocal-research-lane` skill after one more pilot validates the same flow.
- Create task card: add robust OpenAI transcription chunking if we hit a captionless video that matters.
- Hold for later: scheduled recurring "context farmers" for source feeds.
- Reject: installing `claude-video` directly as the canonical SpeakLocal lane dependency.
- Reject: Groq/WhisperFlow-style paid third-party fallback as the default model layer.
- Needs Jojo decision: which video/source feeds deserve recurring monitoring.

## What Not To Do

- Do not let agents scrape broad sources without human-approved source lists.
- Do not turn every video into a large frame set; use sparse frames first and rerun focused windows when a visual moment matters.
- Do not commit downloaded video or raw downloader internals.
- Do not treat Obsidian, Appify, or Claude scheduled agents as requirements for SpeakLocal.
- Do not create a global Codex skill from only one successful pilot unless Jojo explicitly wants the earlier move.

## Open Questions

- Which public YouTube channels, app-review videos, or competitor demo feeds should become approved recurring sources?
- Should video digests live only under `docs/research/video-digests/`, or should topic reports import selected video evidence into their own research folders?
- Do we want a small source index after two more pilots, or should lane notes remain enough?
- Should the future skill live as `speaklocal-video-digest` or be folded into `speaklocal-research-lane`?

## Fold-In Options

### Adopt Now

- Keep `scripts/research-video-digest.py`.
- Use `docs/research/video-digests/<slug>/` for future public video digest artifacts.
- Keep video findings in the R&D template with timestamped transcript and frame references.

### Create Task Card

- Future skill task: create `speaklocal-video-digest` after one more successful pilot.
- Future tooling task: add OpenAI transcription chunking, optional focused `--start/--end`, and frame budget controls.
- Future research ops task: define an approved source registry for recurring video/forum/competitor feeds.

### Hold For Later

- Scheduled "context farmers" that run without Jojo initiating a research pass.
- Graph visualization of research/source relationships.
- Obsidian-specific review surfaces.

### Reject

- Direct dependency on `claude-video` for this repo.
- Groq-first or WhisperFlow-style fallback.
- Broad auto-scraping without a trusted source list.

### Needs Jojo Decision

- Whether to create the video-digest skill immediately after this pilot or wait for a second video.
- Which source feeds should be monitored repeatedly.
- Whether any future scheduled research should run locally on the Mac or in an OpenAI/Codex-compatible cloud path.

## Peer Review

Completed 2026-05-01 as a focused read-only review for evidence quality,
overreach, actionability, and skill/process clarity.

Review findings:

- Evidence quality: Pass. The report cites the public video, local transcript,
  local frames, `claude-video`, and official OpenAI docs.
- Overreach: Pass after narrowing. The report rejects direct adoption of the
  Claude/Appify/Obsidian stack and frames scheduled farmers as future work.
- Actionability: Pass. Recommendations are separated into adopt now, create task
  card, hold, reject, and needs Jojo decision.
- Process clarity: Pass after repair. The helper was updated to clean rolling
  YouTube auto-caption duplication and to avoid committing volatile raw
  `yt-dlp` info JSON.

Residual risk: OpenAI transcription fallback was designed but not exercised in
this pilot because captions were available. Chunking and focused time-window
controls should remain future tooling tasks.

## Folded Into

Folded into this pilot:

- `scripts/research-video-digest.py`
- `docs/research/video-digests/self-improving-ai-wiki-001/README.md`
- `docs/research/video-digests/self-improving-ai-wiki-001/metadata.json`
- `docs/research/video-digests/self-improving-ai-wiki-001/transcript.*`
- `docs/research/video-digests/self-improving-ai-wiki-001/frames/`
- `docs/research/video-digests/self-improving-ai-wiki-001/contact-sheet.jpg`
- `docs/research/video-digests/self-improving-ai-wiki-001/video-digest-manifest.json`
- `docs/research/RESEARCH_LANE_NOTES.md`

No SpeakLocal product direction or app implementation changed. Product adoption is pending Jojo/orchestrator review.

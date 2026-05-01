#!/usr/bin/env python3
"""Extract public-video research artifacts for the SpeakLocal R&D lane.

The helper intentionally keeps model work separate from extraction work:
yt-dlp and ffmpeg gather public metadata, captions, and frames locally; OpenAI
transcription is used only as an explicit fallback when captions are missing.
"""

from __future__ import annotations

import argparse
import html
import json
import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Iterable, List, Optional


TIMESTAMP_RE = re.compile(
    r"(?P<start>\d{2}:\d{2}:\d{2}\.\d{3})\s+-->\s+"
    r"(?P<end>\d{2}:\d{2}:\d{2}\.\d{3})"
)
TAG_RE = re.compile(r"<[^>]+>")


def run(args: List[str], cwd: Optional[Path] = None) -> subprocess.CompletedProcess:
    print("+ " + " ".join(args), file=sys.stderr)
    return subprocess.run(args, cwd=cwd, check=True, text=True, capture_output=True)


def require_command(name: str) -> str:
    path = shutil.which(name)
    if not path:
        raise SystemExit(f"Missing required command: {name}")
    return path


def command_version(name: str) -> str:
    try:
        completed = run([name, "-version"] if name.startswith("ff") else [name, "--version"])
    except subprocess.CalledProcessError:
        return "unknown"
    return completed.stdout.splitlines()[0] if completed.stdout else "unknown"


def hms(seconds: float) -> str:
    seconds = max(0, int(seconds))
    h = seconds // 3600
    m = (seconds % 3600) // 60
    s = seconds % 60
    return f"{h:02d}:{m:02d}:{s:02d}"


def timestamp_seconds(timestamp: str) -> float:
    hours, minutes, rest = timestamp.split(":")
    return int(hours) * 3600 + int(minutes) * 60 + float(rest)


def filename_time(seconds: float) -> str:
    return hms(seconds).replace(":", "-")


def parse_vtt(vtt_path: Path) -> List[dict]:
    segments: List[dict] = []
    lines = vtt_path.read_text(encoding="utf-8", errors="replace").splitlines()
    idx = 0
    while idx < len(lines):
        match = TIMESTAMP_RE.search(lines[idx])
        if not match:
            idx += 1
            continue

        start = match.group("start")
        end = match.group("end")
        if timestamp_seconds(end) - timestamp_seconds(start) < 0.05:
            idx += 1
            continue
        idx += 1
        while idx < len(lines) and not lines[idx].strip():
            idx += 1
        text_lines: List[str] = []
        while idx < len(lines) and lines[idx].strip():
            line = html.unescape(TAG_RE.sub("", lines[idx]).strip())
            line = re.sub(r"\s+", " ", line)
            if line:
                text_lines.append(line)
            idx += 1

        # YouTube auto-captions often use rolling two-line cues: the first line
        # repeats old text, while the final line contains the new phrase.
        text = (text_lines[-1] if text_lines else "").strip()
        if text:
            segments.append({"start": start, "end": end, "text": text})
        idx += 1
    return merge_repeated_segments(segments)


def merge_repeated_segments(segments: Iterable[dict]) -> List[dict]:
    merged: List[dict] = []
    previous_text = ""
    for segment in segments:
        text = segment["text"].strip()
        if not text or text == previous_text:
            continue
        # YouTube auto captions often repeat an earlier fragment plus new words.
        if previous_text and text.startswith(previous_text):
            text = text[len(previous_text) :].strip()
        if not text:
            continue
        merged.append({**segment, "text": text})
        previous_text = segment["text"].strip()
    return merged


def write_transcripts(vtt_path: Path, out_dir: Path) -> dict:
    segments = parse_vtt(vtt_path)
    transcript_json = out_dir / "transcript.json"
    transcript_md = out_dir / "transcript.md"
    transcript_vtt = out_dir / "transcript.vtt"
    shutil.copyfile(vtt_path, transcript_vtt)
    transcript_json.write_text(json.dumps(segments, indent=2) + "\n", encoding="utf-8")

    lines = ["# Transcript", "", f"Source captions: `{vtt_path.name}`", ""]
    for segment in segments:
        lines.append(f"- [{segment['start'][:8]}] {segment['text']}")
    transcript_md.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return {
        "transcript_vtt": str(transcript_vtt),
        "transcript_json": str(transcript_json),
        "transcript_md": str(transcript_md),
        "segment_count": len(segments),
    }


def find_caption(captions_dir: Path) -> Optional[Path]:
    candidates = sorted(captions_dir.glob("source*.vtt"))
    if not candidates:
        return None
    preferred = [
        p
        for p in candidates
        if ".en" in p.name.lower() or ".english" in p.name.lower()
    ]
    return preferred[0] if preferred else candidates[0]


def download_metadata_and_captions(url: str, out_dir: Path) -> dict:
    sources_dir = out_dir / "sources"
    sources_dir.mkdir(parents=True, exist_ok=True)
    run(
        [
            "yt-dlp",
            "--skip-download",
            "--write-info-json",
            "--write-subs",
            "--write-auto-subs",
            "--sub-langs",
            "en,en.*,en-US",
            "--sub-format",
            "vtt",
            "--convert-subs",
            "vtt",
            "-o",
            str(sources_dir / "source.%(ext)s"),
            url,
        ]
    )

    info_path = sources_dir / "source.info.json"
    metadata = json.loads(info_path.read_text(encoding="utf-8")) if info_path.exists() else {}
    if info_path.exists():
        info_path.unlink()
    summary = {
        "title": metadata.get("title"),
        "id": metadata.get("id"),
        "webpage_url": metadata.get("webpage_url") or url,
        "channel": metadata.get("channel") or metadata.get("uploader"),
        "duration": metadata.get("duration"),
        "upload_date": metadata.get("upload_date"),
        "view_count": metadata.get("view_count"),
        "info_json_retained": False,
    }
    (out_dir / "metadata.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    return summary


def download_video(url: str, work_dir: Path) -> Optional[Path]:
    work_dir.mkdir(parents=True, exist_ok=True)
    output = work_dir / "video.%(ext)s"
    try:
        run(
            [
                "yt-dlp",
                "-f",
                "bv*[height<=720]+ba/b[height<=720]/best[height<=720]/best",
                "--merge-output-format",
                "mp4",
                "-o",
                str(output),
                url,
            ]
        )
    except subprocess.CalledProcessError as exc:
        print(exc.stderr, file=sys.stderr)
        return None
    videos = sorted(work_dir.glob("video.*"))
    return videos[0] if videos else None


def probe_duration(video_path: Path) -> Optional[float]:
    try:
        completed = run(
            [
                "ffprobe",
                "-v",
                "error",
                "-show_entries",
                "format=duration",
                "-of",
                "default=nokey=1:noprint_wrappers=1",
                str(video_path),
            ]
        )
        return float(completed.stdout.strip())
    except Exception:
        return None


def sample_times(duration: Optional[float], count: int) -> List[float]:
    if not duration or duration <= 0:
        return [15, 45, 75, 105]
    if duration < 90:
        return [max(1, duration * frac) for frac in (0.15, 0.35, 0.6, 0.85)]
    start = min(20, duration * 0.08)
    end = max(start + 1, duration - min(20, duration * 0.08))
    if count <= 1:
        return [duration / 2]
    step = (end - start) / (count - 1)
    return [start + step * idx for idx in range(count)]


def extract_frames(video_path: Path, out_dir: Path, count: int) -> dict:
    frames_dir = out_dir / "frames"
    frames_dir.mkdir(parents=True, exist_ok=True)
    duration = probe_duration(video_path)
    frames = []
    for idx, seconds in enumerate(sample_times(duration, count), start=1):
        frame = frames_dir / f"frame_{idx:02d}_{filename_time(seconds)}.jpg"
        run(
            [
                "ffmpeg",
                "-y",
                "-hide_banner",
                "-loglevel",
                "error",
                "-ss",
                f"{seconds:.3f}",
                "-i",
                str(video_path),
                "-frames:v",
                "1",
                "-q:v",
                "3",
                str(frame),
            ]
        )
        frames.append({"path": str(frame), "timestamp": hms(seconds), "seconds": round(seconds, 3)})

    contact_sheet = out_dir / "contact-sheet.jpg"
    columns = 4
    rows = max(1, math.ceil(len(frames) / columns))
    try:
        run(
            [
                "ffmpeg",
                "-y",
                "-hide_banner",
                "-loglevel",
                "error",
                "-pattern_type",
                "glob",
                "-i",
                str(frames_dir / "frame_*.jpg"),
                "-vf",
                f"scale=320:-1,tile={columns}x{rows}",
                "-q:v",
                "3",
                str(contact_sheet),
            ]
        )
    except subprocess.CalledProcessError as exc:
        print(exc.stderr, file=sys.stderr)
        contact_sheet = None

    return {
        "duration_seconds": duration,
        "frames": frames,
        "contact_sheet": str(contact_sheet) if contact_sheet else None,
    }


def maybe_openai_transcribe(out_dir: Path, video_path: Optional[Path], allow: bool) -> dict:
    if (out_dir / "transcript.vtt").exists():
        return {"status": "skipped", "reason": "captions_found"}
    if not allow:
        return {"status": "needed_but_not_allowed", "reason": "captions_missing"}
    if not os.environ.get("OPENAI_API_KEY"):
        return {"status": "needed_but_no_api_key", "reason": "captions_missing"}
    if not video_path:
        return {"status": "needed_but_no_video", "reason": "captions_missing"}

    try:
        from openai import OpenAI  # type: ignore
    except ImportError:
        return {"status": "needed_but_openai_package_missing", "reason": "captions_missing"}

    audio_path = out_dir / "sources" / "transcription-audio.mp3"
    run(
        [
            "ffmpeg",
            "-y",
            "-hide_banner",
            "-loglevel",
            "error",
            "-i",
            str(video_path),
            "-vn",
            "-ac",
            "1",
            "-ar",
            "16000",
            "-b:a",
            "48k",
            str(audio_path),
        ]
    )
    if audio_path.stat().st_size > 24 * 1024 * 1024:
        return {
            "status": "needed_but_audio_too_large",
            "reason": "chunking_required",
            "audio_path": str(audio_path),
            "audio_size_bytes": audio_path.stat().st_size,
        }

    client = OpenAI()
    with audio_path.open("rb") as audio_file:
        transcript = client.audio.transcriptions.create(
            model="gpt-4o-mini-transcribe",
            file=audio_file,
            response_format="text",
            prompt="This is a technical YouTube video about AI workflows, Codex or Claude skills, and self-improving knowledge bases.",
        )
    text = getattr(transcript, "text", transcript)
    (out_dir / "transcript.md").write_text("# Transcript\n\n" + str(text).strip() + "\n", encoding="utf-8")
    return {
        "status": "completed",
        "model": "gpt-4o-mini-transcribe",
        "audio_path": str(audio_path),
    }


def write_manifest(out_dir: Path, payload: dict) -> None:
    (out_dir / "video-digest-manifest.json").write_text(
        json.dumps(payload, indent=2) + "\n",
        encoding="utf-8",
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("url")
    parser.add_argument("--slug", required=True)
    parser.add_argument("--output-root", default="docs/research/video-digests")
    parser.add_argument("--frame-count", type=int, default=8)
    parser.add_argument("--allow-openai-transcribe", action="store_true")
    args = parser.parse_args()

    for command in ("yt-dlp", "ffmpeg", "ffprobe"):
        require_command(command)

    out_dir = Path(args.output_root) / args.slug
    out_dir.mkdir(parents=True, exist_ok=True)
    work_dir = Path(tempfile.gettempdir()) / "speaklocal-video-digests" / args.slug

    metadata = download_metadata_and_captions(args.url, out_dir)
    caption_path = find_caption(out_dir / "sources")
    transcript_payload = None
    if caption_path:
        transcript_payload = write_transcripts(caption_path, out_dir)
        for extra_caption in (out_dir / "sources").glob("source*.vtt"):
            if extra_caption != caption_path:
                extra_caption.unlink()

    video_path = download_video(args.url, work_dir)
    frame_payload = extract_frames(video_path, out_dir, args.frame_count) if video_path else {
        "duration_seconds": metadata.get("duration"),
        "frames": [],
        "contact_sheet": None,
        "status": "video_download_failed",
    }

    openai_payload = maybe_openai_transcribe(out_dir, video_path, args.allow_openai_transcribe)
    manifest = {
        "url": args.url,
        "slug": args.slug,
        "output_dir": str(out_dir),
        "work_dir": str(work_dir),
        "metadata": metadata,
        "dependencies": {
            "yt-dlp": command_version("yt-dlp"),
            "ffmpeg": command_version("ffmpeg"),
            "ffprobe": command_version("ffprobe"),
        },
        "caption_source": str(caption_path) if caption_path else None,
        "transcript": transcript_payload,
        "frames": frame_payload,
        "openai_transcription": openai_payload,
    }
    write_manifest(out_dir, manifest)
    print(json.dumps(manifest, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

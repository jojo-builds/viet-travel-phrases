CHANGES_REQUESTED

- Marker-rule safety is not documented tightly enough: the notes still read as though the sample should not contain heavily saturated legacy rows, while the current CSV still includes older high-density anchors such as `problems-2`, `repair-2`, `taxi-1`, `directions-1`, and `directions-map-pin`.
- `relation-authoring-notes.md` visually nests the T-152 promotion block under the new T-154 insertion, which overstates T-154 scope and muddies the historical boundary.
- The worktree is dirty outside the T-154 write list, so future scope review should explicitly ignore unrelated pre-existing changes and focus on the files touched by this task.

Gate recommendation: fix the count / boundary notes and tighten the scope framing before rerunning Gate 2.

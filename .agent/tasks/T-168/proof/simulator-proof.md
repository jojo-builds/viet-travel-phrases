# T-168 Simulator Proof

Date: 2026-04-29

App launch:

```bash
SIMCTL_CHILD_SPEAKLOCAL_USE_SQLITE_GRAPH=1 xcrun simctl launch --terminate-running-process booted app.speaklocal.vietnam.native --use-sqlite-phrase-graph
```

Flow exercised:

1. Home opened with the DEBUG SQLite phrase graph switch enabled.
2. Search opened from Home and `hello` returned the SQLite-backed `Xin chào` result.
3. `Xin chào` opened as `viet-phrase-polite-1`; the page rendered database-backed sections and visible audio controls.
4. Search opened again from the detail flow and `thank you` returned `Cảm ơn`.
5. `Cảm ơn` opened as `viet-phrase-polite-2`, a SQLite relation target from `viet-phrase-polite-1` (`see_also`).
6. Back returned to `Xin chào` and exposed the forward control; forward returned to `Cảm ơn`.

Proof images:

- `01-sqlite-search-hello.png`
- `02-sqlite-detail-xin-chao.png`
- `03-sqlite-search-related-thank-you.png`
- `04-sqlite-related-thank-you-detail.png`
- `05-back-to-xin-chao-forward-available.png`
- `06-forward-to-thank-you.png`

SQLite checks used during proof:

```text
viet-phrase-polite-1|viet-phrase-polite-2|see_also|Cảm ơn
viet-phrase-polite-1|Xin chào|polite-1|Xin chào
viet-phrase-polite-2|Cảm ơn|polite-2|Cảm ơn
```

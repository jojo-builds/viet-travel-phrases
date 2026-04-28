# Native App Config

This folder is the native app-family config surface.

The SwiftUI shell is shared. Each app/language variant should eventually be selected through an app config plus a bundled language pack:

```text
Config/apps/vietnam.json
Config/apps/philippines.json
Config/apps/japan.json
Resources/LanguagePacks/<language>/
```

These files are planning/runtime-wiring truth for the native lane. They are not loaded by the app yet.


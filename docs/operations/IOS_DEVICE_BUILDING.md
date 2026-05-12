# iOS Device Building

Use this note whenever a worker needs to build, install, or launch SpeakLocal on Jojo's physical iPhone.

## Rule

Physical-device testing can be wired or wireless. The repo must stay clean either way.

Jojo's physical iPhone is the live `main` test target by default. Parallel feature branches should use their own Simulator instances; do not install a feature branch on the physical iPhone unless Jojo explicitly asks to test that branch before it merges. After feature work merges, build `main` so the phone reflects the current combined app.

Do not commit:

- personal Apple Team IDs;
- provisioning profile IDs;
- certificate fingerprints;
- phone-specific device IDs;
- phone names;
- Xcode account state.

Local signing belongs in Keychain, Xcode's local account state, or command-line build overrides only.

## Wireless Installs Are Valid

Xcode can build and run on a paired iPhone over the local network after the device has been paired and trusted. Wireless install is expected to work when:

- the iPhone was paired with Xcode;
- Developer Mode is enabled on the iPhone when required;
- the iPhone is awake, unlocked, and reachable;
- the Mac and iPhone are on the same usable local network;
- Xcode/device tools show the iPhone as an available destination.

If the phone appears as offline, unavailable, locked, or unreachable, do not force the build. Wake/unlock the phone, reconnect Wi-Fi, or plug in USB and retry.

Apple references:

- [Pairing your devices with Xcode](https://help.apple.com/xcode/mac/current/en.lproj/devbc48d1bad.html)
- [Running your app in Simulator or on a device](https://help.apple.com/xcode/mac/current/en.lproj/dev3e2f4ee6d.html)
- [Troubleshooting device connections](https://help.apple.com/xcode/mac/current/en.lproj/devac3261a70.html)
- [Enabling Developer Mode on a device](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device)

## Preferred Helper

Use the local safe helper:

```sh
/Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

When working through the parallel-feature helper, prefer:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh build-phone main
```

That wrapper refuses non-`main` phone builds by default, which helps keep Jojo's phone from being overwritten by a stale feature branch.

The helper should:

- find an available paired iPhone, wired or wireless;
- build with local signing overrides;
- install the `Debug-iphoneos` app;
- launch the app when the phone is unlocked;
- verify `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` were not polluted with signing settings.

## Useful Checks

From the repo:

```sh
xcrun xctrace list devices
xcrun devicectl list devices
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -showdestinations
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj
```

Prefer `devicectl` for modern install/launch availability. Older listing tools such as `xctrace list devices` may still show a paired wireless phone under offline devices even when `devicectl` can reach it. If tools disagree, run the safe helper once; if install or launch fails, wake/unlock the phone, reconnect Wi-Fi, or plug in USB and retry.

## Closeout

A worker that builds on the phone should report:

- whether the iPhone was wired or wireless if known;
- build result;
- install result;
- launch result, or that launch was blocked by lock/offline state;
- signing hygiene result for `project.yml` and `.xcodeproj`.

Do not paste raw device IDs, phone names, Team IDs, provisioning IDs, or certificate details into task results.

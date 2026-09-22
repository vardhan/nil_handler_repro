# issue 193097 macOS reproduction

## Requirements

- macOS with Xcode installed and its command-line tools configured.
- Flutter 3.47.5 stable available as `flutter` on `$PATH`.

## Get the reproduction

```sh
git clone https://github.com/vardhan/nil_handler_repro.git
cd nil_handler_repro
flutter --version
flutter pub get
```

## Build

```sh
flutter build macos --debug
```

If you use mise, `mise run build` runs the same command.

## Run

```sh
flutter run -d macos
```

This builds and launches the app; a separate build step is optional. The
reproduction starts automatically and is expected to crash on the affected SDK.

## Expected and actual behavior

The reproduction runs automatically. `macos/Runner/MainFlutterWindow.swift`
registers a binary message handler, then unregisters it with `nil` on the main
thread. `lib/main.dart` waits for native acknowledgement before sending to that
channel. A baseline send before registration returns `null` normally.

Expected: the send after unregistration also returns `null`.
Actual: the app crashes in `-[FlutterEngine engineCallbackOnPlatformMessage:]`
with `EXC_BAD_ACCESS` at address `0x10`.

Verified on stock Flutter 3.47.5 stable (`6a19cca564`), engine `af7e796e16`,
macOS 27.0 arm64, Xcode 26.6.

Issue: https://github.com/flutter/flutter/issues/193097

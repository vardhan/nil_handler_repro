# issue 193097 macOS reproduction

# You need:
- macOS with Xcode installed and its command-line tools configured.
- Flutter 3.47.5 stable available as `flutter` on `$PATH`.

# Pull this:

```sh
git clone https://github.com/vardhan/nil_handler_repro.git
cd nil_handler_repro
flutter --version
flutter pub get
```

# Build & Run

```sh
flutter run -d macos
```

## Expected and actual behavior

The reproduction runs automatically. `macos/Runner/MainFlutterWindow.swift`
registers a binary message handler, then unregisters it with `nil` on the main
thread. `lib/main.dart` waits for native acknowledgement before sending to that
channel. A baseline send before registration returns `null` normally.

Expected: the send after unregistration also returns `null`.
Actual: the app crashes in `-[FlutterEngine engineCallbackOnPlatformMessage:]`
with `EXC_BAD_ACCESS` at address `0x10`.

Issue: https://github.com/flutter/flutter/issues/193097

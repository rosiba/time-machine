# Time Machine

A minimal, cross-platform time tracker for freelancers. Built with Flutter.

Track time across projects, review session logs, and stay focused — without the bloat of a full project management tool.

## Features

- **Timer** — Start and stop a timer against any project. A pulsing indicator in the nav bar keeps the active session visible at a glance.
- **Projects** — Create color-coded projects to organize your work.
- **Logs** — Browse a chronological list of past sessions with start time, end time, and duration.
- **Adaptive layout** — Switches between a bottom nav bar (mobile/narrow) and a side rail (desktop/wide ≥ 640 px).
- **Light & dark theme** — Follows the system preference automatically.
- **Local storage** — All data stays on device; no account or internet connection required.

## Platforms

| Platform | Format |
|----------|--------|
| Linux | `.tar.gz`, `.deb`, `.rpm`, `.pkg.tar.zst` |
| macOS | `.dmg` |
| Windows | Installer `.exe` |
| Android | (build from source) |
| iOS | (build from source) |

## Installation

### Linux

**Debian / Ubuntu**
```bash
sudo dpkg -i time_machine-<version>-linux-amd64.deb
```

**Fedora / RHEL / openSUSE**
```bash
sudo rpm -i time_machine-<version>-linux-x86_64.rpm
```

**Arch Linux**
```bash
sudo pacman -U time_machine-<version>-linux-x86_64.pkg.tar.zst
```

**Generic tarball**
```bash
tar -xzf time_machine-linux-x64.tar.gz
./time_machine
```

### macOS

Open the `.dmg`, drag **Time Machine** to your Applications folder, then launch it from Spotlight or Finder.

### Windows

Run the `time_machine-windows-x64-setup.exe` installer and follow the on-screen steps.

## Building from Source

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, Dart ≥ 3.3)
- Platform toolchain for your target (Xcode for macOS/iOS, Android SDK for Android, GTK dev libs for Linux)

### Steps

```bash
git clone https://github.com/<your-username>/time-machine.git
cd time-machine
flutter pub get
flutter run                    # run in debug mode on a connected device / desktop
flutter build <platform>       # linux | macos | windows | apk | ios
```

Replace `<platform>` with the target you want to build for.

## Tech Stack

| Layer | Library |
|-------|---------|
| UI framework | Flutter / Material 3 |
| State management | `provider` |
| Persistence | `path_provider` + JSON files |
| IDs | `uuid` |

## Project Structure

```
lib/
  main.dart               # app entry point, theme, provider wiring
  models/
    project.dart          # Project model
    time_log.dart         # TimeLog model
  providers/
    projects_provider.dart
    logs_provider.dart
    timer_provider.dart
  screens/
    home_screen.dart      # navigation shell (rail / bottom bar)
    timer_tab.dart
    projects_tab.dart
    logs_tab.dart
  services/
    storage_service.dart  # read/write JSON to disk
```

## License

MIT

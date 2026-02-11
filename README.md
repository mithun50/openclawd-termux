# OpenClaw

[![Download APK](https://img.shields.io/badge/Download-APK-green?style=for-the-badge&logo=android)](https://github.com/mithun50/openclawd-termux/releases/download/v1.0.1/OpenClaw-v1.0.1-universal.apk)
[![Build Flutter APK & AAB](https://github.com/mithun50/openclawd-termux/actions/workflows/flutter-build.yml/badge.svg)](https://github.com/mithun50/openclawd-termux/actions/workflows/flutter-build.yml)
[![npm version](https://img.shields.io/npm/v/openclawd-termux?color=blue&label=npm)](https://www.npmjs.com/package/openclawd-termux)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-22-green?logo=node.js)](https://nodejs.org/)
[![Android](https://img.shields.io/badge/Android-10%2B-brightgreen?logo=android)](https://www.android.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.24-02569B?logo=flutter)](https://flutter.dev/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/mithun50/openclawd-termux/pulls)

<p align="center">
  <img src="assets/mockup.png" alt="OpenClaw App Mockup" width="700"/>
</p>

> Run **OpenClaw AI Gateway** on Android — standalone Flutter app with built-in terminal, web dashboard, and one-tap setup. Also available as a Termux CLI package.

---

## Screenshots

<p align="center">
  <img src="assets/dashboard.png" alt="Dashboard" width="220"/>
  <img src="assets/setupscreen.png" alt="Setup" width="220"/>
  <img src="assets/onboardingscreen.png" alt="Onboarding" width="220"/>
</p>

<p align="center">
  <img src="assets/websscreen.png" alt="Web Dashboard" width="220"/>
  <img src="assets/logscreen.png" alt="Logs" width="220"/>
  <img src="assets/settingsscreen.png" alt="Settings" width="220"/>
</p>

---

## What is OpenClaw?

OpenClaw brings the [OpenClaw](https://github.com/anthropics/openclaw) AI gateway to Android. It sets up a full Ubuntu environment via proot, installs Node.js and OpenClaw, and provides a native Flutter UI to manage everything — no root required.

### Two Ways to Use

| | **Flutter App** (Standalone) | **Termux CLI** |
|---|---|---|
| Install | Build APK or download release | `npm install -g openclawd-termux` |
| Setup | Tap "Begin Setup" | `openclawdx setup` |
| Gateway | Tap "Start Gateway" | `openclawdx start` |
| Terminal | Built-in terminal emulator | Termux shell |
| Dashboard | Built-in WebView | Browser at `localhost:18789` |

---

## Features

### Flutter App
- **One-Tap Setup** — Downloads Ubuntu rootfs, Node.js 22, and OpenClaw automatically
- **Built-in Terminal** — Full terminal emulator with extra keys toolbar, copy/paste, clickable URLs
- **Gateway Controls** — Start/stop gateway with status indicator and health checks
- **Token URL Display** — Captures auth token from onboarding, shows it with a copy button
- **Web Dashboard** — Embedded WebView loads the dashboard with authentication token
- **View Logs** — Real-time gateway log viewer with search/filter
- **Onboarding** — Configure API keys and binding directly in-app
- **Settings** — Auto-start, battery optimization, system info, re-run setup
- **Foreground Service** — Keeps the gateway alive in the background with uptime tracking
- **Setup Notifications** — Progress bar notifications during environment setup

### Termux CLI
- **One-Command Setup** — Installs proot-distro, Ubuntu, Node.js 22, and OpenClaw
- **Bionic Bypass** — Fixes `os.networkInterfaces()` crash on Android's Bionic libc
- **Smart Loading** — Shows spinner until the gateway is ready
- **Pass-through Commands** — Run any OpenClaw command via `openclawdx`

---

## Quick Start

### Flutter App (Recommended)

1. Download the latest APK from [Releases](https://github.com/mithun50/openclawd-termux/releases)
2. Install the APK on your Android device
3. Open the app and tap **Begin Setup**
4. After setup completes, configure your API keys in **Onboarding**
5. Tap **Start Gateway** on the dashboard

Or build from source:

```bash
git clone https://github.com/mithun50/openclawd-termux.git
cd openclawd-termux/flutter_app
flutter build apk --release
```

### Termux CLI

#### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mithun50/openclawd-termux/main/install.sh | bash
```

#### Or via npm

```bash
npm install -g openclawd-termux
openclawdx setup
```

---

## Requirements

| Requirement | Details |
|-------------|---------|
| **Android** | 10 or higher (API 29) |
| **Storage** | ~500MB for Ubuntu + Node.js + OpenClaw |
| **Architectures** | arm64-v8a, armeabi-v7a, x86_64 |
| **Termux** (CLI only) | From [F-Droid](https://f-droid.org/packages/com.termux/) (NOT Play Store) |

---

## CLI Usage

```bash
# First-time setup (installs proot + Ubuntu + Node.js + OpenClaw)
openclawdx setup

# Check installation status
openclawdx status

# Start OpenClaw gateway
openclawdx start

# Run onboarding to configure API keys
openclawdx onboarding

# Enter Ubuntu shell
openclawdx shell

# Any OpenClaw command works directly
openclawdx doctor
openclawdx gateway --verbose
```

---

## Architecture

```
┌──────────────────────────────────────────────┐
│              Flutter App (Dart)               │
│  ┌──────────┐ ┌──────────┐ ┌──────────────┐  │
│  │ Terminal  │ │ Gateway  │ │ Web Dashboard│  │
│  │ Emulator  │ │ Controls │ │   (WebView)  │  │
│  └─────┬────┘ └─────┬────┘ └──────┬───────┘  │
│        │            │             │           │
│  ┌─────┴────────────┴─────────────┴────────┐  │
│  │         Native Bridge (Kotlin)          │  │
│  └─────────────────┬───────────────────────┘  │
└────────────────────┼─────────────────────────┘
                     │
┌────────────────────┼─────────────────────────┐
│  proot-distro      │          Ubuntu          │
│  ┌─────────────────┴──────────────────────┐   │
│  │   Node.js 22 + Bionic Bypass           │   │
│  │   ┌─────────────────────────────────┐  │   │
│  │   │  OpenClaw AI Gateway            │  │   │
│  │   │  http://localhost:18789         │  │   │
│  │   └─────────────────────────────────┘  │   │
│  └────────────────────────────────────────┘   │
└───────────────────────────────────────────────┘
```

### Flutter App Structure

```
flutter_app/lib/
├── main.dart                  # App entry point
├── constants.dart             # App constants, URLs, author info
├── models/
│   ├── gateway_state.dart     # Gateway status, logs, token URL
│   └── setup_state.dart       # Setup wizard progress
├── providers/
│   ├── gateway_provider.dart  # Gateway state management
│   └── setup_provider.dart    # Setup state management
├── screens/
│   ├── splash_screen.dart     # Launch screen with routing
│   ├── setup_wizard_screen.dart # First-time environment setup
│   ├── onboarding_screen.dart # API key configuration terminal
│   ├── dashboard_screen.dart  # Main dashboard with quick actions
│   ├── terminal_screen.dart   # Full terminal emulator
│   ├── web_dashboard_screen.dart # WebView for OpenClaw dashboard
│   ├── logs_screen.dart       # Gateway log viewer
│   └── settings_screen.dart   # App settings and about
├── services/
│   ├── native_bridge.dart     # Kotlin platform channel bridge
│   ├── gateway_service.dart   # Gateway lifecycle and health checks
│   ├── terminal_service.dart  # proot shell configuration
│   ├── bootstrap_service.dart # Environment setup orchestration
│   └── preferences_service.dart # Persistent settings (token URL, etc.)
└── widgets/
    ├── gateway_controls.dart  # Start/stop, URL display, copy button
    ├── terminal_toolbar.dart  # Extra keys (Tab, Ctrl, Esc, arrows)
    ├── status_card.dart       # Reusable status card
    └── progress_step.dart     # Setup wizard step indicator
```

---

## Configuration

### Onboarding

When running onboarding (in-app or via `openclawdx onboarding`):

- **Binding**: Select `Loopback (127.0.0.1)` for non-rooted devices
- **API Keys**: Add your Gemini/OpenAI/Claude keys
- **Token URL**: The app automatically captures and stores the auth token URL (e.g. `http://localhost:18789/#token=...`)

### Battery Optimization

> **Important:** Disable battery optimization for the app to keep the gateway alive in the background.

**For the Flutter app:** Settings > Battery Optimization > tap to disable

**For Termux:** Android Settings > Apps > Termux > Battery > **Unrestricted**

---

## Dashboard

Access the web dashboard at the token URL shown in the app (e.g. `http://localhost:18789/#token=...`).

The Flutter app automatically loads the dashboard with your auth token via the built-in WebView.

| Command | Description |
|---------|-------------|
| `/status` | Check gateway status |
| `/think high` | Enable high-quality thinking |
| `/reset` | Reset session |

---

## Troubleshooting

### Gateway won't start

```bash
# Check status
openclawdx status

# Re-run setup if needed
openclawdx setup

# Make sure onboarding is complete
openclawdx onboarding
```

### "os.networkInterfaces" error

Bionic Bypass not configured. Run setup again:

```bash
openclawdx setup
```

### Process killed in background

Disable battery optimization for the app in Android settings.

### Permission denied

```bash
termux-setup-storage
```

---

## Manual Setup

<details>
<summary>Click to expand manual installation steps</summary>

### 1. Install proot-distro and Ubuntu

```bash
pkg update && pkg install -y proot-distro
proot-distro install ubuntu
```

### 2. Setup Node.js in Ubuntu

```bash
proot-distro login ubuntu
apt update && apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
npm install -g openclaw
```

### 3. Create Bionic Bypass

```bash
mkdir -p ~/.openclawd
cat > ~/.openclawd/bionic-bypass.js << 'EOF'
const os = require('os');
const originalNetworkInterfaces = os.networkInterfaces;
os.networkInterfaces = function() {
  try {
    const interfaces = originalNetworkInterfaces.call(os);
    if (interfaces && Object.keys(interfaces).length > 0) {
      return interfaces;
    }
  } catch (e) {}
  return {
    lo: [{
      address: '127.0.0.1',
      netmask: '255.0.0.0',
      family: 'IPv4',
      mac: '00:00:00:00:00:00',
      internal: true,
      cidr: '127.0.0.1/8'
    }]
  };
};
EOF
```

### 4. Add to bashrc

```bash
echo 'export NODE_OPTIONS="--require ~/.openclawd/bionic-bypass.js"' >> ~/.bashrc
source ~/.bashrc
```

### 5. Run OpenClaw

```bash
openclaw onboarding  # Select "Loopback (127.0.0.1)"
openclaw gateway --verbose
```

</details>

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Author

**Mithun Gowda B** | [NextGenX](https://play.google.com/store/apps/dev?id=8262374975871504599)

- GitHub: [@mithun50](https://github.com/mithun50)
- Email: [mithungowda.b7411@gmail.com](mailto:mithungowda.b7411@gmail.com)
- Instagram: [@nexgenxplorer_nxg](https://www.instagram.com/nexgenxplorer_nxg)
- YouTube: [@nexgenxplorer](https://youtube.com/@nexgenxplorer?si=UG-wBC8UIyeT4bbw)
- Play Store: [NextGenX Apps](https://play.google.com/store/apps/dev?id=8262374975871504599)
- Contact: [nxgextra@gmail.com](mailto:nxgextra@gmail.com)

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with &#10084;&#65039; for the Android community by <a href="https://github.com/mithun50">Mithun Gowda B</a> | <b>NextGenX</b>
</p>

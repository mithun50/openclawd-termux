# OpenClawd-Termux

[![npm version](https://img.shields.io/npm/v/openclawd-termux?color=blue&label=npm)](https://www.npmjs.com/package/openclawd-termux)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green?logo=node.js)](https://nodejs.org/)
[![Android](https://img.shields.io/badge/Android-10%2B-brightgreen?logo=android)](https://www.android.com/)
[![Termux](https://img.shields.io/badge/Termux-F--Droid-orange)](https://f-droid.org/packages/com.termux/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/mithun50/openclawd-termux/pulls)

> Run OpenClaw AI Gateway on Android using Termux with automatic proot Ubuntu setup and Bionic Bypass fix.

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Termux-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Status-Active-success" alt="Status">
</p>

---

## Features

- **One-Command Setup** - Automatically installs proot-distro, Ubuntu, Node.js 22, and OpenClaw
- **Bionic Bypass** - Fixes `os.networkInterfaces()` crash on Android's Bionic libc
- **Smart Loading** - Shows spinner until gateway is actually ready
- **Pass-through Commands** - Run any OpenClaw command directly via `openclawdx`

---

## Quick Install

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mithun50/openclawd-termux/main/install.sh | bash
```

### Or via npm

```bash
npm install -g openclawd-termux
openclawdx setup
```

---

## Requirements

| Requirement | Details |
|-------------|---------|
| **Android** | 10 or higher |
| **Termux** | From [F-Droid](https://f-droid.org/packages/com.termux/) (NOT Play Store) |
| **Storage** | ~2GB for Ubuntu + OpenClaw |

---

## Usage

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

## How It Works

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│     Termux      │     │  proot-distro   │     │     Ubuntu      │
│   openclawdx    │ ──► │                 │ ──► │    OpenClaw     │
│                 │     │  Bionic Bypass  │     │    Gateway      │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

1. **openclawdx** runs in Termux
2. Commands are passed through **proot-distro** with Bionic Bypass
3. **OpenClaw** runs inside Ubuntu environment

---

## Configuration

### Onboarding

When running `openclawdx onboarding`:

- **Binding**: Select `Loopback (127.0.0.1)` for non-rooted devices
- **API Keys**: Add your Gemini/OpenAI/Claude keys

### Battery Optimization

> **Important:** Disable battery optimization for Termux

Settings → Apps → Termux → Battery → **Unrestricted**

---

## Dashboard

Access the web dashboard at: **http://127.0.0.1:18789**

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

Bionic Bypass not configured. Run:

```bash
openclawdx setup
```

### Process killed in background

Disable battery optimization for Termux in Android settings.

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

## Credits

- Based on the guide by [Sagar Tamang](https://sagartamang.com/blog/openclaw-on-android-termux)
- [OpenClaw](https://github.com/anthropics/openclaw) project

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ for the Android community
</p>

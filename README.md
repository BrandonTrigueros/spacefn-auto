# SpaceFn Auto

> 🚀 **Spacebar as a modifier key with automatic multi-keyboard support**

SpaceFn Auto is an enhanced version of spacefn-evdev that allows you to use the spacebar as a modifier key for additional keyboard functions. It features automatic detection of multiple keyboards, automated dependency installation, and systemd integration.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)]()
[![Language: C](https://img.shields.io/badge/Language-C-orange.svg)]()

## ✨ Features

- 🔧 **Automatic keyboard detection** - Works with multiple keyboards simultaneously
- 📦 **Automated installation** - One-click setup with dependency management
- 🔄 **Systemd integration** - Automatic startup and service management
- 📊 **Real-time monitoring** - Live logs and status monitoring
- 🛠️ **Easy uninstallation** - Complete system cleanup

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/BrandonTrigueros/spacefn-auto.git
cd spacefn-auto

# Run installation script
sudo ./install.sh
```

## 📁 Project Structure

```
spacefn-auto/
├── spacefn.c                 # Main SpaceFn implementation (enhanced from original)
├── spacefn                   # Compiled binary (auto-generated)
├── spacefn-auto.sh          # Service control script
├── install.sh               # Automated installation
├── uninstall.sh             # Complete uninstallation
├── spacefn-auto.service     # Systemd service file
├── 99-spacefn-keyboards.rules # Udev rules (optional)
├── README.md                # This documentation
├── LICENSE.md               # License information
└── .gitignore               # Git ignore rules
```

## ⚡️ Installation

### Automated Installation (Recommended)

```bash
sudo ./install.sh
```

This script automatically:
- Detects your Linux distribution
- Installs necessary dependencies (`libevdev-dev`, `build-essential`, etc.)
- Compiles the binary
- Sets up systemd service
- Starts spacefn for all detected keyboards

### Manual Installation

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install build-essential libevdev-dev pkg-config

# Compile
cc `pkg-config --cflags libevdev` spacefn.c -o spacefn `pkg-config --libs libevdev`

# Start manually
sudo ./spacefn-auto.sh start
```

## ⚙️ Usage

### Service Management

```bash
# Start all keyboards
sudo ./spacefn-auto.sh start

# Stop all keyboards
sudo ./spacefn-auto.sh stop

# Check status
sudo ./spacefn-auto.sh status

# Restart service
sudo systemctl restart spacefn-auto
```

## 🔧 Key Mappings

When SpaceFn is active, holding Space + another key provides additional functionality:

| Key Combo | Function | Description |
|-----------|----------|-------------|
| Space + H | Left Arrow | Move cursor left |
| Space + J | Down Arrow | Move cursor down |
| Space + K | Up Arrow | Move cursor up |
| Space + L | Right Arrow | Move cursor right |
| Space + A | Home | Move to beginning of line |
| Space + E | End | Move to end of line |
| Space + D | Delete | Delete character |
| Space + U | Page Up | Scroll up |
| Space + N | Page Down | Scroll down |

*Note: Timeout is 200ms - if you release Space within this time, it acts as a normal spacebar.*

## 🔧 Development

### Building from Source
```bash
# Install dependencies
sudo apt install build-essential libevdev-dev pkg-config

# Compile
cc `pkg-config --cflags libevdev` spacefn.c -o spacefn `pkg-config --libs libevdev`

# Test
sudo ./spacefn /dev/input/event0
```

## 📋 System Requirements

- **OS**: Linux (Ubuntu/Debian recommended)
- **Architecture**: x86_64
- **RAM**: 50MB minimum
- **Dependencies**: 
  - libevdev-dev (auto-installed)
  - build-essential (auto-installed)
  - pkg-config (auto-installed)

## 🗑️ Uninstallation

```bash
sudo ./uninstall.sh
```

This will completely remove:
- Systemd services
- Compiled binaries
- Configuration files
- Udev rules
- Log files

## 🐛 Troubleshooting

### Common Issues

**Service won't start:**
```bash
# Check service status
systemctl status spacefn-auto

# Check logs
journalctl -u spacefn-auto -f
```

**Permission issues:**
```bash
# Add user to input group
sudo usermod -a -G input $USER
# Logout and login again
```

**Multiple keyboards not detected:**
```bash
# List input devices
ls /dev/input/event*
# Check detection
sudo ./spacefn-auto.sh status
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

### Attribution

- **Original spacefn-evdev**: Copyright (c) 2014 James Laird-Wah
- **SpaceFn Auto enhancements**: Copyright (c) 2025 Brandon Trigueros

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/BrandonTrigueros/spacefn-auto/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/BrandonTrigueros/spacefn-auto/discussions)

## 🌟 Acknowledgments

Special thanks to [James Laird-Wah](https://github.com/jameslaird-wah) for the original spacefn-evdev implementation that made this project possible.

## 🔄 Differences from Original Project

This version includes significant improvements over the [original spacefn-evdev by James Laird-Wah](https://github.com/abrasive/spacefn-evdev):

### ✨ **New Features**:
1. **Automatic multi-keyboard management** - Original handles only one keyboard
2. **Automated dependency installation** - Original requires manual setup
3. **Systemd service for auto-startup** - Original has no service management
4. **Centralized logging system** - Original has no organized logs
5. **Advanced management scripts** - Original only has basic binary
6. **Intelligent device detection** - Original requires manual device specification

### 🛠️ **Code Base**:
- Core `spacefn.c` maintains James Laird-Wah's original logic
- Added automation and management scripts (`spacefn-auto.sh`, `install.sh`, `uninstall.sh`)
- Enhanced user experience with automatic installation and configuration

---

<div align="center">
  <strong>Made with ❤️ for the Linux community</strong>
</div>

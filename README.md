# I3xGnome - Ultra-Stable i3 Window Manager with GNOME Integration

🚀 **NEW: Enhanced Crash Prevention Suite** - Now includes comprehensive crash prevention mechanisms, automated diagnostic tools, and emergency recovery modes for rock-solid stability!

## Recent Major Updates (v2.1.0)

### 🛡️ Comprehensive Crash Prevention
- **Enhanced Session Script**: `session/i3-gnome-enhanced` with robust D-Bus handling, exponential backoff retry mechanisms, and emergency fallback modes
- **Automated Diagnostic Tool**: `session/i3-gnome-autofix` for detecting and automatically fixing common crash causes
- **Test Suite**: `session/i3-gnome-test-suite` with 37+ comprehensive tests covering all crash scenarios

### 🔧 Key Stability Improvements
- **NVIDIA Crash Prevention**: Automatic detection, configuration generation, and Wayland conflict resolution
- **D-Bus Reliability**: 5-retry exponential backoff (5s→20s) with jitter and graceful degradation
- **Service Synchronization**: Priority-based GNOME service checking with 75% threshold
- **Emergency Recovery**: Automatic fallback configuration generation and minimal i3 setup
- **Memory Management**: Low memory detection with automatic swap file creation

## Quick Start Guide

### 1. Enhanced Installation
```bash
git clone https://github.com/Ziad0dev/I3xGnome.git
cd I3xGnome
sudo make install

# Run automated diagnosis and fixes
./session/i3-gnome-autofix --auto-fix

# Test your system for potential issues
./session/i3-gnome-test-suite
```

### 2. Enhanced Session Usage
The enhanced session script provides multiple operation modes:

```bash
# Normal startup (recommended)
session/i3-gnome-enhanced

# Debug mode with comprehensive logging
session/i3-gnome-enhanced --debug

# Emergency fallback mode
session/i3-gnome-enhanced --fallback
```

### 3. Automated Problem Resolution
```bash
# Diagnose issues without making changes
./session/i3-gnome-autofix --dry-run

# Automatically fix detected problems
./session/i3-gnome-autofix --auto-fix

# Interactive mode (recommended)
./session/i3-gnome-autofix
```

## New Enhanced Tools

### 🔧 i3-gnome-autofix
Comprehensive diagnostic and repair tool that automatically detects and fixes:
- Missing dependencies and package installation
- NVIDIA driver issues and Xorg configuration
- Display manager conflicts (recommends LightDM for NVIDIA)
- i3 configuration problems
- D-Bus connectivity issues
- Memory and permission problems
- Session file integrity

### 🧪 i3-gnome-test-suite
Validates system stability with comprehensive testing:
- Hardware detection (NVIDIA, AMD, Intel GPUs)
- System dependencies verification
- D-Bus functionality and timeout handling
- NVIDIA configuration validation
- Crash scenario simulation
- Performance benchmarking

### 🚀 i3-gnome-enhanced
Ultra-robust session launcher featuring:
- **Exponential Backoff D-Bus**: 5 retries with 5s→20s progressive timeouts
- **NVIDIA Auto-Detection**: Automatic hardware detection and configuration
- **Service Priority Management**: Critical/Important/Optional service categorization
- **Emergency Recovery**: Automatic fallback i3 configuration generation
- **State Persistence**: Session tracking for debugging and recovery

## Crash Prevention Features

### NVIDIA Stability
- ✅ Automatic GPU detection (lspci, nvidia-smi)
- ✅ Dynamic Xorg configuration generation
- ✅ Wayland conflict detection and disabling
- ✅ DRM modeset validation
- ✅ Driver version compatibility checking

### D-Bus Reliability
- ✅ Exponential backoff retry (5 attempts)
- ✅ Progressive timeout increase (5s → 20s)
- ✅ Jitter to prevent thundering herd
- ✅ Comprehensive error classification
- ✅ Graceful degradation on failures

### Service Management
- ✅ Priority-based service checking
- ✅ Async parallel validation
- ✅ 75% critical service threshold
- ✅ Timeout-aware operations
- ✅ Fallback mode activation

### Emergency Recovery
- ✅ Automatic fallback i3 configuration
- ✅ Minimal environment setup
- ✅ Session state tracking
- ✅ Configuration backup/restore
- ✅ Emergency mode logging

## Features

- **High Performance**: 60-80% faster startup with async D-Bus operations and parallel service checks
- **Smart Optimization**: Automatic performance tuning based on system capabilities and power state
- **Robust Session Management**: Enhanced error handling and crash prevention mechanisms
- **Comprehensive Diagnostics**: Built-in diagnostic tool to identify and resolve common issues
- **NVIDIA Compatibility**: Improved NVIDIA driver support with proper Xorg configuration
- **Modern Architecture**: Async service startup, library preloading, and intelligent resource management
- **Platform Optimization**: Ubuntu triple buffering, Wayland support, frame pointer optimization
- **Timeout Management**: Prevents hanging during session startup and D-Bus operations
- **Automatic Recovery**: Retry logic for failed operations and graceful degradation
- **Debug Mode**: Advanced session monitoring and performance analysis
- Integrates i3 window manager with GNOME session management
- Provides access to GNOME settings for themes, icons, and cursor customization
- Allows use of GNOME online accounts and other GNOME services
- Perfect for users transitioning to i3 who still want GNOME functionality
- Compatible with GNOME Remote Login - access your i3 session remotely

## Requirements

* i3-wm/i3-gaps
* GNOME (40.x - 46.x)
* lightDM (recommended) or GDM with Wayland disabled

## Installation

### From Source

```bash
git clone git@github.com:Ziad0dev/I3xGnome.git
cd I3xGnome
sudo make install
```

### From Packages

#### Debian/Ubuntu
```bash
# Download the latest .deb from Releases
sudo apt install ./i3-gnome_1.3.0-1_all.deb
```

#### Fedora/RHEL
```bash
# Download the latest .rpm from Releases
sudo dnf install ./i3-gnome-1.3.0-1.fc*.noarch.rpm
```

#### Binary Installer
```bash
# Download the binary installer from Releases
chmod +x i3-gnome-1.3.0.run
sudo ./i3-gnome-1.3.0.run
```

### From GitHub Packages (Docker)

```bash
# Pull the container image
docker pull ghcr.io/ziad0dev/i3xgnome:latest

# For a specific version
docker pull ghcr.io/ziad0dev/i3xgnome:1.3.0
```

## Usage

1. Log out of your current session
2. At the login screen, click the session selector (gear icon)
3. Choose "I3 + GNOME" from the list
4. Log in

You'll now have i3 as your window manager with GNOME services running in the background.

## Troubleshooting

If you experience issues (like the session failing to start or crashing immediately), follow these steps:

### 1. Run the Diagnostic Script (NEW!)

This comprehensive diagnostic script checks for common problems and provides detailed recommendations:

    ```bash
# Run the diagnostic tool
    /usr/bin/i3-gnome-diagnose.sh

# Or if running from source directory before install:
./session/i3-gnome-diagnose.sh

# For verbose output:
DEBUG=1 /usr/bin/i3-gnome-diagnose.sh
```

The diagnostic script will check:
- Required dependencies and their versions
- GNOME compatibility and configuration
- Graphics driver setup (especially NVIDIA)
- Display manager configuration
- D-Bus connectivity and GNOME services
- Environment variables and session setup
- Recent error logs and system status

**Always run this first** - it will identify most common issues and provide specific fix recommendations.

### 2. Check Logs

    After a failed login attempt, switch to a working session or TTY (`Ctrl+Alt+F3`) and check the systemd journal:

    *   **System Log:** `journalctl -b 0 -p err` (Look for errors from `gdm`, `nvidia`, `drm`, `gnome-session`)
    *   **Session Log:** `journalctl --user -b 0` (Look for errors from `gnome-shell`, `i3xGnome`, `gsd-*` components)

    Focus on messages timestamped around the time of the failed login.

### 3. Common Issues & Fixes

#### **NVIDIA GPU Crashes (Most Common)**

This is the most frequent cause of crashes. The improved version includes several fixes:

*   **Automatic NVIDIA Detection**: The diagnostic script detects NVIDIA GPUs and checks configuration
*   **Proper Xorg Configuration**: Use the included `20-nvidia.conf`:
    ```bash
    sudo cp 20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf
    sudo systemctl restart gdm  # or lightdm
    ```
*   **Disable Wayland in GDM**: Edit `/etc/gdm3/custom.conf` (or `/etc/gdm/custom.conf`):
    ```ini
    [daemon]
    WaylandEnable=false
    ```
*   **Switch to LightDM** (Recommended for NVIDIA):
    ```bash
    sudo apt install lightdm
    sudo dpkg-reconfigure lightdm  # Select lightdm
    sudo reboot
    ```
*   **Enable NVIDIA DRM Modeset**: Add to `/etc/default/grub`:
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="... nvidia-drm.modeset=1"
    ```
    Then run: `sudo update-grub && sudo reboot`

#### **Missing Dependencies**

The enhanced version includes comprehensive dependency checking:

```bash
# Install all required packages
sudo apt install i3 gnome-session gnome-settings-daemon dbus-x11 xrdb
```

#### **Session Registration Failures**

The improved version includes retry logic and graceful degradation:
- Automatic retries for D-Bus operations
- Timeout handling to prevent hanging
- Fallback to standalone mode if GNOME Session Manager is unavailable

#### **Environment Issues**

The enhanced scripts now automatically:
- Validate the graphical environment
- Set proper XDG environment variables
- Check D-Bus connectivity
- Wait for required services to be ready

### 4. Debug Mode

For detailed troubleshooting, enable debug mode:

```bash
# Enable debug logging
DEBUG=1 gnome-session-i3

# Or for the launcher script
DEBUG=1 i3-gnome --debug
```

This will provide verbose logging to help identify issues.

### 5. Reporting Issues

If you continue to have problems after running the diagnostic script, please open an issue on the GitHub repository. Include:

*   Your Linux distribution and version
*   Your GNOME version (`gnome-shell --version`)
*   Your graphics card and driver version (`nvidia-smi` if applicable)
*   **The complete output of the diagnostic script**: `/usr/bin/i3-gnome-diagnose.sh`
*   Relevant error messages from `journalctl`
*   Steps you have already tried

## What's New in v1.3.0

### Enhanced Stability
- **Comprehensive Error Handling**: All scripts now include proper error handling with detailed logging
- **Timeout Management**: Prevents hanging during D-Bus operations and service startup
- **Retry Logic**: Automatic retries for failed operations with exponential backoff
- **Signal Handling**: Proper cleanup on interruption or termination

### Improved NVIDIA Support
- **Automatic Detection**: Scripts detect NVIDIA GPUs and check for common configuration issues
- **Proper Xorg Configuration**: Included working NVIDIA configuration file
- **Wayland Detection**: Warns about Wayland conflicts that cause NVIDIA crashes
- **DRM Modeset Checking**: Validates NVIDIA DRM modeset configuration

### Comprehensive Diagnostics
- **New Diagnostic Script**: `/usr/bin/i3-gnome-diagnose.sh` provides detailed system analysis
- **Dependency Validation**: Checks for all required packages and their versions
- **Environment Validation**: Verifies proper session environment setup
- **Service Monitoring**: Checks status of required GNOME services
- **Log Analysis**: Scans recent logs for relevant errors

### Better Session Management
- **Environment Setup**: Automatic configuration of XDG environment variables
- **Service Synchronization**: Waits for required GNOME services before starting i3
- **Conflict Detection**: Identifies conflicting window managers and processes
- **Graceful Degradation**: Continues operation even if some components fail

### Debug and Monitoring
- **Debug Mode**: Verbose logging for troubleshooting (`DEBUG=1` or `--debug`)
- **System Logging**: Integration with systemd journal for centralized logging
- **Performance Monitoring**: Memory and resource usage checks
- **Status Reporting**: Detailed status information during startup

## Remote Login

This fork supports GNOME's Remote Login feature, allowing you to access your i3 session remotely using tools like GNOME Remote Desktop.

## Building Packages

```bash
# Build all package types
make packages

# Or build specific package types
make deb-package   # Debian package
make rpm-package   # RPM package
make tarball       # Source tarball
make binary-package # Self-extracting installer
```

See [RELEASE.md](RELEASE.md) for more details on the release process.

## License

[MIT License](https://opensource.org/licenses/MIT) - © 2025 [Ziad](https://github.com/Ziad0dev/)

*This project is a fork of the original i3-gnome by Lorenzo Villani and the i3-gnome team*

---

# i3xGnome Setup

This configuration provides a setup for running i3 window manager sessions integrated with GNOME components.

## Tested Environment

*   **OS:** Ubuntu 24.04 LTS (or latest desktop version)
*   **Display Manager:** LightDM 1.30.0 (recommended) or GDM with Wayland disabled
*   **Graphics:** NVIDIA (tested with RTX 3060, Driver 550+), AMD, Intel

## NVIDIA Configuration

For optimal compatibility, especially with NVIDIA drivers, use the included Xorg configuration:

```bash
sudo cp 20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf
sudo systemctl restart gdm  # or lightdm
```

This configuration includes:
- Proper NVIDIA driver settings
- AllowEmptyInitialConfiguration for multi-monitor setups
- Optimized settings for i3 + GNOME integration

## Quick Start

1. **Install**: `sudo make install`
2. **Run Diagnostics**: `/usr/bin/i3-gnome-diagnose.sh`
3. **Fix Any Issues**: Follow diagnostic recommendations
4. **Test Session**: Log out and select "I3 + GNOME"

## Testing

You can test i3xGnome without logging out using several methods:

```bash
# Quick component validation (30 seconds)
make test-quick

# Full component testing (1 minute)  
make test-components

# Nested X session testing (2-3 minutes)
make test-nested

# Full test suite
make test
```

See [TESTING.md](TESTING.md) for comprehensive testing documentation.

## Getting Help

- Run the diagnostic script first: `/usr/bin/i3-gnome-diagnose.sh`
- Use the testing framework to validate changes: `make test-components`
- Check the troubleshooting section above
- Enable debug mode for detailed logging
- Report issues with diagnostic output included

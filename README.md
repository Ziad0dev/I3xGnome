# I3xGnome

<p align="center">
  <img src="https://i.imgur.com/Ia1pJUK.png" width="45%" height="45%">
</p>

A fork of the [original i3-gnome project](https://github.com/i3-gnome/i3-gnome) updated to work with modern GNOME versions.

This integration allows you to use i3wm with GNOME Session infrastructure.

## Features

- Integrates i3 window manager with GNOME session management
- Provides access to GNOME settings for themes, icons, and cursor customization
- Allows use of GNOME online accounts and other GNOME services
- Perfect for users transitioning to i3 who still want GNOME functionality
- Compatible with GNOME Remote Login - access your i3 session remotely

## Requirements

* i3-wm/i3-gaps
* GNOME (46.x)
* GDM (recommended)

## Installation

### From Source

```bash
git clone git@github.com:Ziad0dev/I3xGnome.git
cd i3-gnome-fork
sudo make install
```

### From Packages

#### Debian/Ubuntu
```bash
# Download the latest .deb from Releases
sudo apt install ./i3-gnome_1.2.0-1_all.deb
```

#### Fedora/RHEL
```bash
# Download the latest .rpm from Releases
sudo dnf install ./i3-gnome-1.2.0-1.fc*.noarch.rpm
```

#### Binary Installer
```bash
# Download the binary installer from Releases
chmod +x i3-gnome-1.2.0.run
sudo ./i3-gnome-1.2.0.run
```

### From GitHub Packages (Docker)

```bash
# Pull the container image
docker pull ghcr.io/n3ros/i3-gnome:latest

# For a specific version
docker pull ghcr.io/n3ros/i3-gnome:1.2.0
```

## Usage

1. Log out of your current session
2. At the login screen, click the session selector (gear icon)
3. Choose "I3 + GNOME" from the list
4. Log in

You'll now have i3 as your window manager with GNOME services running in the background.

## Troubleshooting

If you experience issues (like the session failing to start or crashing immediately), follow these steps:

1.  **Run the Diagnostic Script:**
    This script checks for common problems like missing dependencies, incorrect installation, or configuration issues.
    ```bash
    /usr/bin/i3-gnome-diagnose.sh
    # Or if run from source directory before install:
    # ./session/i3-gnome-diagnose.sh
    ```
    Review the output, especially the "Recommendations" section. You might need to run it with `sudo` for some checks (like NVIDIA modeset status) to work fully.

2.  **Check Logs:**
    After a failed login attempt, switch to a working session or TTY (`Ctrl+Alt+F3`) and check the systemd journal:
    *   **System Log:** `journalctl -b 0 -p err` (Look for errors from `gdm`, `nvidia`, `drm`, `gnome-session`)
    *   **Session Log:** `journalctl --user -b 0` (Look for errors from `gnome-shell`, `i3-gnome`, `gsd-*` components)
    Focus on messages timestamped around the time of the failed login.

3.  **Common Issues & Fixes:**

    *   **Crash ("A problem has occurred...") with NVIDIA Drivers:** This is a known and difficult issue, often related to conflicts between the NVIDIA driver, the display manager (especially GDM), and GNOME Shell when i3 replaces Mutter.
        *   **Ensure Wayland is Disabled in GDM:** GDM might default to or try Wayland, which often works poorly with NVIDIA. Edit `/etc/gdm3/custom.conf` (or `/etc/gdm/custom.conf`) and ensure `WaylandEnable=false` is present and uncommented under the `[daemon]` section. Reboot after changing.
        *   **Try LightDM:** LightDM is often less prone to these specific conflicts. Install (`sudo apt install lightdm`) and configure it as the default (`sudo dpkg-reconfigure lightdm`, select `lightdm`). Reboot and test.
        *   **Try Different NVIDIA Driver:** Compatibility varies. Use Ubuntu's "Additional Drivers" tool or `ubuntu-drivers devices` to check for other proprietary versions (e.g., the 535 series if you're on 550). Install an alternative and reboot.
        *   **Xorg Configuration:** Create a basic NVIDIA Xorg config file at `/etc/X11/xorg.conf.d/20-nvidia.conf`. See the diagnostic script output or online resources for examples. Reboot after creating.
        *   **Disable GNOME Extensions:** Extensions can interfere. Temporarily disable them all using the Extensions app (`gnome-shell-extension-prefs`) or `gnome-extensions disable --all`. Log out and test.

    *   **Missing Dependencies:** Ensure `i3`, `gnome-session`, `gnome-settings-daemon`, and `dbus-x11` (or `dbus`) are installed via your package manager.

    *   **Incorrect Installation:** If files are missing (check diagnostic script), reinstall using `sudo make reinstall` from the source directory.

4.  **Reporting Issues:**
    If you continue to have problems, please open an issue on the GitHub repository. Include:
    *   Your Linux distribution and version.
    *   Your GNOME version (`gnome-shell --version`).
    *   Your graphics card and driver version (`nvidia-smi` if applicable).
    *   The output of the `i3-gnome-diagnose.sh` script.
    *   Relevant error messages from `journalctl`.
    *   Steps you have already tried.

Run the included troubleshooting tool to diagnose common issues:

```bash
/usr/bin/i3-gnome-troubleshoot # This script is deprecated, use i3-gnome-diagnose.sh
```

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

# i3-gnome Setup

This configuration provides a setup for running i3 window manager sessions integrated with GNOME components.

## Tested Environment

*   **OS:** Ubuntu 24.04 LTS (or latest desktop version)
*   **Display Manager:** LightDM 1.30.0
*   **Graphics:** NVIDIA (tested with RTX 3060, Driver 550+)

## NVIDIA Configuration

For optimal compatibility, especially with NVIDIA drivers, it's recommended to use a minimal Xorg configuration. Place the included `20-nvidia.conf` file into `/etc/X11/xorg.conf.d/` on your system:

```bash
sudo cp 20-nvidia.conf /etc/X11/xorg.conf.d/20-nvidia.conf
```

Reboot or restart your display manager after copying the file.

## Installation / Usage

(Add instructions on how to install/use your i3-gnome setup here)

## Streamlining / Updates

(Add details about any specific streamlining or update procedures here)

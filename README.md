# I3xGnome - Simple i3 Window Manager with GNOME Integration

A simple and reliable integration between the i3 window manager and GNOME desktop environment.

## What this provides

- i3 window manager with GNOME session integration
- Access to GNOME settings for themes, icons, and cursor customization
- GNOME online accounts and other GNOME services
- Perfect for users transitioning to i3 who still want GNOME functionality

## Requirements

* i3-wm/i3-gaps
* GNOME (40.x - 46.x)
* GDM or LightDM (recommended)

## Installation

```bash
git clone https://github.com/Ziad0dev/I3xGnome.git
cd I3xGnome
sudo make install
```

## Usage

1. Log out of your current session
2. At the login screen, click the session selector (gear icon)
3. Choose "I3 + GNOME" from the list
4. Log in

You'll now have i3 as your window manager with GNOME services running in the background.

## Components

This package installs the following simple, reliable components:

- `i3-gnome` - Simple session launcher (19 lines)
- `gnome-session-i3` - GNOME session wrapper (10 lines)
- `i3-gnome.session` - Session configuration
- `i3-gnome.desktop` - Window manager definition
- `i3-gnome-xsession.desktop` - Login session entry

## Troubleshooting

If you experience issues:

1. Ensure all dependencies are installed: `i3`, `gnome-session`, `dbus-send`, `xrdb`
2. Check that your i3 configuration is valid: `i3 -C`
3. For NVIDIA users: Consider using LightDM instead of GDM

## Philosophy

This project follows the UNIX philosophy of "do one thing and do it well". Rather than complex error handling, monitoring, and optimization features, we provide a simple, reliable integration that just works.

The original working i3-gnome was 19 lines. This version maintains that simplicity while being properly packaged for easy installation.

## License

MIT License

# i3-gnome-fork

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

```bash
git clone https://github.com/n3ros/i3-gnome-fork.git
cd i3-gnome-fork
sudo make install
```

## Usage

1. Log out of your current session
2. At the login screen, click the session selector (gear icon)
3. Choose "I3 + GNOME" from the list
4. Log in

You'll now have i3 as your window manager with GNOME services running in the background.

## Remote Login

This fork supports GNOME's Remote Login feature, allowing you to access your i3 session remotely using tools like GNOME Remote Desktop.

## License

[MIT License](https://opensource.org/licenses/MIT) - © 2025 [Ziad](https://github.com/Ziad0dev/)

*This project is a fork of the original i3-gnome by Lorenzo Villani and the i3-gnome team* 

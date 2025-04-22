# i3-gnome-fork Installation Guide

This guide provides instructions on how to install, uninstall, and manage the i3-gnome-fork integration using the provided Makefile.

## Quick Install

To install i3-gnome-fork with default settings (installing to `/usr`), simply run:

```bash
sudo make install
```

You might need root privileges (e.g., use `sudo make install`).

## Uninstallation

To remove the installed files:

```bash
sudo make uninstall
```

Again, you might need root privileges (`sudo make uninstall`).

## Checking Installation Status

To verify which files are currently installed in the default location (`/usr`):

```bash
make status
```

## Advanced Installation

### Changing the Installation Prefix

By default, files are installed under the `/usr` prefix. You can change this using the `PREFIX` variable. For example, to install under `/usr/local`:

```bash
sudo make PREFIX=/usr/local install
```

Remember to use the same `PREFIX` when uninstalling:

```bash
sudo make PREFIX=/usr/local uninstall
```

### Staging Installation (for Packagers)

If you are creating a package, you can install the files into a staging directory using the `DESTDIR` variable. This prepends the `DESTDIR` path to all installation targets.

```bash
make DESTDIR=/tmp/my-package-staging install
make DESTDIR=/tmp/my-package-staging PREFIX=/usr/local install # With a custom prefix
```

Note: `make reinstall` (which runs `uninstall` then `install`) will also likely require `sudo`.

## Packaging

The Makefile includes targets for building various package types:

*   **Debian Package:** `make deb-package`
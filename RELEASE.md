# Release Process for i3-gnome

This document outlines the process for creating and publishing new releases of i3-gnome.

## Versioning

We use semantic versioning (MAJOR.MINOR.PATCH):
- MAJOR version for incompatible changes
- MINOR version for new features in a backwards compatible manner
- PATCH version for backwards compatible bug fixes

## Release Checklist

1. Update version in `Makefile`
2. Update changelog (add release notes to the top of `CHANGELOG.md`)
3. Test the package builds (`make packages`)
4. Commit changes: `git commit -am "Prepare release X.Y.Z"`
5. Create a tag: `git tag -a vX.Y.Z -m "Version X.Y.Z"`
6. Push changes: `git push && git push --tags`

## Automated Release Process

When a tag is pushed, GitHub Actions will automatically:
1. Build Debian (.deb) packages
2. Build RPM (.rpm) packages
3. Create a source tarball
4. Create a GitHub release with all build artifacts attached

## Manual Package Building

If you need to build packages manually:

### Build all package types
```
make packages
```

### Build specific package types
```
make deb-package   # Debian package
make rpm-package   # RPM package
make tarball       # Source tarball
```

All packages will be created in the `dist/` directory.

## Installation from Packages

### Debian/Ubuntu
```
sudo apt install ./dist/i3-gnome_X.Y.Z-1_all.deb
```

### Fedora/RHEL
```
sudo dnf install ./dist/i3-gnome-X.Y.Z-1.fc*.noarch.rpm
```

### From Source Tarball
```
tar -xf i3-gnome-X.Y.Z.tar.gz
cd i3-gnome-X.Y.Z
sudo make install
``` 
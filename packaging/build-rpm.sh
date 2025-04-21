#!/bin/bash
#
# build-rpm.sh - Build an RPM package for i3-gnome
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="/tmp/i3-gnome-rpm-build"
VERSION=$(grep 'VERSION =' "$PROJECT_DIR/Makefile" | cut -d'=' -f2 | tr -d ' ')
RPM_BUILD_ROOT="$HOME/rpmbuild"

echo "Building i3-gnome RPM package version $VERSION"

# Ensure rpmbuild directories exist
mkdir -p "$RPM_BUILD_ROOT"/{SOURCES,SPECS,BUILD,RPMS,SRPMS}

# Create the tarball
mkdir -p "$BUILD_DIR"
rm -rf "$BUILD_DIR/i3-gnome-$VERSION"
cp -r "$PROJECT_DIR" "$BUILD_DIR/i3-gnome-$VERSION"
rm -rf "$BUILD_DIR/i3-gnome-$VERSION/.git" "$BUILD_DIR/i3-gnome-$VERSION/dist"
cd "$BUILD_DIR"
tar -czf "$RPM_BUILD_ROOT/SOURCES/i3-gnome-$VERSION.tar.gz" "i3-gnome-$VERSION"

# Create the spec file
cat > "$RPM_BUILD_ROOT/SPECS/i3-gnome.spec" << EOF
Name:           i3-gnome
Version:        $VERSION
Release:        1%{?dist}
Summary:        GNOME integration for i3 window manager

License:        MIT
URL:            https://github.com/n3ros/i3-gnome-fork
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
Requires:       i3 gnome-session gnome-settings-daemon dbus-x11
Recommends:     gdm

%description
This package integrates i3 window manager with GNOME Session
infrastructure, providing access to GNOME settings and services
while using i3 as the window manager.

Features:
* GNOME session management with i3
* Access to GNOME settings for themes, icons, and cursors
* Support for GNOME online accounts and services
* GNOME Remote Login support

%prep
%setup -q

%build
# Nothing to build

%install
make DESTDIR=%{buildroot} PREFIX=/usr install

%files
%license LICENSE
%doc README.md
/usr/bin/i3-gnome
/usr/bin/gnome-session-i3
/usr/share/applications/i3-gnome.desktop
/usr/share/gnome-session/sessions/i3-gnome.session
/usr/share/xsessions/i3-gnome.desktop

%changelog
* $(date "+%a %b %d %Y") n3ros <your-email@example.com> - $VERSION-1
- Initial package
EOF

# Build the RPM
cd "$RPM_BUILD_ROOT/SPECS"
rpmbuild -ba i3-gnome.spec

# Copy the result
mkdir -p "$PROJECT_DIR/dist"
find "$RPM_BUILD_ROOT/RPMS" -name "*.rpm" -exec cp {} "$PROJECT_DIR/dist/" \;

echo "RPM package built successfully. You can find it in the dist/ directory." 
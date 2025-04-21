#!/bin/bash
#
# build-deb.sh - Build a Debian package for i3-gnome
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="/tmp/i3-gnome-build"
VERSION=$(grep 'VERSION =' "$PROJECT_DIR/Makefile" | cut -d'=' -f2 | tr -d ' ')

echo "Building i3-gnome Debian package version $VERSION"

# Create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/i3-gnome-$VERSION"

# Copy source files
cp -r "$PROJECT_DIR"/* "$BUILD_DIR/i3-gnome-$VERSION/"

# Create debian directory
mkdir -p "$BUILD_DIR/i3-gnome-$VERSION/debian"
cp "$SCRIPT_DIR/debian-control" "$BUILD_DIR/i3-gnome-$VERSION/debian/control"
cp "$SCRIPT_DIR/debian-rules" "$BUILD_DIR/i3-gnome-$VERSION/debian/rules"
chmod +x "$BUILD_DIR/i3-gnome-$VERSION/debian/rules"

# Create debian changelog
cat > "$BUILD_DIR/i3-gnome-$VERSION/debian/changelog" << EOF
i3-gnome ($VERSION-1) unstable; urgency=medium

  * Initial release

 -- n3ros <your-email@example.com>  $(date -R)
EOF

# Create debian copyright
cat > "$BUILD_DIR/i3-gnome-$VERSION/debian/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: i3-gnome
Source: https://github.com/n3ros/i3-gnome-fork

Files: *
Copyright: 2025 Ziad <https://github.com/Ziad0dev/>
License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Create compat file
echo "10" > "$BUILD_DIR/i3-gnome-$VERSION/debian/compat"

# Create source/format file
mkdir -p "$BUILD_DIR/i3-gnome-$VERSION/debian/source"
echo "3.0 (native)" > "$BUILD_DIR/i3-gnome-$VERSION/debian/source/format"

# Build the package
cd "$BUILD_DIR/i3-gnome-$VERSION"
echo "Running dpkg-buildpackage..."
dpkg-buildpackage -us -uc

# Copy the result
mkdir -p "$PROJECT_DIR/dist"
cp "$BUILD_DIR"/*.deb "$PROJECT_DIR/dist/"

echo "Package built successfully. You can find it in the dist/ directory." 
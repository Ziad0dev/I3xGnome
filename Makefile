#
# i3-gnome-fork Makefile
#
# Installs i3-gnome integration files for seamless operation
# of i3 window manager with GNOME session
#

# Version
VERSION = 1.3.0

# Installation settings
INSTALL = install
# DESTDIR is intended for staging builds (e.g., packaging)
# It should be empty by default for direct installs
DESTDIR ?=
# PREFIX defines the installation root relative to the filesystem root
PREFIX  ?= /usr

# Installation paths - construct the full path using DESTDIR and PREFIX
BINDIR       = $(DESTDIR)$(PREFIX)/bin
APPDIR       = $(DESTDIR)$(PREFIX)/share/applications
SESSIONDIR   = $(DESTDIR)$(PREFIX)/share/gnome-session/sessions
XSESSIONDIR  = $(DESTDIR)$(PREFIX)/share/xsessions

# Source files
SRC_DIR      = session
I3_GNOME     = $(SRC_DIR)/i3-gnome
GNOME_I3     = $(SRC_DIR)/gnome-session-i3
I3_SESSION   = $(SRC_DIR)/i3-gnome.session
I3_DESKTOP   = $(SRC_DIR)/i3-gnome.desktop
I3_XSESSION  = $(SRC_DIR)/i3-gnome-xsession.desktop
I3_DIAGNOSE  = $(SRC_DIR)/i3-gnome-diagnose.sh

# Target paths are now correctly constructed using DESTDIR and PREFIX
TARGET_I3_GNOME    = $(BINDIR)/i3-gnome
TARGET_GNOME_I3    = $(BINDIR)/gnome-session-i3
TARGET_I3_SESSION  = $(SESSIONDIR)/i3-gnome.session
TARGET_I3_DESKTOP  = $(APPDIR)/i3-gnome.desktop
TARGET_I3_XSESSION = $(XSESSIONDIR)/i3-gnome.desktop
TARGET_I3_DIAGNOSE = $(BINDIR)/i3-gnome-diagnose.sh

# Validation function
validate:
	@echo "Validating files..."
	@test -f $(I3_GNOME) || { echo "Error: $(I3_GNOME) not found"; exit 1; }
	@test -f $(GNOME_I3) || { echo "Error: $(GNOME_I3) not found"; exit 1; }
	@test -f $(I3_SESSION) || { echo "Error: $(I3_SESSION) not found"; exit 1; }
	@test -f $(I3_DESKTOP) || { echo "Error: $(I3_DESKTOP) not found"; exit 1; }
	@test -f $(I3_XSESSION) || { echo "Error: $(I3_XSESSION) not found"; exit 1; }
	@test -f $(I3_DIAGNOSE) || { echo "Error: $(I3_DIAGNOSE) not found"; exit 1; }
	@echo "All files validated successfully."

# Target rules
all: validate
	@echo "i3-gnome-fork $(VERSION)"
	@echo "Run 'make install' to install."

install: validate
	@echo "Installing i3-gnome integration (version $(VERSION))..."
	@echo "--- Makefile install --- DEBUG --- "
	@echo "DESTDIR='$(DESTDIR)'"
	@echo "PREFIX='$(PREFIX)'"
	@echo "BINDIR='$(BINDIR)'"
	@echo "------------------------------------"
	# Ensure target directories exist within DESTDIR
	$(INSTALL) -d $(BINDIR) $(APPDIR) $(SESSIONDIR) $(XSESSIONDIR) $(DESTDIR)/etc/i3-gnome
	$(INSTALL) -m0755 $(I3_GNOME) $(TARGET_I3_GNOME)
	$(INSTALL) -m0755 $(GNOME_I3) $(TARGET_GNOME_I3)
	$(INSTALL) -m0755 $(I3_DIAGNOSE) $(TARGET_I3_DIAGNOSE)
	$(INSTALL) -m0755 tools/benchmark-performance.sh $(BINDIR)/i3-gnome-benchmark
	$(INSTALL) -m0644 $(I3_SESSION) $(TARGET_I3_SESSION)
	$(INSTALL) -m0644 $(I3_DESKTOP) $(TARGET_I3_DESKTOP)
	$(INSTALL) -m0644 $(I3_XSESSION) $(TARGET_I3_XSESSION)
	$(INSTALL) -m0644 config/i3-gnome-performance.conf $(DESTDIR)/etc/i3-gnome/performance.conf
	@echo "Installation completed successfully."

uninstall:
	@echo "Uninstalling i3-gnome integration..."
	rm -f $(DESTDIR)$(PREFIX)/bin/i3-gnome
	rm -f $(DESTDIR)$(PREFIX)/bin/gnome-session-i3
	rm -f $(DESTDIR)$(PREFIX)/bin/i3-gnome-diagnose.sh
	rm -f $(DESTDIR)$(PREFIX)/share/gnome-session/sessions/i3-gnome.session
	rm -f $(DESTDIR)$(PREFIX)/share/applications/i3-gnome.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/xsessions/i3-gnome.desktop
	@echo "Uninstallation completed successfully."

reinstall: uninstall install

# Display information about installed files
status:
	@echo "i3-gnome-fork $(VERSION) status:"
	@for file in $(PREFIX)/bin/i3-gnome $(PREFIX)/bin/gnome-session-i3 $(PREFIX)/bin/i3-gnome-diagnose.sh $(PREFIX)/share/gnome-session/sessions/i3-gnome.session $(PREFIX)/share/applications/i3-gnome.desktop $(PREFIX)/share/xsessions/i3-gnome.desktop; do \
		if [ -f "$$file" ]; then \
			echo "✓ $$file (installed)"; \
		else \
			echo "✗ $$file (not installed)"; \
		fi; \
	done

# Package building targets
deb-package:
	@echo "Building Debian package..."
	@mkdir -p dist
	@chmod +x packaging/build-deb.sh
	@packaging/build-deb.sh

rpm-package:
	@echo "Building RPM package..."
	@mkdir -p dist
	@chmod +x packaging/build-rpm.sh
	@packaging/build-rpm.sh

tarball:
	@echo "Creating source tarball..."
	@mkdir -p dist
	@TMP_DIR="/tmp/i3-gnome-tarball-$(VERSION)" && \
	mkdir -p "$$TMP_DIR" && \
	cp -r ./* "$$TMP_DIR" && \
	rm -rf "$$TMP_DIR/.git" "$$TMP_DIR/dist" "$$TMP_DIR/packaging" && \
	tar -czf "dist/i3-gnome-$(VERSION).tar.gz" -C "/tmp" "i3-gnome-tarball-$(VERSION)" && \
	rm -rf "$$TMP_DIR"
	@echo "Tarball created at dist/i3-gnome-$(VERSION).tar.gz"

binary-package:
	@echo "Building binary installer..."
	@mkdir -p dist
	@chmod +x packaging/build-binary.sh
	@packaging/build-binary.sh

packages: deb-package rpm-package tarball binary-package
	@echo "All packages built successfully in dist/ directory"

# Testing targets
test-components:
	@echo "Running component tests..."
	@chmod +x test-components.sh
	@./test-components.sh

test-nested:
	@echo "Running nested X session test..."
	@chmod +x test-i3xgnome.sh
	@./test-i3xgnome.sh

test-nested-debug:
	@echo "Running nested X session test with debug..."
	@chmod +x test-i3xgnome.sh
	@DEBUG=1 ./test-i3xgnome.sh --debug

test-quick:
	@echo "Running quick component tests..."
	@chmod +x test-components.sh
	@./test-components.sh

test: test-components test-nested
	@echo "All tests completed"

# Performance benchmarking targets
benchmark:
	@echo "Running performance benchmark..."
	@chmod +x tools/benchmark-performance.sh
	@./tools/benchmark-performance.sh

benchmark-verbose:
	@echo "Running verbose performance benchmark..."
	@chmod +x tools/benchmark-performance.sh
	@./tools/benchmark-performance.sh --verbose

benchmark-compare:
	@echo "Running benchmark with comparison..."
	@chmod +x tools/benchmark-performance.sh
	@if [ -f ~/.cache/i3-gnome-benchmarks/baseline.json ]; then \
		./tools/benchmark-performance.sh --compare ~/.cache/i3-gnome-benchmarks/baseline.json; \
	else \
		echo "No baseline found. Creating baseline..."; \
		./tools/benchmark-performance.sh --output ~/.cache/i3-gnome-benchmarks/baseline.json; \
	fi

help:
	@echo "i3-gnome-fork $(VERSION) - i3 window manager with GNOME integration"
	@echo ""
	@echo "Usage:"
	@echo "  make              - Validate files and display version information"
	@echo "  make install      - Install i3-gnome integration"
	@echo "  make uninstall    - Remove i3-gnome integration"
	@echo "  make reinstall    - Reinstall i3-gnome integration"
	@echo "  make status       - Check installation status"
	@echo "  make test         - Run all tests"
	@echo "  make test-components - Test individual components"
	@echo "  make test-nested  - Test in nested X session"
	@echo "  make test-quick   - Quick component validation"
	@echo "  make deb-package  - Build Debian package"
	@echo "  make rpm-package  - Build RPM package"
	@echo "  make tarball      - Create source tarball"
	@echo "  make binary-package - Build self-extracting installer"
	@echo "  make packages     - Build all package types"
	@echo "  make help         - Display this help information"
	@echo ""
	@echo "Variables:"
	@echo "  DESTDIR           - Installation destination root (default: empty)"
	@echo "  PREFIX            - Installation prefix (default: /usr)"

.PHONY: all install uninstall reinstall validate status test test-components test-nested test-nested-debug test-quick deb-package rpm-package tarball binary-package packages help

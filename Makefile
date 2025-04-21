#
# i3-gnome-fork Makefile
#
# Installs i3-gnome integration files for seamless operation
# of i3 window manager with GNOME session
#

# Version
VERSION = 1.2.0

# Installation settings
INSTALL = install
DESTDIR ?= /
PREFIX  ?= $(DESTDIR)/usr

# Installation paths
BINDIR       = $(PREFIX)/bin
APPDIR       = $(PREFIX)/share/applications
SESSIONDIR   = $(PREFIX)/share/gnome-session/sessions
XSESSIONDIR  = $(PREFIX)/share/xsessions

# Source files
SRC_DIR      = session
I3_GNOME     = $(SRC_DIR)/i3-gnome
GNOME_I3     = $(SRC_DIR)/gnome-session-i3
I3_SESSION   = $(SRC_DIR)/i3-gnome.session
I3_DESKTOP   = $(SRC_DIR)/i3-gnome.desktop
I3_XSESSION  = $(SRC_DIR)/i3-gnome-xsession.desktop

# Target paths
TARGET_I3_GNOME    = $(BINDIR)/i3-gnome
TARGET_GNOME_I3    = $(BINDIR)/gnome-session-i3
TARGET_I3_SESSION  = $(SESSIONDIR)/i3-gnome.session
TARGET_I3_DESKTOP  = $(APPDIR)/i3-gnome.desktop
TARGET_I3_XSESSION = $(XSESSIONDIR)/i3-gnome.desktop

# Validation function
validate:
	@echo "Validating files..."
	@test -f $(I3_GNOME) || { echo "Error: $(I3_GNOME) not found"; exit 1; }
	@test -f $(GNOME_I3) || { echo "Error: $(GNOME_I3) not found"; exit 1; }
	@test -f $(I3_SESSION) || { echo "Error: $(I3_SESSION) not found"; exit 1; }
	@test -f $(I3_DESKTOP) || { echo "Error: $(I3_DESKTOP) not found"; exit 1; }
	@test -f $(I3_XSESSION) || { echo "Error: $(I3_XSESSION) not found"; exit 1; }
	@echo "All files validated successfully."

# Target rules
all: validate
	@echo "i3-gnome-fork $(VERSION)"
	@echo "Run 'make install' to install."

install: validate
	@echo "Installing i3-gnome integration (version $(VERSION))..."
	@mkdir -p $(BINDIR) $(APPDIR) $(SESSIONDIR) $(XSESSIONDIR)
	$(INSTALL) -m0755 -D $(I3_GNOME) $(TARGET_I3_GNOME)
	$(INSTALL) -m0755 -D $(GNOME_I3) $(TARGET_GNOME_I3)
	$(INSTALL) -m0644 -D $(I3_SESSION) $(TARGET_I3_SESSION)
	$(INSTALL) -m0644 -D $(I3_DESKTOP) $(TARGET_I3_DESKTOP)
	$(INSTALL) -m0644 -D $(I3_XSESSION) $(TARGET_I3_XSESSION)
	@echo "Installation completed successfully."

uninstall:
	@echo "Uninstalling i3-gnome integration..."
	rm -f $(TARGET_I3_GNOME)
	rm -f $(TARGET_GNOME_I3)
	rm -f $(TARGET_I3_SESSION)
	rm -f $(TARGET_I3_DESKTOP)
	rm -f $(TARGET_I3_XSESSION)
	@echo "Uninstallation completed successfully."

reinstall: uninstall install

# Display information about installed files
status:
	@echo "i3-gnome-fork $(VERSION) status:"
	@for file in $(TARGET_I3_GNOME) $(TARGET_GNOME_I3) $(TARGET_I3_SESSION) $(TARGET_I3_DESKTOP) $(TARGET_I3_XSESSION); do \
		if [ -f "$$file" ]; then \
			echo "✓ $$file (installed)"; \
		else \
			echo "✗ $$file (not installed)"; \
		fi; \
	done

help:
	@echo "i3-gnome-fork $(VERSION) - i3 window manager with GNOME integration"
	@echo ""
	@echo "Usage:"
	@echo "  make              - Validate files and display version information"
	@echo "  make install      - Install i3-gnome integration"
	@echo "  make uninstall    - Remove i3-gnome integration"
	@echo "  make reinstall    - Reinstall i3-gnome integration"
	@echo "  make status       - Check installation status"
	@echo "  make help         - Display this help information"
	@echo ""
	@echo "Variables:"
	@echo "  DESTDIR           - Installation destination root (default: /)"
	@echo "  PREFIX            - Installation prefix (default: /usr)"

.PHONY: all install uninstall reinstall validate status help

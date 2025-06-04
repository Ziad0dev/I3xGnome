#
# I3xGnome Makefile
#
# Simple installation for i3 window manager with GNOME integration
#

# Version
VERSION = 1.0.0

# Installation settings
INSTALL = install
DESTDIR ?=
PREFIX  ?= /usr

# Installation paths
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
	@echo "I3xGnome $(VERSION) - Simple i3 + GNOME integration"
	@echo "Run 'make install' to install."

install: validate
	@echo "Installing I3xGnome $(VERSION)..."
	@$(INSTALL) -d $(BINDIR) $(APPDIR) $(SESSIONDIR) $(XSESSIONDIR)
	@$(INSTALL) -m0755 $(I3_GNOME) $(TARGET_I3_GNOME)
	@$(INSTALL) -m0755 $(GNOME_I3) $(TARGET_GNOME_I3)
	@$(INSTALL) -m0644 $(I3_SESSION) $(TARGET_I3_SESSION)
	@$(INSTALL) -m0644 $(I3_DESKTOP) $(TARGET_I3_DESKTOP)
	@$(INSTALL) -m0644 $(I3_XSESSION) $(TARGET_I3_XSESSION)
	@echo "Installation complete. You can now select 'I3 + GNOME' at login."

uninstall:
	@echo "Uninstalling I3xGnome..."
	@rm -f $(TARGET_I3_GNOME)
	@rm -f $(TARGET_GNOME_I3)
	@rm -f $(TARGET_I3_SESSION)
	@rm -f $(TARGET_I3_DESKTOP)
	@rm -f $(TARGET_I3_XSESSION)
	@echo "Uninstallation complete."

reinstall: uninstall install

status:
	@echo "I3xGnome $(VERSION) status:"
	@for file in $(TARGET_I3_GNOME) $(TARGET_GNOME_I3) $(TARGET_I3_SESSION) $(TARGET_I3_DESKTOP) $(TARGET_I3_XSESSION); do \
		if [ -f "$$file" ]; then \
			echo "  $$file (installed)"; \
		else \
			echo "  $$file (not installed)"; \
		fi; \
	done

help:
	@echo "I3xGnome $(VERSION) - Simple i3 window manager with GNOME integration"
	@echo ""
	@echo "Usage:"
	@echo "  make          - Validate files and display information"
	@echo "  make install  - Install I3xGnome"
	@echo "  make uninstall- Remove I3xGnome"
	@echo "  make reinstall- Reinstall I3xGnome"
	@echo "  make status   - Show installation status"
	@echo "  make help     - Show this help"
	@echo ""
	@echo "After installation, log out and select 'I3 + GNOME' at the login screen."

.PHONY: all install uninstall reinstall status help validate

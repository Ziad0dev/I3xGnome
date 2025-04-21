# Changelog

All notable changes to i3-gnome will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2023-06-15

### Added
- GNOME 46 compatibility
- X-GDM-CanRunHeadless for remote login support
- Comprehensive troubleshooting tool
- Improved packaging for Debian and RPM systems

### Changed
- Updated session file to work with GNOME 46
- More robust GNOME session handling

### Fixed
- Detection of GNOME settings daemons
- Session registration for newer GNOME versions

## [1.1.0] - 2023-01-10

### Added
- GNOME 45 compatibility
- Multiple desktop names in i3-gnome-xsession.desktop

### Changed
- Enhanced session scripts for better integration

### Fixed
- Session termination cleanup
- GNOME settings service detection

## [1.0.0] - 2022-08-22

### Added
- Initial stable release
- GNOME 40-44 compatibility
- i3-gnome launcher script
- gnome-session-i3 script
- Desktop and session files 
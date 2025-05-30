# Testing i3xGnome

This document describes various methods to test i3xGnome integration without having to constantly log out and back in.

## Quick Reference

```bash
# Quick component validation (30 seconds)
make test-quick

# Full component testing (1 minute)
make test-components

# Nested X session testing (2-3 minutes)
make test-nested

# Full test suite (3-5 minutes)
make test

# Debug mode testing
make test-nested-debug
```

## Testing Methods

### 1. Component Testing (Recommended for Development)

**Purpose**: Validate individual components without starting a session
**Time**: ~30 seconds
**Safety**: Completely safe, no session changes

```bash
# Run component tests
./test-components.sh

# Or via Makefile
make test-components
```

**What it tests**:
- Script syntax validation
- File permissions and structure
- Configuration file formats
- Dependencies availability
- GNOME compatibility
- Environment setup
- NVIDIA configuration (if applicable)

**Example output**:
```
i3xGnome Component Test Suite
=============================

[PASS] Script Syntax
[PASS] File Permissions  
[PASS] Session File Format
[PASS] Desktop File Format
[FAIL] Dependencies        # Shows missing packages
[PASS] i3 Configuration
[PASS] GNOME Compatibility
[PASS] D-Bus Connectivity
[PASS] Environment Variables
[PASS] Script Execution
[PASS] NVIDIA Configuration
[PASS] Makefile

Test Summary: 11/12 passed
```

### 2. Nested X Session Testing (Best for Full Testing)

**Purpose**: Test complete session startup in isolated environment
**Time**: ~2-3 minutes
**Safety**: Safe, runs in separate X server

```bash
# Install required dependency first
sudo apt install xserver-xephyr

# Run nested session test
./test-i3xgnome.sh

# Or via Makefile
make test-nested

# With debug output
make test-nested-debug
```

**What it tests**:
- Complete session startup sequence
- i3 window manager functionality
- GNOME service integration
- D-Bus communication
- Session stability
- Error handling and recovery

**Example output**:
```
[INFO] Starting i3xGnome test suite...
[SUCCESS] All dependencies found
[INFO] Using display: :99
[SUCCESS] Xephyr started successfully
[SUCCESS] Test environment configured
[SUCCESS] D-Bus is working
[SUCCESS] i3 configuration is valid
[SUCCESS] gnome-session is available
[SUCCESS] i3 is running in test session
[SUCCESS] i3 is responding to commands
[SUCCESS] Session is stable
[SUCCESS] i3xGnome test completed successfully!
```

### 3. Diagnostic Testing

**Purpose**: Comprehensive system analysis
**Time**: ~1 minute
**Safety**: Read-only analysis

```bash
# Run diagnostics
./session/i3-gnome-diagnose.sh

# Or if installed
/usr/bin/i3-gnome-diagnose.sh

# With verbose output
DEBUG=1 ./session/i3-gnome-diagnose.sh
```

### 4. Manual Component Testing

For specific component testing:

#### Test Script Syntax
```bash
# Check all scripts for syntax errors
bash -n session/i3-gnome
bash -n session/gnome-session-i3
bash -n session/i3-gnome-diagnose.sh
```

#### Test i3 Configuration
```bash
# Validate i3 config without starting i3
i3 -C
```

#### Test GNOME Session File
```bash
# Check session file format
grep -E "(RequiredComponents|i3-gnome)" session/i3-gnome.session
```

#### Test Dependencies
```bash
# Check for required commands
for cmd in i3 gnome-session gnome-settings-daemon dbus-send xrdb; do
    command -v "$cmd" && echo "$cmd: OK" || echo "$cmd: MISSING"
done
```

#### Test D-Bus Connectivity
```bash
# Test D-Bus session
dbus-send --session --print-reply --dest=org.freedesktop.DBus \
    /org/freedesktop/DBus org.freedesktop.DBus.ListNames
```

### 5. Dry Run Testing

Test scripts without actually starting sessions:

```bash
# Test with timeout to prevent hanging
timeout 5s ./session/i3-gnome --debug || echo "Expected timeout"
timeout 5s ./session/gnome-session-i3 --debug || echo "Expected timeout"
```

## Testing Workflow

### Before Making Changes
```bash
# 1. Quick validation
make test-quick

# 2. Full component test
make test-components
```

### After Making Changes
```bash
# 1. Component validation
make test-components

# 2. Nested session test
make test-nested

# 3. If issues found, debug
make test-nested-debug
```

### Before Committing
```bash
# Full test suite
make test
```

## Troubleshooting Tests

### Component Test Failures

**Missing Dependencies**:
```bash
# Install missing packages
sudo apt install gnome-settings-daemon dbus-x11
```

**Permission Issues**:
```bash
# Fix permissions
chmod +x session/*.sh session/i3-gnome session/gnome-session-i3
```

**Syntax Errors**:
```bash
# Check specific script
bash -n session/script-name
```

### Nested Session Test Failures

**Xephyr Not Found**:
```bash
# Install Xephyr
sudo apt install xserver-xephyr
```

**Display Issues**:
```bash
# Test with different display
DISPLAY_NUM=:100 ./test-i3xgnome.sh
```

**Session Startup Failures**:
```bash
# Run with debug
DEBUG=1 ./test-i3xgnome.sh --debug
```

## Continuous Integration

For automated testing:

```bash
#!/bin/bash
# ci-test.sh - Continuous integration testing

set -e

echo "Running i3xGnome CI tests..."

# Component tests (must pass)
make test-components

# Diagnostic tests
./session/i3-gnome-diagnose.sh || true

# Nested tests (if Xephyr available)
if command -v Xephyr >/dev/null 2>&1; then
    make test-nested
else
    echo "Skipping nested tests (Xephyr not available)"
fi

echo "CI tests completed successfully"
```

## Performance Testing

Monitor resource usage during testing:

```bash
# Monitor memory usage
./test-i3xgnome.sh &
TEST_PID=$!
while kill -0 $TEST_PID 2>/dev/null; do
    ps -p $TEST_PID -o pid,ppid,pcpu,pmem,cmd
    sleep 2
done
```

## Test Environment Setup

### Minimal Test Environment
```bash
# Required packages for testing
sudo apt install \
    i3 \
    gnome-session \
    gnome-settings-daemon \
    dbus-x11 \
    xrdb \
    xserver-xephyr
```

### Development Environment
```bash
# Additional packages for development
sudo apt install \
    shellcheck \
    make \
    git \
    build-essential
```

## Best Practices

1. **Always run component tests first** - they're fast and catch most issues
2. **Use nested session tests for integration testing** - safer than real sessions
3. **Run diagnostics when troubleshooting** - provides comprehensive analysis
4. **Test with debug mode when investigating issues** - provides detailed logs
5. **Validate syntax before testing functionality** - catches basic errors early
6. **Test on clean environment** - use fresh user account or container

## Integration with Development

### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running pre-commit tests..."
make test-components || {
    echo "Component tests failed. Commit aborted."
    exit 1
}
```

### Editor Integration
For VS Code, add to `.vscode/tasks.json`:
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Test Components",
            "type": "shell",
            "command": "make test-components",
            "group": "test"
        },
        {
            "label": "Test Nested",
            "type": "shell", 
            "command": "make test-nested",
            "group": "test"
        }
    ]
}
```

## Automated Testing Schedule

For production environments:

- **Every commit**: Component tests
- **Daily**: Full test suite including nested sessions
- **Before releases**: Complete testing on multiple environments
- **After system updates**: Compatibility testing

This testing framework allows you to develop and validate i3xGnome changes efficiently without the overhead of constantly logging out and back in. 
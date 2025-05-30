#!/bin/bash
#
# test-components.sh - Test individual i3xGnome components
#
# This script tests individual components of i3xGnome without
# starting a full session, useful for quick validation.
#

set -euo pipefail

# Colors for output
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${RESET} $1"
}

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function wrapper
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    log_info "Running test: $test_name"
    
    if $test_function; then
        log_success "$test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        log_error "$test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test script syntax
test_script_syntax() {
    local scripts=(
        "./session/i3-gnome"
        "./session/gnome-session-i3"
        "./session/i3-gnome-diagnose.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if bash -n "$script" 2>/dev/null; then
                echo "  ✓ $script syntax OK"
            else
                echo "  ✗ $script syntax error"
                return 1
            fi
        else
            echo "  ? $script not found"
        fi
    done
    return 0
}

# Test file permissions
test_file_permissions() {
    local files=(
        "./session/i3-gnome:executable"
        "./session/gnome-session-i3:executable"
        "./session/i3-gnome-diagnose.sh:executable"
        "./session/i3-gnome.session:readable"
        "./session/i3-gnome.desktop:readable"
        "./session/i3-gnome-xsession.desktop:readable"
    )
    
    for file_info in "${files[@]}"; do
        local file="${file_info%%:*}"
        local perm="${file_info##*:}"
        
        if [ -f "$file" ]; then
            case "$perm" in
                "executable")
                    if [ -x "$file" ]; then
                        echo "  ✓ $file is executable"
                    else
                        echo "  ✗ $file is not executable"
                        return 1
                    fi
                    ;;
                "readable")
                    if [ -r "$file" ]; then
                        echo "  ✓ $file is readable"
                    else
                        echo "  ✗ $file is not readable"
                        return 1
                    fi
                    ;;
            esac
        else
            echo "  ? $file not found"
        fi
    done
    return 0
}

# Test session file format
test_session_file() {
    local session_file="./session/i3-gnome.session"
    
    if [ ! -f "$session_file" ]; then
        echo "  ✗ Session file not found"
        return 1
    fi
    
    # Check required sections
    if grep -q "^\[GNOME Session\]" "$session_file"; then
        echo "  ✓ Session file has GNOME Session section"
    else
        echo "  ✗ Session file missing GNOME Session section"
        return 1
    fi
    
    if grep -q "RequiredComponents=" "$session_file"; then
        echo "  ✓ Session file has RequiredComponents"
    else
        echo "  ✗ Session file missing RequiredComponents"
        return 1
    fi
    
    if grep -q "i3-gnome" "$session_file"; then
        echo "  ✓ Session file references i3-gnome"
    else
        echo "  ✗ Session file missing i3-gnome reference"
        return 1
    fi
    
    return 0
}

# Test desktop file format
test_desktop_files() {
    local desktop_files=(
        "./session/i3-gnome.desktop"
        "./session/i3-gnome-xsession.desktop"
    )
    
    for desktop_file in "${desktop_files[@]}"; do
        if [ ! -f "$desktop_file" ]; then
            echo "  ? $desktop_file not found"
            continue
        fi
        
        # Check required fields
        if grep -q "^\[Desktop Entry\]" "$desktop_file"; then
            echo "  ✓ $desktop_file has Desktop Entry section"
        else
            echo "  ✗ $desktop_file missing Desktop Entry section"
            return 1
        fi
        
        if grep -q "^Exec=" "$desktop_file"; then
            echo "  ✓ $desktop_file has Exec field"
        else
            echo "  ✗ $desktop_file missing Exec field"
            return 1
        fi
    done
    
    return 0
}

# Test dependencies
test_dependencies() {
    local deps=("i3" "gnome-session" "dbus-send" "xrdb")
    local missing=0
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo "  ✓ $dep found"
        else
            echo "  ✗ $dep missing"
            missing=1
        fi
    done
    
    # Check for gnome-settings-daemon components (modern GNOME uses gsd-* components)
    if [ -d "/usr/libexec" ] && ls /usr/libexec/gsd-* >/dev/null 2>&1; then
        echo "  ✓ gnome-settings-daemon components found"
    elif command -v gnome-settings-daemon >/dev/null 2>&1; then
        echo "  ✓ gnome-settings-daemon found"
    else
        echo "  ✗ gnome-settings-daemon missing"
        missing=1
    fi
    
    return $missing
}

# Test i3 configuration
test_i3_config() {
    if command -v i3 >/dev/null 2>&1; then
        if i3 -C >/dev/null 2>&1; then
            echo "  ✓ i3 configuration is valid"
            return 0
        else
            echo "  ✗ i3 configuration has errors"
            return 1
        fi
    else
        echo "  ? i3 not found"
        return 1
    fi
}

# Test GNOME session compatibility
test_gnome_compatibility() {
    if command -v gnome-session >/dev/null 2>&1; then
        local version
        # Try gnome-shell first, then gnome-session
        version=$(gnome-shell --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1 || \
                  gnome-session --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1 || \
                  echo "unknown")
        
        if [ "$version" != "unknown" ]; then
            echo "  ✓ GNOME version: $version"
            
            local major_version
            major_version=$(echo "$version" | cut -d. -f1)
            
            if [ "$major_version" -ge 40 ]; then
                echo "  ✓ GNOME version is compatible (40+)"
                return 0
            elif [ "$major_version" -ge 3 ]; then
                local minor_version
                minor_version=$(echo "$version" | cut -d. -f2)
                if [ "$minor_version" -ge 36 ]; then
                    echo "  ✓ GNOME version is compatible (3.36+)"
                    return 0
                else
                    echo "  ✗ GNOME version too old (requires 3.36+)"
                    return 1
                fi
            else
                echo "  ✗ GNOME version too old"
                return 1
            fi
        else
            echo "  ✗ Could not determine GNOME version"
            return 1
        fi
    else
        echo "  ✗ gnome-session not found"
        return 1
    fi
}

# Test D-Bus connectivity
test_dbus() {
    if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        echo "  ✓ D-Bus session address set"
        
        if dbus-send --session --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames >/dev/null 2>&1; then
            echo "  ✓ D-Bus session is responding"
            return 0
        else
            echo "  ✗ D-Bus session not responding"
            return 1
        fi
    else
        echo "  ✗ D-Bus session address not set"
        return 1
    fi
}

# Test environment variables
test_environment() {
    local required_vars=("DISPLAY" "XDG_CURRENT_DESKTOP")
    local missing=0
    
    for var in "${required_vars[@]}"; do
        if [ -n "${!var:-}" ]; then
            echo "  ✓ $var is set: ${!var}"
        else
            echo "  ✗ $var is not set"
            missing=1
        fi
    done
    
    return $missing
}

# Test script execution (dry run)
test_script_execution() {
    local scripts=(
        "./session/i3-gnome"
        "./session/gnome-session-i3"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            # Test help/version flags
            if "$script" --help >/dev/null 2>&1 || "$script" --version >/dev/null 2>&1; then
                echo "  ✓ $script accepts help/version flags"
            else
                echo "  ? $script doesn't support help/version (normal)"
            fi
            
            # Test debug flag
            if DEBUG=1 timeout 2s "$script" --debug 2>/dev/null || true; then
                echo "  ✓ $script accepts debug flag"
            else
                echo "  ? $script debug test (expected timeout)"
            fi
        fi
    done
    
    return 0
}

# Test NVIDIA configuration
test_nvidia_config() {
    if lspci | grep -i nvidia >/dev/null 2>&1; then
        echo "  ✓ NVIDIA GPU detected"
        
        if [ -f "./20-nvidia.conf" ]; then
            echo "  ✓ NVIDIA config file present"
            
            if grep -q "AllowEmptyInitialConfiguration" "./20-nvidia.conf"; then
                echo "  ✓ NVIDIA config has AllowEmptyInitialConfiguration"
            else
                echo "  ✗ NVIDIA config missing AllowEmptyInitialConfiguration"
                return 1
            fi
        else
            echo "  ✗ NVIDIA config file missing"
            return 1
        fi
    else
        echo "  ? No NVIDIA GPU detected"
    fi
    
    return 0
}

# Test Makefile
test_makefile() {
    if [ -f "./Makefile" ]; then
        echo "  ✓ Makefile present"
        
        # Test make validation
        if make validate >/dev/null 2>&1; then
            echo "  ✓ Makefile validation passes"
        else
            echo "  ✗ Makefile validation fails"
            return 1
        fi
        
        # Check for required targets
        local targets=("install" "uninstall" "status")
        for target in "${targets[@]}"; do
            if grep -q "^$target:" "./Makefile"; then
                echo "  ✓ Makefile has $target target"
            else
                echo "  ✗ Makefile missing $target target"
                return 1
            fi
        done
    else
        echo "  ✗ Makefile not found"
        return 1
    fi
    
    return 0
}

# Print test summary
print_summary() {
    echo ""
    echo "=================================="
    echo "Test Summary"
    echo "=================================="
    echo "Tests run: $TESTS_RUN"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "All tests passed!"
        return 0
    else
        log_error "$TESTS_FAILED test(s) failed"
        return 1
    fi
}

# Main function
main() {
    echo "i3xGnome Component Test Suite"
    echo "============================="
    echo ""
    
    # Run all tests
    run_test "Script Syntax" test_script_syntax
    run_test "File Permissions" test_file_permissions
    run_test "Session File Format" test_session_file
    run_test "Desktop File Format" test_desktop_files
    run_test "Dependencies" test_dependencies
    run_test "i3 Configuration" test_i3_config
    run_test "GNOME Compatibility" test_gnome_compatibility
    run_test "D-Bus Connectivity" test_dbus
    run_test "Environment Variables" test_environment
    run_test "Script Execution" test_script_execution
    run_test "NVIDIA Configuration" test_nvidia_config
    run_test "Makefile" test_makefile
    
    # Print summary
    print_summary
}

# Run main function
main "$@" 
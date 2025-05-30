#!/bin/bash
#
# test-i3xgnome.sh - Test i3xGnome in a nested X session
#
# This script creates a nested X server to test i3xGnome integration
# without having to log out and back in.
#

set -euo pipefail

# Configuration
SCRIPT_NAME="test-i3xgnome"
DISPLAY_NUM=":99"
WINDOW_SIZE="1280x720"
DEBUG=${DEBUG:-0}

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
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Check dependencies
check_dependencies() {
    log_info "Checking test dependencies..."
    
    local missing_deps=()
    local deps=("Xephyr" "gnome-session" "i3")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Install with: sudo apt install xserver-xephyr gnome-session i3"
        exit 1
    fi
    
    log_success "All dependencies found"
}

# Check if display is available
check_display() {
    if xdpyinfo -display "$DISPLAY_NUM" >/dev/null 2>&1; then
        log_warning "Display $DISPLAY_NUM is already in use"
        return 1
    fi
    return 0
}

# Find available display
find_available_display() {
    local display_num=99
    while [ $display_num -lt 110 ]; do
        local test_display=":$display_num"
        if ! xdpyinfo -display "$test_display" >/dev/null 2>&1; then
            DISPLAY_NUM="$test_display"
            log_info "Using display: $DISPLAY_NUM"
            return 0
        fi
        display_num=$((display_num + 1))
    done
    
    log_error "No available display found"
    exit 1
}

# Start nested X server
start_xephyr() {
    log_info "Starting nested X server (Xephyr) on $DISPLAY_NUM..."
    
    # Start Xephyr in background
    Xephyr "$DISPLAY_NUM" \
        -screen "$WINDOW_SIZE" \
        -title "i3xGnome Test Session" \
        -reset \
        -terminate \
        2>/dev/null &
    
    local xephyr_pid=$!
    echo $xephyr_pid > /tmp/test-i3xgnome-xephyr.pid
    
    # Wait for X server to be ready
    local retries=0
    while [ $retries -lt 10 ]; do
        if xdpyinfo -display "$DISPLAY_NUM" >/dev/null 2>&1; then
            log_success "Xephyr started successfully (PID: $xephyr_pid)"
            return 0
        fi
        sleep 1
        retries=$((retries + 1))
    done
    
    log_error "Failed to start Xephyr"
    kill $xephyr_pid 2>/dev/null || true
    exit 1
}

# Set up test environment
setup_test_environment() {
    log_info "Setting up test environment..."
    
    # Export display for nested session
    export DISPLAY="$DISPLAY_NUM"
    
    # Set up D-Bus for the test session
    if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        eval $(dbus-launch --sh-syntax)
        echo "export DBUS_SESSION_BUS_ADDRESS='$DBUS_SESSION_BUS_ADDRESS'" > /tmp/test-i3xgnome-dbus.env
    fi
    
    # Set up environment variables
    export XDG_CURRENT_DESKTOP="GNOME"
    export XDG_SESSION_TYPE="x11"
    export XDG_SESSION_CLASS="user"
    export XDG_SESSION_DESKTOP="gnome"
    
    log_success "Test environment configured"
}

# Test individual components
test_component() {
    local component="$1"
    local description="$2"
    
    log_info "Testing $description..."
    
    case "$component" in
        "dbus")
            if dbus-send --session --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames >/dev/null 2>&1; then
                log_success "D-Bus is working"
                return 0
            else
                log_error "D-Bus test failed"
                return 1
            fi
            ;;
        "i3-config")
            if i3 -C >/dev/null 2>&1; then
                log_success "i3 configuration is valid"
                return 0
            else
                log_error "i3 configuration test failed"
                return 1
            fi
            ;;
        "gnome-session")
            if command -v gnome-session >/dev/null 2>&1; then
                log_success "gnome-session is available"
                return 0
            else
                log_error "gnome-session not found"
                return 1
            fi
            ;;
    esac
}

# Run diagnostic in test environment
run_diagnostics() {
    log_info "Running diagnostics in test environment..."
    
    local diag_exit_code=0
    if [ -f "./session/i3-gnome-diagnose.sh" ]; then
        DISPLAY="$DISPLAY_NUM" ./session/i3-gnome-diagnose.sh || diag_exit_code=$?
    elif [ -f "/usr/bin/i3-gnome-diagnose.sh" ]; then
        DISPLAY="$DISPLAY_NUM" /usr/bin/i3-gnome-diagnose.sh || diag_exit_code=$?
    else
        log_warning "Diagnostic script not found, skipping..."
        return 0
    fi
    
    # Handle diagnostic exit codes
    case $diag_exit_code in
        0)
            log_success "Diagnostics passed with no issues"
            ;;
        1)
            log_error "Diagnostics found critical issues"
            return 1
            ;;
        2)
            log_warning "Diagnostics found warnings but no critical issues"
            ;;
        *)
            log_warning "Diagnostics completed with exit code $diag_exit_code"
            ;;
    esac
    
    return 0
}

# Test i3xGnome session
test_i3xgnome_session() {
    log_info "Testing i3xGnome session startup..."
    
    # Test the session script
    local session_script=""
    if [ -f "./session/gnome-session-i3" ]; then
        session_script="./session/gnome-session-i3"
    elif [ -f "/usr/bin/gnome-session-i3" ]; then
        session_script="/usr/bin/gnome-session-i3"
    else
        log_error "gnome-session-i3 script not found"
        return 1
    fi
    
    log_info "Starting test session with: $session_script"
    
    # Set debug mode if requested
    if [ "$DEBUG" = "1" ]; then
        export DEBUG=1
    fi
    
    # Start the session in background and monitor it
    timeout 30s "$session_script" --debug &
    local session_pid=$!
    echo $session_pid > /tmp/test-i3xgnome-session.pid
    
    # Monitor session startup
    local startup_time=0
    while [ $startup_time -lt 15 ]; do
        if ! kill -0 $session_pid 2>/dev/null; then
            log_error "Session process died during startup"
            return 1
        fi
        
        # Check if i3 is running in the test display
        if DISPLAY="$DISPLAY_NUM" i3-msg get_version >/dev/null 2>&1; then
            log_success "i3 is running in test session"
            break
        fi
        
        sleep 1
        startup_time=$((startup_time + 1))
    done
    
    if [ $startup_time -ge 15 ]; then
        log_warning "Session startup took longer than expected"
    fi
    
    # Test i3 functionality
    if DISPLAY="$DISPLAY_NUM" i3-msg get_workspaces >/dev/null 2>&1; then
        log_success "i3 is responding to commands"
    else
        log_warning "i3 is not responding to commands"
    fi
    
    # Let it run for a few seconds to test stability
    log_info "Testing session stability (5 seconds)..."
    sleep 5
    
    if kill -0 $session_pid 2>/dev/null; then
        log_success "Session is stable"
        
        # Gracefully terminate
        log_info "Terminating test session..."
        kill -TERM $session_pid 2>/dev/null || true
        sleep 2
        kill -KILL $session_pid 2>/dev/null || true
        
        return 0
    else
        log_error "Session crashed during stability test"
        return 1
    fi
}

# Cleanup function
cleanup() {
    log_info "Cleaning up test environment..."
    
    # Kill session if running
    if [ -f /tmp/test-i3xgnome-session.pid ]; then
        local session_pid=$(cat /tmp/test-i3xgnome-session.pid 2>/dev/null || echo "")
        if [ -n "$session_pid" ]; then
            kill -TERM $session_pid 2>/dev/null || true
            sleep 1
            kill -KILL $session_pid 2>/dev/null || true
        fi
        rm -f /tmp/test-i3xgnome-session.pid
    fi
    
    # Kill Xephyr if running
    if [ -f /tmp/test-i3xgnome-xephyr.pid ]; then
        local xephyr_pid=$(cat /tmp/test-i3xgnome-xephyr.pid 2>/dev/null || echo "")
        if [ -n "$xephyr_pid" ]; then
            kill -TERM $xephyr_pid 2>/dev/null || true
            sleep 1
            kill -KILL $xephyr_pid 2>/dev/null || true
        fi
        rm -f /tmp/test-i3xgnome-xephyr.pid
    fi
    
    # Clean up D-Bus if we started it
    if [ -f /tmp/test-i3xgnome-dbus.env ]; then
        rm -f /tmp/test-i3xgnome-dbus.env
    fi
    
    log_info "Cleanup completed"
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Test i3xGnome integration in a nested X session"
    echo ""
    echo "Options:"
    echo "  --debug         Enable debug mode"
    echo "  --diagnostics   Run diagnostics only"
    echo "  --quick         Quick test (skip stability test)"
    echo "  --help          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                    # Full test"
    echo "  $0 --debug           # Test with debug output"
    echo "  $0 --diagnostics     # Run diagnostics only"
    echo "  DEBUG=1 $0           # Alternative debug mode"
}

# Main function
main() {
    local run_diagnostics_only=0
    local quick_test=0
    
    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            --debug)
                DEBUG=1
                ;;
            --diagnostics)
                run_diagnostics_only=1
                ;;
            --quick)
                quick_test=1
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done
    
    log_info "Starting i3xGnome test suite..."
    
    # Check dependencies
    check_dependencies
    
    if [ $run_diagnostics_only -eq 1 ]; then
        log_info "Running diagnostics only..."
        run_diagnostics
        exit 0
    fi
    
    # Find available display
    if ! check_display; then
        find_available_display
    fi
    
    # Start nested X server
    start_xephyr
    
    # Set up test environment
    setup_test_environment
    
    # Run component tests
    test_component "dbus" "D-Bus connectivity"
    test_component "i3-config" "i3 configuration"
    test_component "gnome-session" "GNOME session availability"
    
    # Run diagnostics in test environment
    run_diagnostics
    
    # Test the actual session
    if test_i3xgnome_session; then
        log_success "i3xGnome test completed successfully!"
        exit 0
    else
        log_error "i3xGnome test failed!"
        exit 1
    fi
}

# Run main function
main "$@" 
#!/bin/bash

# Message Display Functions for Cowrie Setup
# This script contains all the display messages used in the setup process

# Source this file to get access to message functions:
# source scripts/messages.sh

# Colors for output (already defined in main script, but included for completeness)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output functions
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Setup completion banner
show_completion_banner() {
    echo
    echo "=================================================="
    print_status "COWRIE HONEYPOT SETUP COMPLETE"
    echo "=================================================="
}

# Service status display
show_service_status() {
    local service_status=$(systemctl is-active cowrie 2>/dev/null || echo "unknown")
    echo
    print_status "✓ SSH Honeypot: Port 22 → 2222"
    print_status "✓ Telnet Honeypot: Port 23 → 2323"
    print_status "✓ Service Status: $service_status"
    echo
}

# Essential locations display
show_essential_locations() {
    echo "📁 Essential Locations:"
    echo "  • Config: /home/cowrie/cowrie/etc/cowrie.cfg"
    echo "  • Logs: /home/cowrie/cowrie/var/log/cowrie/"
    echo "  • Downloads: /home/cowrie/cowrie/var/lib/cowrie/downloads/"
    echo
}

# Quick commands display
show_quick_commands() {
    echo "🔧 Quick Commands:"
    echo "  • Status: sudo systemctl status cowrie"
    echo "  • Logs: tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.log"
    echo "  • Monitor: /home/cowrie/cowrie/monitor.sh"
    echo
}

# Documentation references
show_documentation_references() {
    print_status "📚 Complete documentation available in: docs/"
    echo "  • Installation Guide: docs/installation-guide.md"
    echo "  • Setup Complete Info: docs/setup-complete.md"  
    echo "  • Security Guidelines: docs/security-warnings.md"
    echo "  • Documentation Index: docs/README.md"
    echo
}

# Security reminders
show_security_reminders() {
    print_warning "⚠️  SECURITY REMINDER:"
    print_warning "This honeypot will attract real attackers. Review docs/security-warnings.md"
    print_warning "Ensure proper network isolation and monitoring before exposing to internet."
    echo
}

# Final success message
show_final_success() {
    print_status "🎯 Setup completed successfully! The honeypot is ready to capture attacks."
    print_status "📖 Read docs/setup-complete.md for detailed management information."
}

# Complete setup display (combines all message functions)
show_setup_complete() {
    show_completion_banner
    show_service_status
    show_essential_locations
    show_quick_commands
    show_documentation_references
    show_security_reminders
    show_final_success
}

# Installation progress messages
show_installation_start() {
    print_status "Starting Cowrie honeypot installation on $(hostname)"
}

show_system_update() {
    print_status "Updating system packages..."
}

show_dependencies_install() {
    print_status "Installing dependencies..."
}

show_user_creation() {
    print_status "Creating cowrie user..."
}

show_environment_setup() {
    print_status "Switching to cowrie user and setting up environment..."
}

show_configuration_setup() {
    print_status "Configuring Cowrie with fake credentials and custom settings..."
}

show_config_validation() {
    print_status "Validating configuration files..."
}

show_port_redirection() {
    print_status "Setting up port redirection..."
}

show_firewall_config() {
    print_status "Configuring firewall rules..."
}

show_systemd_service() {
    print_status "Creating systemd service..."
}

show_log_rotation() {
    print_status "Setting up log rotation..."
}

show_permissions() {
    print_status "Setting permissions..."
}

show_monitoring_scripts() {
    print_status "Creating monitoring scripts..."
}

show_service_start() {
    print_status "Starting Cowrie service..."
}

# Error messages
show_root_user_error() {
    print_error "This script should not be run as root for security reasons"
    print_status "Please run as a regular user with sudo privileges"
}

show_config_directory_error() {
    local config_dir="$1"
    print_error "Configuration directory not found: $config_dir"
    print_status "Make sure the config/ directory is in the same location as this script"
}

show_validation_error() {
    print_error "Configuration validation failed"
}

show_service_start_error() {
    print_error "✗ Failed to start Cowrie service"
    print_status "Check logs with: sudo systemctl status cowrie"
}

# Success messages
show_user_created() {
    print_status "Cowrie user created successfully"
}

show_user_exists() {
    print_warning "Cowrie user already exists"
}

show_validation_success() {
    print_status "Basic configuration validation passed"
}

show_service_start_success() {
    print_status "✓ Cowrie honeypot is running successfully!"
    print_status "SSH honeypot listening on port 22 (redirected to 2222)"
    print_status "Telnet honeypot listening on port 23 (redirected to 2323)"
}

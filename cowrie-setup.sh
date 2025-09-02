#!/bin/bash

# Cowrie Honeypot Setup Script for Public VPS
# This script installs and configures Cowrie SSH/Telnet honeypot with fake credentials
# Author: Honeypot Security Team
# Date: September 2025

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions and messages
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/messages.sh"

# Check if running as root
if ! validate_user; then
   show_root_user_error
   exit 1
fi

show_installation_start

# Update system
show_system_update
install_system_packages

# Create cowrie user
show_user_creation
if create_cowrie_user; then
    if user_exists "cowrie"; then
        show_user_exists
    else
        show_user_created
    fi
fi

# Switch to cowrie user for installation
show_environment_setup
setup_cowrie_repository
setup_python_environment

# Configure Cowrie with custom settings
show_configuration_setup

# Get the config directory
CONFIG_DIR="$SCRIPT_DIR/config"

# Check if config directory exists
if ! validate_config_directory "$CONFIG_DIR"; then
    show_config_directory_error "$CONFIG_DIR"
    exit 1
fi

# Validate configuration files
show_config_validation
if [ -x "$CONFIG_DIR/validate-config.sh" ]; then
    if ! "$CONFIG_DIR/validate-config.sh"; then
        show_validation_error
        exit 1
    fi
else
    print_warning "Configuration validator not found or not executable"
    if ! validate_required_files "$CONFIG_DIR"; then
        show_validation_error
        exit 1
    fi
    show_validation_success
fi

# Copy configuration files
copy_config_files "$CONFIG_DIR"

# Generate SSH host keys and create directories
generate_ssh_keys
create_cowrie_directories

# Set up port redirection (redirect port 22 to 2222 and port 23 to 2323)
show_port_redirection
setup_authbind

# Configure iptables to redirect traffic
show_firewall_config
setup_iptables

# Create systemd service and copy system files
show_systemd_service
copy_system_files "$CONFIG_DIR"
enable_cowrie_service

# Create log rotation configuration
show_log_rotation

# Set proper permissions
show_permissions
set_cowrie_permissions

# Create monitoring script
show_monitoring_scripts

# Copy monitoring script from scripts directory
sudo -u cowrie cp "$SCRIPT_DIR/scripts/monitor.sh" /home/cowrie/cowrie/monitor.sh
sudo -u cowrie chmod +x /home/cowrie/cowrie/monitor.sh

# Copy backup script from scripts directory
sudo -u cowrie cp "$SCRIPT_DIR/scripts/backup.sh" /home/cowrie/cowrie/backup.sh
sudo -u cowrie chmod +x /home/cowrie/cowrie/backup.sh

# Add cron job for daily backup
setup_backup_cron

show_service_start
start_cowrie_service

# Wait a moment for service to start
sleep 3

# Check if service is running
if check_service_status; then
    show_service_start_success
else
    show_service_start_error
    exit 1
fi

# Display final information using message functions
show_setup_complete

#!/bin/bash

# Configuration Validation Script for Cowrie Honeypot
# This script validates that all required configuration files are present and properly formatted

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

echo "=== Cowrie Configuration Validation ==="
echo "Config directory: $CONFIG_DIR"
echo

# Required files
REQUIRED_FILES=(
    "cowrie.cfg"
    "userdb.txt"
    "motd"
    "cowrie.service"
    "cowrie.logrotate"
    "iptablesload"
)

# Check if all required files exist
missing_files=0
for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$CONFIG_DIR/$file" ]]; then
        print_status "Found: $file"
    else
        print_error "Missing: $file"
        missing_files=$((missing_files + 1))
    fi
done

echo

if [[ $missing_files -eq 0 ]]; then
    print_status "All required configuration files are present"
else
    print_error "$missing_files configuration file(s) missing"
    exit 1
fi

# Validate cowrie.cfg
echo "=== Validating cowrie.cfg ==="
if grep -q "\[honeypot\]" "$CONFIG_DIR/cowrie.cfg" && \
   grep -q "ssh_port = 2222" "$CONFIG_DIR/cowrie.cfg" && \
   grep -q "telnet_port = 2323" "$CONFIG_DIR/cowrie.cfg"; then
    print_status "cowrie.cfg appears valid"
else
    print_warning "cowrie.cfg may have issues - please check manually"
fi

# Validate userdb.txt
echo
echo "=== Validating userdb.txt ==="
user_count=$(grep -v "^#" "$CONFIG_DIR/userdb.txt" | grep -v "^$" | wc -l)
if [[ $user_count -gt 0 ]]; then
    print_status "userdb.txt contains $user_count user entries"
    
    # Check for common credentials
    if grep -q "root:0:123456" "$CONFIG_DIR/userdb.txt"; then
        print_status "Common weak credentials found"
    else
        print_warning "Consider adding more common weak credentials"
    fi
else
    print_error "userdb.txt appears empty or invalid"
fi

# Validate service file
echo
echo "=== Validating cowrie.service ==="
if grep -q "Description=Cowrie" "$CONFIG_DIR/cowrie.service" && \
   grep -q "User=cowrie" "$CONFIG_DIR/cowrie.service" && \
   grep -q "ExecStart=" "$CONFIG_DIR/cowrie.service"; then
    print_status "cowrie.service appears valid"
else
    print_warning "cowrie.service may have issues - please check manually"
fi

# Check file permissions
echo
echo "=== Checking file permissions ==="
for file in "${REQUIRED_FILES[@]}"; do
    if [[ -r "$CONFIG_DIR/$file" ]]; then
        print_status "$file is readable"
    else
        print_warning "$file may not be readable"
    fi
done

echo
echo "=== Validation Complete ==="

if [[ $missing_files -eq 0 ]]; then
    print_status "Configuration appears ready for deployment"
    echo "You can now run the cowrie-setup.sh script"
else
    print_error "Please fix the missing files before proceeding"
    exit 1
fi

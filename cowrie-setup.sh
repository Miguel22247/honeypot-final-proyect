#!/bin/bash

# Cowrie Honeypot Setup Script for Public VPS
# This script installs and configures Cowrie SSH/Telnet honeypot with fake credentials
# Author: Honeypot Security Team
# Date: September 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   print_status "Please run as a regular user with sudo privileges"
   exit 1
fi

print_status "Starting Cowrie honeypot installation on $(hostname)"

# Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
print_status "Installing dependencies..."
sudo apt install -y python3 python3-pip python3-venv git build-essential \
    libpython3-dev libffi-dev libssl-dev libmysqlclient-dev \
    mysql-server python3-virtualenv authbind

# Create cowrie user
print_status "Creating cowrie user..."
if ! id "cowrie" &>/dev/null; then
    sudo adduser --disabled-password --gecos "" cowrie
    print_status "Cowrie user created successfully"
else
    print_warning "Cowrie user already exists"
fi

# Switch to cowrie user for installation
print_status "Switching to cowrie user and setting up environment..."

sudo -u cowrie bash << 'EOF'
cd /home/cowrie

# Clone Cowrie repository
if [ ! -d "cowrie" ]; then
    git clone https://github.com/cowrie/cowrie.git
else
    echo "Cowrie directory already exists, updating..."
    cd cowrie && git pull && cd ..
fi

cd cowrie

# Create virtual environment
python3 -m venv cowrie-env
source cowrie-env/bin/activate

# Install Python requirements
pip install --upgrade pip
pip install -r requirements.txt

# Create configuration from template
cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Backup original configuration
cp etc/cowrie.cfg etc/cowrie.cfg.backup

EOF

# Configure Cowrie with custom settings
print_status "Configuring Cowrie with fake credentials and custom settings..."

# Get the script directory to find config files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

# Check if config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    print_error "Configuration directory not found: $CONFIG_DIR"
    print_status "Make sure the config/ directory is in the same location as this script"
    exit 1
fi

# Validate configuration files
print_status "Validating configuration files..."
if [ -x "$CONFIG_DIR/validate-config.sh" ]; then
    if ! "$CONFIG_DIR/validate-config.sh"; then
        print_error "Configuration validation failed"
        exit 1
    fi
else
    print_warning "Configuration validator not found or not executable"
    # Basic validation
    REQUIRED_FILES=("cowrie.cfg" "userdb.txt" "motd" "cowrie.service" "cowrie.logrotate" "iptablesload")
    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "$CONFIG_DIR/$file" ]; then
            print_error "Required configuration file missing: $file"
            exit 1
        fi
    done
    print_status "Basic configuration validation passed"
fi

sudo -u cowrie bash << EOF
cd /home/cowrie/cowrie

# Copy configuration files from the config directory
print_status "Copying Cowrie configuration files..."
cp "$CONFIG_DIR/cowrie.cfg" etc/cowrie.cfg
cp "$CONFIG_DIR/userdb.txt" etc/userdb.txt
cp "$CONFIG_DIR/motd" etc/motd

# Make sure the configuration files have correct ownership
chown cowrie:cowrie etc/cowrie.cfg etc/userdb.txt etc/motd

EOF

# Generate SSH host keys
ssh-keygen -t rsa -b 2048 -f etc/ssh_host_rsa_key -N ''
ssh-keygen -t dsa -b 1024 -f etc/ssh_host_dsa_key -N ''

# Create directories for logs and downloads
mkdir -p var/log/cowrie
mkdir -p var/lib/cowrie/downloads
mkdir -p var/lib/cowrie/tty
mkdir -p data

EOF

# Set up port redirection (redirect port 22 to 2222 and port 23 to 2323)
print_status "Setting up port redirection..."

# Allow cowrie user to bind to port 2222
sudo touch /etc/authbind/byport/2222
sudo chown cowrie:cowrie /etc/authbind/byport/2222
sudo chmod 755 /etc/authbind/byport/2222

# Allow cowrie user to bind to port 2323
sudo touch /etc/authbind/byport/2323
sudo chown cowrie:cowrie /etc/authbind/byport/2323
sudo chmod 755 /etc/authbind/byport/2323

# Configure iptables to redirect traffic
print_status "Configuring firewall rules..."

# Redirect SSH traffic from port 22 to 2222
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
# Redirect Telnet traffic from port 23 to 2323
sudo iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2323

# Save iptables rules
sudo sh -c "iptables-save > /etc/iptables.rules"

# Create script to restore iptables on boot
sudo cp "$CONFIG_DIR/iptablesload" /etc/network/if-pre-up.d/iptablesload
sudo chmod +x /etc/network/if-pre-up.d/iptablesload

# Create systemd service for Cowrie
print_status "Creating systemd service..."

sudo cp "$CONFIG_DIR/cowrie.service" /etc/systemd/system/cowrie.service

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable cowrie.service

# Create log rotation configuration
print_status "Setting up log rotation..."

sudo cp "$CONFIG_DIR/cowrie.logrotate" /etc/logrotate.d/cowrie

# Set proper permissions
print_status "Setting permissions..."
sudo chown -R cowrie:cowrie /home/cowrie/cowrie
sudo chmod -R 755 /home/cowrie/cowrie

# Create monitoring script
print_status "Creating monitoring scripts..."

sudo -u cowrie tee /home/cowrie/cowrie/monitor.sh > /dev/null << 'MONITOR'
#!/bin/bash

# Cowrie monitoring script
COWRIE_DIR="/home/cowrie/cowrie"
LOG_FILE="$COWRIE_DIR/var/log/cowrie/cowrie.log"

echo "=== Cowrie Status Report ==="
echo "Date: $(date)"
echo

# Check if Cowrie is running
if systemctl is-active --quiet cowrie; then
    echo "Status: RUNNING ✓"
else
    echo "Status: NOT RUNNING ✗"
fi

# Show recent connections
echo
echo "=== Recent Connections (Last 10) ==="
if [ -f "$LOG_FILE" ]; then
    tail -n 100 "$LOG_FILE" | grep "login attempt" | tail -n 10
else
    echo "No log file found"
fi

# Show connection statistics
echo
echo "=== Connection Statistics (Today) ==="
if [ -f "$LOG_FILE" ]; then
    TODAY=$(date +%Y-%m-%d)
    echo "Total login attempts today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | wc -l)"
    echo "Successful logins today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep "succeeded" | wc -l)"
    echo "Failed logins today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep "failed" | wc -l)"
fi

# Show top attacking IPs
echo
echo "=== Top Attacking IPs (Today) ==="
if [ -f "$LOG_FILE" ]; then
    TODAY=$(date +%Y-%m-%d)
    grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep -oP 'from \K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c | sort -nr | head -5
fi

# Show disk usage
echo
echo "=== Disk Usage ==="
echo "Log directory: $(du -sh $COWRIE_DIR/var/log/cowrie 2>/dev/null || echo "N/A")"
echo "Downloads directory: $(du -sh $COWRIE_DIR/var/lib/cowrie/downloads 2>/dev/null || echo "N/A")"
MONITOR

chmod +x /home/cowrie/cowrie/monitor.sh

# Create backup script
sudo -u cowrie tee /home/cowrie/cowrie/backup.sh > /dev/null << 'BACKUP'
#!/bin/bash

# Cowrie backup script
COWRIE_DIR="/home/cowrie/cowrie"
BACKUP_DIR="/home/cowrie/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "Creating backup: cowrie_backup_$DATE.tar.gz"

tar -czf "$BACKUP_DIR/cowrie_backup_$DATE.tar.gz" \
    -C "$COWRIE_DIR" \
    var/log/cowrie/ \
    var/lib/cowrie/downloads/ \
    etc/cowrie.cfg \
    etc/userdb.txt

echo "Backup completed: $BACKUP_DIR/cowrie_backup_$DATE.tar.gz"

# Keep only last 7 backups
find "$BACKUP_DIR" -name "cowrie_backup_*.tar.gz" -type f -mtime +7 -delete
BACKUP

chmod +x /home/cowrie/cowrie/backup.sh

# Add cron job for daily backup
(sudo -u cowrie crontab -l 2>/dev/null; echo "0 2 * * * /home/cowrie/cowrie/backup.sh >> /home/cowrie/backup.log 2>&1") | sudo -u cowrie crontab -

print_status "Starting Cowrie service..."
sudo systemctl start cowrie.service

# Wait a moment for service to start
sleep 3

# Check if service is running
if systemctl is-active --quiet cowrie; then
    print_status "✓ Cowrie honeypot is running successfully!"
    print_status "SSH honeypot listening on port 22 (redirected to 2222)"
    print_status "Telnet honeypot listening on port 23 (redirected to 2323)"
else
    print_error "✗ Failed to start Cowrie service"
    print_status "Check logs with: sudo systemctl status cowrie"
    exit 1
fi

# Display final information
echo
echo "=================================================="
print_status "COWRIE HONEYPOT SETUP COMPLETE"
echo "=================================================="
echo
echo "Service Status:"
echo "  • SSH Honeypot: Port 22 → 2222"
echo "  • Telnet Honeypot: Port 23 → 2323"
echo
echo "Configuration Files:"
echo "  • Main config: /home/cowrie/cowrie/etc/cowrie.cfg"
echo "  • User database: /home/cowrie/cowrie/etc/userdb.txt"
echo
echo "Log Files:"
echo "  • Main log: /home/cowrie/cowrie/var/log/cowrie/cowrie.log"
echo "  • JSON log: /home/cowrie/cowrie/var/log/cowrie/cowrie.json"
echo "  • Downloads: /home/cowrie/cowrie/var/lib/cowrie/downloads/"
echo
echo "Management Commands:"
echo "  • Check status: sudo systemctl status cowrie"
echo "  • Stop service: sudo systemctl stop cowrie"
echo "  • Start service: sudo systemctl start cowrie"
echo "  • View logs: tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.log"
echo "  • Monitor script: /home/cowrie/cowrie/monitor.sh"
echo "  • Backup script: /home/cowrie/cowrie/backup.sh"
echo
echo "Sample Credentials Available:"
echo "  • root:123456, root:password, admin:admin"
echo "  • user:password, test:test, ubuntu:ubuntu"
echo "  • And many more common weak credentials..."
echo
print_warning "SECURITY REMINDER:"
print_warning "This is a honeypot system designed to attract attackers."
print_warning "Ensure proper network isolation and monitoring."
print_warning "Regularly backup logs and analyze collected data."
echo "=================================================="

print_status "Setup completed successfully! The honeypot is ready to capture attacks."

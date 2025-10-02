#!/bin/bash

# Utility Functions for Cowrie Setup
# Author: Miguel Pacheco y Rolando Quiroz
# Este script contiene funciones de utilidad usadas en el proceso de instalación

# Validation functions
validate_user() {
    if [[ $EUID -eq 0 ]]; then
        return 1  # Running as root
    fi
    return 0  # Not running as root
}

validate_config_directory() {
    local config_dir="$1"
    if [ ! -d "$config_dir" ]; then
        return 1  # Directory doesn't exist
    fi
    return 0  # Directory exists
}

validate_required_files() {
    local config_dir="$1"
    local required_files=("cowrie.cfg" "userdb.txt" "motd" "cowrie.service" "cowrie.logrotate" "iptablesload")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$config_dir/$file" ]; then
            echo "Missing file: $file"
            return 1
        fi
    done
    return 0
}

# Service management functions
check_service_status() {
    systemctl is-active --quiet cowrie
    return $?
}

wait_for_service_start() {
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if check_service_status; then
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    return 1
}

# User management functions
user_exists() {
    local username="$1"
    id "$username" &>/dev/null
    return $?
}

create_cowrie_user() {
    if ! user_exists "cowrie"; then
        sudo adduser --disabled-password --gecos "" cowrie
        return $?
    fi
    return 0  # User already exists
}

# File operations
backup_file() {
    local file="$1"
    local backup_file="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$file" ]; then
        cp "$file" "$backup_file"
        echo "Backup created: $backup_file"
        return 0
    fi
    return 1
}

copy_config_files() {
    local config_dir="$1"
    local target_dir="/home/cowrie/cowrie/etc"
    
    # Copy main configuration files
    sudo -u cowrie cp "$config_dir/cowrie.cfg" "$target_dir/cowrie.cfg"
    sudo -u cowrie cp "$config_dir/userdb.txt" "$target_dir/userdb.txt"
    sudo -u cowrie cp "$config_dir/motd" "$target_dir/motd"
    
    # Set proper ownership
    sudo -u cowrie chown cowrie:cowrie "$target_dir/cowrie.cfg" "$target_dir/userdb.txt" "$target_dir/motd"
}

copy_system_files() {
    local config_dir="$1"
    
    # Copy systemd service file
    sudo cp "$config_dir/cowrie.service" /etc/systemd/system/cowrie.service
    
    # Copy log rotation configuration
    sudo cp "$config_dir/cowrie.logrotate" /etc/logrotate.d/cowrie
    
    # Copy iptables restoration script
    sudo cp "$config_dir/iptablesload" /etc/network/if-pre-up.d/iptablesload
    sudo chmod +x /etc/network/if-pre-up.d/iptablesload
}

# Network configuration
setup_authbind() {
    # Allow cowrie user to bind to port 2222
    sudo touch /etc/authbind/byport/2222
    sudo chown cowrie:cowrie /etc/authbind/byport/2222
    sudo chmod 755 /etc/authbind/byport/2222

    # Allow cowrie user to bind to port 2323
    sudo touch /etc/authbind/byport/2323
    sudo chown cowrie:cowrie /etc/authbind/byport/2323
    sudo chmod 755 /etc/authbind/byport/2323
}

setup_iptables() {
    # Redirect SSH traffic from port 22 to 2222
    sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
    
    # Redirect Telnet traffic from port 23 to 2323
    sudo iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2323

    # Save iptables rules
    sudo sh -c "iptables-save > /etc/iptables.rules"
}

# Permission management
set_cowrie_permissions() {
    sudo chown -R cowrie:cowrie /home/cowrie/cowrie
    sudo chmod -R 755 /home/cowrie/cowrie
}

# Service management
enable_cowrie_service() {
    sudo systemctl daemon-reload
    sudo systemctl enable cowrie.service
}

start_cowrie_service() {
    sudo systemctl start cowrie.service
}

# Directory creation
create_cowrie_directories() {
    sudo -u cowrie mkdir -p /home/cowrie/cowrie/var/log/cowrie
    sudo -u cowrie mkdir -p /home/cowrie/cowrie/var/lib/cowrie/downloads
    sudo -u cowrie mkdir -p /home/cowrie/cowrie/var/lib/cowrie/tty
    sudo -u cowrie mkdir -p /home/cowrie/cowrie/data
}

# SSH key generation
generate_ssh_keys() {
    sudo -u cowrie ssh-keygen -t rsa -b 2048 -f /home/cowrie/cowrie/etc/ssh_host_rsa_key -N ''
    sudo -u cowrie ssh-keygen -t dsa -b 1024 -f /home/cowrie/cowrie/etc/ssh_host_dsa_key -N ''
}

# Package installation
install_system_packages() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y python3 python3-pip python3-venv git build-essential \
        libpython3-dev libffi-dev libssl-dev libmysqlclient-dev \
        mysql-server python3-virtualenv authbind
}

# Python environment setup
setup_python_environment() {
    sudo -u cowrie bash << 'EOF'
cd /home/cowrie/cowrie

# Create virtual environment
python3 -m venv cowrie-env
source cowrie-env/bin/activate

# Install Python requirements
pip install --upgrade pip
pip install -r requirements.txt
EOF
}

# Cowrie repository setup
setup_cowrie_repository() {
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

# Create configuration from template
cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Backup original configuration
cp etc/cowrie.cfg etc/cowrie.cfg.backup
EOF
}

# Cron job setup
setup_backup_cron() {
    (sudo -u cowrie crontab -l 2>/dev/null; echo "0 2 * * * /home/cowrie/cowrie/backup.sh >> /home/cowrie/backup.log 2>&1") | sudo -u cowrie crontab -
}

# Configuration Files for Cowrie Honeypot

This directory contains the configuration files used by the Cowrie honeypot setup script.

## Files Description

### Core Configuration

- **`cowrie.cfg`** - Main Cowrie configuration file
  - Defines honeypot behavior, ports, logging settings
  - SSH/Telnet service configuration
  - Output modules configuration

### Authentication & Users

- **`userdb.txt`** - Fake user credentials database
  - Contains common weak username/password combinations
  - Format: `username:uid:password`
  - Used to simulate vulnerable system credentials

### System Files

- **`motd`** - Message of the Day file
  - Displayed after successful login
  - Simulates Ubuntu 18.04.5 LTS system information

### Service Management

- **`cowrie.service`** - Systemd service configuration
  - Defines how Cowrie runs as a system service
  - Handles automatic startup and restart behavior

### System Integration

- **`cowrie.logrotate`** - Log rotation configuration
  - Manages log file rotation to prevent disk space issues
  - Rotates logs daily, keeps 52 weeks of history

- **`iptablesload`** - Network rules restoration script
  - Restores iptables rules on system boot
  - Ensures port redirection persists after reboot

## Usage

These files are automatically copied to their appropriate locations by the `cowrie-setup.sh` script:

- `cowrie.cfg` → `/home/cowrie/cowrie/etc/cowrie.cfg`
- `userdb.txt` → `/home/cowrie/cowrie/etc/userdb.txt`
- `motd` → `/home/cowrie/cowrie/etc/motd`
- `cowrie.service` → `/etc/systemd/system/cowrie.service`
- `cowrie.logrotate` → `/etc/logrotate.d/cowrie`
- `iptablesload` → `/etc/network/if-pre-up.d/iptablesload`

## Customization

You can modify these files before running the setup script to customize your honeypot:

### Adding More Fake Users

Edit `userdb.txt` and add new lines in the format:

```text
username:uid:password
```

### Changing Honeypot Behavior

Modify `cowrie.cfg` to:

- Change ports (ssh_port, telnet_port)
- Enable/disable different output modules
- Modify system information displayed to attackers

### Customizing System Appearance

Edit `motd` to change what attackers see after logging in.

## Security Note

These configuration files are designed to make the honeypot appear as a vulnerable system to attract attackers. Do not use these credentials or configurations on production systems.

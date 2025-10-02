# Installation Instructions

## Pre-Installation Requirements

### System Requirements

- **Operating System:** Ubuntu 18.04+ or Debian 9+
- **RAM:** Minimum 1GB, recommended 2GB+
- **Storage:** Minimum 10GB free space for logs and downloads
- **Network:** Public IP address with ports 22 and 23 accessible

### Prerequisites

- Non-root user with sudo privileges
- Internet connection for package downloads
- Basic familiarity with Linux command line

## Installation Steps

### Step 1: Download the Setup Files

```bash
git clone <repository-url>
cd honeypot-final-proyect
```

### Step 2: Verify Configuration Files

```bash
# Check that all config files are present
ls -la config/
./config/validate-config.sh
```

### Step 3: Customize Configuration (Optional)

```bash
# Edit fake credentials
nano config/userdb.txt
# Modify honeypot settings
nano config/cowrie.cfg
# Customize welcome message
nano config/motd
```

### Step 4: Run the Installation Script

```bash
# Make script executable
chmod +x cowrie-setup.sh
# Run the installation
./cowrie-setup.sh
```

### Step 5: Post-Installation

- Check service status: `sudo systemctl status cowrie`
- View logs: `tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.log`
- Monitor attacks and connections using provided scripts

## Troubleshooting

- Ensure all configuration files are present in the `config/` directory
- Check permissions for copied files
- Review logs for errors
- Consult the documentation for common issues

## Maintenance

- Use `scripts/backup.sh` for regular backups
- Use `scripts/monitor.sh` for status and statistics
- Rotate logs using `config/cowrie.logrotate`

For more details, see the documentation in the `docs/` folder.

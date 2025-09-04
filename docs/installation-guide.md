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

### Step 5: Verify Installation

```bash

# Check service status
sudo systemctl status cowrie

# Test connectivity
nc -zv localhost 22
nc -zv localhost 23

# Monitor initial logs
tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.log
```

## Post-Installation Configuration

### Firewall Configuration

If using UFW (Ubuntu Firewall):

```bash

# Allow SSH and Telnet through firewall
sudo ufw allow 22
sudo ufw allow 23
sudo ufw enable
```

### Log Monitoring Setup

```bash

# Set up log monitoring cron job
echo "*/5 * * * * /home/cowrie/cowrie/monitor.sh >> /var/log/cowrie-monitor.log 2>&1" | sudo crontab -
```

### Backup Configuration

The script automatically sets up daily backups at 2 AM. To modify:

```bash

# Edit crontab for cowrie user
sudo -u cowrie crontab -e
```

## Troubleshooting

### Common Issues

#### Service Won't Start

```bash

# Check service status
sudo systemctl status cowrie

# Check detailed logs
sudo journalctl -u cowrie -f

# Verify port availability
sudo netstat -tlnp | grep :2222
sudo netstat -tlnp | grep :2323
```

#### Permission Issues

```bash

# Fix ownership
sudo chown -R cowrie:cowrie /home/cowrie/cowrie

# Fix permissions
sudo chmod -R 755 /home/cowrie/cowrie
```

#### Network Issues

```bash

# Check iptables rules
sudo iptables -t nat -L

# Verify authbind configuration
ls -la /etc/authbind/byport/
```

### Log File Locations

- **Service logs:** `/var/log/syslog` (search for "cowrie")
- **Cowrie logs:** `/home/cowrie/cowrie/var/log/cowrie/`
- **System logs:** `sudo journalctl -u cowrie`

## Security Considerations

### Network Isolation

- Deploy on isolated network or VLAN
- Use firewall rules to control access
- Monitor network traffic to/from honeypot

### Data Protection

- Regularly backup attack data
- Implement log rotation to manage disk space
- Consider encrypting stored logs

### Legal Compliance

- Ensure compliance with local laws
- Consider notification requirements
- Document security procedures

## Maintenance

### Regular Tasks

1. **Daily:** Check service status and logs
2. **Weekly:** Review attack patterns and update analysis
3. **Monthly:** Update system packages (carefully)
4. **Quarterly:** Review and update fake credentials

### Updates and Patches

```bash

# Update Cowrie (run as cowrie user)
sudo -u cowrie bash
cd /home/cowrie/cowrie
source cowrie-env/bin/activate
git pull
pip install -r requirements.txt

# Restart service
sudo systemctl restart cowrie
```

## Support and Documentation

- **Cowrie Documentation:** <https://cowrie.readthedocs.io/>
- **Configuration Reference:** `config/README.md`
- **Project Structure:** `PROJECT-STRUCTURE.md`
- **Setup Complete Guide:** `docs/setup-complete.md`

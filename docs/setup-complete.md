# Cowrie Honeypot Setup Complete

## Service Status

- **SSH Honeypot:** Port 22 → 2222
- **Telnet Honeypot:** Port 23 → 2323

## Configuration Files

- **Main config:** `/home/cowrie/cowrie/etc/cowrie.cfg`
- **User database:** `/home/cowrie/cowrie/etc/userdb.txt`
- **MOTD file:** `/home/cowrie/cowrie/etc/motd`

## Log Files

- **Main log:** `/home/cowrie/cowrie/var/log/cowrie/cowrie.log`
- **JSON log:** `/home/cowrie/cowrie/var/log/cowrie/cowrie.json`
- **Downloads:** `/home/cowrie/cowrie/var/lib/cowrie/downloads/`

## Management Commands

### Service Management

```bash

# Check status
sudo systemctl status cowrie

# Stop service
sudo systemctl stop cowrie

# Start service
sudo systemctl start cowrie

# Restart service
sudo systemctl restart cowrie

# View service logs
sudo journalctl -u cowrie -f
```

### Log Monitoring

```bash

# View live logs
tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.log

# View JSON logs
tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.json

# Search for specific attacks
grep "login attempt" /home/cowrie/cowrie/var/log/cowrie/cowrie.log

# View recent connections
tail -n 50 /home/cowrie/cowrie/var/log/cowrie/cowrie.log | grep "New connection"
```

### Utility Scripts

```bash

# Run monitoring script
/home/cowrie/cowrie/monitor.sh

# Run backup script
/home/cowrie/cowrie/backup.sh

# Validate configuration
./config/validate-config.sh
```

## Sample Credentials Available

The honeypot is configured with common weak credentials that attackers often try:

### Root Credentials

- `root:123456`
- `root:password`
- `root:root`
- `root:toor`
- `root:12345`
- `root:qwerty`
- `root:abc123`
- `root:password123`

### Admin Credentials

- `admin:admin`
- `admin:password`
- `admin:123456`
- `admin:12345`
- `administrator:admin`
- `administrator:password`

### Common User Credentials

- `user:user`
- `user:password`
- `test:test`
- `guest:guest`
- `ubuntu:ubuntu`
- `pi:raspberry`

### Service Account Credentials

- `oracle:oracle`
- `postgres:postgres`
- `mysql:mysql`
- `ftp:ftp`
- `www-data:www-data`

## Network Configuration

The honeypot uses iptables rules to redirect standard ports to high-numbered ports:

- Port 22 (SSH) → Port 2222
- Port 23 (Telnet) → Port 2323

This allows Cowrie to run as a non-root user while still capturing traffic on standard ports.

## Security Considerations

⚠️ **IMPORTANT SECURITY REMINDERS:**

1. **Network Isolation:** This is a honeypot system designed to attract attackers. Ensure proper network isolation and monitoring.

2. **Regular Monitoring:** Regularly backup logs and analyze collected data.

3. **System Updates:** Keep the underlying system updated while being careful not to break the honeypot configuration.

4. **Data Protection:** The logs will contain real attack data. Ensure proper handling according to your security policies.

5. **Legal Compliance:** Ensure your honeypot deployment complies with local laws and regulations.

## Next Steps

1. **Monitor Activity:** Use the monitoring script to check for incoming attacks
2. **Analyze Logs:** Review the logs regularly to understand attack patterns
3. **Backup Data:** Set up regular backups of the captured data
4. **Document Findings:** Keep records of interesting attacks for analysis
5. **Network Analysis:** Consider integrating with tools like ELK stack for better analysis

The honeypot is now ready to capture attacks and provide valuable intelligence about attacker behavior!

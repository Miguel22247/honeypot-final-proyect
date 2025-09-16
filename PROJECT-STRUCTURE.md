# Cowrie Honeypot Project Structure

This project has been reorganized to use modular configuration files for better maintainability and customization.

## Project Structure

```plaintext
honeypot-final-proyect/
├── attacker-scripts/           # Scripts and resources for attacking/testing the honeypot
│   ├── passwords.txt           # Password dictionary for brute force
│   ├── README.md               # Documentation for attacker scripts
│   ├── ssh-bruteforce.sh       # SSH brute force attack script
│   └── schedule-ssh-bruteforce.sh # Script para agendar ataques automáticos vía cron
├── config/                     # Configuration files for Cowrie
│   ├── cowrie.cfg
│   ├── cowrie.logrotate
│   ├── cowrie.service
│   ├── iptablesload
│   ├── motd
│   ├── README.md
│   ├── userdb.txt
│   └── validate-config.sh
├── docs/                       # Project documentation
│   ├── installation-guide.md
│   ├── organization-summary.md
│   ├── README.md
│   ├── security-warnings.md
│   └── setup-complete.md
├── elk-setup/                  # ELK Stack setup and integration
│   ├── elk-cowrie-aws-guia.md  # Guide for ELK + Cowrie + AWS
│   ├── elk-install.sh          # ELK installation script
│   ├── kibana-dashboard.ndjson # Example Kibana dashboard
│   ├── logstash/               # Logstash pipeline configs
│   │   └── cowrie.conf         # Logstash pipeline for Cowrie logs
│   ├── logstash-cowrie.conf    # (legacy, see logstash/cowrie.conf)
│   └── README.md
├── scripts/                    # Utility scripts
│   ├── backup.sh
│   ├── fix-markdown.sh
│   ├── messages.sh
│   ├── monitor.sh
│   ├── README.md
│   └── utils.sh
├── .gitignore
├── cowrie-setup.sh             # Main installation script
├── LICENSE
├── PROJECT-STRUCTURE.md
├── README.md
├── RESTRUCTURE-SUMMARY.md
```

## Changes Made

### Before (Monolithic)

- All configuration was embedded in the main setup script
- Hard to customize without editing the script
- Difficult to maintain and version control configurations
- Single large file with mixed concerns

### After (Modular)

- Configuration files separated into dedicated directory
- Easy to customize by editing individual config files
- Better version control and maintenance
- Clear separation of concerns
- Validation script ensures configuration integrity
- Attacker scripts ahora incluyen automatización de ataques vía cron con `schedule-ssh-bruteforce.sh` para pruebas de laboratorio

## Usage

1. **Customize Configuration** (Optional)

   ```bash
   cd config/
   # Edit any configuration files as needed
   vim cowrie.cfg userdb.txt motd
   ```

2. **Validate Configuration**

   ```bash
   ./config/validate-config.sh
   ```

3. **Run Installation**

   ```bash
   chmod +x cowrie-setup.sh
   ./cowrie-setup.sh
   ```

## Benefits

### 🔧 **Modularity**

- Each configuration file serves a specific purpose
- Easy to understand and modify individual components
- Reusable across different deployments

### 📝 **Documentation**

- Each configuration file is well-documented
- README files explain the purpose and usage
- Validation script ensures correctness

### 🔄 **Maintainability**

- Version control friendly structure
- Easy to backup and restore configurations
- Simple to test different configuration sets

### 🎯 **Customization**

- Modify fake credentials without touching main script
- Adjust honeypot behavior through config files
- Change system appearance and responses

## Configuration Files Overview

| File | Purpose | Location after installation |
|------|---------|---------------------------|
| `cowrie.cfg` | Main honeypot behavior | `/home/cowrie/cowrie/etc/cowrie.cfg` |
| `userdb.txt` | Fake login credentials | `/home/cowrie/cowrie/etc/userdb.txt` |
| `motd` | Login welcome message | `/home/cowrie/cowrie/etc/motd` |
| `cowrie.service` | System service definition | `/etc/systemd/system/cowrie.service` |
| `cowrie.logrotate` | Log management rules | `/etc/logrotate.d/cowrie` |
| `iptablesload` | Network rules restoration | `/etc/network/if-pre-up.d/iptablesload` |

This structure makes the honeypot deployment more professional, maintainable, and suitable for production use while maintaining the simplicity of the original single-script approach.

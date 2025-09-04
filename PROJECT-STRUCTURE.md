# Cowrie Honeypot Project Structure

This project has been reorganized to use modular configuration files for better maintainability and customization.

## Project Structure

```plaintext
honeypot-final-proyect/
├── README.md                    # Project overview and timeline
├── cowrie-setup.sh             # Main installation script
└── config/                     # Configuration files directory
    ├── README.md               # Configuration documentation
    ├── validate-config.sh      # Configuration validation script
    ├── cowrie.cfg              # Main Cowrie configuration
    ├── userdb.txt              # Fake user credentials database
    ├── motd                    # Message of the Day file
    ├── cowrie.service          # Systemd service configuration
    ├── cowrie.logrotate        # Log rotation configuration
    └── iptablesload            # Network rules restoration script
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

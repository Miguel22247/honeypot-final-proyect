# Scripts Directory

This directory contains modular scripts used by the Cowrie honeypot setup and management system.

## Script Organization

### Core Setup Scripts

**`messages.sh`** - Display Message Functions

- Contains all user-facing messages and banners
- Provides colored output functions
- Modular message display for different setup phases
- Easy to customize and translate

**`utils.sh`** - Utility Functions

- Core functionality used throughout the setup process
- Validation functions for user, directories, and files
- Service management helpers
- File operations and system configuration
- Network setup utilities

### Monitoring and Maintenance Scripts

**`monitor.sh`** - Honeypot Monitoring

- Real-time status reporting
- Connection statistics and analysis
- Top attacking IPs identification
- Disk usage monitoring
- Can be run manually or via cron

**`backup.sh`** - Backup Management

- Automated backup of logs and configuration
- Configurable retention period (default: 7 days)
- Compressed backup format
- Scheduled via cron job

### Utility Scripts

**`fix-markdown.sh`** - Documentation Maintenance

- Fixes common markdown linter errors
- Adds proper spacing around headings and lists
- Processes all markdown files in the project
- Creates backup files before modification

## Usage

### In Setup Script

The main `cowrie-setup.sh` script sources the core scripts:

```bash
source scripts/utils.sh
source scripts/messages.sh
```

### Manual Execution

Individual scripts can be run directly:

```bash
# Monitor honeypot status
./scripts/monitor.sh

# Create manual backup
./scripts/backup.sh

# Fix markdown formatting
./scripts/fix-markdown.sh
```

### Cron Integration

Scripts are designed for cron integration:

```bash
# Monitor every 5 minutes
*/5 * * * * /path/to/scripts/monitor.sh >> /var/log/cowrie-monitor.log

# Backup daily at 2 AM
0 2 * * * /path/to/scripts/backup.sh >> /var/log/cowrie-backup.log
```

## Script Functions

### messages.sh Functions

- `show_completion_banner()` - Setup completion banner
- `show_service_status()` - Service status display
- `show_essential_locations()` - File locations
- `show_quick_commands()` - Common commands
- `show_documentation_references()` - Documentation links
- `show_security_reminders()` - Security warnings
- `show_setup_complete()` - Combined completion display

### utils.sh Functions

- `validate_user()` - Check if running as non-root
- `validate_config_directory()` - Verify config directory exists
- `create_cowrie_user()` - Create system user
- `setup_python_environment()` - Configure Python environment
- `setup_iptables()` - Configure network rules
- `copy_config_files()` - Deploy configuration files
- `set_cowrie_permissions()` - Fix file permissions

## Benefits of Modular Structure

### Maintainability

- Easy to update individual components
- Clear separation of concerns
- Reusable functions across scripts
- Simplified testing and debugging

### Customization

- Easy to modify messages without touching core logic
- Simple to add new utility functions
- Configurable behavior through function parameters
- Extensible architecture

### Reliability

- Centralized error handling
- Consistent behavior across scripts
- Reduced code duplication
- Better error messages and logging

## Development Guidelines

### Adding New Functions

1. Determine if function belongs in `utils.sh` or `messages.sh`
2. Follow existing naming conventions
3. Include proper error handling
4. Document function purpose and parameters
5. Test function independently

### Message Standards

- Use consistent formatting
- Include appropriate color coding
- Provide clear, actionable information
- Keep messages concise but informative

### Utility Standards

- Return appropriate exit codes
- Handle errors gracefully
- Use consistent parameter patterns
- Include input validation

This modular approach makes the honeypot deployment system more professional, maintainable, and suitable for production environments.

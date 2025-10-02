# Cowrie Honeypot Project Structure

Este proyecto ha sido reorganizado para usar archivos de configuración modulares, facilitando el mantenimiento y la personalización.

## Estructura del Proyecto (Español)

```plaintext
honeypot-final-proyect/
├── cowrie-setup.sh                # Script de instalación Docker para Cowrie & ELK
├── attacker-scripts/              # Scripts y recursos para atacar/probar el honeypot
│   ├── passwords.txt
│   ├── README.md
│   ├── schedule-ssh-bruteforce.sh
│   └── ssh-bruteforce.sh
├── config/                        # Archivos de configuración para Cowrie
│   ├── cowrie.cfg
│   ├── cowrie.logrotate
│   ├── cowrie.service
│   ├── iptablesload
│   ├── motd
│   ├── README.md
│   ├── userdb.txt
│   └── validate-config.sh
├── docs/                          # Documentación
│   ├── installation-guide.md
│   ├── organization-summary.md
│   ├── README.md
│   ├── security-warnings.md
│   └── setup-complete.md
├── elk-setup/                     # Configuración e integración de ELK Stack
│   ├── elk-cowrie-aws-guia.md
│   ├── elk-install.sh
│   ├── filebeat-cowrie.conf
│   ├── filebeat-cowrie.yml
│   ├── install-elk-docker.sh
│   ├── kibana-dashboard.ndjson
│   ├── logstash/
│   │   └── cowrie.conf
│   ├── logstash-cowrie.conf
│   └── README.md
├── scripts/                       # Funciones de mensajes y utilidades
│   ├── backup.sh
│   ├── fix-markdown.sh
│   ├── install-filebeat.sh
│   ├── messages.sh
│   ├── monitor.sh
│   ├── README.md
│   └── utils.sh
├── .gitignore
├── LICENSE
├── PROJECT-STRUCTURE.md
├── README.md
└── RESTRUCTURE-SUMMARY.md
```

## Cambios Realizados

### Antes (Monolítico)

- Toda la configuración estaba embebida en el script principal
- Difícil de mantener y personalizar

### Después (Modular)

- Archivos de configuración separados en `config/`
- Scripts separados en `scripts/` y `attacker-scripts/`
- Documentación movida a `docs/`
- Integración ELK en `elk-setup/`
- Más fácil de mantener, actualizar y extender

---

# Cowrie Honeypot Project Structure (English)

This project has been reorganized to use modular configuration files for better maintainability and customization.

## Project Structure

```plaintext
honeypot-final-proyect/
├── cowrie-setup.sh                # Docker setup script for Cowrie & ELK
├── attacker-scripts/              # Scripts and resources for attacking/testing the honeypot
│   ├── passwords.txt
│   ├── README.md
│   ├── schedule-ssh-bruteforce.sh
│   └── ssh-bruteforce.sh
├── config/                        # Configuration files for Cowrie
│   ├── cowrie.cfg
│   ├── cowrie.logrotate
│   ├── cowrie.service
│   ├── iptablesload
│   ├── motd
│   ├── README.md
│   ├── userdb.txt
│   └── validate-config.sh
├── docs/                          # Documentation
│   ├── installation-guide.md
│   ├── organization-summary.md
│   ├── README.md
│   ├── security-warnings.md
│   └── setup-complete.md
├── elk-setup/                     # ELK Stack setup and integration
│   ├── elk-cowrie-aws-guia.md
│   ├── elk-install.sh
│   ├── filebeat-cowrie.conf
│   ├── filebeat-cowrie.yml
│   ├── install-elk-docker.sh
│   ├── kibana-dashboard.ndjson
│   ├── logstash/
│   │   └── cowrie.conf
│   ├── logstash-cowrie.conf
│   └── README.md
├── scripts/                       # Message functions and utilities
│   ├── backup.sh
│   ├── fix-markdown.sh
│   ├── install-filebeat.sh
│   ├── messages.sh
│   ├── monitor.sh
│   ├── README.md
│   └── utils.sh
├── .gitignore
├── LICENSE
├── PROJECT-STRUCTURE.md
├── README.md
└── RESTRUCTURE-SUMMARY.md
```

## Changes Made

### Before (Monolithic)

- All configuration was embedded in the main setup script
- Difficult to maintain and customize

### After (Modular)

- Configuration files separated into `config/`
- Scripts separated into `scripts/` and `attacker-scripts/`
- Documentation moved to `docs/`
- ELK integration in `elk-setup/`
- Easier to maintain, update, and extend

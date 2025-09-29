# Cowrie Docker Setup

This script installs and runs the Cowrie honeypot using Docker. It is ideal for quick deployment and easy management on any Linux server (including cloud VPS).

## Usage

1. Give execution permissions to the script:

   ```bash
   chmod +x cowrie-docker-setup.sh
   ```

2. Run the setup script:

   ```bash
   ./cowrie-docker-setup.sh
   ```

## What the script does

- Installs Docker if not present
- Pulls the official Cowrie Docker image
- Creates a persistent data directory (`~/cowrie-docker-data`)
- Runs Cowrie in a container, exposing:
  - SSH honeypot on port 2222
  - Telnet honeypot on port 2323

## Accessing Cowrie

- SSH honeypot: `ssh <anyuser>@<server_ip> -p 2222`
- Telnet honeypot: `telnet <server_ip> 2323`
- All Cowrie logs and data are stored in `~/cowrie-docker-data`

## Stopping/Starting Cowrie

- Stop: `docker stop cowrie`
- Start: `docker start cowrie`
- Remove: `docker rm cowrie`

## More info

- Official Cowrie repo: <https://github.com/cowrie/cowrie>
- Docker image: <https://hub.docker.com/r/cowrie/cowrie>

---

For advanced configuration, see the Cowrie documentation and Docker image options.

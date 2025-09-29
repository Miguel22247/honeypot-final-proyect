
# Honeypot for Cyberattack Monitoring

This project guides you through deploying and monitoring honeypots (Cowrie, Honeyd) to simulate vulnerable systems, attract real-world attackers, and analyze their behavior. The goal is to understand attack techniques, tools, and origins, and to generate actionable reports for improving system defenses.

## Project Overview

- **Objective:** Deploy honeypots to study attacker methods in the wild.
- **Tools:** Cowrie (SSH), Honeyd, ELK Stack (Elasticsearch, Logstash, Kibana), Suricata.
- **Team Size:** 3
- **Duration:** 1 month

## Timeline

- **Week 1:** Deploy Cowrie on a public VPS, configure with fake credentials. ✅
- **Week 2:** Capture attacker commands and upload behavior, integrate with ELK for log analysis. ✅
- **Week 3:** Analyze attack patterns, fingerprint sources (IP, country, tools used).
- **Week 4:** Report results, suggest network hardening and improvements.

## Deliverables

- Honeypot logs
- Attack timeline
- Network analysis report
- Recommendations for defense

## Repository Structure

See [`PROJECT-STRUCTURE.md`](PROJECT-STRUCTURE.md) for a detailed directory and file overview.

## Documentation

- [Installation Guide](docs/installation-guide.md)
- [Security Warnings](docs/security-warnings.md)
- [ELK + Cowrie + AWS Guide](elk-setup/elk-cowrie-aws-guia.md)

## Quick Start

1. Clone this repository.
2. Review and customize configuration files in `config/`.
3. Run the main setup script:

  ```bash
  chmod +x cowrie-setup.sh
  ./cowrie-setup.sh
  ```

4. (Optional) Set up ELK Stack using scripts and guides in `elk-setup/`.

---

For more details, see the documentation in the `docs/` folder.

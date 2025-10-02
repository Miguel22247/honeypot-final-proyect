# ELK Stack + Cowrie Integration

This directory contains scripts and configuration files for installing and connecting the ELK stack (Elasticsearch, Logstash, Kibana) with the Cowrie honeypot.

## What is the ELK Stack?

- **Elasticsearch:** Search and data storage engine.
- **Logstash:** Log processor and transformer.
- **Kibana:** Visualization and dashboards.

## Why integrate with Cowrie?

- Centralizes and visualizes attack logs captured by Cowrie.
- Enables real-time analysis, alerts, and dashboards.

---

## Quick Installation (Ubuntu/Debian)

1. **Install Java (required for Elasticsearch and Logstash):**

   ```bash
   sudo apt update
   sudo apt install -y openjdk-11-jre-headless
   ```

2. **Run the installation script:**

   ```bash
   cd elk-setup
   sudo bash elk-install.sh
   ```

3. **Configure Logstash for Cowrie:**
   - Edit `logstash-cowrie.conf` if needed.
   - Copy the file to `/etc/logstash/conf.d/` and restart Logstash:

     ```bash
     sudo cp logstash-cowrie.conf /etc/logstash/conf.d/
     sudo systemctl restart logstash
     ```

4. **Verify Kibana:**
   - Access `http://localhost:5601` in your browser.
   - Create an index called `cowrie-*` to visualize logs.

---

## Quick ELK Installation with Docker

This project includes a script to install Docker and run the ELK stack (Elasticsearch, Logstash, Kibana) using the `sebp/elk` image.

### Steps

1. Connect to your Linux (Ubuntu) instance via SSH.
2. Run:

   ```bash
   chmod +x install-elk-docker.sh
   ./install-elk-docker.sh
   ```

3. Access Kibana at `http://<IP>:5601`.

### Exposed Ports

- 5601: Kibana
- 9200: Elasticsearch
- 5044: Logstash (Filebeat)

### Notes

- The script installs Docker if not present and runs the ELK container automatically.
- The image used is `sebp/elk` from Docker Hub.
- To stop the container: `sudo docker stop elk`
- To remove the container: `sudo docker rm elk`

---

## Integration with Cowrie

- Configure Cowrie to output logs in JSON format (`output_jsonlog` in `cowrie.cfg`).
- Use Filebeat or Logstash to forward logs to Elasticsearch.
- Visualize and analyze attack data in Kibana dashboards.

For more details, see the installation and configuration scripts in this folder.

---

## Included Files

- `elk-install.sh`: Automated script to install Elasticsearch, Logstash, and Kibana.
- `logstash-cowrie.conf`: Logstash configuration to parse Cowrie JSON logs.
- `kibana-dashboard.ndjson`: Example dashboard for import into Kibana.
- `README.md`: This guide.

---

## Useful Resources

- [Official Cowrie Documentation](https://docs.cowrie.org/en/latest/)
- [Elastic Stack Documentation](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-elastic-stack.html)

---

> **Tip:** You can send Cowrie logs to Logstash using Filebeat or directly with Logstash reading the JSON file (`cowrie.json`).

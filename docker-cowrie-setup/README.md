# Cowrie Docker Setup

Use `cowrie-setup.sh` to deploy Cowrie and ELK with Docker. See the main README for details.

## ELK Integration

To run the official ELK stack using Docker:

```bash
sudo docker run -d --name elk -p 5601:5601 -p 9200:9200 -p 5044:5044 sebp/elk:latest
```

Configure Cowrie and ELK to send logs via Filebeat or Logstash as needed.

#!/bin/bash
# Instala Elasticsearch, Logstash y Kibana en Ubuntu/Debian
# Ejecutar como root o con sudo
set -e

# Variables
ELK_VERSION="8.13.4"

# 1. Instala dependencias
apt update
apt install -y apt-transport-https wget gnupg openjdk-11-jre-headless

# 2. Añade la clave y repositorio de Elastic
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
apt update

# 3. Instala Elasticsearch, Logstash y Kibana
apt install -y elasticsearch=$ELK_VERSION logstash=$ELK_VERSION kibana=$ELK_VERSION

# 4. Habilita y arranca los servicios
systemctl enable elasticsearch --now
systemctl enable logstash --now
systemctl enable kibana --now

# 5. Muestra estado
systemctl status elasticsearch --no-pager
systemctl status logstash --no-pager
systemctl status kibana --no-pager

echo "\nELK Stack instalado. Accede a Kibana en http://localhost:5601"
echo "Recuerda configurar la seguridad y los pipelines de Logstash para Cowrie."

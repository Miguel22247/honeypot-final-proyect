#!/bin/bash
# Instala y configura Filebeat para Cowrie + Logstash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_status "Instalando Filebeat y configurando para Cowrie..."
sudo apt update
sudo apt install -y filebeat

# Copiar configuración recomendada
if [ -f "$PROJECT_DIR/elk-setup/filebeat-cowrie.yml" ]; then
    sudo cp "$PROJECT_DIR/elk-setup/filebeat-cowrie.yml" /etc/filebeat/filebeat.yml
    print_status "Configuración copiada: filebeat-cowrie.yml"
else
    print_error "No se encontró filebeat-cowrie.yml en elk-setup."
    exit 1
fi

# Habilitar e iniciar Filebeat
sudo systemctl enable filebeat
sudo systemctl restart filebeat
print_status "Servicio Filebeat iniciado. Verifica con: sudo systemctl status filebeat"

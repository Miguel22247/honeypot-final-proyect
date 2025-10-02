#!/bin/bash
# Instala Docker y ejecuta el contenedor ELK (sebp/elk) en una instancia Linux (Ubuntu)
# Author: Miguel Pacheco y Rolando Quiroz

set -e

# Actualiza el sistema y instala Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Habilita y arranca el servicio Docker
sudo systemctl enable docker
sudo systemctl start docker

# Descarga la imagen ELK
sudo docker pull sebp/elk

# Ejecuta el contenedor ELK exponiendo los puertos estándar
sudo docker run -d --name elk \
  -p 5601:5601 \
  -p 9200:9200 \
  -p 5044:5044 \
  sebp/elk

# Mensaje final
echo "ELK stack (sebp/elk) instalado y corriendo en Docker."
echo "Accede a Kibana en http://<IP>:5601"

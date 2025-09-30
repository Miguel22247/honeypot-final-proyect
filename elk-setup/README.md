# ELK Stack + Cowrie Integration

Este directorio contiene scripts y configuraciones para instalar y conectar el stack ELK (Elasticsearch, Logstash, Kibana) con Cowrie Honeypot.

## ¿Qué es el stack ELK?

- **Elasticsearch:** Motor de búsqueda y almacenamiento de datos.
- **Logstash:** Procesador y transformador de logs.
- **Kibana:** Visualización y dashboards.

## ¿Por qué integrarlo con Cowrie?

- Centraliza y visualiza los logs de ataques capturados por Cowrie.
- Permite análisis, alertas y dashboards en tiempo real.

---

## Instalación rápida (Ubuntu/Debian)

1. **Instala Java (requisito para Elasticsearch y Logstash):**

   ```bash
   sudo apt update
   sudo apt install -y openjdk-11-jre-headless
   ```

2. **Ejecuta el script de instalación:**

   ```bash
   cd elk-setup
   sudo bash elk-install.sh
   ```

3. **Configura Logstash para Cowrie:**
   - Edita `logstash-cowrie.conf` si es necesario.
   - Copia el archivo a `/etc/logstash/conf.d/` y reinicia Logstash:

     ```bash
     sudo cp logstash-cowrie.conf /etc/logstash/conf.d/
     sudo systemctl restart logstash
     ```

4. **Verifica Kibana:**
   - Accede a `http://localhost:5601` en tu navegador.
   - Crea un índice llamado `cowrie-*` para visualizar los logs.

---

## Instalación rápida de ELK con Docker

Este proyecto incluye un script para instalar Docker y ejecutar el stack ELK (Elasticsearch, Logstash, Kibana) usando la imagen sebp/elk.

### Pasos

1. Conéctate a tu instancia Linux (Ubuntu) vía SSH.
2. Ejecuta:

   ```bash
   chmod +x install-elk-docker.sh
   ./install-elk-docker.sh
   ```

3. Accede a Kibana en `http://<IP>:5601` desde tu navegador.

### Puertos expuestos

- 5601: Kibana
- 9200: Elasticsearch
- 5044: Logstash (Filebeat)

### Notas

- El script instala Docker si no está presente y ejecuta el contenedor ELK automáticamente.
- La imagen utilizada es sebp/elk de Docker Hub.
- Para detener el contenedor: `sudo docker stop elk`
- Para eliminar el contenedor: `sudo docker rm elk`

---

## Archivos incluidos

- `elk-install.sh`: Script automatizado para instalar Elasticsearch, Logstash y Kibana.
- `logstash-cowrie.conf`: Configuración de Logstash para parsear logs JSON de Cowrie.
- `kibana-dashboard.ndjson`: Ejemplo de dashboard para importar en Kibana.
- `README.md`: Esta guía.

---

## Recursos útiles

- [Documentación oficial de Cowrie](https://docs.cowrie.org/en/latest/)
- [Documentación de Elastic Stack](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-elastic-stack.html)

---

> **Tip:** Puedes enviar los logs de Cowrie a Logstash usando Filebeat o directamente con Logstash leyendo el archivo JSON (`cowrie.json`).

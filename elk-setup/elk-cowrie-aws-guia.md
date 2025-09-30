# Guía completa: Integración y aseguramiento de Cowrie + ELK en AWS

## 1. Instalación de ELK Stack

- Ejecuta el script `elk-setup/elk-install.sh` en tu instancia Ubuntu/Debian con permisos de root/sudo.

## 2. Configuración de Logstash para Cowrie

1. Copia el archivo `elk-setup/logstash/cowrie.conf` a `/etc/logstash/conf.d/cowrie.conf` en tu instancia.
2. Asegúrate de que Cowrie esté generando logs en formato JSON en `/var/log/cowrie/cowrie.json`.
3. Reinicia Logstash:

   ```bash
   sudo systemctl restart logstash
   ```

## 3. Seguridad básica de ELK

### 3.1. Usuarios y contraseñas

- ELK 8.x incluye seguridad por defecto. Al instalar, sigue las instrucciones para obtener las contraseñas generadas.
- Cambia las contraseñas por defecto usando las herramientas de Elastic:

  ```bash
  sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
  sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u kibana_system
  ```

### 3.2. Acceso a Kibana y Elasticsearch

- Por defecto, solo accesible en localhost. Si necesitas acceso remoto:
  - Edita `/etc/kibana/kibana.yml` y `/etc/elasticsearch/elasticsearch.yml` para cambiar `server.host` y `network.host` a `0.0.0.0` (solo si es necesario y seguro).
  - Reinicia los servicios:

    ```bash
    sudo systemctl restart kibana
    sudo systemctl restart elasticsearch
    ```

### 3.3. Security Groups en AWS

- Solo abre los puertos necesarios:
  - 5601 (Kibana): solo para tu IP o rango seguro
  - 9200 (Elasticsearch): solo si es necesario, restringido
  - 22 (SSH): solo para administración
- Configura esto en la consola de AWS EC2, en la sección de Security Groups.

## 4. (Opcional) Filebeat para enviar logs

- Instala Filebeat en la instancia:

  ```bash
  sudo apt install filebeat
  ```

- Configura Filebeat para leer `/var/log/cowrie/cowrie.json` y enviar a Logstash.

## 5. Verifica la integración y monitorea el flujo de logs

- Ingresa a Kibana (`http://<tu-ip>:5601`), inicia sesión y verifica que el índice `cowrie-*` tenga datos.
- En la instancia, valida que Filebeat esté funcionando:
  
  ```bash
  sudo systemctl status filebeat
  sudo filebeat test config
  tail -f /var/log/cowrie/cowrie.json
  tail -f /var/log/filebeat/filebeat
  ```

- En Logstash, revisa los logs para confirmar recepción de eventos:
  
  ```bash
  sudo journalctl -u logstash -f
  ```

- Si no ves eventos en Kibana, revisa los logs de Filebeat y Logstash para identificar problemas de configuración o conectividad.

## 6. Recomendaciones adicionales

- Mantén los servicios actualizados.
- Usa HTTPS para Kibana si lo expones a internet.
- Monitorea los logs de seguridad y acceso.

---

¿Necesitas ejemplos de configuración para Filebeat o reglas de firewall específicas?

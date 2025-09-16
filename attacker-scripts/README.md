# ssh-bruteforce.sh

Este script realiza un ataque de fuerza bruta SSH contra una máquina (por ejemplo, un honeypot Cowrie) usando un diccionario de contraseñas.

## Uso

```bash
./ssh-bruteforce.sh <IP_HONEYPOT> <USUARIO> <diccionario_passwords.txt>
```

- `<IP_HONEYPOT>`: Dirección IP de la VPS con Cowrie.
- `<USUARIO>`: Usuario a probar (por ejemplo, root).
- `<diccionario_passwords.txt>`: Archivo de texto con una contraseña por línea.

## Requisitos

- bash
- sshpass (`sudo apt install sshpass` en Ubuntu/Debian)
- ssh

## Ejemplo de uso

```bash
./ssh-bruteforce.sh 1.2.3.4 root passwords.txt
```

## Notas

- Este script es solo para fines educativos y de pruebas controladas.
- No uses este script contra sistemas sin autorización.

## Agendar ataque SSH automatizado vía cron

El script `schedule-ssh-bruteforce.sh` agenda ataques de fuerza bruta SSH cada minuto para los usuarios `root`, `admin`, `test`, `guest` y `ubuntu` usando el diccionario `passwords.txt`.

### Ejecución automática

```bash
./schedule-ssh-bruteforce.sh <IP_HONEYPOT>
```

- Ejemplo: `./schedule-ssh-bruteforce.sh 1.2.3.4`
- Los logs se guardan en `/tmp/ssh_bruteforce_<usuario>.log`
- Para ver las tareas agendadas: `crontab -l`
- Para eliminar las tareas: `crontab -r`

### Consideraciones

- El script agenda el ataque cada minuto (ideal para laboratorio).
- Modifica la lista de usuarios en el script si necesitas otros nombres.
- El diccionario de contraseñas debe estar en el mismo folder y llamarse `passwords.txt`.

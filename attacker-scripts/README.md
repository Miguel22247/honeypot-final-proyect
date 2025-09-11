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

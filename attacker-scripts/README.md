# ssh-bruteforce.sh

This script performs an SSH brute-force attack against a machine (e.g., a Cowrie honeypot) using a password dictionary.

## Usage

```bash
./ssh-bruteforce.sh <HONEYPOT_IP> <USER> <password_dictionary.txt>
```

- `<HONEYPOT_IP>`: IP address of the VPS running Cowrie.
- `<USER>`: Username to test (e.g., root).
- `<password_dictionary.txt>`: Text file with one password per line.

## Requirements

- bash
- sshpass (`sudo apt install sshpass` on Ubuntu/Debian)
- ssh

## Example

```bash
./ssh-bruteforce.sh 1.2.3.4 root passwords.txt
```

## Notes

- This script is for educational and controlled testing purposes only.
- Do not use this script against unauthorized systems.

## Automated SSH Attack Scheduling via cron

The `schedule-ssh-bruteforce.sh` script schedules SSH brute-force attacks every minute for the users `root`, `admin`, `test`, `guest`, and `ubuntu` using the `passwords.txt` dictionary.

### Automatic Execution

```bash
./schedule-ssh-bruteforce.sh <HONEYPOT_IP>
```

- Example: `./schedule-ssh-bruteforce.sh 1.2.3.4`
- Logs are saved in `/tmp/ssh_bruteforce_<user>.log`
- To view scheduled tasks: `crontab -l`
- To remove tasks: `crontab -r`

### Considerations

- The script schedules the attack every minute (ideal for lab environments).
- Modify the user list in the script if you need other usernames.
- The password dictionary must be in the same folder and named `passwords.txt`.

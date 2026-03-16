#!/bin/bash
# T1-M1-S02: SECURITY HARDENING AUTOMATION

echo "Starting system hardening..."

chmod 700 ~/Vault
chmod 600 ~/Vault/secrets.txt

sudo chmod 640 /etc/shadow
sudo chown root:shadow /etc/shadow

echo "Hardening complete."

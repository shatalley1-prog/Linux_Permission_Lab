#!/bin/bash
# =================================================================
# MISSION: OPERATION BLACKOUT (WEEK 2 TLAB)
# Objective: Provisioning script for Network Remediation TLAB
# Logic: Triggers Network Loss, Subnet Mismatch, and DNS Poisoning.
# =================================================================

# 1. ROOT CHECK: Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then 
    echo "[-] ERROR: This script must be run with sudo."
    exit 1
fi

# 2. IDENTITY MAPPING: Ensure files are owned by the student, not root
TARGET_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$TARGET_USER)

echo "[*] Initializing Week 2 TLAB Environment..."

# 3. TOOL PROVISIONING: Install ipcalc and tcpdump before the wire is cut
echo "[*] Installing forensic and calculation tools..."
apt-get update && apt-get install -y ipcalc tcpdump > /dev/null

# 4. LAYER 3 SABOTAGE (The Subnet Fence)
# Identify the primary network interface (ignoring loopback)
IFACE=$(ip -br link | awk '{print $1}' | grep -v "lo" | head -n 1)

echo "[!] Executing Network Sabotage on interface: $IFACE"

# Flush the existing IP and apply the /26 "Trap"
# This places the student in 192.168.10.150/26 (Range: .129 - .190)
# This mathematically isolates them from the Gateway at .1
ip addr flush dev $IFACE
ip addr add 192.168.10.150/26 dev $IFACE
ip link set $IFACE up

# 5. LAYER 7 SABOTAGE (The DNS Poison)
# Redirect the target domain to a malicious "Black Hole" IP
echo "[!] Applying DNS Deception..."
if ! grep -q "secure.titancorp.com" /etc/hosts; then
    echo "10.99.99.99  secure.titancorp.com" >> /etc/hosts
fi

# 6. MISSION BRIEF: Create the 'Rules of Engagement' file
mkdir -p "$USER_HOME/lab_prep"
cat << EOF > "$USER_HOME/lab_prep/tlab_orders.txt"
=================================================================
TLAB ORDERS: OPERATION BLACKOUT
=================================================================
GATEWAY: 192.168.10.1
TARGET: secure.titancorp.com (Correct IP: 192.168.10.193)

YOUR MISSION:
1. RECOVERY: You have lost your primary connection. Pivot to OOB.
2. LAYER 3: Restore the IP mask to /24 to reach the gateway.
3. ROUTING: Manually restore the default gateway route.
4. LAYER 7: Cleanse /etc/hosts of the 10.99.99.99 poisoning.
5. PROOF: Capture the [S], [S.], and [.] flags of a 3-way handshake 
   to secure.titancorp.com using tcpdump.

ARTIFACT: ~/tlab_report.txt
SUBMISSION: session-submit --session 02-TLAB --artifact ~/tlab_report.txt
=================================================================
EOF

# 7. PERMISSIONS: Fix ownership so student can read/edit the files
chown -R $TARGET_USER:$TARGET_USER "$USER_HOME/lab_prep"

echo "[+] PROVISIONING COMPLETE."
echo "[!] ALERT: YOUR SSH CONNECTION WILL NOW DROP."
echo "[!] ALERT: PIVOT TO YOUR WEB-BASED CONSOLE NOW."

# Final strike to the connection
ip route flush dev $IFACE

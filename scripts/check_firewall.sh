#!/bin/bash
# ============================================================
# VPN & WireGuard Firewall Debugging Script
# ============================================================
# This script verifies critical firewall and network settings
# for WireGuard, VPNs, and NAT (Network Address Translation)
#
# What This Script Checks:
# - UFW rules: Ensures WireGuard & SSH ports are open
# - IPTables rules: Confirms firewall rules for VPN traffic
# - NAT (iptables -t nat): Checks port forwarding & masquerading
# - Excludes Docker network rules for clarity
#
# Why It Matters:
# - WireGuard relies on correct firewall/NAT rules for routing
# - Missing MASQUERADE rules can break VPN connectivity
# - Misconfigured UFW/IPTables can block VPN traffic
# ============================================================

echo "Checking Firewall & Network Rules for WireGuard & SSH"

# To only show rules for WireGuard (51820/udp, 51821/tcp) and SSH (22/tcp):
echo -e "\nVerify Firewall (UFW) Rules for Open Ports (Filtering WireGuard & SSH)"
sudo ufw status verbose | grep -E "51820|51821|22" || echo "No matching UFW rules found."

# To only show rules related to wg0 (WireGuard VPN interface):
echo -e "\nCheck IPTables Rules (Filtering WireGuard Interface: wg0)"
sudo iptables -L -v -n | grep -i wg0 || echo "No rules found for wg0."

# To show rules related to WireGuard (51820/udp, 51821/tcp) and SSH (22/tcp):
echo -e "\nCheck IPTables Rules (Filtering WireGuard & SSH Ports)"
sudo iptables -L -v -n | grep -E "51820|51821|22" || echo "No matching IPTables rules found."

# Ensures NAT rules (`MASQUERADE`, `POSTROUTING`, `PREROUTING`) exist for VPN traffic routing; missing rules may break VPN internet access 
echo -e "\nCheck IPTables NAT Table (Used for Port Forwarding & Masquerading)"
sudo iptables -t nat -L -v -n | grep -E "51820|51821|22|MASQUERADE|POSTROUTING|PREROUTING" || echo "No relevant NAT rules found."

# Since Docker dynamically manages iptables, its rules can clutter the output
# To hide Docker-related rules:
echo -e "\nHiding Docker Networking Rules"
sudo iptables -L -v -n | grep -vE "DOCKER|docker0|br-|172\." | grep -E "51820|51821|22|wg0" || echo "No Docker interference detected."

echo -e "\nFirewall & Network Check Complete"


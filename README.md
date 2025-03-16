# **🚀 WireGuard VPN Setup with Docker & Firewall Hardening**


Welcome to the **WireGuard Setup Repository**! This repository provides a simple WireGuard VPN solution using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translations (NAT) to ensure a secure, persistent setup across reboots.


## 📌 Features
- **WireGuard + Web UI:** Leverages [wg-easy](https://github.com/wg-easy/wg-easy) for an intuitive VPN management interface
- **Customizable Deployment:** Production-ready `docker-compose.yaml` with an optional development mode for testing (future)
- **Secure Config Management:** Uses a `.env` file to protect sensitive data like public IP and password credentials
- **Secure Firewall & NAT:** Hardened rules for reliable and safe VPN routing 
- **Dockerized & Portable:** Runs in a containerized environment for easy setup and scalability 
- **Automatic Persistence:** Ensures WireGuard VPN and firewall settings survive reboots and restarts 


## **🔑 Requirements**
- A host with a kernel that supports WireGuard (all modern kernels)
- A host with Docker & Docker Compose installed (See below for installation)
- A router configured with NAT/port forwarding for external access


## **📦 Installation**
### Install Docker
```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
exit
```
After installation, log out and log back in


## **⚡ Quick Setup**
### Clone the repo
```bash
git clone https://github.com/bkaewell/wireguard-setup.git
cd wireguard-setup
```

### Set up environment variables
```bash
cp .env.example .env
```
Update these variables in `.env` to protect private data:
- WG_SERVER_PUBLIC_IP → Your public IP address or domain
- WG_SERVER_HOSTNAME → Your server’s hostname (optional)
- WG_WEB_UI_PASSWORD → Set a secure admin password for the WireGuard Web UI

### Adjust settings in `docker-compose.yaml`
Modify `docker-compose.yaml` if you need to customize ports or WireGuard settings:
```yaml
services:
  wg-easy:
    environment:
      - WG_PORT=51820       # WireGuard VPN port (default: 51820)
      - PORT=51821          # Web UI port (default: 51821)
    ports:
      - "51820:51820/udp"   # Expose WireGuard VPN port
      - "51821:51821/tcp"   # Expose Web UI port
```

Update firewall settings to match the ports above:
```bash
sudo ufw allow 51820/udp
sudo ufw allow 51821/tcp
```

Configure router for external access:

For remote VPN access, enable NAT (port forwarding) on your router:

| **Port**  | **Protocol** | **Purpose**                          |
|-----------|------------|----------------------------------|
| 51820     | UDP        | WireGuard VPN                   |
| 51821     | TCP        | Web UI (optional)               |
| 22        | TCP        | SSH (recommended for remote access) |


Example: How to Set Up Port Forwarding

1. Log into your router's admin panel (typically 192.168.1.1 or 192.168.0.1)
2. Navigate to Advanced > NAT Forwarding > Virtual Servers (varies by router model)
3. Add port forwarding rules for each port above, pointing to your server’s local IP (e.g., 192.168.1.100)
4. Save changes and reboot your router


## **📂 Repository Overview**
```
wireguard-setup/                # Root directory for WireGuard Setup (partially implemented)
└── scripts/
    ├── check_firewall.sh       # Firewall & IPTables verification script
    ├── check_docker_reboot.sh  # Docker restart verification script
├── docker-compose.yaml         # Supports both production & development (FUTURE)
├── Dockerfile.dev              # Builds the custom dev-friendly image (FUTURE)
├── docker-entrypoint.dev.sh    # Optional custom entrypoint for dev mode (FUTURE)
├── .env.example                # Template for environment variables
├── .gitignore                  # Ignores sensitive files
└── README.md                   # Documentation (this file)
```

**🎯 Looking to contribute?** Open an issue or fork the repo!  
**🏗 Author:** [Brian Kaewell](https://github.com/bkaewell)  
**📧 Contact:** Please open an issue [here](https://github.com/bkaewell/wireguard-setup/issues)

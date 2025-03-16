# **🚀 WireGuard VPN Setup with Docker & Firewall Hardening**


Welcome to the **WireGuard Setup Repository**! This repository provides a simple WireGuard VPN solution using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translations (NAT) to ensure a secure, persistent setup across reboots.


## 📌 Features
- **WireGuard + Web UI:** Leverages [wg-easy](https://github.com/wg-easy/wg-easy) for an intuitive VPN management interface
- **Customizable Deployment:** Production-ready `docker-compose.yaml` with an optional development mode for testing (future)
- **Secure Config Management:** Uses a `.env` file to protect sensitive data like public IP and password credentials
- **Secure Firewall & NAT:** Hardened rules for reliable and safe VPN routing 
- **Dockerized & Portable:** Runs in a containerized environment for easy setup and scalability 
- **Automatic Persistence:** Ensures WireGuard VPN and firewall settings survive reboots and restarts 


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
Update these variables in .env:
- WG_SERVER_PUBLIC_IP → Your public IP address or domain
- WG_SERVER_HOSTNAME → Your server’s hostname (optional)
- WG_WEB_UI_PASSWORD → Set a secure admin password for the WireGuard Web UI


## **📂 Repository Overview**
```
wireguard-setup/           # Root directory for WireGuard Setup (partially implemented)
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

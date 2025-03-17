# **🚀 WireGuard VPN Setup with Docker & Firewall Hardening**


Welcome to the **WireGuard Setup Repository**! This repository provides a simple WireGuard VPN solution using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translations (NAT) to ensure a secure, persistent setup across reboots.


## **📌 Features**
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
### **Install Docker**
```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
exit
```
After installation, log out and log back in


## **⚡ Quick Setup**
### **1️⃣ Clone the Repo**
```bash
git clone https://github.com/bkaewell/wireguard-setup.git
cd wireguard-setup
```

### **2️⃣ Set Up Environment Variables**
```bash
cp .env.example .env
```
Update these variables in `.env` to protect private data:
- WG_SERVER_PUBLIC_IP → Your public IP address or domain
- WG_SERVER_HOSTNAME → Your server’s hostname (optional)
- WG_WEB_UI_PASSWORD → Set a secure admin password for the WireGuard Web UI

### **3️⃣ Customize `docker-compose.yaml`**
Modify `docker-compose.yaml` to adjust ports and WireGuard settings if necessary:
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

### **4️⃣ Update Firewall Settings**
To match the configured ports, update your firewall settings:
```bash
sudo ufw allow 51820/udp
sudo ufw allow 51821/tcp
```

Optional: Restrict Web UI access to a specific trusted IP:
```bash
sudo ufw allow from <your-trusted-ip> to any port 51821 proto tcp
```

### **5️⃣ Configure Router for External Access**
For remote VPN access, enable NAT (port forwarding) and assign a static IP to your VPN server on your router:

Log into your router's admin panel 
| **Router Model**  | **Admin Panel URL** | 
|-------------------|------------------------------|
| **TP-Link A7**   | [http://192.168.0.1](http://192.168.0.1) |
| **Asus Routers** | `http://192.168.X.1` (varies by model) |

To ensure port forwarding works consistently, assign a static IP to the machine running WireGuard 

**For TP-Link A7 Routers:**
1. Go to Advanced > Network > DHCP Server > Settings > Address Reservation
2. Click Add and select the WireGuard server's MAC address from the list of connected devices
3. Assign it an available IP address in the range `192.168.0.[2-255]`, such as `192.168.0.123`
4. Click Save and reboot your router to apply the changes
Now, your WireGuard VPN server will always have the same local IP (`192.168.0.123`), ensuring port forwarding remains consistent

Once your WireGuard VPN server has a static local IP, configure port forwarding to allow external access:
**For TP-Link A7 Routers:**
1. Navigate to **Advanced > NAT Forwarding > Virtual Servers** (varies by router model)
2. Click **Add** and enter the following values: 

| **Service Name**  | **External Port** | **Internal Port** | **Protocol** | **Purpose**                        | **Internal IP Address** |
|------------------|------------------|------------------|------------|--------------------------------|------------------|
| **WireGuard VPN** | 51820            | 51820            | UDP        | Secure VPN connectivity        | 192.168.0.123    |
| **Web UI**        | 51821            | 51821            | TCP        | Manage WireGuard via web UI    | 192.168.0.123    |
| **SSH Access**    | 22               | 22               | TCP        | Remote server access via SSH   | 192.168.0.123    |

3. Save changes and reboot your router


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

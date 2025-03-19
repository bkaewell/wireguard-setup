# 🚀 WireGuard VPN Setup with Docker & Firewall Hardening  
  
  
Welcome to the **WireGuard Setup Repository**! This repository provides a simple WireGuard VPN solution using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translations (NAT) to ensure a secure, persistent setup across reboots.
  
  
## 📌 Features  
- **WireGuard + Web UI:** Leverages [wg-easy](https://github.com/wg-easy/wg-easy) for an intuitive VPN management interface
- **Customizable Deployment:** Production-ready `docker-compose.yaml` with an optional development mode for testing (future)
- **Secure Config Management:** Uses a `.env` file to protect sensitive data like public IP and password credentials
- **Secure Firewall & NAT:** Hardened rules for reliable and safe VPN routing 
- **Dockerized & Portable:** Runs in a containerized environment for easy setup and scalability 
- **Automatic Persistence:** Ensures WireGuard VPN and firewall settings survive reboots and restarts 
  
  
## 🔑 Requirements  
- A host with a kernel that supports WireGuard (all modern kernels)
- A host with Docker & Docker Compose installed 
- A router configured with NAT/port forwarding for external access
  
  
## ⚡ Quick Setup  
### 1️⃣ Clone the Repo  
```bash
git clone https://github.com/bkaewell/wireguard-setup.git
cd wireguard-setup
```
  
### 2️⃣ Set Up Environment Variables  
```bash
cp .env.example .env
```
Update these variables in `.env` to configure docker for WireGuard VPN and protect private data:  
| **Variable**            | **Description** |
|-------------------------|------------------------------------------|
| `WG_SERVER_PUBLIC_IP`   | Your public IP address or domain |
| `WG_SERVER_HOSTNAME`    | Your server’s hostname (optional) |
| `WG_PORT`               | WireGuard VPN listening port (default: 51820/UDP) |
| `WEB_UI_PORT`           | Web UI access port (default: 51821/TCP) |
| `WG_WEB_UI_PASSWORD`    | Set a secure admin password for the WireGuard Web UI |
  > 🔥 Storing all configuration values in `.env` keeps `docker-compose.yaml` cleaner, more maintainable, and easily customizable. To override settings, modify `docker-compose.yaml` directly, but using `.env` ensures modular and consistent updates across deployments
  
  
### 3️⃣ Update Firewall Settings  
To match the configured ports, update your firewall settings:
```bash
sudo ufw allow 51820/udp
sudo ufw allow 51821/tcp
```
  
Optional: Restrict Web UI access to a specific trusted IP:
```bash
sudo ufw allow from <your-trusted-ip> to any port 51821 proto tcp
```
  
### 4️⃣ Configure Router for External Access  
For remote VPN access, assign a static IP and enable NAT (port forwarding) to your VPN server on your router:
  
Log into your router's admin panel 
| **Router Model**  | **Admin Panel URL** | 
|-------------------|------------------------------|
| **TP-Link A7**   | [http://192.168.0.1](http://192.168.0.1) |
| **Other Routers** | `http://192.168.X.1` |
  
To ensure port forwarding works consistently, assign a static IP to the machine running WireGuard 
  
**Assign a static IP (for TP-Link A7 Routers):**
1. Go to **Advanced > Network > DHCP Server > Settings > Address Reservation**
2. Click **Add** and select the WireGuard server's MAC address from the list of connected devices
3. Assign it an available IP address in the range `192.168.0.[2-255]`, such as `192.168.0.123`
4. Click Save and reboot your router to apply the changes  
  
> 🔥 Now, your WireGuard VPN server will always have the same local IP (`192.168.0.123`), ensuring port forwarding remains consistent
  
Once your WireGuard VPN server has a static local IP, configure port forwarding to allow external access:  
  
**Configure NAT port forwarding (for TP-Link A7 Routers):**
1. Navigate to **Advanced > NAT Forwarding > Virtual Servers**  
2. Click **Add** and enter the following values (don't forget to save/reboot your router): 
  
| **Service Name**  | **External Port** | **Internal Port** | **Protocol** | **Purpose**                        | **Internal IP Address** |
|------------------|------------------|------------------|------------|--------------------------------|------------------|
| **WireGuard VPN** | 51820            | 51820            | UDP        | Secure VPN connectivity        | 192.168.0.123    |
| **Web UI**        | 51821            | 51821            | TCP        | Manage WireGuard via web UI    | 192.168.0.123    |
| **SSH Access**    | 22               | 22               | TCP        | Remote server access via SSH   | 192.168.0.123    |
  
  
### 5️⃣ Port Connectivity Testing: UDP vs. TCP  
  
| **Test Type** | **Command** | **Protocol** | **Expected Behavior** | **Use Case** |
|--------------|------------|-------------|----------------------|-------------|
| **UDP Connectivity** | `nc -uzv <IP> <PORT>` | UDP | ✅ **"Connection succeeded"** if port is open | Check if a UDP port is accessible |
| **TCP Connectivity** | `nc -zv <IP> <PORT>` | TCP | ✅ **"Connection succeeded"** if port is open | Verify if a TCP port is accepting connections |
| **Check Listening Ports on Server** | `sudo ss -tulnp \| grep <PORT>` | TCP/UDP | Shows process listening if port is open | Confirm if WireGuard or a service is running on the port |
| **Check Firewall Rules (UFW)** | `sudo ufw status verbose \| grep <PORT>` | TCP/UDP | Displays if port is allowed | Verify firewall settings for the port |
| **Check Firewall Rules (IPTables)** | `sudo iptables -L -v -n \| grep <PORT>` | TCP/UDP | Shows port rules if configured | Ensure IPTables isn’t blocking traffic |
| **Capture Incoming Packets (UDP/TCP)** | `sudo tcpdump -i any port <PORT> -n` | TCP/UDP | Shows real-time packets if traffic is reaching the server | Troubleshoot whether packets are arriving at the machine |  
  
  
## 📦 Installation  
### 🐳 Install Docker & Docker Compose  
This project requires Docker and Docker Compose. Choose your installation method based on your operating system:  
  
  
#### 🔸 Option 1: Install on macOS (Homebrew)  
```bash
brew install --cask docker
```
**Note: Docker Desktop** must be running in the background for `docker` commands to work  
- You can launch it from **Applications > Docker** or run `open -a Docker`   
  
#### 🔸 Option 2: Install on Ubuntu/Debian (APT)  
```bash
sudo apt update
sudo apt install -y docker.io docker-compose
```
  
#### Verify Installation:  
```bash
docker --version
docker-compose --version
```
  
#### Verify your user has permission to run Docker commands without `sudo`:  
```bash
sudo usermod -aG docker $USER
newgrp docker
```
  
#### Verify Docker starts automatically on a system reboot:  
```bash
sudo systemctl enable --now docker
```
  
## ⚙️ Deployment   
### 🔐 Deploy WireGuard (Production Mode) 

Run the VPN server using **Docker Compose** deploying the `wg-easy` service in detached mode (running in the background):
```bash
docker compose up -d                  # Current
docker compose --profile prod up -d   # Future
```  
  
Check if the container is running:  
```bash
docker ps -a
```  
You should see the `wg-easy` container running  
  
### Stop the VPN Container  
```bash
docker compose down
```  
  
  
  wg0.conf should take care of MASQUERADE
```bash
sudo iptables -t nat -L -v -n | grep MASQUERADE
```  
✅ If MASQUERADE is missing, VPN clients won’t have internet.  
  
  
FUTURE WEB UI CHECK:  
http://<WG_HOST>:<PORT>  
  
  
  
## 📂 Repository Overview  
```
wireguard-setup/                # Root directory for WireGuard VPN Setup (partially implemented)
└── config/                     # Stores WireGuard configuration files
    ├── wg0.conf                # WireGuard auto-generated server configuration (ignored in Git)
    ├── wg0.json                # WireGuard auto-generated client configuration (ignored in Git)
└── scripts/
    ├── check_firewall.sh       # Firewall & IPTables verification script
    ├── check_docker_reboot.sh  # Docker restart verification script
├── docker-compose.yaml         # Supports both production & development (Prod implemented, development FUTURE)
├── Dockerfile.dev              # Builds the custom dev-friendly image (FUTURE)
├── docker-entrypoint.dev.sh    # Optional custom entrypoint for dev mode (FUTURE)
├── .env.example                # Template for environment variables
├── .gitignore                  # Ignores sensitive files
└── README.md                   # Documentation (this file)
```  
  
**🎯 Looking to contribute?** Open an issue or fork the repo!  
**🏗 Author:** [Brian Kaewell](https://github.com/bkaewell)  
**📧 Contact:** Please open an issue [here](https://github.com/bkaewell/wireguard-setup/issues)
  
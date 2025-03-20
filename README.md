# 🚀 WireGuard VPN Server with Docker & Firewall Hardening  
  
  
Welcome to the **WireGuard VPN Server Setup** repository! This provides a simple and secure WireGuard VPN deployment using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translation (NAT) for persistent, secure VPN access.  
  
  
## 📌 Features  
- **WireGuard + Web UI:** Leverages the [wg-easy](https://github.com/wg-easy/wg-easy) Docker image for an intuitive VPN management interface  
- **Customizable Deployment:** Production-ready `docker-compose.yaml` with an optional development mode for testing (future)  
- **Secure Config Management:** Uses a `.env` file to protect sensitive data like public IP, ports and password credentials  
- **Firewall & NAT Hardening:** Implements secure firewall rule to ensure safe VPN traffic routing  
- **Dockerized & Portable:** Runs in a containerized environment for easy setup and scalability  
- **Automatic Persistence:** Ensures the WireGuard VPN server and firewall settings survive reboots   
  
  
## 🔑 Requirements  
- A **host machine** with a kernel that supports WireGuard (all modern Linux kernels)  
- A **host machine** with Docker & Docker Compose installed  
- A **router configured with NAT/port forwarding** for external VPN access  
  
  
## ⚡ Quick Setup  
### 1️⃣ Clone the Repo  
```bash
git clone https://github.com/bkaewell/wireguard-setup.git
cd wireguard-setup
```
  
### 2️⃣ Set Up Environment Variables  
Copy the example `.env` file and configure your WireGuard VPN server:
```bash
cp .env.example .env
```  
| **Variable**            | **Description** |
|-------------------------|------------------------------------------|
| `WG_SERVER_PUBLIC_IP`   | Your public IP address or domain |
| `WG_SERVER_HOSTNAME`    | Your server’s hostname (optional) |
| `WG_SERVER_PORT`        | WireGuard VPN listening port (default: 51820/UDP) |
| `WG_WEB_UI_PORT`        | WireGuard Web UI access port (default: 51821/TCP) |
| `WG_WEB_UI_PASSWORD`    | Set a secure admin password for the WireGuard Web UI |
  > 🔥🔥 Storing all config values in `.env` keeps `docker-compose.yaml` cleaner, more maintainable, and easily customizable. To override settings, modify `docker-compose.yaml` directly, but using `.env` ensures modular/consistent updates across deployments while keeping private data out of version control (GitHub)  
  
  
### 3️⃣ Update Firewall Settings  
To allow VPN traffic, open the configured ports (`WG_SERVER_PORT` & `WG_WEB_UI_PORT`) in UFW:
```bash
sudo ufw allow <WG_SERVER_PORT>/udp
sudo ufw allow <WG_WEB_UI_PORT>/tcp
```
  
Optional: Restrict WireGuard Web UI access to a specific trusted IP:
```bash
sudo ufw allow from <YOUR_TRUSTED_IP> to any port <WG_WEB_UI_PORT> proto tcp
```
  
### 4️⃣ Configure Router for External Access  
Assign a static local IP to the WireGuard VPN server and configure NAT (port forwarding) on your router to allow remote VPN access:
  
Log into your router's admin panel 
| **Router Model**  | **Admin Panel URL** | 
|-------------------|------------------------------|
| **TP-Link A7**   | [http://192.168.0.1](http://192.168.0.1) |
| **Other Routers** | `http://192.168.X.1` |
  

**Assign a static local IP to the WireGuard VPN server**  
**For TP-Link A7 Routers:**  
1. Go to **Advanced > Network > DHCP Server > Settings > Address Reservation**  
2. Click **Add** and select the WireGuard VPN server's MAC address from the connected devices  
3. Assign it an available static IP (i.e. `192.168.0.123`)  
4. Save and reboot the router    
  
> 🔥🔥 A static local IP (`192.168.0.123`) ensures that port forwarding always routes VPN traffic correctly  
  
Configure NAT port forwarding to the router:  
  
**Configure NAT port forwarding**  
**For TP-Link A7 Routers:**  
1. Navigate to **Advanced > NAT Forwarding > Virtual Servers**  
2. Click **Add** and enter the following values (don't forget to save/reboot the router): 
  
| **Service Name**       | **External Port**     | **Internal Port**     | **Protocol** | **Purpose**                        | **Internal IP Address** |  
|-----------------------|---------------------|---------------------|------------|--------------------------------|------------------|  
| **WireGuard VPN**     | `<WG_SERVER_PORT>`  | `<WG_SERVER_PORT>`  | UDP        | Secure VPN connectivity        | `192.168.0.123`  |  
| **WireGuard Web UI**  | `<WG_WEB_UI_PORT>`  | `<WG_WEB_UI_PORT>`  | TCP        | Manage WireGuard via Web UI    | `192.168.0.123`  |  
| **SSH Access**        | 22                  | 22                  | TCP        | Remote server access via SSH   | `192.168.0.123`  |  
  
  > 🔥🔥 Now, external devices can securely connect to your WireGuard VPN server using your public IP or domain, ensuring seamless remote access  
  
  
### 5️⃣ Port Connectivity Testing: UDP vs. TCP  
| **Test Type** | **Command** | **Protocol** | **Expected Behavior** | **Use Case** |  
|--------------|------------|-------------|----------------------|-------------|  
| **UDP Connectivity** | `nc -uzv <IP> <PORT>` | UDP | ✅ **"Connection succeeded"** if port is open | Check if a UDP port is accessible |  
| **TCP Connectivity** | `nc -zv <IP> <PORT>` | TCP | ✅ **"Connection succeeded"** if port is open | Verify if a TCP port is accepting connections |  
| **Check Listening Ports on Server** | `sudo ss -tulnp \| grep <PORT>` | TCP/UDP | Shows process listening if port is open | Confirm if WireGuard or a service is running on the port |  
| **Check Firewall Rules (UFW)** | `sudo ufw status verbose \| grep <PORT>` | TCP/UDP | Displays if port is allowed | Verify firewall settings for the port |  
| **Check Firewall Rules (IPTables)** | `sudo iptables -L -v -n \| grep <PORT>` | TCP/UDP | Shows port rules if configured | Ensure IPTables isn’t blocking traffic |  
| **Capture Incoming Packets (UDP/TCP)** | `sudo tcpdump -i any port <PORT> -n` | TCP/UDP | Shows real-time packets if traffic is reaching the server | Troubleshoot whether packets are arriving |  
  
  
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
sudo usermod -aG docker ${USER:-$(whoami)}
newgrp docker
```
  
#### Verify Docker starts automatically on a system reboot:  
```bash
sudo systemctl enable --now docker
```
  
## ⚙️ Deployment   
### 🔐 Deploy WireGuard VPN Server (Production Mode) 

Run the WireGuard VPN server using **Docker Compose** deploying the `wg-easy` service in detached mode (running in the background):
```bash
docker compose up -d                  # Start in production mode
docker compose --profile prod up -d   # Future dev support
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
  
  
FUTURE WEB UI CHECK:  
http://<WG_SERVER_PUBLIC_IP>:<WG_WEB_UI_PORT> 
  
  
## 📖 Additional Client Setup Guides  

For device-specific WireGuard client configuration, refer to the following guides:
  
- **[Setup WireGuard on Amazon Firestick](docs/firestick_client_setup.md) (Coming Soon)**  
  
  
## 📂 Repository Overview  
```
wireguard-setup/                  # Root directory for WireGuard VPN Server setup 
└── config/                       # Stores WireGuard configuration files 
    ├── wg0.conf                  # Auto-generated live WireGuard server configuration (ignored in Git)  
    |                             # - Contains server settings, keys, and peer configurations  
    ├── wg0.json                  # Auto-generated WireGuard Web UI backup/restore file (ignored in Git)  
    |                             # - Used by the Web UI for backup/restore operations  
└── docs/                         # Documentation for additional setups
    ├── firestick_client_setup.md # Guide for configuring WireGuard on Amazon Firestick
└── scripts/                      # Utility scripts for system checks  
    ├── check_firewall.sh         # Firewall & IPTables verification script  
    ├── check_docker_reboot.sh    # Docker restart verification script  
├── docker-compose.yaml           # Supports production deployment (Dev mode: FUTURE)   
├── Dockerfile.dev                # Builds custom dev-friendly image (FUTURE)  
├── docker-entrypoint.dev.sh      # Optional custom entrypoint for dev mode (FUTURE)  
├── .env.example                  # Template for environment variables  
├── .gitignore                    # Ignores sensitive files  
└── README.md                     # Documentation (this file)  
```  
  
**🎯 Looking to contribute?** Open an issue or fork the repo!  
**🏗 Author:** [Brian Kaewell](https://github.com/bkaewell)  
**📧 Contact:** Please open an issue [here](https://github.com/bkaewell/wireguard-setup/issues)
  
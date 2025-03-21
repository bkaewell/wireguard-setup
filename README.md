# 🚀 WireGuard VPN Server with Docker & Firewall Hardening  
  
  
Welcome to the **WireGuard VPN Server Setup** repository! This provides a simple and secure WireGuard VPN deployment using Docker Compose, Uncomplicated Firewall (UFW), IPTables, and Network Address Translation (NAT) for persistent, secure VPN access.  
  
  
## 📌 Features  
- **WireGuard VPN with Web UI:** Deploys WireGuard using the [wg-easy](https://github.com/wg-easy/wg-easy) Docker image, which provides an intuitive web-based VPN management interface  
- **Customizable Deployment:** Production-ready `docker-compose.yaml` with an optional development mode for testing (FUTURE)  
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

To enable **remote access to WireGuard**, you must:  
- **Assign a static local IP** to the WireGuard VPN server  
- **Set up port forwarding** on your router to ensure VPN traffic reaches the WireGuard VPN server   
  
--- 
  
#### Assign a Static Local IP to the WireGuard Server  
  
Log into your router's **admin panel**
| **Router Model**  | **Admin Panel URL** | 
|-------------------|------------------------------|
| **TP-Link A7**   | [http://192.168.0.1](http://192.168.0.1) |
| **Other Routers** | `http://192.168.X.1` |
  
For **TP-Link A7 Routers:**  
1. Go to **Advanced > Network > DHCP Server > Settings > Address Reservation**  
2. Click **Add** and select the **MAC address** of the WireGuard VPN server   
3. Assign it an **available static IP** (i.e. `192.168.0.123`)  
4. **Save and reboot** the router  
> 🔥🔥 A static local IP (`192.168.0.123`) ensures that port forwarding always routes VPN traffic correctly  
  
--- 
  
#### Configure Port Forwarding to the Router:  
  
For **TP-Link A7 Routers:**  
1. Navigate to **Advanced > NAT Forwarding > Virtual Servers**  
2. Click **Add** and enter the following values (Save/reboot the router): 
    
| **Service Name**       | **External Port** | **Internal Port** | **Protocol** | **Purpose**                      | **Internal IP Address** |
|------------------------|------------------|------------------|------------|--------------------------------|------------------|
| **WireGuard VPN Server**      | `<WG_SERVER_PORT>` | `<WG_SERVER_PORT>` | UDP        | Handles VPN client connections  | `192.168.0.123`  |
| **Web UI for WireGuard** | `<WG_WEB_UI_PORT>` | `<WG_WEB_UI_PORT>` | TCP        | Manage VPN clients and settings  | `192.168.0.123`  |
| **SSH Access**         | 22               | 22               | TCP        | Remote access to the host machine   | `192.168.0.123`  |
  > 🔥🔥 Now, external devices can securely connect to WireGuard using your public IP or domain, ensuring seamless remote access  
  
  
### 5️⃣ Verify VPN and Web UI Connectivity  
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
  
## 📂 Repository Overview  
```
wireguard-setup/                  # Root directory for WireGuard VPN Server setup 
└── config/                       # Stores WireGuard configuration files 
    ├── wg0.conf                  # Auto-generated configuration for the core WireGuard VPN server (ignored in Git)  
    |                             # - Contains private keys, server settings, and VPN peer configurations  
    ├── wg0.json                  # Web UI backup file for restoring VPN settings (ignored in Git)  
    |                             # - Used for restoring server/client settings via the Web UI  
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
  
## 📖 Additional Documentation  

- **[WireGuard Basics](docs/wireguard_basics.md)** – Learn about WireGuard, VPNs, and how they work  
- **[Setup WireGuard on Amazon Firestick](docs/firestick_client_setup.md)**  
  
## 🤝 Contributing & Contact    

**🎯 Looking to contribute?** Open an issue or fork the repo!  
**🏗 Author:** [Brian Kaewell](https://github.com/bkaewell)  
**📧 Contact:** Please open an issue [here](https://github.com/bkaewell/wireguard-setup/issues)
  
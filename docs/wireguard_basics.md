# 📚 WireGuard Basics  

Learn the core concepts behind WireGuard, how it differs from other VPN technologies, and how it works in real-world deployments

---

## 🚦 What is a VPN?  

A **VPN (Virtual Private Network)** creates a **secure, encrypted tunnel** between a user's device and a remote server. It provides:

✅ **Privacy:** Hides your IP address and encrypts internet traffic  
✅ **Security:** Protects data from hackers, ISPs, and surveillance  
✅ **Access:** Bypasses geo-restrictions and firewall blocks  
✅ **Anonymity:** Shields online activity from tracking  

---

## What is WireGuard?

**WireGuard** is a modern, lightweight, and fast **VPN protocol** designed for simplicity and performance. Unlike traditional protocols (i.e., OpenVPN, IPsec), WireGuard operates at **Layer 3 (network layer)** of the kernel, making it:

🔸 Easier to configure  
🔸 More efficient and secure  
🔸 Faster in performance benchmarks  

---

## What is WireGuard VPN?

A **WireGuard VPN** is a VPN implementation that uses the WireGuard protocol to securely route traffic between devices. It allows:

🔒 Secure, encrypted connections between trusted endpoints  
📶 High performance on constrained devices  
🌍 Use across mobile, desktop, embedded systems, and containers  

---

## 😎 What is a WireGuard VPN Server?

A **WireGuard VPN server** is the central component that manages peer (client) connections. It handles:  
- **Authentication** using cryptographic keys
- **Encryption & Routing** between devices and networks
- **Access Relay** to private, internal, or restricted services
- **Deployment Options:** Cloud VPS, home server, or Docker container

> 🔥🔥 **Recap:** WireGuard is the protocol. A WireGuard VPN server is the implementation that enables secure VPN access

---

## 🔄 Real-World WireGuard Data Flow (Full-Tunnel Example)

Here’s what happens when a **Firestick in Europe** connects to a **WireGuard VPN server in the USA**:

1. **Firestick (Europe):** Sends **all traffic** through the VPN tunnel (`AllowedIPs = 0.0.0.0/0, ::/0`)
2. **WireGuard Tunnel:** Encrypts and securely transports packets
3. **WireGuard VPN Server (USA):** Decrypts packets and sends requests to Netflix
4. **Netflix (USA):** Sends video stream data back to the WireGuard VPN server
5. **WireGuard VPN Server → Tunnel → Firestick:** Re-encrypts the response and routes it back through the tunnel to the Firestick

---

## 🚧 🚇 Full-Tunnel Client Settings Overview

| **Client Setting**             | **Effect**                                                 |
|--------------------------------|------------------------------------------------------------|
| `AllowedIPs = 0.0.0.0/0, ::/0` | Routes **all internet traffic** through the VPN tunnel     |
| `DNS = 1.1.1.1`                | DNS queries are tunneled securely through WireGuard        |
| `PersistentKeepalive = 0`      | Client sends no keepalives unless traffic is sent manually |

#### Example Client Config File 

```ini
[Interface]                 # Settings specific to the VPN client
PrivateKey = ABCDEFGHIJK    # Client's private key (keep this secret)
Address = 10.8.0.2/24       # Client's internal VPN IP address
DNS = 1.1.1.1               # DNS resolver used while connected to VPN

[Peer]                                             # Config of the VPN server this client connects to
PublicKey = 1234567                                # Server's public key (shared by server admin)
PresharedKey = 7654321                             # Optional pre-shared key (adds extra encryption layer)
AllowedIPs = 0.0.0.0/0, ::/0                       # Full tunnel – routes all client traffic through the VPN
PersistentKeepalive = 0                            # Sends no keepalive pings (0 = off)
Endpoint = <WG_SERVER_PUBLIC_IP>:<WG_SERVER_PORT>  # Server’s IP or domain + WireGuard port
```

---

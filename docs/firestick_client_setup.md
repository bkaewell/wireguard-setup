# Installing WireGuard on Amazon Firestick 4K  

This guide provides step-by-step instructions for installing WireGuard on an **Amazon Firestick 4K** and configuring it with a **WireGuard VPN client**.  

## Prerequisites  
- **Amazon Firestick 4K** (or compatible Fire TV device)  
- **A computer with FileZilla** (or another FTP client)  
- **WireGuard VPN `.conf` file** (provided by your VPN server)  

---  

## 1️⃣ Install Necessary Apps on Firestick  

### 1.1 Enable Developer Options  
1. **Enable Developer Mode:**  
   - Navigate to **Settings > My Fire TV**  
   - Select **Fire TV Stick 4K** and click **4 times** to unlock Developer Mode  
2. **Enable ADB Connections:**  
   - Navigate to **Settings > Developer Options**  
   - Enable **ADB Debugging**  
3. **Enable Apps from Unknown Sources:**  
   - Navigate to **Settings > Developer Options**  
   - Enable **Apps from Unknown Sources**  

### 1.2 Install Required Apps  
1. **Install Downloader from the Amazon App Store**  
   - Search for **Downloader** in the **Amazon App Store** and install it  
2. **Install ES File Explorer or Xplore**  
   - **Option 1:** Install **ES File Explorer** from the Amazon App Store *(Do NOT select premium upgrade!)*  
   - **Option 2:** If unavailable, try installing **Xplore** from the Amazon App Store  
   - **Alternative Method:**  
     - Open **Downloader**  
     - In the browser address bar, enter:  
       ```
       troypoint.com/es
       ```
     - Download and install **ES File Explorer**  

---  

## 2️⃣ Transfer WireGuard Configuration File to Firestick  

1. **Launch ES File Explorer**  
   - Navigate to **Local > Internal Storage**  
   - Create a new folder named **WireGuard**  

2. **Enable FTP Access on Firestick**  
   - In **ES File Explorer**, navigate to **Home (House Icon)**  
   - Select **"View on PC"** (this starts an FTP file server)  
   - Note the **IP Address and Port** displayed on the screen  

3. **Transfer WireGuard `.conf` File**  
   - On your **computer**, open **FileZilla**  
   - Enter the **Firestick's IP Address & Port**  
   - Leave **Username & Password** blank  
   - Connect and transfer the **WireGuard `.conf` file** to the **WireGuard folder** on Firestick  

---  

## 3️⃣ Install & Configure WireGuard VPN  

### 3.1 Install WireGuard  
1. Open **Downloader**  
2. Search for **WireGuard**  
3. Go to **www.wireguard.com/install**  
4. Scroll to **WireGuard for Android**  
5. Click the **link underneath** the Google Play Store button *(DO NOT install from the Play Store, use the direct APK link)*  
6. Download and install WireGuard  

### 3.2 Import WireGuard Configuration  
1. Open **WireGuard**  
2. Click **"+" (Add a tunnel)**  
3. Select **Import from File**  
4. Navigate to the **WireGuard folder**  
5. Select the `.conf` file and import it  

---  

## 4️⃣ Using WireGuard VPN on Firestick  

1. Open **WireGuard**  
2. Select the VPN configuration  
3. Tap **Activate**  
4. You should see **Uplink & Downlink data transfers** start working  

Your Firestick is now securely connected to the VPN! 🎉  

---

## 🧨 Troubleshooting  

- **Cannot find Developer Options?** Try clicking on **My Fire TV** multiple times to unlock it  
- **WireGuard installation fails?** Make sure you use the direct APK link instead of Google Play Store  
- **File transfer issues?** Verify that **ES File Explorer FTP Server** is running and check the **IP & Port**  

---

This guide ensures your **Amazon Firestick 4K** runs **WireGuard VPN** securely  


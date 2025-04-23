# BOG'S WiFi Attack Suite

A comprehensive WiFi security testing tool with GUI interface.

## Features

- Monitor Mode Management
- WiFi Network Scanning
- WPA/WPA2 Handshake Capture
- Multiple Password Cracking Options:
  - Built-in Wordlist (rockyou.txt)
  - Israeli Phone Numbers Generator
  - Israeli ID Numbers Generator
  - Custom Wordlist Support
- Evil Twin Attack
- Karma Attack
- Beacon Flooding
- Auto Deauthentication

## Requirements

- Linux-based operating system
- Wireless adapter with monitor mode support
- Python 3.x
- Root privileges

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Ben-Big/wifiCrackGUI.git
cd wifiCrackGUI
```

2. Run the installation script:
```bash
sudo chmod +x requirements.sh
sudo ./requirements.sh
```

## Usage

Run the program with root privileges:
```bash
sudo python3 WIFI_V9
```

### Basic Steps:

1. Enable Monitor Mode:
   - Select your wireless interface
   - Click "Enable Monitor Mode"

2. Capture Handshake:
   - Go to "WPA Brute Force" tab
   - Enter target network BSSID and ESSID
   - Click "Capture Handshake"
   - Wait for successful capture (green checkmark)

3. Crack Password:
   - Choose a wordlist option
   - Wait for the cracking process

## Note

This is a personal project created for educational purposes. Please use responsibly.

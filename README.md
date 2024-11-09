VNC and noVNC Setup Script for Ubuntu
This project provides a shell script to set up a lightweight XFCE desktop environment with TigerVNC and noVNC on Ubuntu. The script configures a VNC server and noVNC proxy to allow remote desktop access through VNC clients or a web browser.

Features
XFCE Desktop: Lightweight and fast desktop environment.
TigerVNC: A high-performance VNC server for remote desktop access.
noVNC: A web-based VNC client for accessing the desktop through a browser.
Easy Setup: The script handles all installation and configuration steps.
Requirements
Ubuntu 22.04 or a compatible version.
A non-root user with sudo privileges.
Network access to ports 5901 (VNC) and 6080 (noVNC).
Installation and Usage
Clone or Download the Script

Save the script to your system as setup_vnc_novnc.sh.

Make the Script Executable

bash
Copy code
chmod +x setup_vnc_novnc.sh
Run the Script

Execute the script to set up the environment:

bash
Copy code
./setup_vnc_novnc.sh
Access the Remote Desktop

VNC Client: Use a VNC client (e.g., TigerVNC Viewer) to connect to localhost:5901. The default password is password.
Web Browser: Open your browser and go to http://localhost:6080.
Configuration
The default VNC password is set to password. To change it, modify the following line in the script before running it:
bash
Copy code
echo "password" | vncpasswd -f > ~/.vnc/passwd
The default screen resolution is 1280x720. You can adjust it in the script:
bash
Copy code
vncserver :1 -geometry 1280x720 -depth 24 -localhost no &
Ports and Firewall
Ensure the following ports are open on your system:

5901: For VNC clients.
6080: For noVNC web access.
If you are using ufw (Uncomplicated Firewall), you can open these ports with:

bash
Copy code
sudo ufw allow 5901
sudo ufw allow 6080
Troubleshooting
If you cannot connect, check if the VNC server and noVNC proxy are running:
bash
Copy code
ps aux | grep vncserver
ps aux | grep novnc_proxy
Verify that ports 5901 and 6080 are not blocked:
bash
Copy code
sudo netstat -tuln | grep 5901
sudo netstat -tuln | grep 6080
License
This project is licensed under the MIT License. Feel free to use, modify, and share.


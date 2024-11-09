#!/bin/bash

# Set non-interactive mode untuk apt commands
export DEBIAN_FRONTEND=noninteractive

# Update dan instal XFCE, TigerVNC, wget, git, dan python3-websockify
sudo apt update && sudo apt install -y \
    xfce4 xfce4-goodies tigervnc-standalone-server wget git python3-websockify

# Instal noVNC dari GitHub
sudo mkdir -p /opt/novnc
sudo git clone https://github.com/novnc/noVNC.git /opt/novnc
sudo ln -s /opt/novnc/utils/novnc_proxy /usr/bin/novnc_proxy
sudo chmod +x /opt/novnc/utils/novnc_proxy

# Konfigurasi xstartup untuk XFCE dengan dbus-launch agar sesi tetap berjalan
mkdir -p ~/.vnc
cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
sleep 2
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x ~/.vnc/xstartup

# Set password VNC (password default: 'password')
echo "." | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Set environment variable DISPLAY untuk VNC
export DISPLAY=:1

# Jalankan TigerVNC dan noVNC
vncserver :1 -geometry 1280x720 -depth 24 -localhost no &
novnc_proxy --vnc localhost:5901 --listen 6080 &

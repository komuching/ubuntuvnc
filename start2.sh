#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
    echo "Silakan jalankan sebagai root: sudo bash $0"
    exit
fi

echo "Memulai instalasi WebVNC dengan noVNC di Ubuntu 22.04"

# Update sistem dan instalasi paket yang diperlukan
echo "Mengupdate sistem..."
apt-get update && apt-get upgrade -y

echo "Menginstal paket-paket yang diperlukan..."
apt-get install -y x11vnc xvfb fluxbox novnc websockify wget unzip google-chrome-stable

echo "mencoba verifikasi paket.."
sudo apt-get update
sudo apt-get install -y xvfb fluxbox x11vnc novnc websockify

# Setup Google Chrome jika belum terinstal
if ! command -v google-chrome &> /dev/null; then
    echo "Menginstal Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt-get install -y ./google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
fi

# Setup Xvfb dan fluxbox untuk sesi VNC
echo "Menyiapkan lingkungan virtual dengan Xvfb dan fluxbox..."
mkdir -p ~/.vnc
echo "password" | x11vnc -storepasswd ~/.vnc/passwd

# Membuat file konfigurasi untuk Xvfb
cat <<EOF > /usr/local/bin/start-vnc.sh
#!/bin/bash
export DISPLAY=:0
Xvfb :0 -screen 0 1920x1080x24 &
fluxbox &
x11vnc -display :0 -forever -nopw &
EOF

chmod +x /usr/local/bin/start-vnc.sh

# Setup noVNC
echo "Menyiapkan noVNC..."
NOVNC_DIR="/opt/novnc"
if [ ! -d "$NOVNC_DIR" ]; then
    git clone https://github.com/novnc/noVNC.git $NOVNC_DIR
    git clone https://github.com/novnc/websockify.git $NOVNC_DIR/utils/websockify
fi

# Membuat file sistemd untuk noVNC
cat <<EOF > /etc/systemd/system/novnc.service
[Unit]
Description=noVNC server
After=network.target

[Service]
Type=simple
ExecStart=$NOVNC_DIR/utils/launch.sh --vnc localhost:5900
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd dan enable layanan noVNC
echo "Mengaktifkan layanan noVNC..."
systemctl daemon-reload
systemctl enable novnc.service
systemctl start novnc.service

# Menjalankan layanan VNC
echo "Memulai layanan VNC..."
/usr/local/bin/start-vnc.sh &

echo "Instalasi selesai."
echo "Akses noVNC Anda melalui browser dengan URL berikut:"
echo "http://localhost:6080"

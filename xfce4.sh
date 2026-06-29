#!/bin/bash

# Script tu dong cai dat Xfce4 + goodies + OpenSSH + LightDM
# Tao boi: Tro ly AI
# Danh cho: Arch Linux

set -e  # Dung script neu co loi

echo "=========================================="
echo "  CAI DAT XFCE4 + LIGHTDM + OPENSSH"
echo "=========================================="

# 1. Cap nhat he thong
echo "[1/6] Dang cap nhat he thong..."
sudo pacman -Syu --noconfirm

# 2. Cai dat X Server va driver do hoa co ban
echo "[2/6] Dang cai dat X Server..."
sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm

# 3. Cai dat Xfce4 va cac thanh phan mo rong
echo "[3/6] Dang cai dat Xfce4 va xfce4-goodies..."
sudo pacman -S xfce4 xfce4-goodies --noconfirm

# 4. Cai dat LightDM va cac thanh phan
echo "[4/6] Dang cai dat LightDM..."
sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm

# 5. Cau hinh LightDM chi su dung Xfce4
echo "[5/6] Dang cau hinh LightDM..."

# Tao file cau hinh LightDM
sudo tee /etc/lightdm/lightdm.conf > /dev/null << 'EOF'
[Seat:*]
autologin-user=
autologin-session=xfce
session-wrapper=/etc/lightdm/Xsession
greeter-session=lightdm-gtk-greeter
user-session=xfce
EOF

# Cau hinh Greeter (man hinh dang nhap)
sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null << 'EOF'
[greeter]
background=/usr/share/backgrounds/xfce/xfce-shapes.svg
font-name=Sans 11
theme-name=Adwaita
icon-theme-name=Adwaita
show-indicators=~language;~session;~power
screensaver-timeout=60
clock-format=%H:%M
EOF

# Cau hinh session cho LightDM
sudo mkdir -p /usr/share/xsessions
sudo tee /usr/share/xsessions/xfce.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Xfce Session
Comment=Use this session to run Xfce as your desktop environment
Exec=startxfce4
Type=Application
DesktopNames=XFCE
EOF

# Kich hoat LightDM
sudo systemctl enable lightdm

# 6. Cai dat va cau hinh OpenSSH
echo "[6/6] Dang cai dat va cau hinh OpenSSH..."
sudo pacman -S openssh --noconfirm
sudo systemctl enable sshd
sudo systemctl start sshd

echo "=========================================="
echo "  CAI DAT HOAN TAT!"
echo "=========================================="
echo ""
echo "📋 THONG TIN QUAN TRONG:"
echo "1. Khoi dong lai may: sudo reboot"
echo "2. Dang nhap bang LightDM (man hinh do hoa)"
echo "   - Chi co Xfce4 duoc cau hinh"
echo "   - Khong co lua chon moi truong khac"
echo "3. OpenSSH da duoc kich hoat:"
echo "   - Kiem tra: sudo systemctl status sshd"
echo "   - Ket noi tu may khac: ssh user@ip-address"
echo "4. De tuy chinh LightDM sau nay:"
echo "   sudo nano /etc/lightdm/lightdm.conf"
echo "   sudo nano /etc/lightdm/lightdm-gtk-greeter.conf"
echo ""

🐧 Arch Linux Xfce4 Auto Install Script

Script tự động cài đặt Xfce4 Desktop + LightDM + OpenSSH trên Arch Linux.

https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white
https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white
https://img.shields.io/badge/License-MIT-green.svg
✨ Tính năng

    🚀 Xfce4 - Môi trường desktop nhẹ, nhanh

    🔌 xfce4-goodies - Plugin và công cụ mở rộng

    🖥️ LightDM - Màn hình đăng nhập đồ họa (chỉ Xfce4)

    🔒 OpenSSH - Kết nối từ xa, tự động khởi động

    ⚡ Tự động hóa - Cài đặt với 1 script duy nhất

📋 Yêu cầu

    Arch Linux

    Kết nối Internet

    Quyền sudo

🚀 Cài đặt nhanh
bash

# Tải và chạy
curl -O https://raw.githubusercontent.com/yourusername/arch-xfce-installer/main/cai-dat-xfce.sh
chmod +x cai-dat-xfce.sh
./cai-dat-xfce.sh

# Khởi động lại
sudo reboot

📖 Tạo script thủ công
bash

nano ~/cai-dat-xfce.sh
# Dán nội dung script bên dưới
chmod +x ~/cai-dat-xfce.sh
./cai-dat-xfce.sh

Nội dung script:
bash

#!/bin/bash

set -e

echo "=========================================="
echo "  CAI DAT XFCE4 + LIGHTDM + OPENSSH"
echo "=========================================="

echo "[1/6] Dang cap nhat he thong..."
sudo pacman -Syu --noconfirm

echo "[2/6] Dang cai dat X Server..."
sudo pacman -S xorg-server xorg-xinit xorg-apps --noconfirm

echo "[3/6] Dang cai dat Xfce4 va xfce4-goodies..."
sudo pacman -S xfce4 xfce4-goodies --noconfirm

echo "[4/6] Dang cai dat LightDM..."
sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm

echo "[5/6] Dang cau hinh LightDM..."
sudo tee /etc/lightdm/lightdm.conf > /dev/null << 'EOF'
[Seat:*]
autologin-user=
autologin-session=xfce
session-wrapper=/etc/lightdm/Xsession
greeter-session=lightdm-gtk-greeter
user-session=xfce
EOF

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

sudo mkdir -p /usr/share/xsessions
sudo tee /usr/share/xsessions/xfce.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Xfce Session
Comment=Use this session to run Xfce as your desktop environment
Exec=startxfce4
Type=Application
DesktopNames=XFCE
EOF

sudo systemctl enable lightdm

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
echo "2. Dang nhap bang LightDM (chi Xfce4)"
echo "3. Kiem tra SSH: sudo systemctl status sshd"
echo "4. Ket noi SSH: ssh user@ip-address"
echo ""

🔧 Cấu hình sau cài đặt
Công việc	Lệnh
Kiểm tra LightDM	sudo systemctl status lightdm
Kiểm tra SSH	sudo systemctl status sshd
Tùy chỉnh LightDM	sudo nano /etc/lightdm/lightdm.conf
Đổi mật khẩu	passwd
❗ Xử lý lỗi thường gặp
Lỗi	Giải pháp
LightDM không khởi động	sudo systemctl start lightdm
Màn hình đen	Cài driver đồ họa: sudo pacman -S mesa
SSH không kết nối	Kiểm tra firewall: sudo systemctl stop firewalld
Lỗi pacman	Kiểm tra Internet: ping google.com
🛠️ Tùy chỉnh script
Thêm gói phần mềm
bash

sudo pacman -S xfce4 xfce4-goodies firefox vlc --noconfirm

Đổi sang SDDM
bash

sudo pacman -S sddm --noconfirm
sudo systemctl enable sddm
sudo systemctl disable lightdm

Tự động đăng nhập
bash

# Mở file cấu hình
sudo nano /etc/lightdm/lightdm.conf

# Thêm dòng:
autologin-user=username

❓ Hỏi đáp

Hỏi: Script có chạy trên Manjaro/EndeavourOS không?
Đáp: Có, nhưng có thể cần điều chỉnh nhẹ.

Hỏi: Sao LightDM chỉ hiển thị Xfce4?
Đáp: Script được thiết kế chỉ hiển thị Xfce4 để đơn giản hóa.

Hỏi: Làm sao để gỡ bỏ?
Đáp: sudo pacman -Rns xfce4 xfce4-goodies lightdm openssh
🤝 Đóng góp

Mọi đóng góp đều được hoan nghênh! Fork, tạo branch và gửi Pull Request.
📄 Giấy phép

MIT License - Xem file LICENSE để biết chi tiết.

Tác giả: [Tên của bạn]
GitHub: [Link GitHub của bạn]

Made with ❤️ for Arch Linux community

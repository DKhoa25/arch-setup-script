🚀 Arch Linux Setup Script

https://img.shields.io/badge/License-MIT-yellow.svg
https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white
https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white

    Script tự động hóa cài đặt Arch Linux với đầy đủ ứng dụng văn phòng, đồ họa, giao dịch và hỗ trợ tiếng Việt.

✨ Tính Năng
🆕 Nổi Bật
Tính Năng	Mô Tả
🔐 Auto Security Updates	Cập nhật bảo mật hàng ngày lúc 2h sáng
🖌️ Fonts Đẹp	Hỗ trợ tiếng Việt, văn phòng, lập trình
🎨 GRUB Customize	Bootloader theme Dark Planet
📶 WiFi Manager	Quản lý WiFi qua GUI/TUI/CLI
🌐 DNS Optimized	Cloudflare (1.1.1.1) + Google
🇻🇳 Wine Vietnamese	Unikey + font tiếng Việt trong Wine
📦 Ứng Dụng (23)

    Văn phòng: WPS Office, Firefox (tiếng Việt), GNOME Calculator

    Đồ họa: VLC, Papirus Icon Theme

    Giao dịch: TradingView, MetaTrader 5

    Mạng: Tailscale, OpenSSH, NetworkManager

    Tiện ích: Plank, yt-dlp, TLP (quản lý pin)

    🇻🇳 Tiếng Việt: IBus-Unikey, Unikey (Wine), fonts VNI

🔧 Công Cụ

    Security Updates (systemd timer)

    Log Cleanup (tự động dọn log)

    DNS Test, Status Check

    WiFi Manager đa năng

    GRUB Customizer

    Wine Vietnamese Tools

💻 Yêu Cầu
Thành Phần	Yêu Cầu
Distro	Arch Linux
Internet	Có (để tải packages)
Dung lượng	≥ 10GB
Quyền	Root (sudo)
RAM	≥ 2GB
🚀 Cài Đặt
bash

git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script
chmod +x arch-setup.sh
sudo ./arch-setup.sh

📚 Hướng Dẫn
Công Cụ Quản Lý
bash

# Kiểm tra trạng thái hệ thống
sudo check-status

# Quản lý WiFi
wifi           # Xem danh sách
wifi gui       # GUI
wifi tui       # Terminal UI
wifi on/off    # Bật/tắt
wifi connect SSID [password]

# DNS
dns-test

# Log cleanup
cleanup-manager {run|status|logs|disable|enable|next}

🇻🇳 Wine Tiếng Việt
bash

# Khởi động Unikey
unikey

# Chạy ứng dụng Wine
wine-run notepad
wine-run "C:/Program Files/App/app.exe"

# Kiểm tra cài đặt
wine-test-vietnamese

# Hướng dẫn
wine-setup

Phím tắt: Ctrl+Space - Bật/tắt Unikey
Fonts
bash

# Refresh cache
fc-cache -fv

# Xem fonts đã cài
fc-list | grep -E "DejaVu|Noto|Roboto|VNI"

🐛 Khắc Phục Sự Cố
<details> <summary><b>❌ GRUB không cập nhật</b></summary>
bash

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-install --target=x86_64-efi --efi-directory=/boot

</details><details> <summary><b>❌ MT5 lỗi "debugger found"</b></summary>

Downgrade Wine xuống 10.2:
bash

sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst

</details><details> <summary><b>❌ Không gõ tiếng Việt trong Wine</b></summary>
bash

pkill -f UniKey
unikey
wine-run notepad

</details>
📁 Cấu Trúc
text

arch-setup.sh
├── Tiện ích (print, check, backup)
├── Tính năng mới
│   ├── Auto Security Updates
│   ├── Fonts + GRUB + WiFi + DNS
│   └── 🇻🇳 Wine Vietnamese (Unikey)
├── Cài đặt (23 ứng dụng)
├── Hệ thống (log, timer, tools)
└── Tổng kết

📄 Giấy Phép

MIT © Khoa Phan
⚠️ Tuyên Bố

Script cung cấp "như hiện tại", không bảo đảm. Người dùng tự chịu trách nhiệm.
<div align="center"> <sub>Built with ❤️ for Arch Linux</sub> </div> ```

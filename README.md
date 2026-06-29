<div align="center">

# 🚀 Arch Linux Setup Script

![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![GitHub stars](https://img.shields.io/github/stars/DKhoa25/arch-setup-script?style=social)
![GitHub forks](https://img.shields.io/github/forks/DKhoa25/arch-setup-script?style=social)
![GitHub issues](https://img.shields.io/github/issues/DKhoa25/arch-setup-script)
![GitHub last commit](https://img.shields.io/github/last-commit/DKhoa25/arch-setup-script)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![XFCE](https://img.shields.io/badge/XFCE-%232284F2.svg?style=flat&logo=xfce&logoColor=white)
![Wine](https://img.shields.io/badge/Wine-8.0+-red?style=flat&logo=wine&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=flat&logo=neovim&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/VS_Code-007ACC?style=flat&logo=visual-studio-code&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

> **Script tự động hóa cài đặt Arch Linux với đầy đủ ứng dụng văn phòng, đồ họa, giao dịch và hỗ trợ tiếng Việt.**

[![Cài đặt nhanh](https://img.shields.io/badge/🚀_Cài_Đặt_Nhanh-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](#-cài-đặt-nhanh)
[![Hướng dẫn](https://img.shields.io/badge/📚_Hướng_Dẫn-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](#-hướng-dẫn-sử-dụng)
[![Báo lỗi](https://img.shields.io/badge/🐛_Báo_Lỗi-FF6B6B?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DKhoa25/arch-setup-script/issues)
[![Donate](https://img.shields.io/badge/☕_Donate-FF813F?style=for-the-badge&logo=buymeacoffee&logoColor=white)](https://buymeacoffee.com/yourusername)

</div>

---

## 📸 Hình Ảnh Minh Họa

<p align="center">
  <img src="screenshots/lightdm-login.png" alt="LightDM Login" width="800"/>
  <br/>
  <em>Giao diện đăng nhập LightDM với theme Dark Planet</em>
</p>

<p align="center">
  <img src="screenshots/xfce4-desktop.png" alt="Xfce4 Desktop" width="800"/>
  <br/>
  <em>Màn hình desktop Xfce4 với Plank dock</em>
</p>

<p align="center">
  <img src="screenshots/grub-bootloader.png" alt="GRUB Bootloader" width="800"/>
  <br/>
  <em>GRUB Bootloader với theme Starfield</em>
</p>

---

## ✨ Tính Năng Nổi Bật

<table align="center">
<tr>
<td width="50%">

| Tính Năng | Mô Tả |
|-----------|-------|
| 🔐 **Auto Security Updates** | Cập nhật bảo mật hàng ngày lúc 2h sáng |
| 🖌️ **Fonts Đẹp** | Hỗ trợ tiếng Việt, văn phòng, lập trình |
| 🎨 **GRUB Customize** | Bootloader theme Dark Planet |
| 📶 **WiFi Manager** | Quản lý WiFi qua GUI/TUI/CLI |
| 🌐 **DNS Optimized** | Cloudflare (1.1.1.1) + Google (8.8.8.8) |

</td>
<td width="50%">

| Tính Năng | Mô Tả |
|-----------|-------|
| 🇻🇳 **Wine Vietnamese** | Unikey + font tiếng Việt trong Wine |
| ⚡ **Performance** | Tối ưu hệ thống, khởi động nhanh |
| 🛡️ **Security** | Firewall, SELinux, bảo mật mặc định |
| 🔄 **Auto Cleanup** | Dọn dẹp log tự động hàng tuần |
| 📦 **One-Click Setup** | Cài đặt 23+ ứng dụng tự động |

</td>
</tr>
</table>

---

## 📦 Ứng Dụng Được Cài Đặt

### 🏢 Văn phòng & Đồ họa

| Ứng Dụng | Mô Tả | Badge |
|----------|-------|-------|
| **WPS Office** | Bộ văn phòng | ![WPS](https://img.shields.io/badge/WPS_Office-4CAF50?style=flat&logo=wps&logoColor=white) |
| **Firefox** | Trình duyệt web (bản tiếng Việt) | ![Firefox](https://img.shields.io/badge/Firefox-FF7139?style=flat&logo=firefox&logoColor=white) |
| **GNOME Calculator** | Máy tính | ![GNOME](https://img.shields.io/badge/GNOME_Calculator-4A86CF?style=flat&logo=gnome&logoColor=white) |
| **VLC** | Trình phát đa phương tiện + DVD | ![VLC](https://img.shields.io/badge/VLC-FF8800?style=flat&logo=videolan&logoColor=white) |
| **Papirus Icon Theme** | Icon theme đẹp | ![Papirus](https://img.shields.io/badge/Papirus-7B68EE?style=flat&logo=linux&logoColor=white) |

### 💹 Giao dịch & Mạng

| Ứng Dụng | Mô Tả | Badge |
|----------|-------|-------|
| **TradingView** | Giao dịch tài chính | ![TradingView](https://img.shields.io/badge/TradingView-00B4D8?style=flat&logo=tradingview&logoColor=white) |
| **MetaTrader 5** | Giao dịch forex | ![MT5](https://img.shields.io/badge/MetaTrader_5-0078D4?style=flat&logo=microsoft&logoColor=white) |
| **Tailscale** | VPN mesh | ![Tailscale](https://img.shields.io/badge/Tailscale-000000?style=flat&logo=tailscale&logoColor=white) |
| **OpenSSH** | Remote access | ![SSH](https://img.shields.io/badge/OpenSSH-000000?style=flat&logo=openssh&logoColor=white) |
| **NetworkManager** | Quản lý mạng | ![Network](https://img.shields.io/badge/NetworkManager-1793D1?style=flat&logo=archlinux&logoColor=white) |

### 🛠️ Tiện ích & Hệ thống

| Ứng Dụng | Mô Tả | Badge |
|----------|-------|-------|
| **Plank** | Dock ứng dụng | ![Plank](https://img.shields.io/badge/Plank-5C2D91?style=flat&logo=linux&logoColor=white) |
| **yt-dlp + ffmpeg** | Tải video/audio | ![yt-dlp](https://img.shields.io/badge/yt--dlp-FF0000?style=flat&logo=youtube&logoColor=white) |
| **TLP** | Quản lý pin (55-85%) | ![TLP](https://img.shields.io/badge/TLP-4CAF50?style=flat&logo=linux&logoColor=white) |
| **Bluetooth** | BlueZ + Blueman | ![Bluetooth](https://img.shields.io/badge/Bluetooth-0082FC?style=flat&logo=bluetooth&logoColor=white) |
| **Logrotate** | Dọn dẹp log tự động | ![Logrotate](https://img.shields.io/badge/Logrotate-FF6B6B?style=flat&logo=linux&logoColor=white) |

### 🇻🇳 Hỗ trợ tiếng Việt

| Ứng Dụng | Mô Tả | Badge |
|----------|-------|-------|
| **IBus-Unikey** | Gõ tiếng Việt cho Linux | ![Unikey](https://img.shields.io/badge/Unikey-FF6B6B?style=flat&logo=keyboard&logoColor=white) |
| **Unikey (Wine)** | Gõ tiếng Việt trong ứng dụng Windows | ![Wine](https://img.shields.io/badge/Wine_Unikey-FF0000?style=flat&logo=wine&logoColor=white) |
| **Fonts VNI** | Font tiếng Việt đẹp | ![Fonts](https://img.shields.io/badge/VNI_Fonts-4CAF50?style=flat&logo=adobe&logoColor=white) |

---

## 💻 Yêu Cầu Hệ Thống

| Thành Phần | Yêu Cầu | Badge |
|------------|---------|-------|
| **Distro** | Arch Linux | ![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white) |
| **Internet** | Có (để tải packages) | ![Internet](https://img.shields.io/badge/Internet-Required-4CAF50?style=flat) |
| **Dung lượng** | ≥ 10GB | ![Disk](https://img.shields.io/badge/Disk-10GB+-4CAF50?style=flat) |
| **Quyền** | Root (sudo) | ![Root](https://img.shields.io/badge/Root-Required-FF6B6B?style=flat) |
| **RAM** | ≥ 2GB (khuyến nghị 4GB+) | ![RAM](https://img.shields.io/badge/RAM-2GB+-4CAF50?style=flat) |

---

## 🚀 Cài Đặt Nhanh

```bash
# Clone repository
git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script

# Cấp quyền và chạy
chmod +x arch-setup.sh
sudo ./arch-setup.sh

    ⚠️ Script sẽ hỏi xác nhận trước khi bắt đầu. Nhấn y để tiếp tục.

📚 Hướng Dẫn Sử Dụng
🔧 Công Cụ Kiểm Tra
bash

# Kiểm tra trạng thái toàn bộ hệ thống
sudo check-status

# Kiểm tra DNS
dns-test

# Xem hướng dẫn Wine
wine-setup

📶 Quản Lý WiFi
bash

wifi           # Xem danh sách WiFi
wifi gui       # Mở GUI quản lý
wifi tui       # Mở Terminal UI (nmtui)
wifi on/off    # Bật/tắt WiFi
wifi list      # Liệt kê mạng WiFi
wifi connect SSID [password]  # Kết nối WiFi

🧹 Quản Lý Log
bash

cleanup-manager run     # Chạy dọn dẹp ngay
cleanup-manager status  # Xem trạng thái timer
cleanup-manager logs    # Xem log real-time
cleanup-manager disable # Tắt tự động dọn
cleanup-manager enable  # Bật tự động dọn
cleanup-manager next    # Xem lần chạy tiếp theo

🇻🇳 Gõ Tiếng Việt trong Wine
bash

# 1. Khởi động Unikey
unikey

# 2. Chạy ứng dụng Wine với tiếng Việt
wine-run notepad
wine-run "C:/Program Files/MyApp/app.exe"

# 3. Kiểm tra cài đặt
wine-test-vietnamese

    Phím tắt: Ctrl+Space - Bật/tắt Unikey
    Bảng mã: Unicode | Kiểu gõ: Telex hoặc VNI

🔤 Fonts
bash

# Refresh font cache
fc-cache -fv

# Xem danh sách font đã cài
fc-list | grep -E "DejaVu|Noto|Roboto|VNI"

🛠️ Cấu Hình Nâng Cao
GRUB Bootloader
bash

# Chỉnh sửa cấu hình
sudo nano /etc/default/grub

# Cập nhật GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

🔋 TLP (Quản lý pin)

Cấu hình tại /etc/tlp.conf:
ini

START_CHARGE_THRESH_BAT0=55
STOP_CHARGE_THRESH_BAT0=85

🔐 Security Updates

Xem log:
bash

cat /var/log/security-updates.log

Kiểm tra timer:
bash

systemctl status security-update.timer

🐛 Khắc Phục Sự Cố
<details> <summary><b>❌ GRUB không cập nhật</b></summary>
bash

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

</details><details> <summary><b>❌ MT5 lỗi "debugger found"</b></summary>

Downgrade Wine xuống 10.2:
bash

sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst

</details><details> <summary><b>❌ Không gõ tiếng Việt trong Wine</b></summary>
bash

# Kiểm tra Unikey đã chạy
ps aux | grep UniKey

# Khởi động lại Unikey
pkill -f UniKey
unikey

# Kiểm tra font
ls -la ~/.wine/drive_c/windows/Fonts/ | grep -E "DejaVu|Noto"

</details><details> <summary><b>❌ LightDM không hiển thị theme</b></summary>
bash

# Kiểm tra theme
ls -la /usr/share/web-greeter/themes/dark-planet/

# Kiểm tra cấu hình
cat /etc/lightdm/lightdm-webkit2-greeter.conf

</details>
📁 Cấu Trúc Script
text

arch-setup.sh
├── Hàm tiện ích
│   ├── print_header / print_step / print_success
│   ├── check_distro / check_internet / check_disk_space
│   └── backup_config
├── Tính năng mới
│   ├── setup_auto_security_updates   # Security patches tự động
│   ├── install_fonts                  # Fonts đẹp
│   ├── customize_grub                 # Bootloader theme
│   ├── setup_wifi_management          # WiFi manager
│   └── configure_dns                  # DNS optimization
├── Cài đặt chính
│   ├── remove_xfce4_panel             # Gỡ bỏ panel cũ
│   └── install_applications           # 23 ứng dụng
│       └── setup_wine_vietnamese      # 🇻🇳 Wine + Unikey
├── Hệ thống
│   ├── create_cleanup_script          # Script dọn log
│   ├── setup_systemd_timer            # Timer tự động
│   ├── create_tools                   # Công cụ kiểm tra
│   └── create_wine_guide              # Hướng dẫn Wine
└── Tổng kết
    └── show_summary                    # Báo cáo cài đặt

📦 Bảng Lệnh Nhanh - Arch Linux
🚀 Lệnh Nhanh
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ ⚡ Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ sudo check-status                           │ Kiểm tra trạng thái hệ thống                 │
│ 2  │ unikey                                      │ Khởi động Unikey trong Wine                  │
│ 3  │ wine-run app.exe                            │ Chạy ứng dụng Wine với tiếng Việt            │
│ 4  │ wifi                                        │ Quản lý WiFi                                 │
│ 5  │ bluetoothctl                                │ Quản lý Bluetooth                            │
│ 6  │ dns-test                                    │ Kiểm tra DNS                                 │
│ 7  │ grub-mkconfig                               │ Cập nhật GRUB                                │
│ 8  │ pacman -Syu                                 │ Cập nhật toàn bộ hệ thống                    │
│ 9  │ fc-cache -fv                                │ Refresh font cache                           │
│ 10 │ systemctl status security-update.timer      │ Kiểm tra cập nhật bảo mật                    │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

📂 Bảng Lệnh Theo Nhóm
🏗️ Quản lý Hệ thống
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ ⚙️ Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ sudo check-status                           │ Kiểm tra trạng thái hệ thống                 │
│ 2  │ systemctl status security-update.timer      │ Kiểm tra cập nhật bảo mật                    │
│ 3  │ journalctl -xe                              │ Xem log hệ thống                             │
│ 4  │ htop                                        │ Giám sát hệ thống                            │
│ 5  │ neofetch                                    │ Hiển thị thông tin hệ thống                  │
│ 6  │ pacman -Syu                                 │ Cập nhật toàn bộ hệ thống                    │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

💾 Quản lý Ổ đĩa & Bộ nhớ
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ 💽 Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ lsblk -f                                    │ Xem thông tin phân vùng                      │
│ 2  │ df -h                                       │ Kiểm tra dung lượng đĩa                      │
│ 3  │ free -h                                     │ Kiểm tra RAM                                 │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

🌐 Quản lý Mạng & Kết nối
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ 🌍 Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ wifi                                        │ Quản lý WiFi                                 │
│ 2  │ wifi gui                                    │ Mở GUI quản lý WiFi                          │
│ 3  │ wifi tui                                    │ Mở Terminal UI (nmtui)                       │
│ 4  │ wifi on/off                                 │ Bật/tắt WiFi                                 │
│ 5  │ wifi connect SSID [password]                │ Kết nối WiFi                                 │
│ 6  │ dns-test                                    │ Kiểm tra DNS                                 │
│ 7  │ bluetoothctl                                │ Quản lý Bluetooth                            │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

🍷 Quản lý Wine & Tiếng Việt
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ 🍇 Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ unikey                                      │ Khởi động Unikey trong Wine                  │
│ 2  │ wine-run app.exe                            │ Chạy ứng dụng Wine với tiếng Việt            │
│ 3  │ wine-test-vietnamese                        │ Kiểm tra cài đặt tiếng Việt                  │
│ 4  │ wine-setup                                  │ Hướng dẫn cấu hình Wine                      │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

🖥️ Quản lý Hệ thống khởi động
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ 🚀 Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ grub-mkconfig -o /boot/grub/grub.cfg        │ Cập nhật GRUB                                │
│ 2  │ grub-install --target=x86_64-efi            │ Cài đặt GRUB UEFI                            │
│    │ --efi-directory=/boot                       │                                            │
│    │ --bootloader-id=GRUB                       │                                            │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

🧹 Dọn dẹp & Tối ưu
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ 🧽 Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ cleanup-manager run                         │ Chạy dọn dẹp ngay                            │
│ 2  │ cleanup-manager status                      │ Xem trạng thái timer                         │
│ 3  │ cleanup-manager logs                        │ Xem log real-time                            │
│ 4  │ cleanup-manager disable/enable              │ Tắt/bật tự động dọn                          │
│ 5  │ cleanup-manager next                        │ Xem lần chạy tiếp theo                       │
│ 6  │ fc-cache -fv                                │ Refresh font cache                           │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

🔋 Quản lý Năng lượng
text

┌────┬──────────────────────────────────────────────┬────────────────────────────────────────────┐
│ #  │ ⚡ Lệnh                                      │ 📝 Mục đích                                  │
├────┼──────────────────────────────────────────────┼────────────────────────────────────────────┤
│ 1  │ tlp-stat -b                                 │ Kiểm tra trạng thái pin                      │
│ 2  │ tlp-stat -s                                 │ Kiểm tra cấu hình TLP                        │
└────┴──────────────────────────────────────────────┴────────────────────────────────────────────┘

📝 Hướng dẫn sử dụng
🔹 Copy lệnh nhanh
text

1. Bôi đen dòng lệnh cần copy
2. Ctrl+C (hoặc Cmd+C trên Mac)
3. Dán vào terminal: Ctrl+Shift+V

🔹 Tùy chỉnh tham số
text

Thay thế các tham số trong [ ] với giá trị của bạn:
• SSID        → Tên WiFi của bạn
• password    → Mật khẩu WiFi
• app.exe     → Tên ứng dụng .exe

💡 Mẹo: Sử dụng Ctrl+R trong terminal để tìm kiếm lịch sử lệnh đã dùng!


📄 Giấy Phép

Dự án được phân phối dưới giấy phép MIT. Xem file LICENSE để biết thêm chi tiết.

https://img.shields.io/badge/License-MIT-yellow.svg
⚠️ Tuyên Bố Miễn Trách

    Script này được cung cấp "như hiện tại", không có bất kỳ bảo đảm nào. Người dùng chịu trách nhiệm cho mọi thay đổi được thực hiện trên hệ thống của họ.

📞 Liên Hệ & Đóng Góp

    Tác Giả: Khoa Phan

    Issue Tracker: GitHub Issues

    Pull Requests: GitHub PRs

https://img.shields.io/github/followers/DKhoa25?style=social
https://img.shields.io/twitter/follow/yourusername?style=social
<div align="center"> <sub>Built with ❤️ for the Arch Linux community</sub> <br/> <sub>⭐ Đừng quên star repository nếu bạn thấy hữu ích!</sub> </div> ```

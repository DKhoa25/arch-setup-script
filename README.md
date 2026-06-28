# 🚀 Arch Linux Setup Script - Full Installation & Optimization

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Bash](https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

> **Một script tự động hóa toàn diện để cài đặt và tối ưu Arch Linux với đầy đủ ứng dụng văn phòng, đồ họa, và tính năng bảo mật.**

---

## 📋 Mục Lục

- [Tổng Quan](#-tổng-quan)
- [Tính Năng Nổi Bật](#-tính-năng-nổi-bật)
- [Yêu Cầu Hệ Thống](#-yêu-cầu-hệ-thống)
- [Cài Đặt Nhanh](#-cài-đặt-nhanh)
- [Các Tính Năng Chi Tiết](#-các-tính-năng-chi-tiết)
- [Hướng Dẫn Sử Dụng](#-hướng-dẫn-sử-dụng)
- [Khắc Phục Sự Cố](#-khắc-phục-sự-cố)
- [Cấu Trúc Script](#-cấu-trúc-script)

## 📖 Tổng Quan

Script này được thiết kế để tự động hóa quá trình cài đặt và cấu hình Arch Linux, biến nó thành một hệ thống hoàn chỉnh với:

- **Giao diện đẹp**: LightDM Webkit + Plymouth Animation
- **Đầy đủ ứng dụng**: Văn phòng, đồ họa, giải trí, giao dịch
- **Bảo mật**: Tự động cập nhật security patches
- **Tối ưu**: Quản lý pin, dọn dẹp log, cấu hình DNS

---

## ✨ Tính Năng Nổi Bật

### 🆕 Tính Năng Mới

| Tính Năng | Mô Tả |
|-----------|-------|
| 🔐 **Auto Security Updates** | Tự động cập nhật bảo mật hàng ngày lúc 2h sáng |
| 🖌️ **Fonts Đẹp** | Hỗ trợ tiếng Việt, văn phòng, lập trình |
| 🎨 **GRUB Customize** | Bootloader với theme Dark Planet + background |
| 📶 **WiFi Manager** | Quản lý WiFi dễ dàng qua GUI/TUI/CLI |
| 🌐 **DNS Optimized** | Cloudflare (1.1.1.1) + Google (8.8.8.8) |

### 📦 Ứng Dụng Được Cài Đặt

<details>
<summary><b>📌 Nhấn để xem danh sách đầy đủ (22 ứng dụng)</b></summary>

| # | Ứng Dụng | Mục Đích |
|---|----------|----------|
| 1 | **IBus-Unikey** | Gõ tiếng Việt |
| 2 | **Plank** | Dock ứng dụng |
| 3 | **Firefox** | Trình duyệt web (bản tiếng Việt) |
| 4 | **VLC** | Trình phát đa phương tiện + DVD |
| 5 | **Forecast** | Dự báo thời tiết |
| 6 | **Tailscale** | VPN mesh |
| 7 | **OpenSSH** | Remote access |
| 8 | **Bluetooth** | BlueZ + Blueman |
| 9 | **TLP** | Quản lý pin (ngưỡng sạc 55-85%) |
| 10 | **yt-dlp + ffmpeg** | Tải video/audio |
| 11 | **Driver Intel** | Mesa, Vulkan, VA-API |
| 12 | **Wine** | Chạy ứng dụng Windows (full plugins) |
| 13 | **WPS Office** | Bộ văn phòng |
| 14 | **Zalo Chat** | Nhắn tin (Snap) |
| 15 | **TradingView** | Giao dịch tài chính |
| 16 | **MetaTrader 5** | Giao dịch forex |
| 17 | **GNOME Calculator** | Máy tính |
| 18 | **Papirus Icon** | Icon theme đẹp |
| 19 | **LightDM Webkit** | Giao diện đăng nhập |
| 20 | **Plymouth** | Boot splash đẹp |
| 21 | **NetworkManager** | Quản lý mạng |
| 22 | **Logrotate** | Dọn dẹp log tự động |

</details>

### 🔧 Công Cụ Hệ Thống

<details>
<summary><b>📌 Nhấn để xem công cụ hệ thống</b></summary>

- **Security Updates**: Tự động cập nhật hàng ngày
- **Log Cleanup**: Dọn dẹp log theo lịch trình
- **DNS Test**: Kiểm tra độ trễ DNS
- **Status Check**: Kiểm tra trạng thái services
- **WiFi Manager**: Quản lý WiFi đa năng
- **GRUB Customizer**: Tùy chỉnh bootloader

</details>

---

## 💻 Yêu Cầu Hệ Thống

| Thành Phần | Yêu Cầu |
|------------|---------|
| **Distro** | Arch Linux |
| **Kết nối** | Internet (để tải packages) |
| **Dung lượng** | ≥ 10GB trống |
| **Quyền** | Root (sudo) |
| **Memory** | ≥ 2GB RAM (khuyến nghị 4GB+) |

---

## 🚀 Cài Đặt Nhanh

### 1. Clone Repository

```bash
git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script

2. Chạy Script
bash

chmod +x arch-setup.sh
sudo ./arch-setup.sh

3. Xác Nhận

Script sẽ hỏi xác nhận trước khi bắt đầu. Nhấn y để tiếp tục.
📚 Các Tính Năng Chi Tiết
🛡️ 1. Tự Động Cập Nhật Bảo Mật

Script cài đặt systemd timer chạy hàng ngày lúc 2h sáng:
bash

# Xem log cập nhật
cat /var/log/security-updates.log

# Kiểm tra trạng thái timer
systemctl status security-update.timer

# Chạy thủ công
systemctl start security-update.service

🎨 2. GRUB Customize

    Theme: Dark Planet (Starfield)

    Background: Gradient darkblue-black

    Font: Unicode

    Color: White/Black (normal), Cyan/Black (highlight)

Thay đổi theme GRUB:
bash

# Chỉnh sửa /etc/default/grub
GRUB_THEME=/boot/grub/themes/starfield/theme.txt
# Cập nhật
grub-mkconfig -o /boot/grub/grub.cfg

📶 3. Quản Lý WiFi

Công cụ wifi đa năng:
bash

wifi           # Xem danh sách WiFi
wifi gui       # Mở GUI quản lý
wifi tui       # Mở Terminal UI (nmtui)
wifi on/off    # Bật/tắt WiFi
wifi list      # Liệt kê mạng WiFi
wifi connect SSID [password]  # Kết nối WiFi

🌐 4. Cấu Hình DNS

DNS được cấu hình với ưu tiên:

    Cloudflare: 1.1.1.1, 1.0.0.1

    Google: 8.8.8.8, 8.8.4.4

    Cloudflare DNS-over-TLS: 1.1.1.2, 1.0.0.2

Kiểm tra DNS:
bash

dns-test

🛠️ Hướng Dẫn Sử Dụng
Công Cụ Kiểm Tra
bash

# Kiểm tra trạng thái toàn bộ services
sudo check-status

# Kết quả sẽ hiển thị
# - Trạng thái services
# - Thông tin pin
# - Dung lượng log
# - Các ứng dụng đã cài

Quản Lý Log
bash

cleanup-manager run     # Chạy dọn dẹp ngay
cleanup-manager status  # Xem trạng thái timer
cleanup-manager logs    # Xem log real-time
cleanup-manager disable # Tắt tự động dọn
cleanup-manager enable  # Bật tự động dọn
cleanup-manager next    # Xem lần chạy tiếp theo

Wine và MetaTrader 5

Lưu ý quan trọng: MT5 hiện có lỗi "debugger found" trên Wine 10.3+

Giải pháp: Downgrade Wine về 10.2
bash

# Downgrade Wine
sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst

# Hoặc sử dụng wine-setup để xem hướng dẫn
wine-setup

Fonts
bash

# Refresh font cache (nếu font không hiển thị)
fc-cache -fv

# Xem danh sách font đã cài
fc-list | grep -E "DejaVu|Noto|Roboto"

🐛 Khắc Phục Sự Cố
<details> <summary><b>❌ Lỗi: "Script chỉ chạy trên Arch Linux"</b></summary>

Giải pháp: Đảm bảo bạn đang sử dụng Arch Linux
bash

cat /etc/os-release | grep ID

</details><details> <summary><b>❌ Lỗi: "Không có kết nối Internet"</b></summary>

Giải pháp: Kiểm tra kết nối mạng
bash

ping -c 3 archlinux.org

</details><details> <summary><b>❌ Lỗi: "Dung lượng đĩa còn < 10GB"</b></summary>

Giải pháp: Dọn dẹp hoặc mở rộng phân vùng
bash

df -h /

</details><details> <summary><b>❌ GRUB không cập nhật được</b></summary>

Giải pháp: Chạy thủ công
bash

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

</details><details> <summary><b>❌ LightDM không hiển thị theme đẹp</b></summary>

Giải pháp:
bash

# Kiểm tra theme đã được copy chưa
ls -la /usr/share/web-greeter/themes/dark-planet/

# Kiểm tra cấu hình
cat /etc/lightdm/lightdm-webkit2-greeter.conf

</details><details> <summary><b>❌ Wine MT5 lỗi "debugger found"</b></summary>

Giải pháp: Đọc hướng dẫn chi tiết trong wine-setup
bash

wine-setup

</details>
📁 Cấu Trúc Script
<details> <summary><b>📌 Nhấn để xem cấu trúc chi tiết</b></summary>
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
│   └── install_applications           # 22 ứng dụng
├── Hệ thống
│   ├── create_cleanup_script          # Script dọn log
│   ├── setup_systemd_timer            # Timer tự động
│   ├── create_tools                   # Công cụ kiểm tra
│   └── create_wine_guide              # Hướng dẫn Wine
└── Tổng kết
    └── show_summary                    # Báo cáo cài đặt

</details>

Dự án được phân phối dưới giấy phép MIT. Xem file LICENSE để biết thêm chi tiết.
⚠️ Tuyên Bố Miễn Trách

Script này được cung cấp "như hiện tại", không có bất kỳ bảo đảm nào. Người dùng chịu trách nhiệm cho mọi thay đổi được thực hiện trên hệ thống của họ.
📞 Liên Hệ

    Tác Giả: Khoa Phan

    Issue Tracker: GitHub Issues

    Wiki: Documentation

<div align="center"> <sub>Built with ❤️ for the Arch Linux community</sub> </div> ```

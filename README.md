🚀 Arch Linux Setup Script

https://img.shields.io/badge/License-MIT-yellow.svg
https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white
https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white

    Script tự động hóa cài đặt Arch Linux với đầy đủ ứng dụng văn phòng, đồ họa, giao dịch và hỗ trợ tiếng Việt.

📸 Hình Ảnh Minh Họa
<p align="center"> <img src="screenshots/lightdm-login.png" alt="LightDM Login" width="800"/> <br/> <em>Giao diện đăng nhập LightDM với theme Dark Planet</em> </p><p align="center"> <img src="screenshots/xfce4-desktop.png" alt="Xfce4 Desktop" width="800"/> <br/> <em>Màn hình desktop Xfce4 với Plank dock</em> </p><p align="center"> <img src="screenshots/grub-bootloader.png" alt="GRUB Bootloader" width="800"/> <br/> <em>GRUB Bootloader với theme Starfield</em> </p>
✨ Tính Năng Nổi Bật
Tính Năng	Mô Tả
🔐 Auto Security Updates	Cập nhật bảo mật hàng ngày lúc 2h sáng
🖌️ Fonts Đẹp	Hỗ trợ tiếng Việt, văn phòng, lập trình
🎨 GRUB Customize	Bootloader theme Dark Planet
📶 WiFi Manager	Quản lý WiFi qua GUI/TUI/CLI
🌐 DNS Optimized	Cloudflare (1.1.1.1) + Google (8.8.8.8)
🇻🇳 Wine Vietnamese	Unikey + font tiếng Việt trong Wine
📦 Ứng Dụng Được Cài Đặt
Văn phòng & Đồ họa
Ứng Dụng	Mô Tả
WPS Office	Bộ văn phòng
Firefox	Trình duyệt web (bản tiếng Việt)
GNOME Calculator	Máy tính
VLC	Trình phát đa phương tiện + DVD
Papirus Icon Theme	Icon theme đẹp
Giao dịch & Mạng
Ứng Dụng	Mô Tả
TradingView	Giao dịch tài chính
MetaTrader 5	Giao dịch forex
Tailscale	VPN mesh
OpenSSH	Remote access
NetworkManager	Quản lý mạng
Tiện ích & Hệ thống
Ứng Dụng	Mô Tả
Plank	Dock ứng dụng
yt-dlp + ffmpeg	Tải video/audio
TLP	Quản lý pin (ngưỡng sạc 55-85%)
Bluetooth	BlueZ + Blueman
Logrotate	Dọn dẹp log tự động
🇻🇳 Hỗ trợ tiếng Việt
Ứng Dụng	Mô Tả
IBus-Unikey	Gõ tiếng Việt cho Linux
Unikey (Wine)	Gõ tiếng Việt trong ứng dụng Windows
Fonts VNI	Font tiếng Việt đẹp
💻 Yêu Cầu Hệ Thống
Thành Phần	Yêu Cầu
Distro	Arch Linux
Internet	Có (để tải packages)
Dung lượng	≥ 10GB
Quyền	Root (sudo)
RAM	≥ 2GB (khuyến nghị 4GB+)
🚀 Cài Đặt Nhanh
bash

# Clone repository
git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script

# Cấp quyền và chạy
chmod +x arch-setup.sh
sudo ./arch-setup.sh

Script sẽ hỏi xác nhận trước khi bắt đầu. Nhấn y để tiếp tục.
📚 Hướng Dẫn Sử Dụng
Công Cụ Kiểm Tra
bash

# Kiểm tra trạng thái toàn bộ hệ thống
sudo check-status

# Kiểm tra DNS
dns-test

# Xem hướng dẫn Wine
wine-setup

Quản Lý WiFi
bash

wifi           # Xem danh sách WiFi
wifi gui       # Mở GUI quản lý
wifi tui       # Mở Terminal UI (nmtui)
wifi on/off    # Bật/tắt WiFi
wifi list      # Liệt kê mạng WiFi
wifi connect SSID [password]  # Kết nối WiFi

Quản Lý Log
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
Fonts
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

TLP (Quản lý pin)

Cấu hình tại /etc/tlp.conf:
ini

START_CHARGE_THRESH_BAT0=55
STOP_CHARGE_THRESH_BAT0=85

Security Updates

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

📦 Bảng Lệnh Nhanh
Lệnh	Mục đích
sudo check-status	Kiểm tra trạng thái hệ thống
unikey	Khởi động Unikey trong Wine
wine-run app.exe	Chạy ứng dụng Wine với tiếng Việt
wine-test-vietnamese	Kiểm tra cài đặt tiếng Việt
wine-setup	Hướng dẫn cấu hình Wine
wifi	Quản lý WiFi
dns-test	Kiểm tra DNS
cleanup-manager	Quản lý dọn dẹp log
fc-cache -fv	Refresh font cache
📄 Giấy Phép

Dự án được phân phối dưới giấy phép MIT. Xem file LICENSE để biết thêm chi tiết.
⚠️ Tuyên Bố Miễn Trách

Script này được cung cấp "như hiện tại", không có bất kỳ bảo đảm nào. Người dùng chịu trách nhiệm cho mọi thay đổi được thực hiện trên hệ thống của họ.
📞 Liên Hệ & Đóng Góp

    Tác Giả: Khoa Phan

    Issue Tracker: GitHub Issues

    Pull Requests: GitHub PRs

<div align="center"> <sub>Built with ❤️ for the Arch Linux community</sub> </div>
📸 Hướng Dẫn Thêm Ảnh

Để thêm ảnh vào README, bạn cần:

    Tạo thư mục screenshots/ trong repository

    Thêm ảnh vào thư mục đó

    Sử dụng cú pháp: ![Tên ảnh](screenshots/tên-file.png)

Ví dụ cấu trúc thư mục:
text

arch-setup-script/
├── arch-setup.sh
├── README.md
├── LICENSE
└── screenshots/
    ├── lightdm-login.png
    ├── xfce4-desktop.png
    ├── grub-bootloader.png
    └── plymouth-boot.png

Hoặc sử dụng ảnh từ URL:
markdown

![Logo](https://raw.githubusercontent.com/DKhoa25/arch-setup-script/main/screenshots/logo.png)

🎯 Tóm Tắt

Script này giúp bạn có một hệ thống Arch Linux hoàn chỉnh với:

✅ Giao diện đẹp - LightDM Webkit + Plymouth Animation
✅ Đầy đủ ứng dụng - 23 ứng dụng cho mọi nhu cầu
✅ Hỗ trợ tiếng Việt - IBus-Unikey + Wine Unikey
✅ Bảo mật - Tự động cập nhật security patches
✅ Tối ưu - Quản lý pin, dọn dẹp log, DNS nhanh

Chúc bạn sử dụng vui vẻ! 🚀
This response is AI-generated, for reference only.
Markdow https://img.shields.io/badge/License-MIT-yellow.svg https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white
🚀 Arch Linux Setup Script

https://img.shields.io/badge/License-MIT-yellow.svg
https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white
https://img.shields.io/badge/Bash-4.4+-4EAA25?style=flat&logo=gnu-bash&logoColor=white

    Script tự động hóa cài đặt Arch Linux với đầy đủ ứng dụng văn phòng, đồ họa, giao dịch và hỗ trợ tiếng Việt.

✨ Tính Năng Nổi Bật
Tính Năng	Mô Tả
🔐 Auto Security Updates	Cập nhật bảo mật hàng ngày lúc 2h sáng
🖌️ Fonts Đẹp	Hỗ trợ tiếng Việt, văn phòng, lập trình
🎨 GRUB Customize	Bootloader theme Dark Planet
📶 WiFi Manager	Quản lý WiFi qua GUI/TUI/CLI
🌐 DNS Optimized	Cloudflare (1.1.1.1) + Google (8.8.8.8)
🇻🇳 Wine Vietnamese	Unikey + font tiếng Việt trong Wine
📦 Ứng Dụng Được Cài Đặt
Văn phòng & Đồ họa
Ứng Dụng	Mô Tả
WPS Office	Bộ văn phòng
Firefox	Trình duyệt web (bản tiếng Việt)
GNOME Calculator	Máy tính
VLC	Trình phát đa phương tiện + DVD
Papirus Icon Theme	Icon theme đẹp
Giao dịch & Mạng
Ứng Dụng	Mô Tả
TradingView	Giao dịch tài chính
MetaTrader 5	Giao dịch forex
Tailscale	VPN mesh
OpenSSH	Remote access
NetworkManager	Quản lý mạng
Tiện ích & Hệ thống
Ứng Dụng	Mô Tả
Plank	Dock ứng dụng
yt-dlp + ffmpeg	Tải video/audio
TLP	Quản lý pin (ngưỡng sạc 55-85%)
Bluetooth	BlueZ + Blueman
Logrotate	Dọn dẹp log tự động
🇻🇳 Hỗ trợ tiếng Việt
Ứng Dụng	Mô Tả
IBus-Unikey	Gõ tiếng Việt cho Linux
Unikey (Wine)	Gõ tiếng Việt trong ứng dụng Windows
Fonts VNI	Font tiếng Việt đẹp
💻 Yêu Cầu Hệ Thống
Thành Phần	Yêu Cầu
Distro	Arch Linux
Internet	Có (để tải packages)
Dung lượng	≥ 10GB
Quyền	Root (sudo)
RAM	≥ 2GB (khuyến nghị 4GB+)
🚀 Cài Đặt Nhanh
bash

# Clone repository
git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script

# Cấp quyền và chạy
chmod +x arch-setup.sh
sudo ./arch-setup.sh

Script sẽ hỏi xác nhận trước khi bắt đầu. Nhấn y để tiếp tục.
📚 Hướng Dẫn Sử Dụng
Công Cụ Kiểm Tra
bash

# Kiểm tra trạng thái toàn bộ hệ thống
sudo check-status

# Kiểm tra DNS
dns-test

# Xem hướng dẫn Wine
wine-setup

Quản Lý WiFi
bash

wifi           # Xem danh sách WiFi
wifi gui       # Mở GUI quản lý
wifi tui       # Mở Terminal UI (nmtui)
wifi on/off    # Bật/tắt WiFi
wifi list      # Liệt kê mạng WiFi
wifi connect SSID [password]  # Kết nối WiFi

Quản Lý Log
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
Fonts
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

TLP (Quản lý pin)

Cấu hình tại /etc/tlp.conf:
ini

START_CHARGE_THRESH_BAT0=55
STOP_CHARGE_THRESH_BAT0=85

Security Updates

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

📦 Bảng Lệnh Nhanh
Lệnh	Mục đích
sudo check-status	Kiểm tra trạng thái hệ thống
unikey	Khởi động Unikey trong Wine
wine-run app.exe	Chạy ứng dụng Wine với tiếng Việt
wine-test-vietnamese	Kiểm tra cài đặt tiếng Việt
wine-setup	Hướng dẫn cấu hình Wine
wifi	Quản lý WiFi
dns-test	Kiểm tra DNS
cleanup-manager	Quản lý dọn dẹp log
fc-cache -fv	Refresh font cache
📄 Giấy Phép

Dự án được phân phối dưới giấy phép MIT. Xem file LICENSE để biết thêm chi tiết.
⚠️ Tuyên Bố Miễn Trách

Script này được cung cấp "như hiện tại", không có bất kỳ bảo đảm nào. Người dùng chịu trách nhiệm cho mọi thay đổi được thực hiện trên hệ thống của họ.
📞 Liên Hệ & Đóng Góp

    Tác Giả: Khoa Phan

    Issue Tracker: GitHub Issues

    Pull Requests: GitHub PRs

<div align="center"> <sub>Built with ❤️ for the Arch Linux community</sub> </div>

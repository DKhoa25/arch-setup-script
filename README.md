# 🐧 Arch Linux Setup Script

Script tự động cài đặt và tối ưu Arch Linux với đầy đủ ứng dụng cho người dùng Việt Nam.

## ✨ Tính năng

- ✅ Cài đặt **18+ ứng dụng** thiết yếu
- ✅ Tối ưu hệ thống tự động
- ✅ Quản lý pin với TLP (ngưỡng sạc 55%-85%)
- ✅ Dọn dẹp log tự động lúc 3h sáng
- ✅ Gỡ bỏ xfce4-panel (làm sạch giao diện)
- ✅ Cấu hình sẵn Plank, IBus-Unikey

---

## 📦 Ứng dụng được cài đặt

### 🌐 Internet & Mạng
| Ứng dụng | Mô tả |
|----------|-------|
| **Firefox** | Trình duyệt web (bản tiếng Việt) |
| **Tailscale** | VPN mesh an toàn |
| **OpenSSH** | Remote access |
| **yt-dlp + ffmpeg** | Tải video/audio từ YouTube |

### 🎨 Giao diện & Tiện ích
| Ứng dụng | Mô tả |
|----------|-------|
| **Plank** | Dock ứng dụng đẹp mắt |
| **IBus-Unikey** | Gõ tiếng Việt |
| **Forecast** | Dự báo thời tiết |
| **GNOME Calculator** | Máy tính |

### 🎬 Giải trí & Đa phương tiện
| Ứng dụng | Mô tả |
|----------|-------|
| **VLC Media Player** | Trình phát đa phương tiện (hỗ trợ DVD) ⭐ |
| **Wine + Plugins** | Chạy ứng dụng Windows (25+ plugins) |

### 📝 Văn phòng & Giao dịch
| Ứng dụng | Mô tả |
|----------|-------|
| **WPS Office** | Bộ văn phòng (Writer, Spreadsheets, Presentation) |
| **TradingView** | Nền tảng giao dịch tài chính |
| **MetaTrader 5** | Nền tảng giao dịch Forex (qua Wine) |
| **Zalo Chat** | Ứng dụng nhắn tin phổ biến tại Việt Nam |

### 🔧 Hệ thống & Driver
| Ứng dụng | Mô tả |
|----------|-------|
| **Driver Intel** | Mesa, Vulkan, xf86-video-intel |
| **TLP** | Quản lý pin và tiết kiệm năng lượng |
| **Bluetooth** | BlueZ + Blueman |
| **Logrotate** | Tự động dọn dẹp log |

---

## 🚀 Cài đặt nhanh

### Cách 1: Tải và chạy trực tiếp (Khuyến nghị)
```bash
curl -sL https://raw.githubusercontent.com/DKhoa25/arch-setup-script/main/arch-setup.sh | sudo bash

###  Cách 2: Tải về rồi chạy
wget https://raw.githubusercontent.com/DKhoa25/arch-setup-script/main/arch-setup.sh
chmod +x arch-setup.sh
sudo ./arch-setup.sh

###  Cách 3: Clone toàn bộ repo
git clone https://github.com/DKhoa25/arch-setup-script.git
cd arch-setup-script
sudo ./arch-setup.sh

📋 Hướng dẫn sau cài đặt
Kiểm tra trạng thái hệ thống
sudo check-status

Quản lý dọn dẹp log
cleanup-manager status   # Xem trạng thái
cleanup-manager run      # Chạy dọn dẹp ngay
cleanup-manager logs     # Xem log realtime
cleanup-manager next     # Xem lịch chạy tiếp theo

Cấu hình Tailscale
sudo tailscale up
sudo tailscale status    # Kiểm tra trạng thái

Xem thông tin pin
sudo tlp-stat -b

Hướng dẫn sử dụng Wine
wine-setup

Mở ứng dụng
firefox                 # Trình duyệt
vlc                     # VLC Media Player
wps                     # WPS Office Writer
et                      # WPS Spreadsheets
wpp                     # WPS Presentation
snap run zalo-chat-unofficial  # Zalo
tradingview             # TradingView
gnome-calculator        # Máy tính
forecast                # Dự báo thời tiết

⚠️ Lưu ý quan trọng
MetaTrader 5

    ⚠️ MT5 hiện có lỗi "debugger found" trên Wine 10.3+

    📌 Giải pháp: Downgrade Wine xuống 10.2
sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst
📌 Hoặc dùng script chính thức từ MetaQuotes:
wget https://download.terminal.free/cdn/web/metaquotes.software.corp/mt5/mt5linux.sh
chmod +x mt5linux.sh
./mt5linux.sh

Sau khi cài đặt

    🔄 Khởi động lại hệ thống để áp dụng đầy đủ

    👤 Đăng nhập lại để sử dụng IBus-Unikey

    🔐 Kiểm tra Tailscale: sudo tailscale status

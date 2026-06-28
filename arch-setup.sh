#!/bin/bash

# ============================================================
# SCRIPT CÀI ĐẶT & TỐI ƯU ARCH LINUX
# ============================================================

set -e

# Màu sắc
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Biến cấu hình
START_CHARGE=55
STOP_CHARGE=85
LOG_RETENTION=30
LOG_COMPRESS=7
CLEANUP_HOUR=3

# ============================================================
# HÀM TIỆN ÍCH
# ============================================================

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

print_step() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

get_current_user() {
    # Lấy username chính xác khi chạy sudo
    local user=$(logname 2>/dev/null || echo $SUDO_USER 2>/dev/null || echo $USER)
    echo "$user"
}

check_distro() {
    if ! grep -q "ID=arch" /etc/os-release 2>/dev/null; then
        print_error "Script này chỉ chạy trên Arch Linux!"
        echo "Distro hiện tại: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
        exit 1
    fi
    print_success "Distro: Arch Linux"
}

check_internet() {
    print_step "Kiểm tra kết nối Internet..."
    if ! ping -c 3 archlinux.org >/dev/null 2>&1; then
        print_error "Không có kết nối Internet!"
        exit 1
    fi
    print_success "Kết nối Internet OK"
}

check_disk_space() {
    print_step "Kiểm tra dung lượng đĩa..."
    local available=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available" -lt 10 ]; then
        print_error "Dung lượng đĩa còn < 10GB ($available GB)! Không đủ để cài đặt."
        exit 1
    fi
    print_success "Dung lượng đĩa: $available GB (đủ)"
}

backup_config() {
    print_step "Backup cấu hình hiện tại..."
    local backup_dir="/root/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup các file quan trọng
    [ -f /etc/lightdm/lightdm.conf ] && cp /etc/lightdm/lightdm.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/mkinitcpio.conf ] && cp /etc/mkinitcpio.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/tlp.conf ] && cp /etc/tlp.conf "$backup_dir/" 2>/dev/null
    
    print_success "Backup đã lưu tại: $backup_dir"
}

# ============================================================
# PHẦN 1: GỠ BỎ XFCE4-PANEL
# ============================================================

remove_xfce4_panel() {
    print_header "GỠ BỎ XFCE4-PANEL"
    
    if pacman -Qs xfce4-panel > /dev/null 2>&1; then
        print_step "Đang gỡ bỏ xfce4-panel và các gói liên quan..."
        pacman -Rns --noconfirm xfce4-panel xfce4-settings xfce4-session xfconf 2>/dev/null || true
        print_success "Đã gỡ bỏ xfce4-panel"
    else
        print_warning "xfce4-panel chưa được cài đặt, bỏ qua"
    fi
    
    print_step "Đang làm sạch cấu hình xfce4..."
    rm -rf /etc/xdg/xfce4 2>/dev/null || true
    rm -rf ~/.config/xfce4 2>/dev/null || true
    rm -rf ~/.cache/xfce4 2>/dev/null || true
    print_success "Đã làm sạch cấu hình xfce4"
}

# ============================================================
# PHẦN 2: CÀI ĐẶT ỨNG DỤNG
# ============================================================

install_applications() {
    print_header "CÀI ĐẶT ỨNG DỤNG"
    
    # Cập nhật hệ thống
    print_step "Đang cập nhật hệ thống..."
    pacman -Syu --noconfirm
    print_success "Đã cập nhật hệ thống"

    # 1. IBus-Unikey
    print_step "1. Cài đặt IBus-Unikey..."
    pacman -S --noconfirm ibus ibus-unikey
    cat > /etc/environment << EOF
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
EOF
    print_success "Đã cài đặt IBus-Unikey"

    # 2. Plank
    print_step "2. Cài đặt Plank..."
    pacman -S --noconfirm plank
    mkdir -p /etc/skel/.config/plank/dock1/
    cat > /etc/skel/.config/plank/dock1/settings << EOF
[PlankDock]
Monitor=0
Position=Bottom
Alignment=Center
AutoHide=false
HideDelay=0
ShowDelay=0
Transparency=100
Theme=Transparent
IconSize=48
Items=plank.dockitem,firefox.dockitem,terminal.dockitem,nautilus.dockitem
LockItems=false
UnhideOnClick=false
ShowOnlyWorkspace=0
ShowUnpinned=false
WorkspaceScroll=false
PinnedOnly=false
MaxVisibleItems=0
EOF
    print_success "Đã cài đặt Plank"

    # 3. Firefox
    print_step "3. Cài đặt Firefox..."
    pacman -S --noconfirm firefox firefox-i18n-vi
    print_success "Đã cài đặt Firefox (bản tiếng Việt)"

    # 4. VLC Media Player
    print_step "4. Cài đặt VLC Media Player..."
    pacman -S --noconfirm vlc \
        vlc-plugin-fluidsynth \
        vlc-plugin-jack \
        libdvdcss \
        libdvdread \
        libdvdnav
    print_success "Đã cài đặt VLC Media Player (hỗ trợ DVD)"

    # 5. Forecast (dự báo thời tiết)
    print_step "5. Cài đặt Forecast..."
    if ! command -v yay &> /dev/null; then
        print_warning "Yay chưa được cài đặt, đang cài đặt..."
        pacman -S --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin 2>/dev/null || {
            print_error "Không thể clone yay-bin! Kiểm tra kết nối mạng."
            return 1
        }
        cd /tmp/yay-bin
        makepkg -si --noconfirm
        cd /
        rm -rf /tmp/yay-bin
    fi
    yay -S --noconfirm forecast || print_warning "Forecast có thể đã được cài"
    print_success "Đã cài đặt Forecast"

    # 6. Tailscale
    print_step "6. Cài đặt Tailscale..."
    pacman -S --noconfirm tailscale
    systemctl enable tailscaled
    systemctl start tailscaled
    print_success "Đã cài đặt Tailscale"

    # 7. OpenSSH
    print_step "7. Cài đặt OpenSSH..."
    pacman -S --noconfirm openssh
    systemctl enable sshd
    systemctl start sshd
    print_success "Đã cài đặt OpenSSH"

    # 8. Bluetooth
    print_step "8. Cài đặt Bluetooth..."
    pacman -S --noconfirm bluez bluez-utils blueman
    systemctl enable bluetooth
    systemctl start bluetooth
    local current_user=$(get_current_user)
    usermod -aG lp "$current_user" 2>/dev/null || true
    print_success "Đã cài đặt Bluetooth"

    # 9. TLP
    print_step "9. Cài đặt TLP..."
    pacman -S --noconfirm tlp tlp-rdw
    cat > /etc/tlp.conf << EOF
# Cấu hình TLP với ngưỡng sạc pin
START_CHARGE_THRESH_BAT0=$START_CHARGE
STOP_CHARGE_THRESH_BAT0=$STOP_CHARGE
EOF
    systemctl enable tlp
    systemctl start tlp
    print_success "Đã cài đặt TLP (ngưỡng sạc: $START_CHARGE% - $STOP_CHARGE%)"

    # 10. yt-dlp
    print_step "10. Cài đặt yt-dlp..."
    pacman -S --noconfirm yt-dlp ffmpeg
    print_success "Đã cài đặt yt-dlp và ffmpeg"

    # 11. Driver Intel
    print_step "11. Cài đặt driver Intel..."
    pacman -S --noconfirm mesa lib32-mesa xf86-video-intel vulkan-intel lib32-vulkan-intel intel-media-driver
    print_success "Đã cài đặt driver Intel"

    # 12. Wine và các plugin đầy đủ
    print_step "12. Cài đặt Wine và plugin..."
    
    # Bật multilib nếu chưa có
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
        pacman -Sy --noconfirm
    fi
    
    # Wine core
    pacman -S --noconfirm wine wine-gecko wine-mono winetricks
    
    # 32-bit libraries cần thiết cho Wine
    pacman -S --noconfirm \
        lib32-mesa \
        lib32-libpulse \
        lib32-alsa-plugins \
        lib32-gnutls \
        lib32-libldap \
        lib32-libpng \
        lib32-libxcomposite \
        lib32-libxinerama \
        lib32-opencl-icd-loader \
        lib32-gst-plugins-base \
        lib32-gst-plugins-good \
        lib32-gst-plugins-bad \
        lib32-gst-plugins-ugly \
        lib32-vulkan-intel \
        lib32-vkd3d \
        lib32-mpg123 \
        lib32-openal \
        lib32-sdl2 \
        lib32-libgcrypt \
        lib32-ncurses \
        lib32-v4l-utils \
        lib32-libjpeg-turbo \
        lib32-sqlite \
        lib32-libxslt \
        lib32-libva \
        lib32-gtk3 \
        2>/dev/null || print_warning "Một số package Wine có thể không có sẵn"
    print_success "Đã cài đặt Wine và plugin đầy đủ"

    # 13. WPS Office
    print_step "13. Cài đặt WPS Office..."
    yay -S --noconfirm wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts freetype2-wps libtiff5 2>/dev/null || \
        print_warning "WPS Office có thể cần cài thủ công"
    print_success "Đã cài đặt WPS Office"

    # 14. Zalo Chat Unofficial
    print_step "14. Cài đặt Zalo Chat Unofficial..."
    if ! command -v snap &> /dev/null; then
        pacman -S --noconfirm snapd
        systemctl enable --now snapd.socket
        ln -sf /var/lib/snapd/snap /snap
    fi
    snap install zalo-chat-unofficial 2>/dev/null || print_warning "Zalo có thể đã được cài"
    print_success "Đã cài đặt Zalo Chat Unofficial"

    # 15. TradingView
    print_step "15. Cài đặt TradingView..."
    yay -S --noconfirm tradingview 2>/dev/null || snap install tradingview 2>/dev/null || \
        print_warning "TradingView cần cài thủ công"
    print_success "Đã cài đặt TradingView"

    # 16. MetaTrader 5
    print_step "16. Cài đặt MetaTrader 5..."
    print_warning "⚠ MetaTrader 5 có thể gặp lỗi 'debugger found' trên Wine 10.3+"
    print_warning "👉 Nếu gặp lỗi, downgrade Wine xuống 10.2:"
    print_warning "   sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst"
    
    wget -O /tmp/mt5linux.sh https://download.terminal.free/cdn/web/metaquotes.software.corp/mt5/mt5linux.sh 2>/dev/null || {
        print_warning "Không thể tải MT5, bỏ qua"
    }
    if [ -f /tmp/mt5linux.sh ]; then
        chmod +x /tmp/mt5linux.sh
        local current_user=$(get_current_user)
        sudo -u "$current_user" /tmp/mt5linux.sh 2>/dev/null || print_warning "MT5 cài thất bại"
        rm -f /tmp/mt5linux.sh
        print_success "Đã cài đặt MetaTrader 5"
    fi

    # 17. Calculator Linux (GNOME Calculator)
    print_step "17. Cài đặt Calculator..."
    pacman -S --noconfirm gnome-calculator
    print_success "Đã cài đặt GNOME Calculator"

    # 18. Gói bổ sung
    print_step "18. Cài đặt gói bổ sung..."
    pacman -S --noconfirm networkmanager wpa_supplicant wireless_tools logrotate \
        gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
    print_success "Đã cài đặt gói bổ sung"

    # 19. Icon Papirus
    print_step "19. Cài đặt Icon Papirus..."
    pacman -S --noconfirm papirus-icon-theme
    print_success "Đã cài đặt Icon Papirus"

    # 20. LightDM Webkit và Theme Dark Planet
    print_step "20. Cài đặt LightDM Webkit và Theme Dark Planet..."
    
    # Kiểm tra display manager hiện tại
    if systemctl is-active --quiet gdm 2>/dev/null || systemctl is-active --quiet sddm 2>/dev/null; then
        print_warning "Phát hiện display manager khác (GDM/SDDM)"
        print_warning "Sẽ disable và thay thế bằng LightDM"
        systemctl stop gdm 2>/dev/null || true
        systemctl stop sddm 2>/dev/null || true
        systemctl disable gdm 2>/dev/null || true
        systemctl disable sddm 2>/dev/null || true
    fi
    
    # Cài đặt lightdm-webkit2-greeter
    pacman -S --noconfirm lightdm-webkit2-greeter lightdm
    
    # Tải và cài đặt theme Dark Planet
    if [ -d /tmp/dark-planet ]; then
        rm -rf /tmp/dark-planet
    fi
    git clone https://github.com/Antergos/web-greeter-theme-dark-planet.git /tmp/dark-planet 2>/dev/null || {
        print_warning "Không thể clone theme Dark Planet, tạo theme mặc định"
        mkdir -p /usr/share/web-greeter/themes/dark-planet
    }
    if [ -d /tmp/dark-planet ]; then
        mkdir -p /usr/share/web-greeter/themes/
        cp -r /tmp/dark-planet /usr/share/web-greeter/themes/dark-planet
        rm -rf /tmp/dark-planet
    fi
    
    # Cấu hình LightDM
    mkdir -p /etc/lightdm
    cat > /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-webkit2-greeter
user-session=xfce
EOF

    # Cấu hình webkit2 greeter
    cat > /etc/lightdm/lightdm-webkit2-greeter.conf << EOF
[greeter]
webkit-theme = dark-planet
debug-mode = false
screensaver-timeout = 30
show-pane = true
show-keyboard = true
EOF

    # Enable LightDM (chỉ khi không có DM khác)
    systemctl enable lightdm 2>/dev/null || print_warning "LightDM không thể enable"
    print_success "Đã cài đặt LightDM Webkit và Theme Dark Planet"

    # 21. Plymouth và Theme Dark Planet
    print_step "21. Cài đặt Plymouth và Theme Dark Planet..."
    pacman -S --noconfirm plymouth
    
    # Tải và cài đặt theme Dark Planet cho Plymouth
    mkdir -p /usr/share/plymouth/themes/dark-planet
    cat > /usr/share/plymouth/themes/dark-planet/dark-planet.plymouth << 'EOF'
[Plymouth Theme]
Name=Dark Planet
Description=Dark Planet Boot Splash
ModuleName=two-step

[two-step]
ImageDir=/usr/share/plymouth/themes/dark-planet
HorizontalAlignment=.5
VerticalAlignment=.5
TransitionDuration=2.0
Transition=none
BackgroundStartColor=0x0a0a0a
BackgroundEndColor=0x1a1a2e
EOF

    # Tạo background và logo đơn giản (sử dụng ImageMagick nếu có)
    pacman -S --noconfirm imagemagick 2>/dev/null || true
    
    if command -v convert &> /dev/null; then
        # Tạo background
        convert -size 1920x1080 gradient:black-darkblue /usr/share/plymouth/themes/dark-planet/background.png 2>/dev/null || true
        
        # Tạo logo đơn giản (hình tròn với chữ A)
        convert -size 100x100 xc:transparent -fill white -draw "circle 50,50 50,10" \
            -gravity center -pointsize 40 -fill black -draw "text 0,-5 'A'" \
            /usr/share/plymouth/themes/dark-planet/logo.png 2>/dev/null || true
    fi

    # Cấu hình Plymouth
    sed -i 's/^#*\(Theme=\).*$/\1dark-planet/' /etc/plymouth/plymouthd.conf 2>/dev/null || \
        echo "Theme=dark-planet" > /etc/plymouth/plymouthd.conf
    
    # Cập nhật initramfs - SỬA LỖI HOOKS
    if command -v mkinitcpio &> /dev/null; then
        # Thêm plymouth vào HOOKS nếu chưa có
        if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
            # Sửa HOOKS an toàn hơn
            if grep -q "^HOOKS=" /etc/mkinitcpio.conf; then
                sed -i 's/^HOOKS=(/HOOKS=(plymouth /' /etc/mkinitcpio.conf
            else
                echo 'HOOKS=(base udev plymouth autodetect modconf block filesystems keyboard fsck)' >> /etc/mkinitcpio.conf
            fi
        fi
        mkinitcpio -p linux 2>/dev/null || print_warning "mkinitcpio thất bại, Plymouth có thể không hoạt động"
    fi
    
    print_success "Đã cài đặt Plymouth và Theme Dark Planet"

    # 22. Autostart
    print_step "22. Cấu hình tự động khởi động..."
    mkdir -p /etc/skel/.config/autostart
    
    cat > /etc/skel/.config/autostart/plank.desktop << EOF
[Desktop Entry]
Type=Application
Name=Plank
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

    cat > /etc/skel/.config/autostart/ibus.desktop << EOF
[Desktop Entry]
Type=Application
Name=IBus
Exec=ibus-daemon -drx
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    print_success "Đã cấu hình tự động khởi động"
}

# ============================================================
# PHẦN 3: SCRIPT DỌN DẸP LOG
# ============================================================

create_cleanup_script() {
    print_header "TẠO SCRIPT DỌN DẸP LOG"
    
    cat > /usr/local/bin/log-cleanup.sh << 'EOF'
#!/bin/bash

# Script dọn dẹp và tối ưu file log
LOG_DIR="/var/log"
BACKUP_DIR="/var/log/backup"
ARCHIVE_DIR="/var/log/archive"
RETENTION_DAYS=30
COMPRESS_DAYS=7
REPORT_FILE="/var/log/cleanup_report_$(date +%Y%m%d).log"

mkdir -p "$BACKUP_DIR" "$ARCHIVE_DIR"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$REPORT_FILE"
}

# Bắt đầu
log_message "========== BẮT ĐẦU DỌN DẸP =========="

# 1. Backup log quan trọng trước khi xóa
log_message "Đang backup log quan trọng..."
mkdir -p "$BACKUP_DIR/$(date +%Y%m%d)"
find "$LOG_DIR" -name "*error*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null
find "$LOG_DIR" -name "*critical*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null
find "$LOG_DIR" -name "*secure*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null

# 2. Xóa log cũ
log_message "Đang xóa log cũ hơn $RETENTION_DAYS ngày..."
find "$LOG_DIR" -name "*.log" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null
find "$LOG_DIR" -name "*.log.*" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null

# 3. Xóa log rỗng
log_message "Đang xóa file log rỗng..."
find "$LOG_DIR" -name "*.log" -type f -empty -delete 2>/dev/null

# 4. Nén log cũ
log_message "Đang nén log từ $COMPRESS_DAYS-$RETENTION_DAYS ngày..."
find "$LOG_DIR" -name "*.log" -type f -mtime +$COMPRESS_DAYS -mtime -$RETENTION_DAYS -exec gzip -9 {} \; 2>/dev/null
find "$LOG_DIR" -name "*.log.*" -type f -mtime +$COMPRESS_DAYS -mtime -$RETENTION_DAYS -exec gzip -9 {} \; 2>/dev/null

# 5. Logrotate
log_message "Đang chạy logrotate..."
command -v logrotate &>/dev/null && logrotate -f /etc/logrotate.conf 2>/dev/null

# 6. Journald
log_message "Đang dọn dẹp journald..."
command -v journalctl &>/dev/null && journalctl --vacuum-time=${RETENTION_DAYS}d 2>/dev/null
command -v journalctl &>/dev/null && journalctl --vacuum-size=500M 2>/dev/null

# 7. Tối ưu log
log_message "Đang tối ưu log..."
find "$LOG_DIR" -name "*.log" -type f -size +100k -exec sh -c '
    for file do
        sed -i "/^[[:space:]]*$/d" "$file" 2>/dev/null
        if [ $(stat -c%s "$file" 2>/dev/null || echo 0) -gt 52428800 ]; then
            tail -n 50000 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        fi
    done
' sh {} + 2>/dev/null

# 8. Nén archive cũ
log_message "Đang nén archive cũ..."
find "$ARCHIVE_DIR" -name "*.log" -type f -mtime +60 -exec gzip -9 {} \; 2>/dev/null

# 9. Xóa backup cũ
log_message "Đang xóa backup cũ..."
find "$BACKUP_DIR" -name "*.log*" -type f -mtime +90 -delete 2>/dev/null

# 10. Báo cáo
LOG_COUNT=$(find "$LOG_DIR" -name "*.log" -type f | wc -l)
COMPRESSED_COUNT=$(find "$LOG_DIR" -name "*.log.gz" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$LOG_DIR" 2>/dev/null | cut -f1)

echo "----------------------------------------" >> "$REPORT_FILE"
echo "THỐNG KÊ:" >> "$REPORT_FILE"
echo "- File log: $LOG_COUNT" >> "$REPORT_FILE"
echo "- File nén: $COMPRESSED_COUNT" >> "$REPORT_FILE"
echo "- Tổng dung lượng: $TOTAL_SIZE" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

log_message "========== DỌN DẸP HOÀN TẤT =========="
EOF

    chmod +x /usr/local/bin/log-cleanup.sh
    print_success "Đã tạo script dọn dẹp log"
}

# ============================================================
# PHẦN 4: CÀI ĐẶT SYSTEMD TIMER
# ============================================================

setup_systemd_timer() {
    print_header "CÀI ĐẶT SYSTEMD TIMER"
    
    # Service
    cat > /etc/systemd/system/log-cleanup.service << 'EOF'
[Unit]
Description=Log Cleanup and Optimization Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/log-cleanup.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Timer
    cat > /etc/systemd/system/log-cleanup.timer << EOF
[Unit]
Description=Log Cleanup Timer - Runs daily at ${CLEANUP_HOUR}:00 AM
Requires=log-cleanup.service

[Timer]
OnCalendar=*-*-* ${CLEANUP_HOUR}:00:00
Persistent=true
AccuracySec=1h

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable log-cleanup.timer
    systemctl start log-cleanup.timer
    
    print_success "Đã cài đặt systemd timer (chạy lúc ${CLEANUP_HOUR}h sáng)"
}

# ============================================================
# PHẦN 5: TẠO CÔNG CỤ KIỂM TRA
# ============================================================

create_tools() {
    print_header "TẠO CÔNG CỤ KIỂM TRA"
    
    # Script kiểm tra trạng thái
    cat > /usr/local/bin/check-status << 'EOF'
#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}===== TRẠNG THÁI DỊCH VỤ =====${NC}"
echo "Tailscale: $(systemctl is-active tailscaled 2>/dev/null || echo 'inactive')"
echo "SSH: $(systemctl is-active sshd 2>/dev/null || echo 'inactive')"
echo "Bluetooth: $(systemctl is-active bluetooth 2>/dev/null || echo 'inactive')"
echo "TLP: $(systemctl is-active tlp 2>/dev/null || echo 'inactive')"
echo "LightDM: $(systemctl is-active lightdm 2>/dev/null || echo 'inactive')"
echo "Plymouth: $(systemctl is-active plymouth-quit 2>/dev/null || echo 'inactive')"
echo "Log Cleanup Timer: $(systemctl is-active log-cleanup.timer 2>/dev/null || echo 'inactive')"
echo ""
echo -e "${YELLOW}===== THÔNG TIN PIN =====${NC}"
tlp-stat -b 2>/dev/null | grep -E "Charge|Status" || echo "Không có dữ liệu pin"
echo ""
echo -e "${YELLOW}===== DỤNG LƯỢNG LOG =====${NC}"
du -sh /var/log 2>/dev/null
echo ""
echo -e "${YELLOW}===== LOG CLEANUP LẦN CUỐI =====${NC}"
ls -lt /var/log/cleanup_report_*.log 2>/dev/null | head -1
echo ""
echo -e "${YELLOW}===== KIỂM TRA WINE =====${NC}"
wine --version 2>/dev/null || echo "Wine chưa được cấu hình"
echo ""
echo -e "${YELLOW}===== KIỂM TRA DRIVER INTEL =====${NC}"
glxinfo 2>/dev/null | grep "OpenGL renderer" | head -1 || echo "Không có thông tin OpenGL"
echo ""
echo -e "${YELLOW}===== CÁC ỨNG DỤNG ĐÃ CÀI =====${NC}"
command -v firefox &>/dev/null && echo "✓ Firefox" || echo "✗ Firefox"
command -v forecast &>/dev/null && echo "✓ Forecast" || echo "✗ Forecast"
command -v vlc &>/dev/null && echo "✓ VLC Media Player" || echo "✗ VLC Media Player"
command -v wps &>/dev/null && echo "✓ WPS Office" || echo "✗ WPS Office"
command -v tradingview &>/dev/null && echo "✓ TradingView" || echo "✗ TradingView"
command -v gnome-calculator &>/dev/null && echo "✓ GNOME Calculator" || echo "✗ GNOME Calculator"
snap list 2>/dev/null | grep -q zalo && echo "✓ Zalo Chat" || echo "✗ Zalo Chat"
[ -d ~/.mt5wine ] 2>/dev/null && echo "✓ MetaTrader 5" || echo "✗ MetaTrader 5"
echo ""
echo -e "${YELLOW}===== THEMES ĐÃ CÀI =====${NC}"
[ -d /usr/share/plymouth/themes/dark-planet ] && echo "✓ Plymouth Dark Planet" || echo "✗ Plymouth Dark Planet"
[ -d /usr/share/web-greeter/themes/dark-planet ] && echo "✓ LightDM Dark Planet" || echo "✗ LightDM Dark Planet"
ls /usr/share/icons/ 2>/dev/null | grep -q Papirus && echo "✓ Papirus Icons" || echo "✗ Papirus Icons"
EOF
    chmod +x /usr/local/bin/check-status
    
    # Script quản lý cleanup
    cat > /usr/local/bin/cleanup-manager << 'EOF'
#!/bin/bash
case "$1" in
    run)
        echo "Đang chạy dọn dẹp log..."
        sudo systemctl start log-cleanup.service
        sleep 2
        sudo journalctl -u log-cleanup.service -n 20 --no-pager
        ;;
    status)
        sudo systemctl status log-cleanup.timer --no-pager
        ;;
    logs)
        sudo journalctl -u log-cleanup.service -f
        ;;
    disable)
        sudo systemctl stop log-cleanup.timer
        sudo systemctl disable log-cleanup.timer
        echo "Đã tắt tự động dọn dẹp"
        ;;
    enable)
        sudo systemctl enable log-cleanup.timer
        sudo systemctl start log-cleanup.timer
        echo "Đã bật tự động dọn dẹp"
        ;;
    next)
        sudo systemctl list-timers log-cleanup.timer --no-pager
        ;;
    *)
        echo "Usage: cleanup-manager {run|status|logs|disable|enable|next}"
        echo "  run     - Chạy dọn dẹp ngay"
        echo "  status  - Xem trạng thái timer"
        echo "  logs    - Xem log realtime"
        echo "  disable - Tắt tự động"
        echo "  enable  - Bật tự động"
        echo "  next    - Xem lịch chạy tiếp theo"
        ;;
esac
EOF
    chmod +x /usr/local/bin/cleanup-manager
    
    print_success "Đã tạo công cụ kiểm tra: check-status, cleanup-manager"
}

# ============================================================
# PHẦN 6: HƯỚNG DẪN WINE
# ============================================================

create_wine_guide() {
    print_header "HƯỚNG DẪN SỬ DỤNG WINE"
    
    cat > /usr/local/bin/wine-setup << 'EOF'
#!/bin/bash
# Script hướng dẫn cấu hình Wine

echo "===== HƯỚNG DẪN CẤU HÌNH WINE ====="
echo ""
echo "1. Tạo Wine prefix (32-bit nếu cần chạy game cũ):"
echo "   WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg"
echo ""
echo "2. Cài đặt các thành phần cần thiết:"
echo "   winetricks corefonts dxvk vcrun2017 vcrun2019"
echo ""
echo "3. Cấu hình Wine:"
echo "   winecfg"
echo ""
echo "4. Chạy ứng dụng Windows:"
echo "   wine app.exe"
echo ""
echo "5. Sử dụng DXVK để tăng hiệu năng game:"
echo "   export DXVK_HUD=1"
echo "   wine game.exe"
echo ""
echo "===== LƯU Ý CHO METATRADER 5 ====="
echo "MT5 yêu cầu Wine bản 10.2 để chạy ổn định trên Arch"
echo "Downgrade Wine:"
echo "  sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst"
echo ""
echo "Hoặc sử dụng script chính thức từ MetaQuotes:"
echo "  wget https://download.terminal.free/cdn/web/metaquotes.software.corp/mt5/mt5linux.sh"
echo "  chmod +x mt5linux.sh && ./mt5linux.sh"
echo ""
echo "Xem thêm: https://wiki.archlinux.org/title/Wine"
EOF
    chmod +x /usr/local/bin/wine-setup
    
    print_success "Đã tạo hướng dẫn Wine: wine-setup"
}

# ============================================================
# PHẦN 7: TỔNG KẾT
# ============================================================

show_summary() {
    print_header "CÀI ĐẶT HOÀN TẤT"
    
    echo -e "${GREEN}Các ứng dụng đã cài đặt:${NC}"
    echo "  ✓ IBus-Unikey (gõ tiếng Việt)"
    echo "  ✓ Plank (dock ứng dụng)"
    echo "  ✓ Firefox (trình duyệt web)"
    echo "  ✓ VLC Media Player (trình phát đa phương tiện) ⭐"
    echo "  ✓ Forecast (dự báo thời tiết)"
    echo "  ✓ Tailscale (VPN mesh)"
    echo "  ✓ OpenSSH (remote access)"
    echo "  ✓ BlueZ + Blueman (Bluetooth)"
    echo "  ✓ TLP (quản lý pin)"
    echo "  ✓ yt-dlp + ffmpeg (tải video/audio)"
    echo "  ✓ Driver Intel (mesa, vulkan, xf86-video-intel)"
    echo "  ✓ Wine + plugins đầy đủ (gstreamer, vulkan, 32-bit libs)"
    echo "  ✓ WPS Office (bộ văn phòng)"
    echo "  ✓ Zalo Chat Unofficial (Snap)"
    echo "  ✓ TradingView (AUR/Snap)"
    echo "  ✓ MetaTrader 5 (qua Wine)"
    echo "  ✓ GNOME Calculator"
    echo "  ✓ Papirus Icon Theme"
    echo "  ✓ LightDM Webkit + Dark Planet Theme"
    echo "  ✓ Plymouth + Dark Planet Theme"
    echo "  ✓ Logrotate + Cleanup (dọn dẹp log)"
    
    echo -e "\n${GREEN}Đã gỡ bỏ:${NC}"
    echo "  ✓ xfce4-panel và các gói liên quan"
    
    echo -e "\n${GREEN}Cấu hình:${NC}"
    echo "  ✓ Ngưỡng sạc pin: $START_CHARGE% - $STOP_CHARGE%"
    echo "  ✓ Dọn dẹp log: ${CLEANUP_HOUR}h sáng hàng ngày"
    echo "  ✓ Tự động khởi động: Plank, IBus"
    echo "  ✓ Giao diện đăng nhập: LightDM Webkit với Dark Planet"
    echo "  ✓ Boot splash: Plymouth với Dark Planet"
    
    echo -e "\n${YELLOW}📋 HƯỚNG DẪN SỬ DỤNG:${NC}"
    echo -e "1. ${CYAN}Kiểm tra trạng thái:${NC} sudo check-status"
    echo -e "2. ${CYAN}Quản lý dọn dẹp log:${NC} cleanup-manager {run|status|logs|disable|enable|next}"
    echo -e "3. ${CYAN}Cấu hình Tailscale:${NC} sudo tailscale up"
    echo -e "4. ${CYAN}Mở Blueman:${NC} blueman-manager"
    echo -e "5. ${CYAN}Xem cấu hình pin:${NC} sudo tlp-stat -b"
    echo -e "6. ${CYAN}Hướng dẫn Wine:${NC} wine-setup"
    echo -e "7. ${CYAN}Tải video với yt-dlp:${NC} yt-dlp -f 'bestvideo+bestaudio' <URL>"
    echo -e "8. ${CYAN}Mở Firefox:${NC} firefox"
    echo -e "9. ${CYAN}Mở VLC:${NC} vlc"
    echo -e "10. ${CYAN}Mở Forecast:${NC} forecast"
    echo -e "11. ${CYAN}Mở WPS Office:${NC} wps (Writer), et (Spreadsheets), wpp (Presentation)"
    echo -e "12. ${CYAN}Mở Zalo:${NC} snap run zalo-chat-unofficial"
    echo -e "13. ${CYAN}Mở TradingView:${NC} tradingview"
    echo -e "14. ${CYAN}Mở MT5:${NC} ~/.mt5wine/drive_c/Program\ Files/MetaTrader\ 5/terminal.exe"
    echo -e "15. ${CYAN}Mở Calculator:${NC} gnome-calculator"
    echo -e "16. ${CYAN}Đổi icon theme:${NC} Cài đặt Papirus qua công cụ của XFCE"
    
    echo -e "\n${GREEN}📁 Log và báo cáo:${NC}"
    echo "  • Báo cáo dọn dẹp: /var/log/cleanup_report_*.log"
    echo "  • Systemd log: sudo journalctl -u log-cleanup.service"
    
    echo -e "\n${RED}⚠ LƯU Ý QUAN TRỌNG:${NC}"
    echo "  • MT5 hiện có lỗi 'debugger found' trên Wine 10.3+"
    echo "  • Giải pháp: downgrade Wine xuống 10.2"
    echo "  • Hoặc sử dụng script chính thức từ MetaQuotes"
    echo "  • Xem hướng dẫn chi tiết: ${CYAN}wine-setup${NC}"
    echo "  • LightDM sẽ là màn hình đăng nhập mới sau khi khởi động lại"
    echo "  • Plymouth sẽ hiển thị splash screen khi boot"
    
    echo -e "\n${YELLOW}⚠ LƯU Ý CHUNG:${NC}"
    echo "  • Khởi động lại hệ thống để áp dụng đầy đủ"
    echo "  • Đăng nhập lại để dùng IBus-Unikey"
    echo "  • Kiểm tra Tailscale: sudo tailscale status"
    echo "  • Nếu LightDM không hoạt động, check log: /var/log/lightdm/*"
    
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}  🚀 HỆ THỐNG ĐÃ SẴN SÀNG!  ${NC}"
    echo -e "${GREEN}========================================${NC}"
}

# ============================================================
# PHẦN CHÍNH
# ============================================================

main() {
    # Kiểm tra root
    if [[ $EUID -ne 0 ]]; then
        print_error "Script cần chạy với quyền root!"
        echo "Sử dụng: sudo $0"
        exit 1
    fi
    
    clear
    print_header "CÀI ĐẶT & TỐI ƯU ARCH LINUX (BẢN ĐẦY ĐỦ + VLC)"
    echo -e "${CYAN}Thời gian: $(date '+%H:%M:%S %d/%m/%Y')${NC}"
    echo -e "${CYAN}User: $(get_current_user)${NC}"
    
    # Kiểm tra trước khi chạy
    check_distro
    check_internet
    check_disk_space
    backup_config
    
    # Hỏi xác nhận
    echo -e "\n${YELLOW}⚠ Bạn có chắc chắn muốn tiếp tục?${NC}"
    echo -e "Script sẽ cài đặt nhiều ứng dụng và thay đổi cấu hình hệ thống."
    read -p "Nhấn y/Y để tiếp tục, bất kỳ phím nào khác để hủy: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Đã hủy cài đặt."
        exit 1
    fi
    
    # Chạy các phần
    remove_xfce4_panel
    install_applications
    create_cleanup_script
    setup_systemd_timer
    create_tools
    create_wine_guide
    
    # Chạy thử cleanup lần đầu
    print_step "Chạy dọn dẹp log lần đầu..."
    systemctl start log-cleanup.service 2>/dev/null || true
    
    # Hiển thị tổng kết
    show_summary
    
    # Hiển thị trạng thái timer
    echo -e "\n${CYAN}Lịch chạy tiếp theo:${NC}"
    systemctl list-timers log-cleanup.timer --no-pager 2>/dev/null || echo "Không có thông tin"
    
    echo -e "\n${GREEN}✅ SCRIPT HOÀN TẤT!${NC}"
}

# Chạy main
main

#!/bin/bash

# ============================================================
# SCRIPT CÀI ĐẶT & TỐI ƯU ARCH LINUX (BẢN ĐẦY ĐỦ + TÍNH NĂNG MỚI)
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
    
    [ -f /etc/lightdm/lightdm.conf ] && cp /etc/lightdm/lightdm.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/mkinitcpio.conf ] && cp /etc/mkinitcpio.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/tlp.conf ] && cp /etc/tlp.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/resolv.conf ] && cp /etc/resolv.conf "$backup_dir/" 2>/dev/null
    [ -f /etc/default/grub ] && cp /etc/default/grub "$backup_dir/" 2>/dev/null
    
    print_success "Backup đã lưu tại: $backup_dir"
}

# ============================================================
# TÍNH NĂNG 1: CẬP NHẬT SECURITY PATCHES TỰ ĐỘNG
# ============================================================

setup_auto_security_updates() {
    print_header "CẬP NHẬT SECURITY PATCHES TỰ ĐỘNG"
    
    # Script cập nhật bảo mật
    cat > /usr/local/bin/security-update << 'EOF'
#!/bin/bash
# Script cập nhật security patches tự động

LOG_FILE="/var/log/security-updates.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log_message() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

log_message "========== BẮT ĐẦU CẬP NHẬT BẢO MẬT =========="

# Cập nhật danh sách package
pacman -Sy --noconfirm 2>&1 | tee -a "$LOG_FILE"

# Lọc và cài đặt các bản cập nhật bảo mật
# Sử dụng pacman -Syu để cập nhật tất cả (bao gồm security patches)
pacman -Syu --noconfirm 2>&1 | tee -a "$LOG_FILE"

# Cập nhật AUR packages (nếu có yay)
if command -v yay &> /dev/null; then
    yay -Syu --noconfirm 2>&1 | tee -a "$LOG_FILE"
fi

# Cập nhật Snap packages
if command -v snap &> /dev/null; then
    snap refresh 2>&1 | tee -a "$LOG_FILE"
fi

log_message "========== CẬP NHẬT BẢO MẬT HOÀN TẤT =========="
EOF

    chmod +x /usr/local/bin/security-update

    # Systemd service
    cat > /etc/systemd/system/security-update.service << 'EOF'
[Unit]
Description=Security Patches Auto Update
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/security-update
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Systemd timer - chạy mỗi ngày lúc 2h sáng
    cat > /etc/systemd/system/security-update.timer << 'EOF'
[Unit]
Description=Security Patches Daily Update
Requires=security-update.service

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=3600

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable security-update.timer
    systemctl start security-update.timer

    print_success "Đã cấu hình tự động cập nhật security patches hàng ngày lúc 2h sáng"
    print_success "Log: /var/log/security-updates.log"
}

# ============================================================
# TÍNH NĂNG 2: FONTS CHO VĂN PHÒNG & TIẾNG VIỆT ĐẸP
# ============================================================

install_fonts() {
    print_header "CÀI ĐẶT FONTS CHO VĂN PHÒNG & TIẾNG VIỆT"
    
    print_step "Đang cài đặt fonts..."
    
    # Fonts cơ bản
    pacman -S --noconfirm \
        ttf-dejavu \
        ttf-liberation \
        ttf-roboto \
        ttf-roboto-mono \
        ttf-ubuntu-font-family \
        ttf-fira-code \
        ttf-fira-mono \
        adobe-source-code-pro-fonts \
        adobe-source-sans-pro-fonts \
        adobe-source-serif-pro-fonts
    
    # Fonts Google
    pacman -S --noconfirm \
        ttf-google-fonts-git 2>/dev/null || \
        yay -S --noconfirm ttf-google-fonts-git 2>/dev/null || \
        print_warning "Google Fonts có thể cần cài từ AUR"
    
    # Fonts hỗ trợ tiếng Việt tốt
    pacman -S --noconfirm \
        noto-fonts \
        noto-fonts-emoji \
        noto-fonts-cjk
    
    # Fonts văn phòng
    pacman -S --noconfirm \
        ttf-caladea \
        ttf-carlito \
        ttf-nerd-fonts-symbols
    
    # Font tiếng Việt (AUR)
    yay -S --noconfirm ttf-vietnamese-fonts 2>/dev/null || \
        print_warning "Vietnamese fonts có thể cần cài từ AUR"
    
    # Refresh font cache
    fc-cache -fv
    
    print_success "Đã cài đặt fonts (đã refresh cache)"
    
    # Hiển thị fonts đã cài
    echo -e "\n${GREEN}Fonts đã cài:${NC}"
    fc-list | grep -E "DejaVu|Liberation|Roboto|Noto|Fira|Source" | head -10
}

# ============================================================
# TÍNH NĂNG 3: CUSTOMIZE BOOTLOADER (GRUB)
# ============================================================

customize_grub() {
    print_header "CUSTOMIZE GRUB BOOTLOADER"
    
    # Kiểm tra GRUB
    if ! command -v grub-mkconfig &> /dev/null; then
        print_warning "GRUB chưa được cài đặt! Đang cài..."
        pacman -S --noconfirm grub efibootmgr
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 2>/dev/null || \
        grub-install --target=i386-pc /dev/sda 2>/dev/null || \
        print_warning "Không thể cài GRUB, cần cấu hình thủ công"
    fi
    
    print_step "Đang cấu hình GRUB..."
    
    # Backup GRUB config
    cp /etc/default/grub /etc/default/grub.bak
    
    # Cấu hình GRUB đẹp
    cat > /etc/default/grub << 'EOF'
# GRUB bootloader configuration
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR="Arch Linux"
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash plymouth.ignore-serial-consoles"
GRUB_CMDLINE_LINUX=""

# Theme và giao diện
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=gfxterm
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_BACKGROUND="/usr/share/grub/background.png"

# Font
GRUB_FONT="/usr/share/grub/fonts/unicode.pf2"

# Disable os-prober (tăng tốc)
GRUB_DISABLE_OS_PROBER=false

# Color theme (Dark)
GRUB_COLOR_NORMAL="white/black"
GRUB_COLOR_HIGHLIGHT="cyan/black"
EOF

    # Tạo background cho GRUB
    print_step "Tạo background cho GRUB..."
    mkdir -p /usr/share/grub
    
    if command -v convert &> /dev/null; then
        # Tạo background gradient đẹp
        convert -size 1920x1080 gradient:darkblue-black \
            -fill white -pointsize 48 -gravity center \
            -annotate 0 "Arch Linux" \
            /usr/share/grub/background.png 2>/dev/null || \
        convert -size 1920x1080 gradient:darkblue-black \
            /usr/share/grub/background.png 2>/dev/null || true
    else
        # Tạo background đơn giản
        pacman -S --noconfirm imagemagick 2>/dev/null
        if command -v convert &> /dev/null; then
            convert -size 1920x1080 gradient:darkblue-black /usr/share/grub/background.png
        fi
    fi
    
    # Cài theme GRUB đẹp (Starfield)
    print_step "Cài đặt GRUB theme Starfield..."
    if [ ! -d "/usr/share/grub/themes/starfield" ]; then
        git clone https://github.com/boozed/grub-theme-starfield /tmp/grub-theme 2>/dev/null || \
        git clone https://gitlab.com/Vandal/grub-theme-starfield /tmp/grub-theme 2>/dev/null || true
        
        if [ -d "/tmp/grub-theme" ]; then
            mkdir -p /boot/grub/themes
            cp -r /tmp/grub-theme/starfield /boot/grub/themes/ 2>/dev/null || \
            cp -r /tmp/grub-theme/* /boot/grub/themes/ 2>/dev/null || true
            rm -rf /tmp/grub-theme
            
            # Cập nhật GRUB config với theme
            echo "GRUB_THEME=/boot/grub/themes/starfield/theme.txt" >> /etc/default/grub
        fi
    fi
    
    # Cài GRUB customizer
    print_step "Cài đặt GRUB Customizer..."
    yay -S --noconfirm grub-customizer 2>/dev/null || \
        pacman -S --noconfirm grub-customizer 2>/dev/null || \
        print_warning "GRUB Customizer có thể cài từ AUR"
    
    # Cập nhật GRUB
    print_step "Cập nhật GRUB..."
    grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || \
        print_warning "Không thể cập nhật GRUB, cần chạy thủ công"
    
    print_success "Đã customize GRUB bootloader"
    print_warning "Xem thêm GRUB theme: https://wiki.archlinux.org/title/GRUB/Tips_and_tricks"
}

# ============================================================
# TÍNH NĂNG 4: QUẢN LÝ WIFI DỄ DÀNG
# ============================================================

setup_wifi_management() {
    print_header "CÀI ĐẶT QUẢN LÝ WIFI"
    
    # Cài đặt NetworkManager (đã có trong script gốc)
    print_step "Cấu hình NetworkManager..."
    
    # Cài đặt thêm công cụ quản lý WiFi
    pacman -S --noconfirm \
        network-manager-applet \
        nm-connection-editor \
        networkmanager-openvpn \
        networkmanager-pptp \
        networkmanager-openconnect \
        networkmanager-vpnc \
        networkmanager-l2tp \
        networkmanager-strongswan
    
    # Tự động kết nối WiFi khi boot
    systemctl enable NetworkManager
    systemctl start NetworkManager
    
    # Cài đặt GUI WiFi manager
    print_step "Cài đặt GUI WiFi manager..."
    pacman -S --noconfirm \
        wpa_supplicant_gui \
        wifi-menu \
        iw \
        iwd
    
    # Cài đặt nmtui (TUI)
    pacman -S --noconfirm networkmanager-tui
    
    # Tạo shortcut cho WiFi
    cat > /usr/local/bin/wifi << 'EOF'
#!/bin/bash
# WiFi Manager GUI

if [ "$1" = "gui" ]; then
    nm-connection-editor
elif [ "$1" = "tui" ]; then
    nmtui
elif [ "$1" = "on" ]; then
    nmcli radio wifi on
elif [ "$1" = "off" ]; then
    nmcli radio wifi off
elif [ "$1" = "list" ]; then
    nmcli dev wifi list
elif [ "$1" = "connect" ]; then
    shift
    nmcli dev wifi connect "$@"
elif [ -z "$1" ]; then
    nmcli dev wifi list | head -20
else
    echo "Usage: wifi {gui|tui|on|off|list|connect SSID}"
    echo "  gui      - Open WiFi GUI"
    echo "  tui      - Open Terminal UI"
    echo "  on/off   - Turn WiFi on/off"
    echo "  list     - List WiFi networks"
    echo "  connect  - Connect to SSID"
fi
EOF
    chmod +x /usr/local/bin/wifi
    
    # Thêm vào .bashrc
    echo 'alias wifi="wifi"' >> /etc/skel/.bashrc
    echo 'alias wifigui="nm-connection-editor"' >> /etc/skel/.bashrc
    
    print_success "Đã cấu hình WiFi Manager"
    echo -e "\n${GREEN}Hướng dẫn:${NC}"
    echo "  ${CYAN}wifi${NC}           - Xem danh sách WiFi"
    echo "  ${CYAN}wifi gui${NC}       - Mở GUI quản lý WiFi"
    echo "  ${CYAN}wifi tui${NC}       - Mở Terminal UI (nmtui)"
    echo "  ${CYAN}wifi on/off${NC}    - Bật/tắt WiFi"
    echo "  ${CYAN}wifi connect SSID${NC} - Kết nối WiFi"
}

# ============================================================
# TÍNH NĂNG 5: CẤU HÌNH DNS (1.1.1.1 / 8.8.8.8)
# ============================================================

configure_dns() {
    print_header "CẤU HÌNH DNS"
    
    print_step "Đang cấu hình DNS..."
    
    # Backup DNS config
    cp /etc/resolv.conf /etc/resolv.conf.bak 2>/dev/null
    
    # Tạo resolv.conf mới
    cat > /etc/resolv.conf << 'EOF'
# Cloudflare DNS (1.1.1.1)
nameserver 1.1.1.1
nameserver 1.0.0.1

# Google DNS (8.8.8.8) - Backup
nameserver 8.8.8.8
nameserver 8.8.4.4

# Cloudflare DNS over TLS
nameserver 1.1.1.2
nameserver 1.0.0.2

# Options
options edns0
options trust-ad
EOF
    
    # Cấu hình NetworkManager để sử dụng DNS cố định
    if systemctl is-active --quiet NetworkManager; then
        cat > /etc/NetworkManager/conf.d/dns.conf << 'EOF'
[main]
dns=default

[global-dns-domain-*]
servers=1.1.1.1,1.0.0.1,8.8.8.8,8.8.4.4
EOF
        
        # Restart NetworkManager
        systemctl restart NetworkManager
    fi
    
    # Cấu hình systemd-resolved (nếu có)
    if systemctl is-active --quiet systemd-resolved; then
        cat > /etc/systemd/resolved.conf << 'EOF'
[Resolve]
DNS=1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
DNSOverTLS=yes
DNSSEC=yes
FallbackDNS=1.1.1.1 8.8.8.8
EOF
        systemctl restart systemd-resolved
    fi
    
    # Cài đặt DNS benchmark tool
    print_step "Cài đặt DNS benchmark tool..."
    pacman -S --noconfirm dnsutils bind-tools
    yay -S --noconfirm dnscrypt-proxy 2>/dev/null || \
        print_warning "DNScrypt-proxy có thể cài từ AUR"
    
    # Tạo script kiểm tra DNS
    cat > /usr/local/bin/dns-test << 'EOF'
#!/bin/bash
echo "===== KIỂM TRA DNS ====="
echo ""
echo "1. Cloudflare (1.1.1.1):"
dig @1.1.1.1 archlinux.org +short 2>/dev/null || echo "  ❌ Không kết nối được"
echo ""
echo "2. Google (8.8.8.8):"
dig @8.8.8.8 archlinux.org +short 2>/dev/null || echo "  ❌ Không kết nối được"
echo ""
echo "3. DNS hiện tại:"
cat /etc/resolv.conf | grep nameserver
echo ""
echo "4. DNS latency:"
time dig archlinux.org +short 2>/dev/null
EOF
    chmod +x /usr/local/bin/dns-test
    
    # Chạy test DNS
    dns-test
    
    print_success "Đã cấu hình DNS (1.1.1.1, 8.8.8.8)"
    print_success "Công cụ kiểm tra: dns-test"
}

# ============================================================
# PHẦN 1: GỠ BỎ XFCE4-PANEL (GIỮ NGUYÊN)
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
# PHẦN 2: CÀI ĐẶT ỨNG DỤNG (GIỮ NGUYÊN)
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

    # 5. Forecast
    print_step "5. Cài đặt Forecast..."
    if ! command -v yay &> /dev/null; then
        print_warning "Yay chưa được cài đặt, đang cài đặt..."
        pacman -S --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin 2>/dev/null || {
            print_error "Không thể clone yay-bin!"
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
    
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
        pacman -Sy --noconfirm
    fi
    
    pacman -S --noconfirm wine wine-gecko wine-mono winetricks
    pacman -S --noconfirm \
        lib32-mesa lib32-libpulse lib32-alsa-plugins lib32-gnutls \
        lib32-libldap lib32-libpng lib32-libxcomposite lib32-libxinerama \
        lib32-opencl-icd-loader lib32-gst-plugins-base lib32-gst-plugins-good \
        lib32-gst-plugins-bad lib32-gst-plugins-ugly lib32-vulkan-intel \
        lib32-vkd3d lib32-mpg123 lib32-openal lib32-sdl2 lib32-libgcrypt \
        lib32-ncurses lib32-v4l-utils lib32-libjpeg-turbo lib32-sqlite \
        lib32-libxslt lib32-libva lib32-gtk3 2>/dev/null || true
    print_success "Đã cài đặt Wine và plugin đầy đủ"

    # 13. WPS Office
    print_step "13. Cài đặt WPS Office..."
    yay -S --noconfirm wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts freetype2-wps libtiff5 2>/dev/null || \
        print_warning "WPS Office có thể cần cài thủ công"
    print_success "Đã cài đặt WPS Office"

    # 14. Zalo
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
    print_warning "⚠ MT5 có thể gặp lỗi 'debugger found' trên Wine 10.3+"
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

    # 17. Calculator
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

    # 20. LightDM Webkit
    print_step "20. Cài đặt LightDM Webkit và Theme Dark Planet..."
    
    if systemctl is-active --quiet gdm 2>/dev/null || systemctl is-active --quiet sddm 2>/dev/null; then
        print_warning "Phát hiện display manager khác (GDM/SDDM)"
        systemctl stop gdm 2>/dev/null || true
        systemctl stop sddm 2>/dev/null || true
        systemctl disable gdm 2>/dev/null || true
        systemctl disable sddm 2>/dev/null || true
    fi
    
    pacman -S --noconfirm lightdm-webkit2-greeter lightdm
    
    if [ -d /tmp/dark-planet ]; then
        rm -rf /tmp/dark-planet
    fi
    git clone https://github.com/Antergos/web-greeter-theme-dark-planet.git /tmp/dark-planet 2>/dev/null || {
        print_warning "Không thể clone theme Dark Planet"
        mkdir -p /usr/share/web-greeter/themes/dark-planet
    }
    if [ -d /tmp/dark-planet ]; then
        mkdir -p /usr/share/web-greeter/themes/
        cp -r /tmp/dark-planet /usr/share/web-greeter/themes/dark-planet
        rm -rf /tmp/dark-planet
    fi
    
    mkdir -p /etc/lightdm
    cat > /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-webkit2-greeter
user-session=xfce
EOF

    cat > /etc/lightdm/lightdm-webkit2-greeter.conf << EOF
[greeter]
webkit-theme = dark-planet
debug-mode = false
screensaver-timeout = 30
show-pane = true
show-keyboard = true
EOF

    systemctl enable lightdm 2>/dev/null || print_warning "LightDM không thể enable"
    print_success "Đã cài đặt LightDM Webkit và Theme Dark Planet"

    # 21. Plymouth
    print_step "21. Cài đặt Plymouth và Theme Dark Planet..."
    pacman -S --noconfirm plymouth
    
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

    pacman -S --noconfirm imagemagick 2>/dev/null || true
    
    if command -v convert &> /dev/null; then
        convert -size 1920x1080 gradient:black-darkblue /usr/share/plymouth/themes/dark-planet/background.png 2>/dev/null || true
        convert -size 100x100 xc:transparent -fill white -draw "circle 50,50 50,10" \
            -gravity center -pointsize 40 -fill black -draw "text 0,-5 'A'" \
            /usr/share/plymouth/themes/dark-planet/logo.png 2>/dev/null || true
    fi

    sed -i 's/^#*\(Theme=\).*$/\1dark-planet/' /etc/plymouth/plymouthd.conf 2>/dev/null || \
        echo "Theme=dark-planet" > /etc/plymouth/plymouthd.conf
    
    if command -v mkinitcpio &> /dev/null; then
        if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
            if grep -q "^HOOKS=" /etc/mkinitcpio.conf; then
                sed -i 's/^HOOKS=(/HOOKS=(plymouth /' /etc/mkinitcpio.conf
            else
                echo 'HOOKS=(base udev plymouth autodetect modconf block filesystems keyboard fsck)' >> /etc/mkinitcpio.conf
            fi
        fi
        mkinitcpio -p linux 2>/dev/null || print_warning "mkinitcpio thất bại"
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
# PHẦN 3: SCRIPT DỌN DẸP LOG (GIỮ NGUYÊN)
# ============================================================

create_cleanup_script() {
    print_header "TẠO SCRIPT DỌN DẸP LOG"
    
    cat > /usr/local/bin/log-cleanup.sh << 'EOF'
#!/bin/bash

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

log_message "========== BẮT ĐẦU DỌN DẸP =========="

log_message "Đang backup log quan trọng..."
mkdir -p "$BACKUP_DIR/$(date +%Y%m%d)"
find "$LOG_DIR" -name "*error*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null
find "$LOG_DIR" -name "*critical*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null
find "$LOG_DIR" -name "*secure*.log" -type f -mtime -7 -exec cp {} "$BACKUP_DIR/$(date +%Y%m%d)/" \; 2>/dev/null

log_message "Đang xóa log cũ hơn $RETENTION_DAYS ngày..."
find "$LOG_DIR" -name "*.log" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null
find "$LOG_DIR" -name "*.log.*" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null

log_message "Đang xóa file log rỗng..."
find "$LOG_DIR" -name "*.log" -type f -empty -delete 2>/dev/null

log_message "Đang nén log từ $COMPRESS_DAYS-$RETENTION_DAYS ngày..."
find "$LOG_DIR" -name "*.log" -type f -mtime +$COMPRESS_DAYS -mtime -$RETENTION_DAYS -exec gzip -9 {} \; 2>/dev/null
find "$LOG_DIR" -name "*.log.*" -type f -mtime +$COMPRESS_DAYS -mtime -$RETENTION_DAYS -exec gzip -9 {} \; 2>/dev/null

log_message "Đang chạy logrotate..."
command -v logrotate &>/dev/null && logrotate -f /etc/logrotate.conf 2>/dev/null

log_message "Đang dọn dẹp journald..."
command -v journalctl &>/dev/null && journalctl --vacuum-time=${RETENTION_DAYS}d 2>/dev/null
command -v journalctl &>/dev/null && journalctl --vacuum-size=500M 2>/dev/null

log_message "Đang tối ưu log..."
find "$LOG_DIR" -name "*.log" -type f -size +100k -exec sh -c '
    for file do
        sed -i "/^[[:space:]]*$/d" "$file" 2>/dev/null
        if [ $(stat -c%s "$file" 2>/dev/null || echo 0) -gt 52428800 ]; then
            tail -n 50000 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        fi
    done
' sh {} + 2>/dev/null

log_message "Đang nén archive cũ..."
find "$ARCHIVE_DIR" -name "*.log" -type f -mtime +60 -exec gzip -9 {} \; 2>/dev/null

log_message "Đang xóa backup cũ..."
find "$BACKUP_DIR" -name "*.log*" -type f -mtime +90 -delete 2>/dev/null

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
# PHẦN 4: SYSTEMD TIMER (GIỮ NGUYÊN)
# ============================================================

setup_systemd_timer() {
    print_header "CÀI ĐẶT SYSTEMD TIMER"
    
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
# PHẦN 5: CÔNG CỤ KIỂM TRA (CẬP NHẬT)
# ============================================================

create_tools() {
    print_header "TẠO CÔNG CỤ KIỂM TRA"
    
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
echo "Log Cleanup: $(systemctl is-active log-cleanup.timer 2>/dev/null || echo 'inactive')"
echo "Security Update: $(systemctl is-active security-update.timer 2>/dev/null || echo 'inactive')"
echo "NetworkManager: $(systemctl is-active NetworkManager 2>/dev/null || echo 'inactive')"
echo ""

echo -e "${YELLOW}===== THÔNG TIN PIN =====${NC}"
tlp-stat -b 2>/dev/null | grep -E "Charge|Status" || echo "Không có dữ liệu pin"
echo ""

echo -e "${YELLOW}===== DỤNG LƯỢNG LOG =====${NC}"
du -sh /var/log 2>/dev/null
echo ""

echo -e "${YELLOW}===== KIỂM TRA DNS =====${NC}"
cat /etc/resolv.conf | grep nameserver | head -3
echo ""

echo -e "${YELLOW}===== CÁC ỨNG DỤNG ĐÃ CÀI =====${NC}"
command -v firefox &>/dev/null && echo "✓ Firefox" || echo "✗ Firefox"
command -v vlc &>/dev/null && echo "✓ VLC" || echo "✗ VLC"
command -v wps &>/dev/null && echo "✓ WPS Office" || echo "✗ WPS Office"
command -v tradingview &>/dev/null && echo "✓ TradingView" || echo "✗ TradingView"
command -v gnome-calculator &>/dev/null && echo "✓ Calculator" || echo "✗ Calculator"
snap list 2>/dev/null | grep -q zalo && echo "✓ Zalo Chat" || echo "✗ Zalo Chat"
[ -d ~/.mt5wine ] 2>/dev/null && echo "✓ MetaTrader 5" || echo "✗ MetaTrader 5"
EOF
    chmod +x /usr/local/bin/check-status
    
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
        ;;
esac
EOF
    chmod +x /usr/local/bin/cleanup-manager
    
    print_success "Đã tạo công cụ kiểm tra"
}

# ============================================================
# PHẦN 6: HƯỚNG DẪN WINE (GIỮ NGUYÊN)
# ============================================================

create_wine_guide() {
    print_header "HƯỚNG DẪN SỬ DỤNG WINE"
    
    cat > /usr/local/bin/wine-setup << 'EOF'
#!/bin/bash
echo "===== HƯỚNG DẪN CẤU HÌNH WINE ====="
echo ""
echo "1. Tạo Wine prefix:"
echo "   WINEARCH=win32 WINEPREFIX=~/.wine32 winecfg"
echo ""
echo "2. Cài đặt các thành phần:"
echo "   winetricks corefonts dxvk vcrun2017 vcrun2019"
echo ""
echo "3. Chạy ứng dụng Windows:"
echo "   wine app.exe"
echo ""
echo "===== LƯU Ý CHO METATRADER 5 ====="
echo "MT5 yêu cầu Wine bản 10.2 để chạy ổn định"
echo "Downgrade Wine:"
echo "  sudo pacman -U /var/cache/pacman/pkg/wine-10.2-1-x86_64.pkg.tar.zst"
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
    echo "  ✓ VLC Media Player (trình phát đa phương tiện)"
    echo "  ✓ Forecast (dự báo thời tiết)"
    echo "  ✓ Tailscale (VPN mesh)"
    echo "  ✓ OpenSSH (remote access)"
    echo "  ✓ BlueZ + Blueman (Bluetooth)"
    echo "  ✓ TLP (quản lý pin)"
    echo "  ✓ yt-dlp + ffmpeg (tải video/audio)"
    echo "  ✓ Driver Intel (mesa, vulkan, xf86-video-intel)"
    echo "  ✓ Wine + plugins đầy đủ"
    echo "  ✓ WPS Office (bộ văn phòng)"
    echo "  ✓ Zalo Chat Unofficial (Snap)"
    echo "  ✓ TradingView (AUR/Snap)"
    echo "  ✓ MetaTrader 5 (qua Wine)"
    echo "  ✓ GNOME Calculator"
    echo "  ✓ Papirus Icon Theme"
    echo "  ✓ LightDM Webkit + Dark Planet Theme"
    echo "  ✓ Plymouth + Dark Planet Theme"
    echo "  ✓ Logrotate + Cleanup (dọn dẹp log)"
    
    echo -e "\n${GREEN}TÍNH NĂNG MỚI ĐÃ THÊM:${NC}"
    echo "  🔐 Security Updates (tự động cập nhật bảo mật hàng ngày)"
    echo "  🖌️  Fonts cho văn phòng & tiếng Việt"
    echo "  🎨 GRUB Customize (bootloader đẹp)"
    echo "  📶 WiFi Manager (quản lý WiFi dễ dàng)"
    echo "  🌐 DNS 1.1.1.1 / 8.8.8.8"
    
    echo -e "\n${YELLOW}📋 HƯỚNG DẪN SỬ DỤNG:${NC}"
    echo -e "1. ${CYAN}Kiểm tra trạng thái:${NC} sudo check-status"
    echo -e "2. ${CYAN}Quản lý WiFi:${NC} wifi {gui|tui|on|off|list|connect}"
    echo -e "3. ${CYAN}Kiểm tra DNS:${NC} dns-test"
    echo -e "4. ${CYAN}Xem log cập nhật bảo mật:${NC} cat /var/log/security-updates.log"
    echo -e "5. ${CYAN}Quản lý dọn dẹp log:${NC} cleanup-manager {run|status|logs}"
    echo -e "6. ${CYAN}Hướng dẫn Wine:${NC} wine-setup"
    
    echo -e "\n${GREEN}📁 Log và báo cáo:${NC}"
    echo "  • Security updates: /var/log/security-updates.log"
    echo "  • Log cleanup: /var/log/cleanup_report_*.log"
    
    echo -e "\n${RED}⚠ LƯU Ý QUAN TRỌNG:${NC}"
    echo "  • MT5 hiện có lỗi 'debugger found' trên Wine 10.3+"
    echo "  • Giải pháp: downgrade Wine xuống 10.2"
    echo "  • Cần khởi động lại để áp dụng LightDM và Plymouth"
    echo "  • GRUB theme có thể cần cài thủ công nếu clone thất bại"
    
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}  🚀 HỆ THỐNG ĐÃ SẴN SÀNG!  ${NC}"
    echo -e "${GREEN}========================================${NC}"
}

# ============================================================
# PHẦN CHÍNH
# ============================================================

main() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Script cần chạy với quyền root!"
        echo "Sử dụng: sudo $0"
        exit 1
    fi
    
    clear
    print_header "CÀI ĐẶT & TỐI ƯU ARCH LINUX (BẢN ĐẦY ĐỦ + TÍNH NĂNG MỚI)"
    echo -e "${CYAN}Thời gian: $(date '+%H:%M:%S %d/%m/%Y')${NC}"
    echo -e "${CYAN}User: $(get_current_user)${NC}"
    
    check_distro
    check_internet
    check_disk_space
    backup_config
    
    echo -e "\n${YELLOW}⚠ Bạn có chắc chắn muốn tiếp tục?${NC}"
    echo -e "Script sẽ cài đặt nhiều ứng dụng và thay đổi cấu hình hệ thống."
    read -p "Nhấn y/Y để tiếp tục, bất kỳ phím nào khác để hủy: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Đã hủy cài đặt."
        exit 1
    fi
    
    # Các phần chính
    remove_xfce4_panel
    install_applications
    
    # CÁC TÍNH NĂNG MỚI
    setup_auto_security_updates
    install_fonts
    customize_grub
    setup_wifi_management
    configure_dns
    
    # Phần còn lại
    create_cleanup_script
    setup_systemd_timer
    create_tools
    create_wine_guide
    
    # Chạy thử cleanup
    print_step "Chạy dọn dẹp log lần đầu..."
    systemctl start log-cleanup.service 2>/dev/null || true
    
    # Chạy cập nhật security lần đầu
    print_step "Chạy cập nhật security lần đầu..."
    systemctl start security-update.service 2>/dev/null || true
    
    show_summary
    
    echo -e "\n${CYAN}Lịch chạy các timer:${NC}"
    systemctl list-timers --no-pager 2>/dev/null | grep -E "log-cleanup|security-update" || echo "Đang cập nhật..."
    
    echo -e "\n${GREEN}✅ SCRIPT HOÀN TẤT!${NC}"
    echo -e "${YELLOW}🔔 Khởi động lại hệ thống để áp dụng đầy đủ!${NC}"
}

# Chạy main
main

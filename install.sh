#!/bin/bash

# Venom Hyprland Rice Installer
# https://github.com/darraghsalt1-pixel/venom-hyprland-rice

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${RED}"
    echo "╦  ╦┌─┐┌┐┌┌─┐┌┬┐  ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐"
    echo "╚╗╔╝├┤ ││││ ││││  ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││"
    echo " ╚╝ └─┘┘└┘└─┘┴ ┴  ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘"
    echo "           🕷️  Rice Installer  🕷️           "
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

check_arch() {
    if [ ! -f /etc/arch-release ]; then
        print_error "This installer is designed for Arch Linux."
        print_info "You can still manually copy the configs if you're on another distro."
        read -p "Continue anyway? (y/N): " continue
        if [[ ! $continue =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

create_backup() {
    print_info "Creating backups..."
    backup_dir=~/.config_backup_$(date +%Y%m%d_%H%M%S)
    mkdir -p "$backup_dir"
    
    # Backup existing configs
    [ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$backup_dir/" && print_success "Backed up hypr"
    [ -d ~/.config/kitty ] && cp -r ~/.config/kitty "$backup_dir/" && print_success "Backed up kitty"
    [ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$backup_dir/" && print_success "Backed up waybar"
    [ -d ~/.config/wofi ] && cp -r ~/.config/wofi "$backup_dir/" && print_success "Backed up wofi"
    [ -d ~/.config/dunst ] && cp -r ~/.config/dunst "$backup_dir/" && print_success "Backed up dunst"
    
    print_success "Backups saved to: $backup_dir"
}

check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    local deps=(
        "hyprland"
        "kitty"
        "waybar"
        "wofi"
        "dunst"
        "swaybg"
        "swaylock"
        "grim"
        "slurp"
        "wl-clipboard"
        "ffmpeg"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! pacman -Qi "$dep" &> /dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        read -p "Install missing dependencies? (Y/n): " install_deps
        if [[ ! $install_deps =~ ^[Nn]$ ]]; then
            print_info "Installing dependencies..."
            if command -v yay &> /dev/null; then
                yay -S --needed "${missing_deps[@]}"
            elif command -v paru &> /dev/null; then
                paru -S --needed "${missing_deps[@]}"
            else
                sudo pacman -S --needed "${missing_deps[@]}"
            fi
            print_success "Dependencies installed"
        fi
    else
        print_success "All dependencies are installed"
    fi
}

install_configs() {
    print_info "Installing configuration files..."
    
    # Copy all configs
    cp -r .config/* ~/.config/ 2>/dev/null || true
    print_success "Copied config files"
    
    # Make scripts executable
    if [ -d scripts ]; then
        chmod +x scripts/*
        [ -d ~/.config/hypr/scripts ] && chmod +x ~/.config/hypr/scripts/*
        print_success "Made scripts executable"
    fi
    
    # Copy wallpapers
    if [ -d wallpapers ]; then
        mkdir -p ~/Pictures/wallpapers
        cp -r wallpapers/* ~/Pictures/wallpapers/ 2>/dev/null || true
        print_success "Copied wallpapers to ~/Pictures/wallpapers/"
    fi
}

install_sddm() {
    print_info "SDDM Theme Installation"
    read -p "Install SDDM theme? (requires sudo) (Y/n): " install_sddm
    
    if [[ ! $install_sddm =~ ^[Nn]$ ]]; then
        if [ -d sddm/my-sddm-rice ]; then
            print_info "Installing SDDM theme..."
            sudo mkdir -p /usr/share/sddm/themes/
            sudo cp -r sddm/my-sddm-rice /usr/share/sddm/themes/
            
            # Update SDDM config if it exists
            if [ -f sddm/sddm.conf ]; then
                sudo cp sddm/sddm.conf /etc/sddm.conf
                print_success "SDDM config updated"
            else
                print_warning "No sddm.conf found. You'll need to manually set the theme."
                print_info "Add this to /etc/sddm.conf:"
                echo -e "${BLUE}[Theme]${NC}"
                echo -e "${BLUE}Current=my-sddm-rice${NC}"
            fi
            
            print_success "SDDM theme installed"
        else
            print_warning "SDDM theme not found in repo"
        fi
    fi
}

start_services() {
    print_info "Starting heartbeat border animation..."
    
    if [ -f ~/.config/hypr/scripts/venom-border.sh ]; then
        # Kill existing instance if running
        pkill -f venom-border.sh 2>/dev/null || true
        
        # The script should auto-start via hyprland.conf exec-once
        print_success "Border animation will start with Hyprland"
    else
        print_warning "Border animation script not found"
    fi
}

print_completion() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}║   🕷️  Installation Complete! 🕷️         ║${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Next steps:"
    echo "  1. Reload Hyprland: SUPER + SHIFT + R (or restart)"
    echo "  2. If SDDM was installed: reboot to see the theme"
    echo "  3. Check waybar is running: it should auto-start"
    echo "  4. Enjoy your Venom-themed setup! 🕷️"
    echo ""
    print_info "Keybinds:"
    echo "  SUPER + Q     → Close window"
    echo "  SUPER + ENTER → Terminal (Kitty)"
    echo "  SUPER + D     → Launcher (Wofi)"
    echo "  SUPER + R     → Voice recording (OSTT)"
    echo "  SUPER + L     → Lock screen"
    echo ""
    print_warning "If you encounter issues:"
    echo "  - Check hyprland logs: hyprctl monitors"
    echo "  - Waybar logs: journalctl --user -u waybar -f"
    echo "  - Report issues: https://github.com/darraghsalt1-pixel/venom-hyprland-rice/issues"
    echo ""
}

main() {
    print_header
    
    # Check if running from correct directory
    if [ ! -d ".config" ]; then
        print_error "Please run this script from the venom-hyprland-rice directory"
        exit 1
    fi
    
    check_arch
    create_backup
    check_dependencies
    install_configs
    install_sddm
    start_services
    print_completion
}

main "$@"

# my venom themed rice hope you all like it!
<img width="2560" height="1452" alt="20251228_10h53m22s_grim" src="https://github.com/user-attachments/assets/f22377f1-74e2-47bd-b738-9f8b883879ac" />
<img width="2560" height="1579" alt="20251228_10h53m58s_grim" src="https://github.com/user-attachments/assets/05f5457e-978e-43cc-9fbb-13376b1941e4" />
just a few examples of this rice!

## Installation

### Quick Install
```bash
git clone https://github.com/darraghsalt1-pixel/venom-hyprland-rice
cd venom-hyprland-rice
chmod +x install.sh
./install.sh
```

The script will:
- Create automatic backups of your existing configs
- Check and install missing dependencies
- Copy all configuration files
- Install the SDDM theme (optional, requires sudo)
- Set up the heartbeat border animation

### Manual Install
If you prefer to install manually:
```bash
cp -r .config/* ~/.config/
chmod +x ~/.config/hypr/scripts/*
sudo cp -r sddm/my-sddm-rice /usr/share/sddm/themes/
```

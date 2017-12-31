#! /bin/bash
# Backup mirror file
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
# Get fastest 6 mirrors and save them to mirrorlist
sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
echo "Mirrors ranked and written"
# Add multilib (32-bit packages) for 64-bit systems
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    sudo sed -i "90,91 s/^#//" /etc/pacman.conf
    echo "Multilib enabled"
fi
# Update and install my packages
sudo pacman -Syu --noconfirm
yes | sudo pacman -S --noconfirm linux-hardened thunar xterm pepperflash kdialog xscreensaver xrandr unclutter scrot mpd mpc dmenu xsel wget awesome vim emacs xorg xorg-xinit rxvt-unicode git base-devel firefox chromium ffmpeg wine-staging wine_gecko wine-mono

# Install yaourt for AUR access
git clone https://aur.archlinux.org/package-query.git $HOME/package-query
cd $HOME/package-query
makepkg -si --noconfirm
git clone https://aur.archlinux.org/yaourt.git $HOME/yaourt
cd $HOME/yaourt
makepkg -si --noconfirm
#cleanup
rm -rf $HOME/yaourt/ $HOME/package-query
# install login manager
## yaourt -S cdm-git
# Configure awesome
mkdir -p $HOME/.config/awesome/
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
# Clone config
git clone --recursive https://github.com/lcpz/awesome-copycats.git $HOME/awesome-copycats/
mv -bv $HOME/awesome-copycats/* $HOME/.config/awesome
cp $HOME/.config/awesome/rc.lua.template $HOME/.config/awesome/rc.lua
#cleanup
rm -rf $HOME/awesome-copycats
#resolution
echo "Enter your desired resolution e.g. 1280x720"
read resolution

#Start awesome using X
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "xscreensaver & 
exec awesome" > ~/.xinitrc

# Auto-start x at login
echo "if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi" >> ~/.bash_profile

#VMWare-specific
#sudo pacman -S --noconfirm xf86-video-vmware open-vm-tools linux-headers
#yaourt -S --noconfirm open-vm-tools-dkms
#systemctl vmware-vmblock-fuse.service

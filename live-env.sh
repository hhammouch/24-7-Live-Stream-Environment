(
(
# set password
sudo passwd $USER
)
(
# install xrdp service 
sudo apt update
sudo apt install -y xrdp


# install ubuntu & cinnamon desktop
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y ubuntu-desktop
sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes cinnamon-core desktop-base dbus-x11
)
(
# enable and start xrdp service
echo "cinnamon" > ~/.Xclients
chmod +x ~/.Xclients
sudo systemctl restart xrdp.service
)
(
# fix "authentication required" bug
cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-NetworkManager.pkla
[Netowrkmanager]
Identity=unix-group:sudo
Action=org.freedesktop.NetworkManager.network-control
ResultAny=yes
ResultInactive=yes
ResultActive=yes
EOF


cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-packagekit.pkla
[Netowrkmanager]
Identity=unix-group:sudo
Action=org.freedesktop.packagekit.system-sources-refresh
ResultAny=yes
ResultInactive=auth_admin
ResultActive=yes
EOF
sudo systemctl restart polkit 
)
(
# install obs, discord, pulse, chrome and actiona
sudo snap install obs-studio
sudo snap install pulseaudio
sudo apt install -y actiona
)
(
# Create a 4GB swapfile
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
)
(
# install codecs
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y ubuntu-restricted-extras
)
(
# set rdp session to use cinnamon
echo "cinnamon-session" > ~/.xsession 
D=/usr/share/gnome:/usr/share/cinnamon:/usr/local/share:/usr/share
D=${D}:/var/lib/snapd/desktop C=/etc/xdg/xdg-cinnamon:/etc/xdg
cat <<EOF > ~/.xsessionrc
export XDG_SESSION_DESKTOP=cinnamon
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=${C}
export CINNAMON_2D=1
dconf write /org/cinnamon/desktop/interface/icon-theme "'Humanity'"
dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
EOF
)
(
sudo reboot
)
)


# end

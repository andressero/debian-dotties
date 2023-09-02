#!/bin/bash

# (Check if sudo was used)
echo "$0: Using sudo"

# Change language from spanish to english
# dpkg-reconfigure locales
echo "$0: Change language from spanish to english"
# Add contrib and non-free to the repositories in /etc/apt/sources.list
echo "$0: Adding contrib and non-free to repositories"

# Install a bunch of stuff (curl is for add vscode)
echo "$0: Installing packages"
apt install nala -y
nala install moreutils flatpak fonts-clear-sans git git-gui libavcodec-extra make vim papirus-icon-theme plymouth plymouth-themes cpplint valgrind build-essential python3-pip clang gcc libzip-dev ttf-mscorefonts-installer icdiff doxygen graphviz neofetch gnome-core gnome-tweaks gnome-shell-pomodoro gnome-software-plugin-flatpak wget gpg -y

# Add vscode repo and install code
echo "$0: Adding vscode repo"

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

echo "$0: Installing vscode"
nala install apt-transport-https -y
nala update
nala install code -y

# Add zoom repo and install zoom

# Add flathub to flatpak
echo "$0: Adding flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
echo "$0: Installing flatpaks"
flatpak install com.mattjakeman.ExtensionManager org.gnome.Geary org.libreoffice.LibreOffice org.onlyoffice.desktopeditors org.telegram.desktop page.codeberg.libre_menu_editor.LibreMenuEditor md.obsidian.Obsidian com.raggesilver.BlackBox org.gnome.Calendar -y

# Remove some packages
echo "$0: Removing some packages"
nala purge gnome-shell-extensions-prefs gnome-contacts gnome-font-viewer gnome-characters totem baobab debian-reference debian-reference-es debian-reference-common -y

# Config gnome (dark mode, default terminal, icons, user icon)
# Set icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# Set up plymouth theme
# Create a program that modifies /etc/default/grub so it can handle plymouths
# plymouth-set-default-theme emerald

# Hide some applications
echo "Hiding some applications"
mkdir -p ~/.local/share/applications
cd /usr/share/applications/
cp im-config.desktop nm-connection-editor.desktop org.gnome.Terminal.desktop org.libreoffice.LibreOffice.base.desktop org.libreoffice.LibreOffice.draw.desktop org.libreoffice.LibreOffice.math.desktop yelp.desktop  ~/.local/share/applications

for i in *
do
	if test -f "$i"
	then
		echo "NoDisplay=true" >> $i
		echo ""
	fi
done

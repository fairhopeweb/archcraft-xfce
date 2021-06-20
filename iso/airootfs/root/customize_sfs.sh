#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

## -------------------------------------------------------------- ##

## Enable Parallel Downloads
sed -i -e 's|#ParallelDownloads.*|ParallelDownloads = 6|g' /etc/pacman.conf
sed -i -e '/#\[testing\]/Q' /etc/pacman.conf

## Append archcraft repository to pacman.conf
cat >> "/etc/pacman.conf" <<- EOL
	## Archcraft Repository
	[archcraft]
	SigLevel = Optional TrustAll
	Server = https://archcraft.io/archcraft-pkgs/\$arch

	#[testing]
	#Include = /etc/pacman.d/mirrorlist

	[core]
	Include = /etc/pacman.d/mirrorlist

	[extra]
	Include = /etc/pacman.d/mirrorlist

	#[community-testing]
	#Include = /etc/pacman.d/mirrorlist

	[community]
	Include = /etc/pacman.d/mirrorlist

	# If you want to run 32 bit applications on your x86_64 system,
	# enable the multilib repositories as required here.

	#[multilib-testing]
	#Include = /etc/pacman.d/mirrorlist

	[multilib]
	Include = /etc/pacman.d/mirrorlist

	# An example of a custom package repository.  See the pacman manpage for
	# tips on creating your own repositories.
	#[custom]
	#SigLevel = Optional TrustAll
	#Server = file:///home/custompkgs
EOL

## -------------------------------------------------------------- ##

## Copy Few Configs Into Root Dir
rdir='/root/.config'
sdir='/etc/skel'

if [[ ! -d "${rdir}" ]]; then
	mkdir "${rdir}"
fi

rconfig=('geany' 'gtk-3.0' 'Kvantum' 'qt5ct' 'ranger' 'Thunar' 'xfce4')
for cfg in "${rconfig[@]}"; do
	cp -rf "${sdir}/.config/${cfg}" "${rdir}"
done

rcfg=('.oh-my-zsh' '.vimrc' '.zshrc')
for cfile in "${rcfg[@]}"; do
	cp -rf "${sdir}/${cfile}" /root
done

## -------------------------------------------------------------- ##

## Fix wallpaper in xfce
mv /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfce_verticals.png
cp -rf /usr/share/archcraft/wallpapers/Default.png /usr/share/backgrounds/xfce/xfce-verticals.png

## -------------------------------------------------------------- ##

## Copy Calamares to Desktop
_desktop="/home/liveuser/Desktop"

if [[ ! -d "${_desktop}" ]]; then
	mkdir -p "${_desktop}"
fi

cp /usr/share/applications/calamares.desktop "${_desktop}"
chown -R liveuser:users "${_desktop}"/calamares.desktop
chmod +x "${_desktop}"/calamares.desktop

## -------------------------------------------------------------- ##

## Hide Unnecessary Apps
adir='/usr/share/applications'
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop compton.desktop echomixer.desktop \
	envy24control.desktop exo-mail-reader.desktop exo-preferred-applications.desktop feh.desktop \
	hdajackretask.desktop hdspconf.desktop hdspmixer.desktop hwmixvolume.desktop lftp.desktop \
	libfm-pref-apps.desktop lxshortcut.desktop lstopo.desktop mimeinfo.cache \
	networkmanager_dmenu.desktop nm-connection-editor.desktop pcmanfm-desktop-pref.desktop \
	qv4l2.desktop qvidcap.desktop stoken-gui.desktop stoken-gui-small.desktop thunar-bulk-rename.desktop \
	thunar-settings.desktop thunar-volman-settings.desktop yad-icon-browser.desktop)

for app in "${apps[@]}"; do
	if [[ -f "${adir}/${app}" ]]; then
		sed -i '$s/$/\nNoDisplay=true/' "${adir}/${app}"
	fi
done

## -------------------------------------------------------------- ##

## Other Stuff
rm -rf /usr/share/pixmaps/{archlinux.png,archlinux.svg,archlinux-logo.png,archlinux-logo.svg}

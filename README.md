# dotfiles

My dotfiles managed using [GNU Stow](https://www.gnu.org/software/stow).

## Personal installation notes

#### Things that I might want to backup manually

- `~/.local/share/fish/fish_history`
- uBlock Origin filters & settings
- Twitch FFZ, Previews, 7TV settings
- ViolentMonkey userscripts & options
- Hover Zoom+ settings
- YouTube Enhancer & SponsorBlock config
- Tabs and windows using Session Buddy
- Remote Torrent Adder config
- AniList Automail userscript config
- VueTorrent settings
- Redirector entries
- Flatpak apps (`~/.var/app/` or `flatpak list --columns=application --app`)
- gpg keys (`~/.gnupg/`)

#### Manual actions to perform
- Disable HoverZoom+ on
```
qbittorrent.bas.sh
twitch.tv
kick.com
trash-guides.info
kemono.su
coomer.su
pixeldrain.com
drive.google.com
eos.usbx.me
scrutiny.bas.sh
youtube.com
store.steampowered.com
pomf.tv
bunkr
arazu.io
```

`// TODO: automate everything below`

#### Clone dotfiles
```shell
git clone git@github.com:brw/dotfiles.git
```

#### Disable Intel pstate driver
Add `intel_pstate=disable` to the options in `/boot/entries/linux.conf`

Or `intel_pstate=active`, if using [throttled](https://github.com/erpalma/throttled):

#### Copy system files
```shell
sudo cp -i sysctl/etc/sysctld.d/* /etc/sysctl.d/
sudo cp -i zram/etc/systemd/zram-generator.conf /etc/systemd/
sudo cp -i etc/udev/rules.d/10-trim.rules /etc/udev/rules.d/
sudo cp -i throttled/etc/throttled.conf /etc/throttled.conf
```

#### Enable throttled
```shell
sudo systemctl enable --now throttled
```

#### Install yay
```shell
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
```

#### Import tor gpg key
```shell
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
```

#### Install packages
```shell
yay -Syu --needed $(cat arch-{shell,desktop}-packages)
```

#### Install dotfiles
```
rm -rf ~/.config/fish
stow -d dotfiles bin cpupower direnv fish git gtk neofetch nvim pacman ripgrep mise starship stow wayland yay ghostty
```

#### Use systemd-resolved
```shell
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable --now systemd-resolved
```

#### Enable pkgfile daemon and pacman files db refresh timer
```shell
sudo systemctl enable --now pkgfiled pacman-filesdb-refresh.timer
```

#### Enable timers
```shell
sudo systemctl enable --now yaycache.timer paccache.timer plocate-updatedb.timer
```

#### Enable printer service
```shell
sudo systemctl enable --now cups
```

#### Enable systemd-boot update service
```shell
sudo systemctl enable systemd-boot-update
```

#### Enable en_NL locale
```shell
sudo sed -i '/^#en_NL.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
```

#### Enable kernel-modules-hook linux-modules-cleanup service
```shell
sudo systemctl enable --now linux-modules-cleanup
```

#### Fix fish universal variables in Gnome Wayland session
Modify `/usr/bin/gnome-session`, changing (hardcoding) `$SHELL` to `sh` on line 10 ([temporary fix](https://github.com/fish-shell/fish-shell/issues/7995), probably bad practice but /shrug, universal variables are sort of maybe [being removed](https://github.com/fish-shell/fish-shell/issues/7379) in the near future anyway, at which point I'll change this)


#### Fix scaling issues on Gnome Wayland and bluriness with Xwayland
```shell
org.gnome.mutter experimental-features ['scale-monitor-framebuffer', 'xwayland-native-scaling']
```

#### Unbind XF86Tools (F13) on Gnome
For some reason the button I have bound to F13 on my mouse opens the Gnome control center/settings by default, with no way to change it outside of dconf/gsettings. quite annoying

```shell
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center-static "['']"
```

#### Enable Gnome Keyring SSH Agent
```shell
systemctl --user enable --now gcr-ssh-agent
ssh-add
````

#### Set up keylightd
```
sudo usermod -aG keylightd bas
sudo systemctl enable --now keylightd
```

#### Get latest plex-rich-presence
```shell
curl -s https://api.github.com/repos/Arno500/plex-richpresence/releases/latest \
    | jq -r '.assets[] | select(.name | contains("linux_amd64")).browser_download_url' \
    | wget -q -P $HOME -i - \
    && chmod +x $HOME/plex-rich-presence_linux_amd64-*
```

#### Install systemd services
```shell
cp -i systemd/.config/systemd/user/plex-rich-presence.service ~/.config/systemd/user/
systemctl --user enable --now plex-rich-presence
#sudo cp -i etc/systemd/system/reload-cpu-modules.service /etc/systemd/system/
#sudo systemctl enable --now reload-cpu-modules
#cp -i systemd/.config/systemd/user/imwheel.service ~/.config/systemd/user/
#systemctl --user enable --now imwheel
```

# dotfiles

My dotfiles managed using [GNU Stow](https://www.gnu.org/software/stow).

## Personal installation notes

#### Things that I might want to backup manually

- `~/.local/share/fish/fish_history`
- uBlock Origin filters & settings
- Twitch FFZ & Previews settings
- ViolentMonkey userscripts & options
- YouTube Enhancer & SponsorBlock config
- Tabs and windows using Session Buddy
- Remote Torrent Adder config
- AniList Automail userscript config
- Flatpak apps (`~/.var/app/` or `flatpak list --columns=application --app`)

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
bas.eos.usbx.me
eos.usbx.me
scrutiny.bas.sh
```

//TODO: properly automate everything below

#### Clone dotfiles
```shell
git clone git@github.com:brw/dotfiles.git
```

#### Disable Intel pstate driver
Add `intel_pstate=disable` to the options in `/boot/entries/linux.conf`

#### Copy system files
```shell
sudo cp sysctl/etc/sysctld.d/* /etc/sysctl.d/
sudo cp zram/etc/systemd/zram-generator.conf /etc/systemd/
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
yay -Syu --needed $(cat arch-*-packages)
```

#### Install dotfiles
```
rm -rf ~/.config/fish
stow -d dotfiles bin cpupower direnv fish git gtk neofetch nvim pacman ripgrep mise starship stow terminator wayland yay
```

#### Update pkgfile database
```shell
sudo pkgfile -u
```

#### Enable timers
```shell
sudo systemctl enable --now yaycache.timer paccache.timer plocate-updatedb.timer
```

#### Enable printer service
```shell
sudo systemctl enable --now cups
```

#### Enable en_NL locale
```shell
sudo sed -i '/^#en_NL.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
```

#### Fix fish universal variables in Gnome Wayland session
modify `/usr/bin/gnome-session`, changing (hardcoding) `$SHELL` to `shell` on line 10.

temporary fix for https://github.com/fish-shell/fish-shell/issues/7995 (probably bad but /shrug, universal variables are sort of maybe [being removed](https://github.com/fish-shell/fish-shell/issues/7379) in the near future anyway, at which point I'll change this)

#### Fix scaling issues on Gnome Wayland
```shell
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

#### Unbind XF86Tools (F13) on Gnome
for some reason the button I have bound to F13 on my mouse opens the Gnome control center/settings by default, with no way to change it outside of dconf/gsettings. quite annoying
```shell
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center-static "['']"
```

#### Get latest plex-rich-presence
```shell
curl -s https://api.github.com/repos/Arno500/plex-richpresence/releases/latest \
    | jq -r '.assets[] | select(.name | contains("linux_amd64")).browser_download_url' \
    | wget -q -P $HOME -i - \
    && chmod +x $HOME/plex-rich-presence_linux_amd64-*
```

#### Copy systemd services
```shell
sudo cp systemd/etc/systemd/system/reload-cpu-modules.service /etc/systemd/system/
cp systemd/.config/systemd/user/plex-rich-presence.service ~/.config/systemd/user/
cp systemd/.config/systemd/user/imwheel.service ~/.config/systemd/user/
```

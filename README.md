# yeet

My dotfiles managed using [GNU Stow](https://www.gnu.org/software/stow).

## soo how do i

#### Copy system files
```bash
sudo cp pacman/etc/pacman.conf /etc/
sudo cp makepkg/etc/makepkg.conf /etc/
sudo cp sysctl/etc/sysctld.d/80-gamecompatibility.conf /etc/sysctl.d/
```

#### Install yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### Install multithreaded compression alternatives
```bash
yay -Sy pigz lbzip2 plzip
```

#### Import tor gpg key
```bash
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
```

#### Install packages 
```bash
yay -Syu --needed $(cat arch-*-packages)
```

#### Update pkgfile database
```bash
sudo pkgfile -u
```

#### Enable plocate updatedb timer
```bash
sudo systemctl enable plocate-updatedb.timer
sudo updatedb
```

#### Enable printer service
```bash
sudo systemctl enable --now cups
```

#### Set locale to en_NL
uncomment `en_NL.UTF-8 UTF-8` in `/etc/locale.gen`, then
```bash
sudo locale-gen
```

#### Fix fish universal variables in Gnome Wayland session
modify `/usr/bin/gnome-session`, changing (hardcoding) `$SHELL` to `bash` on line 10.

temporary fix for https://github.com/fish-shell/fish-shell/issues/7995 (probably bad but /shrug, universal variables are sort of maybe [being removed](https://github.com/fish-shell/fish-shell/issues/7379) in the near future anyway, at which point I'll change this)

#### Copy dotfiles
```
git clone git@github.com:brw/dotfiles.git
stow -d ~/dotfiles direnv fish git nvim ripgrep rtx starship stow bin terminator wayland imwheel plex-rich-presence cpupower
```

#### Disable Intel pstate driver
Add `intel_pstate=disable` to the options in `/boot/entries/linux.conf`

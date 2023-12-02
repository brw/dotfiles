# yeet

My dotfiles managed using [GNU Stow](https://www.gnu.org/software/stow).

## soo how do i

#### Install yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

#### Install packages 
```bash
yay -Syu --needed $(cat arch-*-packages)
```

#### Copy dotfiles
```
git clone git@github.com:brw/dotfiles.git
stow -d ~/dotfiles direnv fish git nvim ripgrep rtx starship stow bin imwheel plex-rich-presence
```

#### Copy system files
```bash
sudo cp pacman/etc/pacman.conf /etc/
sudo cp makepkg/etc/makepkg.conf /etc/
sudo cp sysctl/etc/sysctld.d/80-gamecompatibility.conf /etc/sysctl/etc/sysctld.d/
```

#### Disable Intel pstate driver
Add `intel_pstate=disable` to the options in `/boot/entries/linux.conf`

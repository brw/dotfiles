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
stow -d ~/dotfiles direnv fish git nvim ripgrep rtx starship stow
```

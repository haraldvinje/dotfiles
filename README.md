# dotfiles

Dotfiles for [Garuda Linux](https://garudalinux.org/) **i3**.

Managed with [rcm](https://github.com/thoughtbot/rcm).

## Quick start (new machine)

See **[docs/reinstall.md](docs/reinstall.md)** for the full Garuda + i3 checklist (packages, fonts, rcup, manual steps).

Short version:

```bash
sudo pacman -S --needed git rcm
git clone git@github.com:haraldvinje/dotfiles.git ~/.dotfiles
sudo pacman -S --needed - < ~/.dotfiles/packages/pacman.txt
paru -S --needed - < ~/.dotfiles/packages/aur.txt
sudo pacman -S --needed - < ~/.dotfiles/packages/fonts.txt
# optional: paru -S --needed - < ~/.dotfiles/packages/optional.txt
rcup -v -d ~/.dotfiles
chsh -s /bin/zsh
```

Bring your own wallpapers into `~/Pictures/Wallpapers/`.

## Day-to-day

```bash
mkrc -v ~/.some/config     # start tracking a file
rcup -v -d ~/.dotfiles     # re-apply links
```

## Package lists

| File | Purpose |
|------|---------|
| `packages/pacman.txt` | Official repo delta |
| `packages/aur.txt` | AUR / Chaotic (paru) |
| `packages/fonts.txt` | Nerd / UI fonts |
| `packages/optional.txt` | Chrome, editors, Docker, … |


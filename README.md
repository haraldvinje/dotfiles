# dotfiles

Dotfiles for [Garuda Linux](https://garudalinux.org/) **i3**.

Managed with [rcm](https://github.com/thoughtbot/rcm).

## Quick start (new machine)

See **[docs/reinstall.md](docs/reinstall.md)** for the full Garuda + i3 checklist (packages, fonts, rcup, manual steps).

A client Mac is a parallel workstation, not a port: **[docs/mac.md](docs/mac.md)** (AeroSpace + Raycast + Ghostty, best effort).

Short version:

```bash
sudo pacman -S --needed git rcm
git clone git@github.com:haraldvinje/dotfiles.git ~/.dotfiles
sudo pacman -S --needed - < ~/.dotfiles/packages/pacman.txt
paru -S --needed - < ~/.dotfiles/packages/aur.txt
sudo pacman -S --needed - < ~/.dotfiles/packages/fonts.txt
# optional: paru -S --needed - < ~/.dotfiles/packages/optional.txt
RCRC=~/.dotfiles/rcrc rcup -v   # first run; afterwards ~/.rcrc is linked
chsh -s /bin/zsh
```

Wallpapers live in `~/Pictures/Wallpapers/` (not in git). Login randomizes with `feh`. Grow the folder from Wallhaven (SFW landscapes, 1920×1080+):

```bash
desk theme fetch 8     # download into the library
desk theme catalog     # fetch / review / pick   (Alt+Shift+N)
desk theme review      # keep or skip one at a time (Alt+Shift+F)
```

`desk` is the desktop command router (Super+Space). After `rcup`, run `desk help`. Super+Space → **Defaults: apps** sets browser, terminal, files, editor, PDF, and image viewer; Super+Return / Super+B / Super+F8 / Super+F2 open those defaults.

Claude Code and Cursor **prefs** are tracked (`claude/settings.json`, `config/Cursor/User/settings.json`, `cursor/mcp.json`). OAuth, sessions, and `~/.claude.json` stay on the machine.

## Day-to-day

```bash
mkrc -v ~/.some/config     # start tracking a file
rcup -v                    # re-apply links (settings in rcrc)
```

## Package lists

| File | Purpose |
|------|---------|
| `packages/pacman.txt` | Official repo packages the configs need (beyond stock Garuda i3) |
| `packages/aur.txt` | AUR / Chaotic packages the configs need (paru) |
| `packages/fonts.txt` | Nerd / UI fonts |
| `packages/tools.txt` | CLI tools nothing in the configs calls |
| `packages/optional.txt` | Chrome, editors, Docker, … |
| `packages/ignore.txt` | Installed but not reinstalled (Garuda base, one-offs) |
| `packages/primary` | Which machine may edit the lists |

For the configs to work you need `pacman`, `aur` and `fonts`. The rest is up to you.

Every explicitly installed package should be in exactly one list. `full-update` reports any drift at the end. To fix it:

```bash
pkgs status    # untracked / missing packages
pkgs triage    # file each one: [p]acman [a]ur [f]onts [t]ools [o]ptional [i]gnore [s]kip
```

If you're unsure about a package, press `s` to skip it. Skipped packages come up again next time, so nothing gets filed by guessing.

Only the **primary** machine edits the lists. `packages/primary` holds a hash of its `/etc/machine-id`, so a second laptop with the same hostname still counts as secondary. On a secondary, `pkgs status` shows what's missing there and `pkgs triage` refuses to run. After reinstalling the primary, run `pkgs set-primary` once and commit `packages/primary`.

Bringing an existing machine with old configs up to date: see [docs/reinstall.md → Existing machine](docs/reinstall.md#existing-machine-old-configs).


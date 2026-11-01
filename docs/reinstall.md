# Garuda Linux + i3 — reinstall checklist

Target: **Garuda** with the **i3** session. Wallpapers stay local (`~/Pictures/Wallpapers/`).

Do **not** put secrets in this repo (SSH private keys, GPG private keys, AWS creds, `.env`, browser profiles, tokens).

---

## 1. Install the OS

1. Install Garuda Linux and pick the **i3** edition / session.
2. Create your user, reboot, log into **i3**.
3. Connect to the network; run a system update if the installer suggests it.

## 2. Clone dotfiles + rcm

```bash
sudo pacman -S --needed git && paru -S --needed rcm   # rcm is AUR-only
git clone git@github.com:haraldvinje/dotfiles.git ~/.dotfiles
# or HTTPS if SSH is not ready yet:
# git clone https://github.com/haraldvinje/dotfiles.git ~/.dotfiles
```

SSH: generate a key, add it to GitHub, then use the SSH remote.

## 3. Packages (prompted — run each block when you want it)

The configs need `pacman.txt`, `aur.txt` and `fonts.txt`. `tools.txt` and `optional.txt` are extras.

### Official (pacman)

```bash
sudo pacman -S --needed - < ~/.dotfiles/packages/pacman.txt
```

### AUR (paru) — separate on purpose

```bash
paru -S --needed - < ~/.dotfiles/packages/aur.txt
```

### Fonts (glyphs / polybar / nerd fonts)

```bash
sudo pacman -S --needed - < ~/.dotfiles/packages/fonts.txt
fc-cache -fv
```

### Tools (CLI extras the configs don't call)

```bash
sudo pacman -S --needed - < ~/.dotfiles/packages/tools.txt
```

### Optional (Chrome, editors, Docker, …)

Defaults in `.profile` / `mimeapps.list` expect **Google Chrome**. If you skip it, change `BROWSER` and the http(s) mime handlers after `rcup`.

```bash
paru -S --needed - < ~/.dotfiles/packages/optional.txt
```

## 4. Apply configs

```bash
cd ~
RCRC=~/.dotfiles/rcrc rcup -v
```

This links shell, i3, polybar, themes, mime defaults, etc.

## 5. Shell + session defaults

```bash
chsh -s /bin/zsh   # if not already zsh
```

Confirm LightDM / greeter session is **i3** (Garuda usually does this).

Optional after Chrome/Terminator are installed:

```bash
xdg-settings set default-web-browser google-chrome.desktop
# or: Super+Space → Defaults: apps
```

## 6. Wallpapers

Login uses `feh --randomize` on `~/Pictures/Wallpapers/`. Seed it however you like:

```bash
mkdir -p ~/Pictures/Wallpapers
desk theme fetch 8    # SFW Wallhaven landscapes
# or copy your own files here
```

Alt+Shift+N opens the catalog (fetch / review / pick). Images stay out of git.

## 7. Manual / once-per-machine

| Item | Notes |
|------|--------|
| **GPG** | Create or import a key; update `signingkey` in `~/.gitconfig` if the id differs. Never commit the private key. |
| **SSH** | `~/.ssh` stays local; add public key to GitHub. |
| **gh** | `gh auth login` |
| **asdf** | Plugins + `asdf install` from `~/.tool-versions` (after `asdf-vm` from AUR) |
| **displays** | Host-specific, not in git. Login / dock / Super+Shift+o run `~/.screenlayout/<name>.sh` via `monitor-map`. New desk: arandr → Save As `~/.screenlayout/work.sh`, then add that name next to the office SSID in `config/i3/scripts/monitor-map`. Undocked rows can keep the autorandr `laptop` profile. |
| **Docker** | If installed: enable service, add user to `docker` group |
| **JetBrains Toolbox** | Optional; `.profile` only adds its PATH if present |

## 8. First-login sanity

1. Relogin (or reboot) so `.profile` / theme env vars apply.
2. Mod+Return → Terminator; `ranger` → image preview (w3m).
3. Polybar icons look correct (fonts step).
4. GTK apps dark + Papirus (Qogir).

## Existing machine (old configs)

For a laptop that already runs Garuda i3 but has old configs, maybe from an older clone of this repo. You can stop after any step.

**1. Snapshot first.** Garuda takes btrfs snapshots, so make one by hand (`sudo snapper -c root create -d "before dotfiles"`, or use btrfs-assistant). Also back up your home configs, since snapper's root config usually doesn't include `/home`:

```bash
tar czf ~/dotfiles-before-$(date +%F).tgz -C ~ .config .zshrc .profile .gitconfig .scripts 2>/dev/null
```

**2. Get the repo.**

```bash
# no clone yet:
git clone git@github.com:haraldvinje/dotfiles.git ~/.dotfiles
# old clone: keep any local edits aside, then update
cd ~/.dotfiles && git status && git stash && git pull
```

**3. Install only what the configs need.** `pkgs` isn't on PATH yet, so call it from the repo. It installs only what's missing on this machine:

```bash
P=~/.dotfiles/scripts/pkgs
$P missing pacman fonts | sudo pacman -S --needed -
$P missing aur | paru -S --needed -
```

Leave out `tools` and `optional` unless you want them. This laptop isn't the primary (see `packages/primary`), so `pkgs` won't let it edit the lists.

**4. See what `rcup` would replace.**

```bash
RCRC=~/.dotfiles/rcrc lsrc | while IFS=: read -r dst src; do
  if [ -L "$dst" ]; then [ "$(readlink "$dst")" = "$src" ] || echo "LINK $dst -> $(readlink "$dst")"
  elif [ -e "$dst" ]; then echo "FILE $dst"; fi
done
```

`FILE` is an old real file and `LINK` is a symlink pointing somewhere else. `rcup` asks about each of them. To skip the prompts, move them all into a backup folder (same paths, so they're easy to compare later):

```bash
B=~/dotfiles-backup-$(date +%F); RCRC=~/.dotfiles/rcrc lsrc | while IFS=: read -r dst src; do
  if { [ -e "$dst" ] || [ -L "$dst" ]; } && [ "$(readlink "$dst")" != "$src" ]; then
    mkdir -p "$B/$(dirname "${dst#$HOME/}")" && mv "$dst" "$B/${dst#$HOME/}"
  fi
done; echo "moved to $B"
```

The two `colors.generated.*` links under polybar/rofi aren't in the repo any more, so they don't show up here. `desk` recreates them.

**5. Link.**

```bash
cd ~ && RCRC=~/.dotfiles/rcrc rcup -v
find ~ -maxdepth 4 -xtype l -lname "$HOME/.dotfiles/*" -print   # dead links from files the repo no longer has
```

Delete the dead links the `find` lists, once you've checked them (add `-delete` to remove them all).

**6. Session.** `chsh -s /bin/zsh` if needed, then log out and back in. i3 runs `desk theme ensure`, which writes the bar and rofi colors. If something looks wrong, compare with the backup folder, or restore the snapshot.

## What is intentionally not in the repo

- Wallpapers
- SSH / GPG private material
- Cloud credentials (`~/.aws`, etc.)
- Browser / Slack / IDE account data
- Claude / Cursor OAuth, sessions, `~/.claude.json` (prefs and MCP server *commands* are tracked)
- Host-specific autorandr profiles (re-save per machine)

## Updating later

```bash
cd ~/.dotfiles && git pull
rcup -v
pkgs status    # what's missing on this machine (or drift, on the primary)
```

Desktop extras (`desk`, clipboard history, OCR/QR) need the packages in `pacman.txt` / `aur.txt` (`jq`, `maim`, `tesseract`, `tesseract-data-eng`, `zbar`, `flameshot`, `rofi-greenclip`). Super+Space opens the command palette. English OCR needs `tesseract-data-eng`.

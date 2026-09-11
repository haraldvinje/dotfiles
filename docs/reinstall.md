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
sudo pacman -S --needed git rcm
git clone git@github.com:haraldvinje/dotfiles.git ~/.dotfiles
# or HTTPS if SSH is not ready yet:
# git clone https://github.com/haraldvinje/dotfiles.git ~/.dotfiles
```

SSH: generate a key, add it to GitHub, then use the SSH remote.

## 3. Packages (prompted — run each block when you want it)

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

### Optional (Chrome, editors, Docker, …)

Defaults in `.profile` / `mimeapps.list` expect **Google Chrome**. If you skip it, change `BROWSER` and the http(s) mime handlers after `rcup`.

```bash
paru -S --needed - < ~/.dotfiles/packages/optional.txt
```

## 4. Apply configs

```bash
cd ~
rcup -v -d ~/.dotfiles
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
rcup -v -d ~/.dotfiles
# then package lists if they changed
```

Desktop extras (`desk`, clipboard history, OCR/QR) need the packages in `pacman.txt` / `aur.txt` (`jq`, `maim`, `tesseract`, `tesseract-data-eng`, `zbar`, `flameshot`, `rofi-greenclip`). Super+Space opens the command palette. English OCR needs `tesseract-data-eng`.

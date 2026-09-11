# Apply this setup to a Mac (best effort)

This repo is **Garuda Linux + i3**. A client Mac should feel *close enough*, not identical. Do not port i3, polybar, rofi, or `desk`. Expect to fix paths and keybinds on the machine.

If they force Windows instead: WSL2 for the Unix bits, komorebi + PowerToys Run for the desktop. Heavier compromise. Pick Mac when the choice is real.

## What to keep vs replace

| Linux now | On the Mac |
|-----------|------------|
| i3 (`$mod` = Super, hjkl, 1–0 workspaces) | [AeroSpace](https://github.com/nikitabobko/AeroSpace). Skip yabai (SIP, MDM). |
| rofi + `desk` (Super+Space) | [Raycast](https://www.raycast.com/). Spotlight if they lock you down. |
| Terminator | Ghostty (or Kitty). Same zsh. |
| Super+Ctrl+W / B / A (wifi / bt / audio TUIs) | Control Center. Not worth a TUI port. |
| greenclip | Raycast clipboard (or Maccy). |
| polybar | Menu bar + AeroSpace workspace labels. SketchyBar only if you miss a bar enough to maintain it. |
| dunst | Native notifications. |
| caps ↔ escape (`setxkbmap`) | Karabiner-Elements. This is the one remap that is worth doing on day one. |
| autorandr / feh / wal / Wallhaven fetch | System Settings displays + a wallpaper. Don’t port wal or `desk theme`. |
| cava / wiremix / pavucontrol | Skip. Volume is the menu bar. |
| pacman / paru / `full-update` | Homebrew. |
| Cursor, Claude, Antigravity, git, asdf | Same tools. |

**Don’t bother:** `scripts/desk`, `config/i3`, polybar, picom, dunst, rofi, GTK/Kvantum, mimeapps, terminator. Those are the Linux desktop. On client MDM, unsigned kexts and “make it look like Garuda” will fight you.

The part that transfers is keyboard window management plus the same terminal, git, and language tools.

## First week (order)

1. **Homebrew**, then Karabiner (Caps ↔ Esc), Ghostty, AeroSpace, Raycast.
2. Clone this repo. **Do not** `rcup` the whole tree. Link only the portable bits (below).
3. AeroSpace muscle memory: Option as `$mod` (closer to i3; Command stays copy/paste). hjkl focus, 1–0 workspaces, Shift+1–0 move. Decide Command vs Option on day one and stick to it.
4. Raycast: clipboard history, emoji, window switcher. Add at most a few user scripts (e.g. open Ghostty in `~/Documents/Programming`). Super+Space on Linux is this, not `desk`.
5. Same agents: Cursor + Claude / agy. No desk agent picker.

Rough Homebrew start (formula names drift; fix on the machine):

```bash
# CLI
brew install git git-lfs gh rcm zsh starship asdf antigen neovim ranger lsd fzf fd jq

# Desktop
brew install --cask ghostty karabiner-elements raycast
brew install --cask nikitabobko/tap/aerospace
brew install --cask cursor visual-studio-code google-chrome
```

Fonts you actually miss: a Nerd Font (Hack or Iosevka) via `brew install --cask font-hack-nerd-font` or similar.

## What to symlink (and what not to)

`rcm` exists on Mac (`brew install rcm`). A full `rcup -d ~/.dotfiles` will also plant i3/polybar/GTK files you do not want.

Either:

- `ln -s` the files below by hand, or
- add a `~/.rcrc` with a fat `EXCLUDES` list, then `rcup`.

**Usually fine**

| Repo path | Typical home path |
|-----------|-------------------|
| `gitconfig` | `~/.gitconfig` (GPG: install `pinentry-mac`, import the key) |
| `tool-versions` | `~/.tool-versions` after asdf plugins exist |
| `config/starship.toml` | `~/.config/starship.toml` |
| `config/nvim` | `~/.config/nvim` |
| `vimrc` | `~/.vimrc` |
| `scripts/asdf-update` | `~/.scripts/asdf-update` |
| `scripts/set-aws-profile`, `scripts/cwlogs` | `~/.scripts/…` if you still use them |
| `config/Code/User/settings.json` | VS Code user settings (strip Linux-only terminal profiles) |
| `config/Cursor/User/settings.json` | Cursor user settings (keybindings already shared with Code) |
| `claude/settings.json` | `~/.claude/settings.json` (prefs only; login stays local) |
| `cursor/mcp.json` | `~/.cursor/mcp.json` (commands, no tokens) |

**Leave on Linux**

`config/i3`, `config/polybar`, `config/picom.conf`, `config/dunst`, `config/rofi`, `config/terminator`, GTK/Kvantum/qt6ct, `config/mimeapps.list`, `config/xfce4`, `Xresources`, `gtkrc-2.0`, `scripts/desk`, `scripts/full-update`, `scripts/swap-caps-escape`, `profile` (Qt/GTK/ibus).

## Shell (`zshrc`)

The tracked `zshrc` is Arch-shaped. It will not source cleanly as-is:

- `source /usr/share/zsh/share/antigen.zsh` → Homebrew antigen (often `$(brew --prefix)/share/antigen/antigen.zsh`)
- fzf / fzf-tab under `/usr/share/...` → `$(brew --prefix)/opt/fzf/shell/...` and a Homebrew fzf-tab, or skip fzf-tab at first
- `CHROME_EXECUTABLE='/usr/bin/google-chrome-stable'`
- pacman / yay / reflector / grub aliases — harmless if unused, noisy if you tab-complete them
- `ls --color=auto` is GNU; macOS `ls` wants `ls -G` (you already alias `l`/`ll` to `lsd` if that is installed)
- `eval "$(starship init zsh)"` and asdf shims should work once both are on PATH

Practical approach: copy `zshrc` once, patch the three hard-coded `/usr/share` paths, put Mac-only aliases in `~/.zshrc-personal` (already sourced). Do not try to keep one file perfect for both OSes until you have lived on the Mac for a week.

asdf: `brew install asdf`, then the same plugins as `tool-versions`. `scripts/asdf-update` should work if asdf is on PATH.

## AeroSpace (rough bind map)

Linux `$mod` is Super (Mod4). On Mac, prefer **Option** as the tiling modifier so Command stays system shortcuts.

Aim for the same verbs, not the same config file:

| i3 now | AeroSpace-ish |
|--------|----------------|
| `$mod`+hjkl | focus |
| `$mod`+Shift+hjkl | move |
| `$mod`+1–0 | workspace 1–10 |
| `$mod`+Shift+1–0 | move node to workspace |
| `$mod`+Return | Ghostty |
| `$mod`+Space | Raycast (not `desk menu`) |
| `$mod`+f / `$mod`+e | fullscreen / toggle tiling vs floating — use AeroSpace’s equivalents |
| scratchpad / marks | skip; they will not feel the same |

Copy `~/.config/aerospace/aerospace.toml` into this repo later, once it exists. Do not invent a full toml here.

## Raycast vs `desk`

Port the *verbs you actually hit*, not the palette JSON.

Worth a Raycast script or snippet: open project folder, clipboard history, emoji, lock screen. Not worth it: wifi TUI, polybar weather, Wallhaven catalog, mime default picker.

## Secrets and client policy

Same rules as [reinstall.md](reinstall.md): no SSH/GPG private keys, AWS creds, or browser profiles in git. Generate a new SSH key on the Mac, add it to GitHub, import GPG if you still want signed commits (`gpgsign = true` in `gitconfig`).

Client MDM may block Karabiner, AeroSpace, or Homebrew in `/opt/homebrew`. If something is blocked, drop that piece rather than jailbreaking the laptop.

## After it works

When the Mac is tolerable, dump real configs back here (AeroSpace toml, Karabiner `caps_lock` → `escape`, Ghostty, a `~/.rcrc` exclude list). This doc stays a checklist until those files exist.

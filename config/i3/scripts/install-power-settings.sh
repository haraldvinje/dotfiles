#!/usr/bin/env bash
set -euo pipefail

src="/home/harald/.config/i3/systemd/logind.d/50-no-auto-suspend.conf"
dest="/etc/systemd/logind.conf.d/50-no-auto-suspend.conf"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run with sudo to install logind settings:" >&2
  echo "  sudo $0" >&2
  exit 1
fi

install -d /etc/systemd/logind.conf.d
install -m 644 "$src" "$dest"
systemctl restart systemd-logind

if ! /usr/bin/pacman -Q xfce4-power-manager >/dev/null 2>&1; then
  echo "Installing xfce4-power-manager..."
  /usr/bin/pacman -S --needed --noconfirm xfce4-power-manager
fi

echo "Done. Reload i3 or restart xfce4-power-manager:"
echo "  pkill -x xfce4-power-manager; xfce4-power-manager &"

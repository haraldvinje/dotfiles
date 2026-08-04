# Start ibus if available (ignore if missing).
command -v ibus-daemon >/dev/null && ibus-daemon -d -x

export EDITOR=/usr/bin/micro
export BROWSER=google-chrome-stable
export TERMINAL=terminator
export MAIL=thunderbird
# Match i3 session: qt6ct + Kvantum. Do not force TERM — terminals set their own.
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# JetBrains Toolbox (only if installed)
[ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ] && \
  PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

# GTK4 / libadwaita dark (pavucontrol, etc.)
export GTK_THEME=Qogir-Dark:dark
export GTK_APPLICATION_PREFER_DARK_THEME=1

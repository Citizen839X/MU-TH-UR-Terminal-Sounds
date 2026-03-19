#!/bin/bash
# ==========================================================
# MU-TH-UR 6000 - UNIVERSAL TERMINAL INSTALLER
# SERIAL: WAYLAND-YUTANI#056709
#
# Copyright (C) 2026 Carlo Sitaro
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License.
# ==========================================================

#!/bin/bash
# ==========================================================
# MU-TH-UR 6000 - UNIVERSAL TERMINAL INSTALLER
# SERIAL: WAYLAND-YUTANI#056709
# ==========================================================

echo "--- INITIALIZING WEYLAND-YUTANI DEPLOYMENT ---"

# 1. Dependency Check
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        opensuse*|suse) sudo zypper install -y fish sox pv ;;
        ubuntu|debian|pop|mint) sudo apt update && sudo apt install -y fish sox pv ;;
        arch|manjaro) sudo pacman -S --noconfirm fish sox pv ;;
        *) echo "ERROR: Unsupported OS. Install fish, sox, pv manually."; exit 1 ;;
    esac
fi

# 2. Sound Asset Deployment (Corrected Folder Name)
DEST_DIR="$HOME/sounds_terminal"
SRC_DIR="./sounds_terminal"

echo "--- DEPLOYING AUDIO ASSETS TO $DEST_DIR ---"
mkdir -p "$DEST_DIR"

if [ -d "$SRC_DIR" ]; then
    cp "$SRC_DIR"/*.ogg "$DEST_DIR/"
    echo "ASSETS DEPLOYED SUCCESSFULLY."
else
    echo "ERROR: Source folder '$SRC_DIR' not found in current directory."
    exit 1
fi

# 3. Fish Configuration (Universal Pathing)
FISH_CONF="$HOME/.config/fish/config.fish"
mkdir -p "$HOME/.config/fish"

cat << 'EOF' > "$FISH_CONF"
# --- MU-TH-UR 6000 CORE INTERFACE ---
# AUTH_CODE: WAYLAND-YUTANI#056709

function fish_greeting
    set -l AUDIO_PATH "$HOME/sounds_terminal"
    
    # Background Ambient Loop
    setsid sh -c "while true; do play -q $AUDIO_PATH/wait.ogg $AUDIO_PATH/installation_loop.ogg $AUDIO_PATH/wait.ogg; done" >/dev/null 2>&1 & disown

    # Startup Sequence
    setsid play -q $AUDIO_PATH/start.ogg >/dev/null 2>&1 & disown
    
    echo "----------------------------------------" | pv -qL 100
    echo "   MU-TH-UR 6000 SYSTEMS - INTERFACE    " | pv -qL 100
    setsid play -q $AUDIO_PATH/message.ogg >/dev/null 2>&1 & disown
    echo "----------------------------------------" | pv -qL 100
    echo " STATUS: STABLE                         " | pv -qL 100
    echo " CORE: ACTIVE                           " | pv -qL 100
    echo " AUTH: WAYLAND-YUTANI#056709            " | pv -qL 100
    echo " USER: $USER                            " | pv -qL 100
    echo "----------------------------------------" | pv -qL 100
    echo " READY FOR INPUT...                     " | pv -qL 100
end

function on_command_exec --on-event fish_preexec
    if not string match -q "exit" $argv
        setsid play -q "$HOME/sounds_terminal/command.ogg" >/dev/null 2>&1 & disown
    end
end

function on_exit_cleanup --on-event fish_exit
    pkill -f "$HOME/sounds_terminal/" >/dev/null 2>&1
    killall play >/dev/null 2>&1
    play -q "$HOME/sounds_terminal/logout.ogg"
end
EOF

echo "--- INSTALLATION COMPLETE. RESTART FISH SHELL. ---"

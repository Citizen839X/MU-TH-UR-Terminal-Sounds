#!/bin/bash
# ==========================================================
# MU-TH-UR 6000 - UNIVERSAL TERMINAL INSTALLER v.1.1.5
# SERIAL: WAYLAND-YUTANI#056709
# ==========================================================

echo "--- INITIALIZING WEYLAND-YUTANI DEPLOYMENT v.1.1.5 ---"

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

# 2. Strict Sound Asset Deployment (Only 4 Core Files)
DEST_DIR="$HOME/sounds_terminal"
SRC_DIR="./sounds_terminal"

echo "--- DEPLOYING CORE AUDIO ASSETS TO $DEST_DIR ---"
mkdir -p "$DEST_DIR"

if [ -d "$SRC_DIR" ]; then
    # Selective transfer of the 4 core pillars
    cp "$SRC_DIR/bkg_loop.ogg" "$DEST_DIR/" 2>/dev/null
    cp "$SRC_DIR/start.ogg" "$DEST_DIR/" 2>/dev/null
    cp "$SRC_DIR/message.ogg" "$DEST_DIR/" 2>/dev/null
    cp "$SRC_DIR/logout.ogg" "$DEST_DIR/" 2>/dev/null
    
    echo "CORE ASSETS DEPLOYED: bkg_loop, start, message, logout."
else
    echo "ERROR: Source folder '$SRC_DIR' not found."
    exit 1
fi

# 3. Fish Configuration (v.1.1.5 - Minimalist & Error-Aware)
FISH_CONF="$HOME/.config/fish/config.fish"
mkdir -p "$HOME/.config/fish"

cat << 'EOF' > "$FISH_CONF"
# --- MU-TH-UR 6000 CORE INTERFACE v.1.1.5 ---
# AUTH_CODE: WAYLAND-YUTANI#056709

function fish_greeting
    set -l AUDIO_PATH "$HOME/sounds_terminal"
    
    # Background Ambient Loop (Continuous & Gapless)
    play -q "$AUDIO_PATH/bkg_loop.ogg" repeat - >/dev/null 2>&1 & disown

    # Startup Sequence
    play -q "$AUDIO_PATH/start.ogg" >/dev/null 2>&1 & disown
    
    echo "----------------------------------------" | pv -qL 100
    echo "    MU-TH-UR 6000 SYSTEMS - INTERFACE    " | pv -qL 100
    play -q "$AUDIO_PATH/message.ogg" >/dev/null 2>&1 & disown
    echo "----------------------------------------" | pv -qL 100
    echo " STATUS: STABLE (v.1.1.5)               " | pv -qL 100
    echo " CORE: ACTIVE                           " | pv -qL 100
    echo " AUTH: WAYLAND-YUTANI#056709            " | pv -qL 100
    echo " USER: $USER                            " | pv -qL 100
    echo "----------------------------------------" | pv -qL 100
    echo " READY FOR INPUT...                     " | pv -qL 100
end

# Error Feedback (e.g., Root privileges required / Syntax error)
function on_command_error --on-event fish_postexec
    if test $status -ne 0
        play -q "$HOME/sounds_terminal/message.ogg" >/dev/null 2>&1 & disown
    end
end

# Cleanup on Shell Exit
function on_exit_cleanup --on-event fish_exit
    killall play >/dev/null 2>&1
    play -q "$HOME/sounds_terminal/logout.ogg"
end
EOF

# --- MISSION COMPLETE SIGNAL ---
echo "----------------------------------------"
echo "--- v.1.1.5 INSTALLATION COMPLETE.   ---"
echo "--- RESTART FISH SHELL TO ACTIVATE.  ---"
echo "----------------------------------------"

# 🔊 Triggering message.ogg as a success chime for the installer itself
if [ -f "$DEST_DIR/message.ogg" ]; then
    play -q "$DEST_DIR/message.ogg" >/dev/null 2>&1 &
fi

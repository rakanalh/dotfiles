#!/usr/bin/env bash
#
# Staged KDE / Wayland autostart orchestrator.
#
# Launches apps one desktop at a time, walking from the highest-numbered
# virtual desktop down to 1, and does NOT advance to the next desktop until the
# current app's window has actually appeared. Each window is then pinned to its
# target desktop and moved to the target monitor by absolute X coordinate
# (KWin's per-app "screen" rule is unreliable on Wayland). Ends on desktop 1.
#
# This script is meant to be the SOLE autostart launcher for these apps — the
# individual ~/.config/autostart/*.desktop entries have been disabled so they
# don't race/double-launch.
#
# Requires kdotool (drives KWin scripting, so it sees native-Wayland windows).
# The script self-heals: if kdotool is missing it tries `cargo install kdotool`.

set -uo pipefail
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

log()    { printf '%s  %s\n' "$(date +%H:%M:%S)" "$*" >&2; }
notify() { command -v notify-send >/dev/null 2>&1 && notify-send -a "Staged Autostart" "Staged Autostart" "$1" || true; }

# ---- Monitor X origins (verified via kscreen-doctor) -----------------------
LEFT_X=0        # DP-2  (geometry 0,0)
RIGHT_X=2560    # DP-1  (geometry 2560,0)

WAIT_TIMEOUT=25 # seconds to wait for a window before giving up on it

# ---------------------------------------------------------------------------
# Guarantee kdotool is present before doing anything else.
# ---------------------------------------------------------------------------
ensure_kdotool() {
    if command -v kdotool >/dev/null 2>&1; then
        return 0
    fi
    log "kdotool not found — attempting 'cargo install kdotool'"
    notify "kdotool missing — installing via cargo…"
    if command -v cargo >/dev/null 2>&1 && cargo install kdotool >/dev/null 2>&1 \
        && command -v kdotool >/dev/null 2>&1; then
        log "kdotool installed"
        return 0
    fi
    log "FATAL: kdotool unavailable and install failed — aborting."
    notify "kdotool unavailable — staged autostart aborted. Install kdotool and re-login."
    return 1
}

# ---------------------------------------------------------------------------
# Wait until a window whose class matches $1 exists; print its id.
# $2 = timeout seconds. Returns non-zero on timeout.
# ---------------------------------------------------------------------------
wait_for_window() {
    local pat="$1" timeout="${2:-$WAIT_TIMEOUT}" waited=0 id=""
    while :; do
        id=$(kdotool search --class "$pat" 2>/dev/null | head -1)
        if [ -n "$id" ]; then
            echo "$id"
            return 0
        fi
        if awk "BEGIN{exit !($waited >= $timeout)}"; then
            return 1
        fi
        sleep 0.25
        waited=$(awk "BEGIN{print $waited + 0.25}")
    done
}

# ---------------------------------------------------------------------------
# Wait for a NEW window of class $1 (one whose id is not in the pre-launch set
# $3). Prevents grabbing an already-open window of the same class. Prints id.
# ---------------------------------------------------------------------------
wait_for_new_window() {
    local pat="$1" timeout="${2:-$WAIT_TIMEOUT}" before=" $3 " waited=0 id
    while :; do
        for id in $(kdotool search --class "$pat" 2>/dev/null); do
            case "$before" in
                *" $id "*) : ;;              # already existed, skip
                *) echo "$id"; return 0 ;;   # brand-new window
            esac
        done
        if awk "BEGIN{exit !($waited >= $timeout)}"; then return 1; fi
        sleep 0.25
        waited=$(awk "BEGIN{print $waited + 0.25}")
    done
}

# ---------------------------------------------------------------------------
# launch_place <desktop-N> <target-x> <class-pattern> <launch cmd...>
#   Launch the app, wait for its NEW window, pin it to the desktop and move it
#   to the target monitor.
# ---------------------------------------------------------------------------
launch_place() {
    local desk="$1" tx="$2" pat="$3"; shift 3
    local before; before=$(kdotool search --class "$pat" 2>/dev/null | tr '\n' ' ')
    log "D${desk}: launching '$*'  (class~${pat})"
    setsid "$@" >/dev/null 2>&1 &

    local id
    if id=$(wait_for_new_window "$pat" "$WAIT_TIMEOUT" "$before"); then
        log "D${desk}: new window ${id} up → pin desktop=${desk}, x=${tx}"
        kdotool set_desktop_for_window "$id" "$desk" >/dev/null 2>&1
        kdotool windowmove "$id" "$tx" y      >/dev/null 2>&1
    else
        log "D${desk}: TIMEOUT (${WAIT_TIMEOUT}s) waiting for class~${pat} — continuing"
        notify "Timed out waiting for '${pat}' on desktop ${desk}"
    fi
}

# ---------------------------------------------------------------------------
# launch_place_all <desktop-N> <target-x> <class-pattern> <launch cmd...>
#   Like launch_place, but after the first new window appears, place EVERY
#   window of that class (e.g. Firefox session-restore opens several windows).
# ---------------------------------------------------------------------------
launch_place_all() {
    local desk="$1" tx="$2" pat="$3"; shift 3
    local before; before=$(kdotool search --class "$pat" 2>/dev/null | tr '\n' ' ')
    log "D${desk}: launching '$*'  (class~${pat}, place-all)"
    setsid "$@" >/dev/null 2>&1 &

    if wait_for_new_window "$pat" "$WAIT_TIMEOUT" "$before" >/dev/null; then
        sleep 2   # let any remaining session-restore windows come up
        local id
        for id in $(kdotool search --class "$pat" 2>/dev/null); do
            kdotool set_desktop_for_window "$id" "$desk" >/dev/null 2>&1
            kdotool windowmove "$id" "$tx" y             >/dev/null 2>&1
        done
        log "D${desk}: placed all '${pat}' windows → desktop=${desk}, x=${tx}"
    else
        log "D${desk}: TIMEOUT (${WAIT_TIMEOUT}s) waiting for class~${pat} — continuing"
        notify "Timed out waiting for '${pat}' on desktop ${desk}"
    fi
}

# launch_bg <class-or-label> <launch cmd...>
#   Fire-and-forget launch (no window to wait for, e.g. systray apps).
launch_bg() {
    local label="$1"; shift
    log "bg: launching '$*'  (${label})"
    setsid "$@" >/dev/null 2>&1 &
}

main() {
    ensure_kdotool || exit 1

    # Let plasma/kwin finish coming up before we start driving desktops.
    sleep 3
    log "starting staged autostart"

    # ---- Desktop 4 : Discord (left) ----
    kdotool set_desktop 4; log "→ switched to D4"
    launch_place 4 "$LEFT_X"  "discord"  flatpak run com.discordapp.Discord

    # ---- Desktop 3 : Emacs (right), Ferdium (left) ----
    kdotool set_desktop 3; log "→ switched to D3"
    launch_place 3 "$RIGHT_X" "emacs"   emacs
    launch_place 3 "$LEFT_X"  "ferdium" flatpak run org.ferdium.Ferdium

    # ---- Desktop 2 : Alacritty (right), Slack (left) ----
    kdotool set_desktop 2; log "→ switched to D2"
    launch_place 2 "$RIGHT_X" "Alacritty" alacritty -e remux
    launch_place 2 "$LEFT_X"  "slack"     flatpak run com.slack.Slack

    # ---- Desktop 1 : TradingView (left), Firefox (all windows, right); qtpass to systray ----
    kdotool set_desktop 1; log "→ switched to D1"
    launch_place 1 "$LEFT_X"  "tradingview" flatpak run com.tradingview.tradingview
    launch_place_all 1 "$RIGHT_X" "firefox" firefox
    launch_bg "qtpass/systray" qtpass

    # Land on desktop 1 — and HOLD it. Late-mapping windows (Electron apps
    # finishing a cold start) can switch the view after the sequence ends, so
    # re-assert desktop 1 for a few seconds to win that race.
    log "settling on D1 (holding against late window maps)"
    local n
    for n in $(seq 1 8); do
        kdotool set_desktop 1 >/dev/null 2>&1
        sleep 1
    done
    log "done — resting on D1"
}

main "$@"

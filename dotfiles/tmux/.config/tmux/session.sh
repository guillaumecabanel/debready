#!/bin/sh
# Start a fresh tmux session pre-populated with the windows listed in
# ~/.config/tmux/windows.conf, then attach to it.
#
# windows.local.conf, if present, is read straight after and its windows are
# appended — that is where machine-specific projects live, so the tracked
# windows.conf can stay machine-neutral.
#
# Alacritty runs this in place of `tmux new-session` (see alacritty.toml), so it
# must stay quiet and it must fail loudly enough for the caller's
# `|| exec /bin/zsh` rescue hatch to take over.
#
# Sessions stay auto-named (1, 2, 3...) exactly as before: one per Alacritty
# window, independent of each other.

set -u

conf="${TMUX_WINDOWS_CONF:-$HOME/.config/tmux/windows.conf}"
local_conf="${TMUX_WINDOWS_LOCAL_CONF:-$HOME/.config/tmux/windows.local.conf}"

# Called from inside tmux already — do not nest.
[ -z "${TMUX:-}" ] || exit 0

session=""

# Reads a manifest on stdin. Fed by a redirect, never a pipe: the loop must run
# in this shell so that $session survives the call.
add_windows() {
  # Default IFS: $name takes the first field, $path takes the rest of the line
  # with surrounding whitespace stripped.
  while read -r name path || [ -n "${name:-}" ]; do
    case "$name" in ''|'#'*) continue ;; esac

    [ -n "$path" ] || path="~"
    case "$path" in
      '~')   dir="$HOME" ;;
      '~/'*) dir="$HOME/${path#\~/}" ;;
      *)     dir="$path" ;;
    esac
    [ -d "$dir" ] || dir="$HOME"

    if [ -z "$session" ]; then
      session=$(tmux new-session -d -P -F '#{session_name}' -n "$name" -c "$dir") || return 1
    else
      tmux new-window -d -t "$session:" -n "$name" -c "$dir" || return 1
    fi
  done
}

for c in "$conf" "$local_conf"; do
  [ -r "$c" ] || continue
  add_windows < "$c" || exit 1
done

# No manifest, or every manifest was empty or all comments.
[ -n "$session" ] || exec tmux new-session

tmux select-window -t "$session:^"
exec tmux attach-session -t "$session"

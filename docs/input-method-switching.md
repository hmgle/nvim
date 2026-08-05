# Input Method Switching

When Fcitx5 Rime is active, Neovim requests ASCII mode when leaving insert,
command-line, or terminal input. Normal and visual mode Escape mappings also
request the same target state before forwarding the key.

## tmux behavior

Neovim does not use the pane's SSH_* variables to decide whether a tmux
client is remote. Those variables belong to the process that created the pane
and can remain stale after another terminal attaches to the session.

For each switch request inside tmux, the configuration:

1. Resolves the pane's session ID.
2. Selects the most recently active client in that session.
3. Reads that client's environment on Linux from
   /proc/<client_pid>/environ.
4. Honors TMUX_IM_CLIENT=local or TMUX_IM_CLIENT=ssh before checking SSH_*
   and MOSH_* variables.
5. Executes the input-method command with the selected client's graphical and
   D-Bus environment.

If there is no attached client, or the client cannot be identified, the
request is ignored. This is intentional: an unknown source must not change a
desktop input method.

The client query is asynchronous and does not block Escape. It is a
best-effort attribution mechanism, not an atomic association between one tmux
key event and one Neovim callback. Rapidly alternating clients can still race.
For a strict Escape-only guarantee, handle Escape in the terminal or in a
tmux client-context binding and disable the duplicate Neovim action.

This design does not add a root Escape binding or depend on tmux's session-wide
environment. The existing tmux client environment is read directly, so no
DBus variables need to be copied into `update-environment` for this feature.

## Optional client markers

Markers are useful when the same tmux session is regularly attached from both
local and SSH terminals:

~~~sh
# Local desktop terminal
TMUX_IM_CLIENT=local tmux attach -t work

# SSH terminal
TMUX_IM_CLIENT=ssh tmux attach -E -t work
~~~

The marker must be set on the tmux client process. Do not use
tmux set-environment for this purpose because that environment is shared by
the whole session.

## Backend and overrides

The preferred backend is the Fcitx5 Rime D-Bus method
SetAsciiMode b true. The fcitx5-remote and fcitx-remote commands are fallbacks
with backend-specific semantics. The synthetic xdotool fallback remains
opt-in because it can wake an X11 display that is powered off.

Available environment switches are:

- NVIM_DISABLE_IM_SWITCH=1: disable all automatic switching.
- NVIM_ALLOW_REMOTE_IM_SWITCH=1: explicitly allow switching from a remote
  client.
- NVIM_ALLOW_UNKNOWN_IM_SWITCH=1: explicitly allow switching when the client
  source cannot be identified.
- NVIM_ALLOW_XDOTOOL_IM_SWITCH=1: allow the synthetic X11 fallback.

VimEnter is intentionally not used for automatic switching inside tmux,
because startup has no key source to attribute. The regular mode-leave,
Escape, and full-width punctuation paths remain available.

## Verification

With local and SSH clients attached to one session, test each client
independently:

~~~sh
tmux list-clients -t "$SESSION_ID" -O activity -r \
  -F '#{client_pid} #{client_tty}'
tr '\000' '\n' < /proc/$CLIENT_PID/environ
~~~

On the local desktop, the Rime state can be checked with:

~~~sh
busctl --user call org.fcitx.Fcitx5 /rime \
  org.fcitx.Fcitx.Rime1 IsAsciiMode
~~~

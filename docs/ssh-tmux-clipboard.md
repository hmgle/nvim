# SSH + tmux Clipboard Safety

This configuration uses a special clipboard provider when Neovim runs inside
a tmux session that is currently attached over SSH. The goal is to preserve
remote-to-local copying without allowing an outer terminal's OSC 52 response to
be interpreted as keyboard input by Neovim.

## Background

Neovim is configured with `clipboard=unnamedplus`, so code that reads the
default register normally reads the `+` register. Yanky loads on `VeryLazy` and
initializes its ring by reading that register. This means a clipboard read can
happen shortly after startup, without the user pressing a paste key.

Neovim's built-in tmux provider uses the following shape for a paste operation:

```sh
tmux refresh-client -l && sleep 0.05 && tmux save-buffer -
```

`refresh-client -l` asks the selected tmux client terminal for its clipboard.
The request is an OSC 52 query. A terminal that supports clipboard reads sends
the clipboard contents back as another OSC 52 sequence whose payload is
base64-encoded.

When that reply is delayed or split across reads, older tmux versions can stop
waiting after `escape-time` and reprocess the incomplete sequence as ordinary
input. The remaining base64 bytes then go to the active pane. In Neovim this
can appear as a file being modified immediately after it is opened.

The important direction is:

```text
Yanky startup read
  -> Neovim tmux paste provider
  -> tmux refresh-client -l
  -> outer terminal OSC 52 query reply
  -> tmux partial-key timeout
  -> literal bytes delivered to the active pane
```

This is not caused by base64 decoding in Neovim. The base64 is the payload of
the terminal protocol; it becomes visible because tmux stops consuming the
protocol sequence as a sequence.

## Configuration

For a remote tmux session, `lua/options.lua` installs the `tmux-quiet` provider:

- Copy uses `tmux load-buffer -w -` on tmux 3.2 and newer. This continues to
  forward Neovim yanks to the attached terminal clipboard.
- Paste uses `tmux save-buffer -` only. It reads tmux's existing paste buffer
  and never calls `refresh-client -l`.
- A missing tmux buffer is treated as an empty clipboard.
- Local desktop tmux sessions keep Neovim's normal provider selection.

The consequence is deliberate: clipboard contents copied in an outer desktop
application are not automatically imported into Neovim's `+` register. Use the
terminal's normal paste action, such as WezTerm or kitty's native paste
shortcut, to send that content directly to the active pane. That path does not
require an OSC 52 clipboard-read reply.

The provider override can be skipped with `NVIM_CLIPBOARD_PROVIDER=native`.
This only skips the configuration override; Neovim can still auto-detect tmux
if no higher-priority clipboard provider is available.

## Why Not Only Increase `escape-time`?

Increasing tmux's `escape-time` reduces the chance of a partial reply timing
out, but it is a finite timeout and is global to the tmux server. It can also
make Escape and Meta-key recognition feel slower. It is useful as defense in
depth for other terminal queries, but it does not remove the unsafe query path.

tmux has accepted a fix for this class of failure that raises the waiting
floor while tmux-owned queries are active, but the robust configuration still
avoids initiating the outer clipboard query:

- [tmux issue #5388: OSC 52 query replies can reach the active pane](https://github.com/tmux/tmux/issues/5388)
- [tmux commit 418ddada: increase the delay for tmux-owned queries](https://github.com/tmux/tmux/commit/418ddada23d290ab02417b62213b402a08f4d9b5)

## Neovim and Yanky

Neovim's `refresh-client -l` call is an intentional part of its tmux provider;
it is needed to make external clipboard paste work when the terminal responds.
The provider behavior itself is discussed in:

- [Neovim issue #36786: tmux provider paste behavior](https://github.com/neovim/neovim/issues/36786)

Yanky's `system_clipboard.sync_with_ring` option controls focus-based
synchronization. It does not disable `init_history()`, which reads the default
register during setup. With `tmux-quiet`, that read is local to tmux and no
longer starts an OSC 52 query, but `ring.storage = 'shada'` can still persist
the value read from tmux's buffer. If that persistence is not wanted, use
memory storage or defer Yanky initialization separately.

The startup-read behavior is tracked in:

- [yanky issue #237: unable to disable `sync_with_ring`](https://github.com/gbprod/yanky.nvim/issues/237)

## WezTerm

The current WezTerm terminal-state handler ignores OSC 52 clipboard queries but
handles OSC 52 clipboard writes. With WezTerm as the only attached tmux client,
the specific query-reply failure described above normally cannot produce a
base64 reply. It also means automatic outer-clipboard import through
`refresh-client -l` is not available; use WezTerm's native paste action.

This is not a guarantee for a tmux session with multiple attached clients: a
different client may answer the query, and terminal behavior can change across
versions. The relevant implementation is:

- [WezTerm OSC 52 handler](https://github.com/wezterm/wezterm/blob/main/term/src/terminalstate/performer.rs#L784-L795)

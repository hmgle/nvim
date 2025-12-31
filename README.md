# Neovim Configuration

A Lua-based Neovim configuration using lazy.nvim for plugin management.

## Requirements

- Neovim >= 0.10.0 (built with LuaJIT)
- Git >= 2.19.0
- CMake, make, GCC/Clang (for telescope-fzf-native)
- Node.js (for LSP servers and formatters)
- Python 3 with pynvim: `pip install pynvim`
- A Nerd Font (optional, for icons)

## Installation

```bash
pip install pynvim
git clone https://github.com/hmgle/nvim.git ~/.config/nvim
nvim
```

Plugins install automatically on first launch. LSP servers install on-demand via Mason.

## Directory Structure

```
~/.config/nvim/
├── init.lua              # Entry point, lazy.nvim bootstrap
├── lazy-lock.json        # Plugin version lock
├── lua/
│   ├── basic.lua         # Core settings (leader, encoding, etc.)
│   ├── options.lua       # Additional options and keymaps
│   ├── utils.lua         # Shared helpers
│   ├── plugins.lua       # Plugin specifications
│   └── config/           # Individual plugin configs
│       ├── lspconf.lua
│       ├── telescope.lua
│       ├── conform.lua
│       ├── lint.lua
│       └── ...
└── viml/
    └── conf.vim          # Legacy VimScript
```

## Key Bindings

Leader key is `,` (comma).

### Navigation

| Key                                                                 | Mode          | Action                   |
| ------------------------------------------------------------------- | ------------- | ------------------------ |
| <kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Normal        | Window navigation        |
| <kbd>gt</kbd> / <kbd>gT</kbd>                                       | Normal        | Next/Previous buffer     |
| <kbd>Alt</kbd>+<kbd>1</kbd> to <kbd>Alt</kbd>+<kbd>9</kbd>          | Normal        | Jump to buffer by number |
| <kbd>s</kbd>                                                        | Normal/Visual | Flash jump               |
| <kbd>S</kbd>                                                        | Normal        | Flash treesitter jump    |
| <kbd>Ctrl</kbd>+<kbd>u</kbd> / <kbd>Ctrl</kbd>+<kbd>d</kbd>         | Normal/Visual | Treewalker up/down       |
| <kbd>,</kbd><kbd>h</kbd> / <kbd>,</kbd><kbd>l</kbd>                 | Normal/Visual | Treewalker out/in        |

### Search

| Key                                                                          | Mode   | Action                          |
| ---------------------------------------------------------------------------- | ------ | ------------------------------- |
| <kbd>Ctrl</kbd>+<kbd>p</kbd>                                                 | Normal | Smart file picker (snacks.nvim) |
| <kbd>,</kbd><kbd>f</kbd><kbd>f</kbd>                                         | Normal | Find files                      |
| <kbd>,</kbd><kbd>f</kbd><kbd>g</kbd> or <kbd>,</kbd><kbd>f</kbd><kbd>l</kbd> | Normal | Live grep                       |
| <kbd>,</kbd><kbd>f</kbd><kbd>b</kbd>                                         | Normal | Fuzzy find in current buffer    |
| <kbd>,</kbd><kbd>f</kbd><kbd>z</kbd>                                         | Normal | Frecency/smart file finder      |
| <kbd>,</kbd><kbd>f</kbd><kbd>r</kbd>                                         | Normal | Resume last telescope           |
| <kbd>,</kbd><kbd>\*</kbd>                                                    | Normal | Grep word under cursor          |
| <kbd>,</kbd><kbd>Enter</kbd>                                                 | Normal | Clear search highlight          |

### LSP

| Key                                                 | Mode          | Action                   |
| --------------------------------------------------- | ------------- | ------------------------ |
| <kbd>g</kbd><kbd>d</kbd>                            | Normal        | Go to definition         |
| <kbd>g</kbd><kbd>D</kbd>                            | Normal        | Go to declaration        |
| <kbd>g</kbd><kbd>i</kbd>                            | Normal        | Show implementations     |
| <kbd>g</kbd><kbd>r</kbd>                            | Normal        | Show references          |
| <kbd>g</kbd><kbd>h</kbd>                            | Normal        | Document symbols         |
| <kbd>g</kbd><kbd>s</kbd>                            | Normal        | Signature help           |
| <kbd>,</kbd><kbd>k</kbd>                            | Normal        | Hover                    |
| <kbd>,</kbd><kbd>r</kbd><kbd>n</kbd>                | Normal        | Rename                   |
| <kbd>,</kbd><kbd>c</kbd><kbd>a</kbd>                | Normal/Visual | Code actions             |
| <kbd>,</kbd><kbd>H</kbd>                            | Normal        | Toggle inlay hints       |
| <kbd>[</kbd><kbd>d</kbd> / <kbd>]</kbd><kbd>d</kbd> | Normal        | Previous/Next diagnostic |
| <kbd>g</kbd><kbd>l</kbd>                            | Normal        | All diagnostics          |
| <kbd>g</kbd><kbd>p</kbd>                            | Normal        | Preview definition       |

### File Management

| Key                                                       | Mode   | Action                           |
| --------------------------------------------------------- | ------ | -------------------------------- |
| <kbd>,</kbd><kbd>c</kbd><kbd>p</kbd>                      | Normal | Copy relative path               |
| <kbd>,</kbd><kbd>c</kbd><kbd>P</kbd>                      | Normal | Copy absolute path               |
| <kbd>,</kbd><kbd>c</kbd><kbd>f</kbd>                      | Normal | Copy filename                    |
| <kbd>,</kbd><kbd>o</kbd>                                  | Normal | Close all buffers except current |
| <kbd>Ctrl</kbd>+<kbd>w</kbd> <kbd>Ctrl</kbd>+<kbd>e</kbd> | Normal | Toggle outline                   |
| <kbd>,</kbd><kbd>t</kbd><kbd>t</kbd>                      | Normal | Toggle file tree                 |
| <kbd>,</kbd><kbd>t</kbd><kbd>f</kbd>                      | Normal | Reveal file in tree              |

### Editing

| Key                                                                         | Mode          | Action                              |
| --------------------------------------------------------------------------- | ------------- | ----------------------------------- |
| <kbd>p</kbd> / <kbd>P</kbd>                                                 | Normal/Visual | Paste (yanky enhanced)              |
| <kbd>Ctrl</kbd>+<kbd>n</kbd>                                                | Normal        | Cycle yank history                  |
| <kbd>,</kbd><kbd>y</kbd>                                                    | Normal        | Show yank history                   |
| <kbd>,</kbd><kbd>r</kbd>                                                    | Normal/Visual | Substitute operator                 |
| <kbd>,</kbd><kbd>c</kbd><kbd>c</kbd> / <kbd>,</kbd><kbd>c</kbd><kbd>b</kbd> | Normal/Visual | Toggle line/block comment           |
| <kbd>Ctrl</kbd>+<kbd>a</kbd> / <kbd>Ctrl</kbd>+<kbd>x</kbd>                 | Normal        | Increment/Decrement (smart boolean) |

### Search & Replace

| Key                                  | Mode          | Action                    |
| ------------------------------------ | ------------- | ------------------------- |
| <kbd>,</kbd><kbd>s</kbd><kbd>r</kbd> | Normal/Visual | Search/Replace (ripgrep)  |
| <kbd>,</kbd><kbd>s</kbd><kbd>a</kbd> | Normal/Visual | Search/Replace (ast-grep) |

### Terminal & Tools

| Key                          | Mode            | Action                    |
| ---------------------------- | --------------- | ------------------------- |
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | Normal/Terminal | Toggle terminal           |
| <kbd>Esc</kbd>               | Terminal        | Exit terminal insert mode |
| <kbd>,</kbd><kbd>q</kbd>     | Normal          | Toggle quickfix           |

### AI Integration

| Key                                                                         | Mode                   | Action               |
| --------------------------------------------------------------------------- | ---------------------- | -------------------- |
| <kbd>Ctrl</kbd>+<kbd>x</kbd>                                                | Normal/Insert/Terminal | Toggle Aider         |
| <kbd>,</kbd><kbd>a</kbd><kbd>s</kbd>                                        | Normal                 | Spawn Aider          |
| <kbd>,</kbd><kbd>a</kbd><kbd>Space</kbd>                                    | Normal                 | Toggle Aider         |
| <kbd>,</kbd><kbd>a</kbd><kbd>f</kbd> / <kbd>,</kbd><kbd>a</kbd><kbd>v</kbd> | Normal                 | Aider float/vertical |
| <kbd>,</kbd><kbd>a</kbd><kbd>l</kbd>                                        | Normal                 | Add file to Aider    |
| <kbd>,</kbd><kbd>a</kbd><kbd>d</kbd>                                        | Normal/Visual          | Ask Aider            |
| <kbd>,</kbd><kbd>a</kbd><kbd>m</kbd><kbd>\*</kbd>                           | Normal                 | Switch AI models     |

## Formatting (conform.nvim)

Format-on-save is enabled globally.

| Filetype              | Formatter                       |
| --------------------- | ------------------------------- |
| JavaScript/TypeScript | biome (fallback: prettier)      |
| CSS/HTML              | biome (fallback: prettier)      |
| JSON/JSONC            | biome-json (fallback: prettier) |
| Lua                   | stylua                          |
| Python                | isort + black                   |
| Go                    | goimports + gofumpt             |
| Rust                  | rustfmt                         |
| Shell                 | shfmt                           |
| YAML                  | yamlfix (fallback: prettier)    |

## Linting (nvim-lint)

Runs on BufEnter, BufWritePost, InsertLeave. Toggle with `,L`.

| Filetype              | Linter     |
| --------------------- | ---------- |
| JavaScript/TypeScript | biomejs    |
| Python                | ruff       |
| Shell                 | shellcheck |

## LSP

Uses Mason + mason-lspconfig. Servers auto-install on demand.

Configured servers include:

- lua_ls (Lua)
- clangd (C/C++)
- gopls (Go, with gofumpt and staticcheck)
- pyright/pylsp (Python)
- rust-analyzer (Rust)
- Various others via Mason

## Theme

Default: Gruvbox Material (light mode)

Alternative themes available but disabled: Nightfox, TokyoNight, Melange.

## AI Setup

### GitHub Copilot

```
:Copilot auth
```

Integrated with blink.cmp completion.

### Aider

```bash
pip install aider-chat
export DEEPSEEK_API_KEY="your-key"
```

## Troubleshooting

```vim
:Lazy              " Plugin manager
:Lazy update       " Update plugins
:Mason             " LSP server manager
:LspInfo           " LSP status
:checkhealth       " General health check
:Lazy profile      " Profile startup
```

## Performance

- Lazy loading for most plugins
- bigfile.nvim disables features for files >2MB
- go.nvim skips loading for large Go files (>100KB)

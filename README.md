# Modern Neovim Configuration

A feature-rich, modern Neovim configuration built with Lua and lazy.nvim plugin manager, optimized for development productivity with AI assistance integration.

## ✨ Features

- 🚀 **Fast Startup**: Lazy loading with optimized plugin management
- 🔍 **Powerful Search**: Telescope fuzzy finder with frecency/smart-open
- 🧠 **AI Integration**: GitHub Copilot, Aider, and CodeCompanion support
- 📝 **Modern LSP**: Full Language Server Protocol with Mason auto-installation
- 🎨 **Rich UI**: Gruvbox Material theme with custom highlights
- ⚡ **Smart Completion**: Blink.cmp with snippet and AI completions
- 🔧 **Code Quality**: Auto-formatting and linting on save
- 🌳 **Syntax Highlighting**: Advanced Treesitter parsing

## 🛠️ Prerequisites

- **Neovim** >= 0.10.0 (built with LuaJIT)
- **Git** >= 2.19.0 (for partial clones)
- **CMake, make, GCC/Clang** for telescope-fzf-native
- **C compiler** for nvim-treesitter
- **Node.js** for LSP servers and formatters
- **Python 3** with pynvim: `pip install pynvim`
- **Nerd Font** (optional, for icons)

## 📦 Installation

```bash
# Install pynvim for Python integration
pip install pynvim

# Clone the configuration
git clone https://github.com/hmgle/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

On first launch, lazy.nvim will automatically install all plugins. LSP servers will be installed on-demand via Mason.

## ⌨️ Keybindings

### Leader Keys
- **Leader**: `,` (comma)
- **Local Leader**: `,` (comma)

### 🧭 Navigation & Movement

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-h/j/k/l>` | Normal | Window navigation | Move between splits |
| `gt` / `gT` | Normal | Buffer navigation | Next/Previous buffer |
| `<Alt-1-9>` | Normal | Buffer selection | Go to buffer by number |
| `s` | Normal/Visual | Flash jump | Quick jump to position |
| `S` | Normal | Flash treesitter | Jump to treesitter node |
| `<leader>h/l` | Normal/Visual | Treewalker | Move out/in AST tree |
| `<C-u/d>` | Normal/Visual | Treewalker | Move up/down AST tree |

### 🔍 Search & Find

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-p>` | Normal | Smart file picker | Snacks.nvim smart picker |
| `<leader>ff` | Normal | Find files | Telescope file finder |
| `<leader>fl` | Normal | Live grep | Search in files |
| `<leader>fb` | Normal | Buffer search | Fuzzy find in current buffer |
| `<leader>fz` | Normal | Frecency/Smart | Frequent/smart file finder |
| `<leader>fr` | Normal | Resume search | Resume last telescope |
| `<leader>*` | Normal | Grep word | Search word under cursor |
| `<leader><cr>` | Normal | Clear search | Clear search highlight |
| `n/N` | Normal | Search next/prev | Enhanced with hlslens |
| `*/# g*/g#` | Normal | Enhanced search | Search with hlslens |

### 📄 File & Buffer Management

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>o` | Normal | Close others | Close all buffers except current |
| `<C-w><C-e>` | Normal | Toggle outline | Symbol outline sidebar |
| Tree view (nvim-tree) | | | |
| `o/<CR>` | Normal | Open file | Open file/directory |
| `l/h` | Normal | CD down/up | Change root directory |
| `d/D` | Normal | Trash/Delete | Remove file |
| `<C-t/v>` | Normal | Tab/Split | Open in tab/vertical split |

### 📝 LSP & Code Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gd` | Normal | Go to definition | Jump to definition |
| `gD` | Normal | Go to declaration | Jump to declaration |
| `gi` | Normal | Implementations | Show implementations (Telescope) |
| `gr` | Normal | References | Show references (Telescope) |
| `gh` | Normal | Document symbols | Show document symbols |
| `gs` | Normal | Signature help | Show function signature |
| `<leader>k` | Normal | Hover | Show hover information |
| `<leader>rn` | Normal | Rename | Rename symbol |
| `<leader>ca` | Normal/Visual | Code actions | Show code actions |
| `<leader>H` | Normal | Toggle hints | Toggle inlay hints |
| `[d` / `]d` | Normal | Diagnostics | Previous/Next diagnostic |
| `gl` | Normal | All diagnostics | Show all diagnostics |
| `gp` | Normal | Preview definition | Goto preview |
| `gP` | Normal | Close preview | Close all previews |

### ✍️ Text Editing & Manipulation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `p/P` | Normal/Visual | Paste | Enhanced paste with Yanky |
| `<C-n>` | Normal | Cycle yank | Cycle through yank history |
| `<leader>y` | Normal | Yank history | Show yank history (Telescope) |
| `<leader>r` | Normal/Visual | Substitute | Substitute operator |
| `<leader>rs/rS` | Normal | Substitute line/EOL | Substitute line/to end |
| `<leader>cc/cb` | Normal/Visual | Comment line/block | Toggle comments |
| `<leader>cgc/cgb` | Normal | Comment operator | Comment with operator |
| `<C-a/x>` | Normal | Increment/Decrement | Smart boolean toggle |

### 🔧 Code Quality & Formatting

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>L` | Normal | Toggle lint | Toggle linting |
| Format on save | Auto | Auto-format | Automatic formatting enabled |
| `<leader>gf` | Normal | Format buffer | Manual formatting |

### 🤖 AI Integration

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-x>` | Normal/Insert/Terminal | Toggle Aider | Toggle AI assistant |
| `<leader>as` | Normal | Spawn Aider | Start Aider terminal |
| `<leader>a<space>` | Normal | Toggle Aider | Toggle Aider window |
| `<leader>af/av` | Normal | Float/Vertical | Aider in float/vertical |
| `<leader>al` | Normal | Add file | Add file to Aider |
| `<leader>ad` | Normal/Visual | Ask Aider | Ask with selection |
| `<leader>am*` | Normal | Model switch | Switch AI models |

### 🔍 Search & Replace

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>sr` | Normal/Visual | Search/Replace (rg) | Grug-far with ripgrep |
| `<leader>sa` | Normal/Visual | Search/Replace (ast) | AST-grep search/replace |

### 🖥️ Terminal & Tools

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-S>` | Normal/Terminal | Toggle terminal | ToggleTerm integration |
| `<Esc>` | Terminal | Normal mode | Exit terminal insert mode |
| `<leader>q` | Normal | Toggle quickfix | Smart quickfix toggle |

### 📋 Command Line (VimL legacy)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-A/E>` | Command | Home/End | Move to line start/end |
| `<C-B/F>` | Command | Left/Right | Character movement |
| `<C-P/N>` | Command | Up/Down | Command history |
| `<C-K>` | Command | Delete to end | Kill to end of line |
| `<C-d>` | Insert | Insert date | Insert current date |

### 🌐 Translation (Optional)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ee` | Normal/Visual | Translate | YouDao translator |
| `<leader>yd` | Normal | English | Translate to English |

### 📊 Special Features

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>n/N` | Normal | Next/Prev reference | Illuminate references |
| `<leader>ss/sS` | Normal | Symbols | Document/Workspace symbols |
| `<C-w>d` | Normal | Diagnostics | Workspace diagnostics |
| `<leader>fn` | Normal | Notifications | Show notifications |

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point & lazy.nvim bootstrap
├── lazy-lock.json          # Plugin version lockfile
├── lua/
│   ├── basic.lua           # Basic Neovim settings
│   ├── options.lua         # Additional options & keymaps
│   ├── utils.lua           # Utility functions
│   ├── plugins.lua         # Plugin specifications (main file)
│   └── config/             # Individual plugin configurations
│       ├── lspconf.lua     # LSP configuration
│       ├── telescope.lua   # Telescope setup
│       ├── conform.lua     # Formatting setup
│       ├── lint.lua        # Linting configuration
│       └── ...             # Other plugin configs
└── viml/
    └── conf.vim            # Legacy VimScript settings
```

## 🚀 AI Features Setup

### GitHub Copilot
1. Install: `:Copilot auth`
2. Already integrated with blink.cmp completion

### Aider (AI Pair Programming)
```bash
# Install aider
pip install aider-chat

# Set API key
export DEEPSEEK_API_KEY="your-api-key"
```

### CodeCompanion
Uses Deepseek API for chat completion. Set environment variable:
```bash
export DEEPSEEK_API_KEY="your-api-key"
```

## 📋 Language Support

### Full LSP Support
- **Go**: gopls with goimports, gofumpt
- **JavaScript/TypeScript**: Various LSP servers via Mason
- **Python**: Pyright/Pylsp with mypy, black, isort
- **Lua**: lua-language-server with stylua
- **Rust**: rust-analyzer with rustfmt
- **C/C++**: clangd
- **And many more via Mason**

### Formatting (via conform.nvim)
- **Format on save**: Enabled globally
- **JavaScript/TypeScript**: prettier
- **Python**: black + isort
- **Go**: goimports + gofumpt
- **Lua**: stylua
- **Rust**: rustfmt
- **Shell**: shfmt

### Linting (via nvim-lint)
- **JavaScript/TypeScript**: eslint_d
- **Python**: mypy
- **Shell**: shellcheck

## ⚡ Performance Notes

- **Lazy Loading**: Most plugins load on-demand
- **Big File Handling**: bigfile.nvim for large files (>2MB)
- **Go Files**: Special handling for large Go files
- **Startup Time**: ~50-100ms typical startup

## 🎨 Themes & UI

- **Default Theme**: Gruvbox Material (light mode)
- **Alternative**: Nightfox, TokyoNight (disabled by default)
- **Status Line**: nvim-hardline
- **Icons**: nvim-web-devicons with Nerd Font support
- **Notifications**: nvim-notify with noice.nvim

## 🔧 Customization

### Adding New Languages
1. LSP server auto-installs via Mason
2. Add formatter to `lua/config/conform.lua`
3. Add linter to `lua/config/lint.lua`

### Plugin Management
```lua
-- In lua/plugins.lua, add:
{
  'author/plugin-name',
  config = function()
    require('config.plugin-name')  -- if complex config needed
  end,
  dependencies = { 'dep1', 'dep2' },
  event = 'VeryLazy',  -- lazy load trigger
},
```

### Custom Keymaps
Add to `lua/options.lua` or create `lua/keymaps.lua`:
```lua
local map = require('utils').map
map('n', '<leader>custom', '<cmd>CustomCommand<CR>', 'Description')
```

## 🐛 Troubleshooting

### Plugin Issues
- `:Lazy` - Plugin manager interface
- `:Lazy update` - Update all plugins
- `:Lazy clean` - Remove unused plugins

### LSP Issues
- `:Mason` - LSP server manager
- `:LspInfo` - LSP status for current buffer
- `:checkhealth` - General health check

### Performance Issues
- `:Lazy profile` - Profile plugin loading
- Disable format-on-save in `conform.lua` if needed
- Check big file detection settings

## 📚 Documentation

- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [Which-key](https://github.com/folke/which-key.nvim) - Keybinding help

## 🤝 Contributing

This configuration is actively maintained. Feel free to:
- Report issues
- Suggest improvements
- Submit pull requests
- Share your customizations

## 📄 License

This configuration is open source. Individual plugins maintain their own licenses.
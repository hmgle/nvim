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
- **Leader**: <kbd>,</kbd> (comma)
- **Local Leader**: <kbd>,</kbd> (comma)

### 🧭 Navigation & Movement

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Normal | Window navigation | Move between splits |
| <kbd>gt</kbd> / <kbd>gT</kbd> | Normal | Buffer navigation | Next/Previous buffer |
| <kbd>Alt</kbd>+<kbd>1-9</kbd> | Normal | Buffer selection | Go to buffer by number |
| <kbd>s</kbd> | Normal/Visual | Flash jump | Quick jump to position |
| <kbd>S</kbd> | Normal | Flash treesitter | Jump to treesitter node |
| <kbd>,</kbd><kbd>h</kbd>/<kbd>l</kbd> | Normal/Visual | Treewalker | Move out/in AST tree |
| <kbd>Ctrl</kbd>+<kbd>u</kbd>/<kbd>d</kbd> | Normal/Visual | Treewalker | Move up/down AST tree |

### 🔍 Search & Find

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>Ctrl</kbd>+<kbd>p</kbd> | Normal | Smart file picker | Snacks.nvim smart picker |
| <kbd>,</kbd><kbd>ff</kbd> | Normal | Find files | Telescope file finder |
| <kbd>,</kbd><kbd>fl</kbd> | Normal | Live grep | Search in files |
| <kbd>,</kbd><kbd>fb</kbd> | Normal | Buffer search | Fuzzy find in current buffer |
| <kbd>,</kbd><kbd>fz</kbd> | Normal | Frecency/Smart | Frequent/smart file finder |
| <kbd>,</kbd><kbd>fr</kbd> | Normal | Resume search | Resume last telescope |
| <kbd>,</kbd><kbd>*</kbd> | Normal | Grep word | Search word under cursor |
| <kbd>,</kbd><kbd>Enter</kbd> | Normal | Clear search | Clear search highlight |
| <kbd>n</kbd>/<kbd>N</kbd> | Normal | Search next/prev | Enhanced with hlslens |
| <kbd>*</kbd>/<kbd>#</kbd> <kbd>g*</kbd>/<kbd>g#</kbd> | Normal | Enhanced search | Search with hlslens |

### 📄 File & Buffer Management

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>,</kbd><kbd>o</kbd> | Normal | Close others | Close all buffers except current |
| <kbd>Ctrl</kbd>+<kbd>w</kbd><kbd>Ctrl</kbd>+<kbd>e</kbd> | Normal | Toggle outline | Symbol outline sidebar |
| Tree view (nvim-tree) | | | |
| <kbd>o</kbd>/<kbd>Enter</kbd> | Normal | Open file | Open file/directory |
| <kbd>l</kbd>/<kbd>h</kbd> | Normal | CD down/up | Change root directory |
| <kbd>d</kbd>/<kbd>D</kbd> | Normal | Trash/Delete | Remove file |
| <kbd>Ctrl</kbd>+<kbd>t</kbd>/<kbd>v</kbd> | Normal | Tab/Split | Open in tab/vertical split |

### 📝 LSP & Code Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>gd</kbd> | Normal | Go to definition | Jump to definition |
| <kbd>gD</kbd> | Normal | Go to declaration | Jump to declaration |
| <kbd>gi</kbd> | Normal | Implementations | Show implementations (Telescope) |
| <kbd>gr</kbd> | Normal | References | Show references (Telescope) |
| <kbd>gh</kbd> | Normal | Document symbols | Show document symbols |
| <kbd>gs</kbd> | Normal | Signature help | Show function signature |
| <kbd>,</kbd><kbd>k</kbd> | Normal | Hover | Show hover information |
| <kbd>,</kbd><kbd>rn</kbd> | Normal | Rename | Rename symbol |
| <kbd>,</kbd><kbd>ca</kbd> | Normal/Visual | Code actions | Show code actions |
| <kbd>,</kbd><kbd>H</kbd> | Normal | Toggle hints | Toggle inlay hints |
| <kbd>[d</kbd> / <kbd>]d</kbd> | Normal | Diagnostics | Previous/Next diagnostic |
| <kbd>gl</kbd> | Normal | All diagnostics | Show all diagnostics |
| <kbd>gp</kbd> | Normal | Preview definition | Goto preview |
| <kbd>gP</kbd> | Normal | Close preview | Close all previews |

### ✍️ Text Editing & Manipulation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>p</kbd>/<kbd>P</kbd> | Normal/Visual | Paste | Enhanced paste with Yanky |
| <kbd>Ctrl</kbd>+<kbd>n</kbd> | Normal | Cycle yank | Cycle through yank history |
| <kbd>,</kbd><kbd>y</kbd> | Normal | Yank history | Show yank history (Telescope) |
| <kbd>,</kbd><kbd>r</kbd> | Normal/Visual | Substitute | Substitute operator |
| <kbd>,</kbd><kbd>rs</kbd>/<kbd>rS</kbd> | Normal | Substitute line/EOL | Substitute line/to end |
| <kbd>,</kbd><kbd>cc</kbd>/<kbd>cb</kbd> | Normal/Visual | Comment line/block | Toggle comments |
| <kbd>,</kbd><kbd>cgc</kbd>/<kbd>cgb</kbd> | Normal | Comment operator | Comment with operator |
| <kbd>Ctrl</kbd>+<kbd>a</kbd>/<kbd>x</kbd> | Normal | Increment/Decrement | Smart boolean toggle |

### 🔧 Code Quality & Formatting

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>,</kbd><kbd>L</kbd> | Normal | Toggle lint | Toggle linting |
| Format on save | Auto | Auto-format | Automatic formatting enabled |
| <kbd>,</kbd><kbd>gf</kbd> | Normal | Format buffer | Manual formatting |

### 🤖 AI Integration

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>Ctrl</kbd>+<kbd>x</kbd> | Normal/Insert/Terminal | Toggle Aider | Toggle AI assistant |
| <kbd>,</kbd><kbd>as</kbd> | Normal | Spawn Aider | Start Aider terminal |
| <kbd>,</kbd><kbd>a</kbd><kbd>Space</kbd> | Normal | Toggle Aider | Toggle Aider window |
| <kbd>,</kbd><kbd>af</kbd>/<kbd>av</kbd> | Normal | Float/Vertical | Aider in float/vertical |
| <kbd>,</kbd><kbd>al</kbd> | Normal | Add file | Add file to Aider |
| <kbd>,</kbd><kbd>ad</kbd> | Normal/Visual | Ask Aider | Ask with selection |
| <kbd>,</kbd><kbd>am</kbd>* | Normal | Model switch | Switch AI models |

### 🔍 Search & Replace

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>,</kbd><kbd>sr</kbd> | Normal/Visual | Search/Replace (rg) | Grug-far with ripgrep |
| <kbd>,</kbd><kbd>sa</kbd> | Normal/Visual | Search/Replace (ast) | AST-grep search/replace |

### 🖥️ Terminal & Tools

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>Ctrl</kbd>+<kbd>S</kbd> | Normal/Terminal | Toggle terminal | ToggleTerm integration |
| <kbd>Esc</kbd> | Terminal | Normal mode | Exit terminal insert mode |
| <kbd>,</kbd><kbd>q</kbd> | Normal | Toggle quickfix | Smart quickfix toggle |

### 📋 Command Line (VimL legacy)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>Ctrl</kbd>+<kbd>A</kbd>/<kbd>E</kbd> | Command | Home/End | Move to line start/end |
| <kbd>Ctrl</kbd>+<kbd>B</kbd>/<kbd>F</kbd> | Command | Left/Right | Character movement |
| <kbd>Ctrl</kbd>+<kbd>P</kbd>/<kbd>N</kbd> | Command | Up/Down | Command history |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> | Command | Delete to end | Kill to end of line |
| <kbd>Ctrl</kbd>+<kbd>d</kbd> | Insert | Insert date | Insert current date |

### 🌐 Translation (Optional)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>,</kbd><kbd>ee</kbd> | Normal/Visual | Translate | YouDao translator |
| <kbd>,</kbd><kbd>yd</kbd> | Normal | English | Translate to English |

### 📊 Special Features

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| <kbd>,</kbd><kbd>n</kbd>/<kbd>N</kbd> | Normal | Next/Prev reference | Illuminate references |
| <kbd>,</kbd><kbd>ss</kbd>/<kbd>sS</kbd> | Normal | Symbols | Document/Workspace symbols |
| <kbd>Ctrl</kbd>+<kbd>w</kbd><kbd>d</kbd> | Normal | Diagnostics | Workspace diagnostics |
| <kbd>,</kbd><kbd>fn</kbd> | Normal | Notifications | Show notifications |

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
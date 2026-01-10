# Neovim Configuration Guide

A comprehensive guide for your custom Neovim setup with Rust development support, LSP, and modern plugins.

---

## 📋 Table of Contents

- [Installation](#installation)
- [Neovim Modes](#neovim-modes)
- [Essential Commands](#essential-commands)
- [Leader Key Shortcuts](#leader-key-shortcuts)
- [LSP Features (Rust)](#lsp-features-rust)
- [File Navigation (Telescope)](#file-navigation-telescope)
- [Editing Features](#editing-features)
- [Window Management](#window-management)
- [Plugins Overview](#plugins-overview)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Installation

### 1. Install Neovim (if not already installed)
```bash
# Ubuntu/Debian
sudo apt install neovim

# Arch Linux
sudo pacman -S neovim

# macOS
brew install neovim
```

### 2. Install vim-plug (Plugin Manager)
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

### 3. Setup Configuration
```bash
# Create config directory
mkdir -p ~/.config/nvim

# Copy your init.vim to the config directory
cp init.vim ~/.config/nvim/init.vim

# Create backup and undo directories
mkdir -p ~/.config/nvim/backup ~/.config/nvim/undo
```

### 4. Install Plugins
```bash
# Open Neovim
nvim

# Inside Neovim, run:
:PlugInstall

# Wait for plugins to install, then restart Neovim
```

### 5. Install Rust Analyzer (for Rust LSP)
```bash
# Using rustup (recommended)
rustup component add rust-analyzer

# Or download directly
# https://rust-analyzer.github.io/manual.html#installation
```

### 6. Install Additional Dependencies
```bash
# For Telescope (fuzzy finder)
sudo apt install ripgrep fd-find  # Ubuntu/Debian
# or
sudo pacman -S ripgrep fd  # Arch Linux
# or
brew install ripgrep fd  # macOS

# For clipboard support
sudo apt install xclip  # Linux
```

---

## 🎮 Neovim Modes

| Mode | How to Enter | Purpose | How to Exit |
|------|--------------|---------|-------------|
| **Normal** | `Esc` | Navigate & execute commands | Default mode |
| **Insert** | `i`, `a`, `o`, `O` | Type and edit text | `Esc` |
| **Visual** | `v`, `V`, `Ctrl+v` | Select text | `Esc` |
| **Command** | `:` | Execute commands (`:wq`, `:q!`) | `Esc` or `Enter` |

### Insert Mode Variants
- `i` - Insert before cursor
- `a` - Insert after cursor
- `o` - Insert new line below
- `O` - Insert new line above
- `I` - Insert at beginning of line
- `A` - Insert at end of line

---

## 💾 Essential Commands

### Saving and Quitting
```vim
:w          " Save (write) file
:q          " Quit
:wq         " Save and quit
:x          " Save and quit (same as :wq)
:q!         " Quit without saving
:wqa        " Save and quit all buffers
```

### Basic Navigation (Normal Mode)
```
h  " Left
j  " Down
k  " Up
l  " Right

w  " Jump to next word
b  " Jump to previous word
0  " Jump to beginning of line
$  " Jump to end of line
gg " Jump to beginning of file
G  " Jump to end of file
```

---

## ⌨️ Leader Key Shortcuts

**Leader Key = `Space`**

### General
| Shortcut | Action |
|----------|--------|
| `Space w` | Save file quickly |
| `Space q` | Quit |
| `Space h` | Clear search highlights |

### Rust-Specific
| Shortcut | Action |
|----------|--------|
| `Space f` | Format Rust code (in .rs files) |

---

## 🔧 LSP Features (Rust)

These work automatically when editing `.rs` files:

### Navigation
| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `gt` | Go to type definition |

### Documentation
| Shortcut | Action |
|----------|--------|
| `K` | Show hover documentation |
| `Ctrl+k` | Show signature help |

### Code Actions
| Shortcut | Action |
|----------|--------|
| `Space rn` | Rename symbol |
| `Space ca` | Code actions (quick fixes) |
| `Space f` | Format code |

### Diagnostics (Errors/Warnings)
| Shortcut | Action |
|----------|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `Space d` | Show diagnostic details |
| `Space q` | Add diagnostics to location list |

---

## 🔍 File Navigation (Telescope)

Fuzzy finder for files and text:

| Shortcut | Action |
|----------|--------|
| `Space ff` | Find files in project |
| `Space fg` | Live grep (search text in all files) |
| `Space fb` | Browse open buffers |
| `Space fh` | Search help documentation |

**Usage:**
1. Press the shortcut
2. Type to filter results
3. Use `↓` `↑` or `Ctrl+j` `Ctrl+k` to navigate
4. Press `Enter` to open file
5. Press `Esc` to cancel

---

## ✏️ Editing Features

### Copy, Cut, Paste (Normal Mode)
```
yy       " Yank (copy) current line
yw       " Yank word
y$       " Yank to end of line
dd       " Delete (cut) current line
dw       " Delete word
p        " Paste after cursor
P        " Paste before cursor
u        " Undo
Ctrl+r   " Redo
```

### Visual Mode Operations
```
v        " Enter Visual mode (character selection)
V        " Enter Visual Line mode (line selection)
Ctrl+v   " Enter Visual Block mode (column selection)

After selecting:
y        " Yank (copy) selection
d        " Delete (cut) selection
c        " Change (delete and enter Insert mode)
>        " Indent selection
<        " Unindent selection
```

### Auto-Completion (Insert Mode)
| Shortcut | Action |
|----------|--------|
| `Tab` | Next suggestion |
| `Shift+Tab` | Previous suggestion |
| `Enter` | Accept suggestion |
| `Ctrl+Space` | Manually trigger completion |
| `Ctrl+e` | Close completion menu |

**Completion Sources:**
- `[LSP]` - Language server suggestions (functions, variables)
- `[Snippet]` - Code snippets
- `[Buffer]` - Words from current file
- `[Path]` - File paths

### Comments
```
gcc      " Toggle comment on current line
gc       " Toggle comment on selection (Visual mode)
```

### Moving Lines (Visual Mode)
```
J        " Move selected lines down
K        " Move selected lines up
```

### Auto-Pairs
Automatically closes:
- `()` parentheses
- `[]` brackets
- `{}` braces
- `""` quotes
- `''` single quotes

---

## 🪟 Window Management

### Buffer Navigation
```
Tab         " Next buffer
Shift+Tab   " Previous buffer
:ls         " List all buffers
:b <number> " Switch to buffer number
:bd         " Close current buffer
```

### Split Windows
```
:split      " Horizontal split
:vsplit     " Vertical split
:only       " Close all splits except current
```

### Split Navigation
| Shortcut | Action |
|----------|--------|
| `Ctrl+h` | Move to left split |
| `Ctrl+j` | Move to down split |
| `Ctrl+k` | Move to up split |
| `Ctrl+l` | Move to right split |

### Resize Splits
| Shortcut | Action |
|----------|--------|
| `Ctrl+↑` | Increase height |
| `Ctrl+↓` | Decrease height |
| `Ctrl+←` | Decrease width |
| `Ctrl+→` | Increase width |

---

## 🔌 Plugins Overview

### LSP & Completion
- **nvim-cmp** - Auto-completion engine
- **cmp-nvim-lsp** - LSP completion source
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Collection of snippets

### Language Support
- **nvim-treesitter** - Advanced syntax highlighting
- **rust.vim** - Rust language support
  - Auto-formatting with `rustfmt`
  - Clippy integration

### Interface
- **tokyonight.nvim** - Color scheme
- **lualine.nvim** - Status line
- **nvim-web-devicons** - File icons

### Navigation
- **telescope.nvim** - Fuzzy finder
- **plenary.nvim** - Telescope dependency

### Utilities
- **nvim-autopairs** - Auto-close brackets/quotes
- **Comment.nvim** - Easy commenting
- **gitsigns.nvim** - Git integration (shows changes)
- **indent-blankline.nvim** - Indent guides

---

## 🛠️ Troubleshooting

### Plugins Not Working
```vim
" Inside Neovim, run:
:PlugInstall
:PlugUpdate

" Then restart Neovim
```

### LSP Not Starting
```bash
# Check if rust-analyzer is installed
which rust-analyzer

# Check LSP status in Neovim
:LspInfo

# Restart LSP
:LspRestart
```

### Telescope Not Finding Files
```bash
# Make sure ripgrep and fd are installed
which rg
which fd
```

### Check Leader Key
```vim
" Inside Neovim:
:echo mapleader
" Should show a space character
```

### Clear Cache
```bash
# Remove plugin cache
rm -rf ~/.local/share/nvim/plugged
rm -rf ~/.cache/nvim

# Reinstall plugins
nvim +PlugInstall +qall
```

---

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [Rust Analyzer Manual](https://rust-analyzer.github.io/manual.html)
- [Telescope Documentation](https://github.com/nvim-telescope/telescope.nvim)

### Built-in Help
```vim
:help              " General help
:help <topic>      " Help on specific topic
:help keybindings  " Keybinding help
:Tutor             " Interactive Vim tutorial
```

---

## 🎯 Quick Start Workflow

1. **Open file**: `nvim main.rs`
2. **Find another file**: `Space ff`, type filename, `Enter`
3. **Edit**: Press `i`, type code, `Esc`
4. **Save**: `Space w` or `:w`
5. **Auto-complete**: Start typing, use `Tab` to select
6. **Go to definition**: Cursor on function, press `gd`
7. **Format code**: `Space f`
8. **Quit**: `:wq` or `Space w` then `Space q`

---

**Happy coding! 🚀**

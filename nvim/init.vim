" ============================================
" VIM-PLUG - PLUGIN MANAGER
" ============================================
call plug#begin('~/.local/share/nvim/plugged')

" === LSP and Autocompletion ===
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" === Snippets ===
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" === Syntax Highlighting (optional, can be disabled) ===
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" === Rust Support ===
Plug 'rust-lang/rust.vim'

" === Interface and Theme ===
Plug 'Abhra00/solarized-luv.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" === Navigation and Files ===
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-lua/plenary.nvim'

" === Utilities ===
Plug 'windwp/nvim-autopairs'
Plug 'numToStr/Comment.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" ============================================
" GENERAL SETTINGS
" ============================================
set number
set relativenumber
set cursorline
set mouse=a
set clipboard=unnamedplus
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set wrap
set ignorecase
set smartcase
set termguicolors
set signcolumn=yes
set updatetime=300
set timeoutlen=500
set hidden
set backup
set backupdir=~/.config/nvim/backup
set undofile
set undodir=~/.config/nvim/undo
set scrolloff=8
set sidescrolloff=8

" Create directories if they don't exist
silent !mkdir -p ~/.config/nvim/backup ~/.config/nvim/undo

" ============================================
" THEME
" ============================================
try
  colorscheme solarized-luv
catch
  colorscheme default
endtry

" ============================================
" LUA CONFIGURATION
" ============================================
lua << EOF
-- ================================================
-- SAFE LOADING HELPER
-- ================================================
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Failed to load: " .. module, vim.log.levels.WARN)
    return nil
  end
  return result
end

-- ================================================
-- NVIM-CMP: AUTOCOMPLETION
-- ================================================
local cmp = safe_require('cmp')
local luasnip = safe_require('luasnip')

if cmp and luasnip then
  -- Load friendly-snippets
  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp', priority = 1000 },
      { name = 'luasnip', priority = 750 },
      { name = 'buffer', priority = 500 },
      { name = 'path', priority = 250 },
    }),
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          luasnip = '[Snippet]',
          buffer = '[Buffer]',
          path = '[Path]',
        })[entry.source.name]
        return vim_item
      end,
    },
  })

  -- Command-line autocompletion
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'path' },
      { name = 'cmdline' }
    }
  })
end

-- ================================================
-- LSP: RUST-ANALYZER CONFIGURATION
-- ================================================
local cmp_nvim_lsp = safe_require('cmp_nvim_lsp')
local capabilities = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {}

-- Configuration with NEW Neovim 0.11+ API
vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  root_markers = { 'Cargo.toml', '.git' },
  filetypes = { 'rust' },
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        enable = true,
      },
    },
  },
})

-- Auto-enable for Rust files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.lsp.enable('rust_analyzer')
  end,
})

-- ================================================
-- LSP KEYBINDINGS
-- ================================================
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

    -- Documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  end,
})

-- ================================================
-- TREESITTER: SYNTAX HIGHLIGHTING (SAFE LOAD)
-- ================================================
local treesitter = safe_require('nvim-treesitter.configs')
if treesitter then
  treesitter.setup({
    ensure_installed = { "rust", "python", "lua", "vim", "bash" },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  })
end

-- ================================================
-- LUALINE: STATUS BAR
-- ================================================
local lualine = safe_require('lualine')
if lualine then
  lualine.setup({
    options = {
      theme = 'auto',
      icons_enabled = true,
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  })
end

-- ================================================
-- TELESCOPE: CONFIGURATION
-- ================================================
local telescope = safe_require('telescope')
if telescope then
  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules", ".git/" },
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
      },
      -- Disable preview for problematic file types
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      -- Buffer previewer configuration
      buffer_previewer_maker = function(filepath, bufnr, opts)
        local previewers = require('telescope.previewers')
        local Job = require('plenary.job')

        -- Skip preview for large files or binary files
        local stat = vim.loop.fs_stat(filepath)
        if stat and stat.size > 100000 then
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'File too large to preview'})
          end)
          return
        end

        -- Use default previewer
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end,
    },
    pickers = {
      find_files = {
        hidden = true,
        follow = true,
      },
    },
  })
end

-- ================================================
-- UTILITIES
-- ================================================

-- Autopairs
local autopairs = safe_require('nvim-autopairs')
if autopairs then
  autopairs.setup({})
end

-- Comment
local comment = safe_require('Comment')
if comment then
  comment.setup()
end

-- Gitsigns
local gitsigns = safe_require('gitsigns')
if gitsigns then
  gitsigns.setup({
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  })
end

-- Indent-blankline
local ibl = safe_require('ibl')
if ibl then
  ibl.setup({
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
    },
  })
end

-- ================================================
-- DIAGNOSTICS CONFIGURATION
-- ================================================
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- Diagnostic symbols
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

EOF

" ============================================
" LANGUAGE-SPECIFIC CONFIGURATION
" ============================================

" === RUST ===
autocmd FileType rust setlocal shiftwidth=4 tabstop=4 expandtab
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -selection clipboard'

" === PYTHON ===
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType python setlocal colorcolumn=88

" === ASSEMBLY MIPS ===
autocmd BufNewFile,BufRead *.s setfiletype asm
autocmd FileType asm setlocal shiftwidth=4 tabstop=4 expandtab commentstring=#\ %s

" === MARKDOWN ===
autocmd FileType markdown setlocal spell spelllang=en,fr

" ============================================
" CUSTOM KEYBINDINGS
" ============================================

" Leader key = space
let mapleader = " "

" Quick save
nnoremap <leader>w :w<CR>

" Quit (asks to save if modified)
nnoremap <leader>q :q<CR>

" Quit without saving (force quit)
nnoremap <leader>qq :q!<CR>

" Quit all without saving
nnoremap <leader>qa :qa!<CR>

" Save and quit
nnoremap <leader>x :wq<CR>

" Telescope (file search)
nnoremap <leader>ff <cmd>Telescope find_files cwd=~<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Telescope - search in specific directories
nnoremap <leader>fc <cmd>Telescope find_files cwd=.<cr>
nnoremap <leader>fd <cmd>Telescope find_files cwd=~/Documents<cr>

" Navigate between buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Move lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize splits
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Format Rust code
autocmd FileType rust nnoremap <buffer> <leader>f :RustFmt<CR>

" Clear search highlights
nnoremap <leader>h :nohlsearch<CR>

" ============================================
" AUTO COMMANDS
" ============================================

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

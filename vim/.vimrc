" =======================
" Configuration de Vim
" =======================


" Numéros de lignes
set number
set rnu

" Gestion des tabulations
set tabstop=4
set shiftwidth=4
set expandtab

" Raccourci pour déplier/replier
nnoremap <space> za

" Activer la syntaxe et les couleurs
syntax enable 
set t_Co=256 "Activer les couleurs 256

" Options diverses
set autochdir
set clipboard^=unnamed,unnamedplus
set concealcursor=
set conceallevel=2
set encoding=utf-8
set foldlevel=99
set foldmethod=syntax
set hidden
set hlsearch
set ignorecase
set incsearch
set nowrap
set scrolloff=10
set shortmess=atToOs
set showcmd
set spelllang+=fr
set splitbelow
set splitright
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:·

" =======================
" Couleurs
" =======================

" Appliquer le schéma desert de base
colorscheme desert

" Personnalisation des couleurs
highlight Normal guifg=#d4d4d4 guibg=#282828         " Couleur du texte normal
highlight Comment guifg=#7f7f7f                      " Couleur des commentaires
highlight StatusLine guifg=#ffffff guibg=#005f87     " Couleur de la ligne de statut
highlight Statement guifg=#5fafaf                      " Couleur des instructions
highlight String guifg=#ffaf00                        " Couleur des chaînes de caractères
highlight LineNr guifg=#ff5f00 guibg=#282828        " Couleur des numéros de ligne
highlight CursorLine guibg=#3a3a3a                   " Couleur de la ligne actuelle
highlight CursorLineNr guifg=#ffd700 guibg=#444444   " Couleur du numéro de ligne actuel
highlight Identifier guifg=#87ceeb                    " Couleur des identifiants
highlight Constant guifg=#ff4500                      " Couleur des constantes
highlight Type guifg=#b0c4de                          " Couleur des types


" =======================
" Configuration pour Neovim
" =======================


if !has('nvim')
    set ttymouse=xterm2
endif



" Affiche les numéros de ligne sur la gauche
set number

" Affiche les numéros relatifs
set relativenumber

" Personnalisation de la barre d'état
set statusline=%f\ %y\ %l/%L\ %c

" Active la coloration syntaxique
syntax enable

" Détection automatique du type de fichier
filetype on

" Configuration spécifique pour Python
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab
" Optionnel : activer l'indentation automatique pour Python
autocmd FileType python filetype plugin indent on

" Configuration spécifique pour l'assembleur MIPS (.s)
autocmd BufNewFile,BufRead *.s setfiletype asm
autocmd FileType asm setlocal shiftwidth=4 tabstop=4 expandtab

" Optionnel : activer l'indentation automatique pour l'assembleur
autocmd FileType asm filetype plugin indent on



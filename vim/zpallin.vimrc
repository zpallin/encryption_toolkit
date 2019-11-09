syntax on
set expandtab
set tabstop=2
set shiftwidth=2

set clipboard=unnamedplus
execute pathogen#infect()

au BufNewFile,BufRead *.html set filetype=htmldjango
au BufNewFile,BufRead *.sh set noexpandtab

" mac fix for backspace
set backspace=indent,eol,start " backspace over everything in insert mode

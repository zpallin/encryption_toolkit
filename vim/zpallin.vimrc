syntax on
set expandtab
set tabstop=2
set shiftwidth=2

set clipboard=unnamedplus
execute pathogen#infect()

au BufNewFile,BufRead *.html set filetype=htmldjango
au BufNewFile,BufRead *.sh set noexpandtab

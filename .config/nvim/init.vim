" let g:python3_host_prog = 'C:\Python36-64\python.exe'
" set runtimepath^=C:/Program\ Files\ (x86)/vim
source ~/.vimrc
nnoremap <silent> <leader>ev :split ~/.vimrc<CR>
nnoremap <silent> <leader>evn :split $MYVIMRC<CR>
if has( "macunix" )
    Guifont Courier New:h16
end

" let g:python3_host_prog = 'C:\Python36-64\python.exe'
" set runtimepath^=C:/Program\ Files\ (x86)/vim
source ~/.vimrc
nnoremap <silent> <leader>ev :split ~/.vimrc<CR>
nnoremap <silent> <leader>evn :split $MYVIMRC<CR>
nnoremap <silent> <leader>evg :split ~/.config/nvim/ginit.vim<CR>

" Help Neovim check if file has changed on disc
" https://github.com/neovim/neovim/issues/2127
augroup checktime
    autocmd!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter,FocusGained,BufEnter,FocusLost,WinLeave * checktime
    endif
augroup END

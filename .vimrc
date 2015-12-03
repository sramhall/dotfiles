" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible                          " be iMproved, required

" *****************************************************************************

" VIM Functional {{{
   set history=50                            " Keep 50 lines of command line history
   set nobackup                              " Do not keep a backup file
   set viminfo^=%                            " Remember info about open buffers on close
   set tags=tags                             "http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
   set autowriteall
   if has( "formatoptions" )
      set formatoptions-=cro
      "set formatoptions+=j
   endif
   "set path+=.\**                           "When not on windows: set path=$PWD/**
   " }}}
" Colors {{{
   set t_Co=256
   syntax on                                 " Switch syntax highlighting on
   colorscheme desert                        " Set color scheme

   set colorcolumn=80                        " Set a margin at 80 lines
   highlight ColorColumn ctermbg=red ctermfg=white guibg=#592929
   " }}}
" Whitespace / Indentation {{{
   filetype plugin indent on                 " Enable filetype detection--specific behavior for plugins and indent
   set tabstop=3                             " Tab is equivalent to 3 spaces
   set softtabstop=3                         " Use 3 spaces when pressing tab in insert mode
   set shiftwidth=3                          " Shifting/indenting text inserts 3 spaces
   set expandtab                             " Always expand tabs to spaces
   set autoindent                            " Copy indent from current line when creating new line
   set copyindent                            " Copy indent from previous line
   set shiftround                            " Round indent value to multiples of shiftwidth
   " set smarttab
   set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
   " }}}
" UI Config {{{
   set ttyfast                               " Speed redrawing by transferring more characters to redraw
   set lazyredraw                            " Don't auto redraw screen when executing macros, improves performance
   set number                                " Show line numbers
   set relativenumber                        " Always show line numbers as relative
   set showcmd                               " Show command as typed in status bar
   set hidden                                " hide buffers instead of closing them
   set splitbelow                            " Split below by default
   set ruler                                 " show the cursor position all the time
   set showmatch                             " show matching brackets
   set gfn=Consolas:h9:cANSI                 " set font
   set lines=50                              " GUI 50 lines long
   set columns=100                           " GUI 100 columns wide
   set nowrap                                " Don't wrap lines
   set scrolloff=7                           " Scroll screen when cursor 7 from beg/end
   set visualbell                            " don't beep
   set noerrorbells                          " don't beep
   set guioptions-=r                         " No scrollbar
   set diffopt=vertical,filler               " When opening vimdiff always split vertical and show filler lines for missing text
   set backspace=indent,eol,start            " backspacing over everything in insert mode
   set laststatus=2
   " set statusline="%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P"
   " }}}
" Searching, Wildmode {{{
   set smartcase                             " case-insens if search is lowercase, case-sens otherwise
   set ignorecase                            " ignore case when searching
   set hlsearch                              " highlight all search results
   set incsearch                             " do incremental searching
   set wildmenu                              " Use wildmenu for tab completion
   set wildmode=longest:full
   set wildignore+=*.o,*.bak,*.swp,*~,*.pyc,*.pbout,*.cout   " Ignore compiled files
   if has( "wildignorecase" )
      set wildignorecase
   endif

   " Use Ag for grep
   if executable('ag')
      set grepprg=ag\ --nogroup\ --nocolor

      " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
      let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'

      " ag is fast enough that CtrlP doesn't need to cache
      let g:ctrlp_use_caching = 0
   endif
   " }}}
" Folding {{{
   set modelines=2                           " Ensure that modeline at bottom of file will enable folding in vimrc if it is opened later for editing
   set foldenable                            " Use folding
   set foldmethod=syntax                     " Use language syntax for folding
   set foldlevelstart=10                     " Don't fold anything when opening file
   set foldnestmax=10                        " Don't fold anything when opening file
   " }}}
" AutoGroups {{{
   " Only do this part when compiled with support for autocommands.
   if has("autocmd")

      " Put these in an autocmd group, so that we can delete them easily.
      augroup configgroup
      autocmd!

         " filetype specific indenting
         autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype cpp setlocal tabstop=3 softtabstop=3 shiftwidth=3
         autocmd Filetype c setlocal tabstop=3 softtabstop=3 shiftwidth=3


         autocmd FileChangedShell * echo "Warning: File changed on disk"

         " Always strip trailing whitespace when editing a file
         " autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

         " For all text files set 'textwidth' to 78 characters.
         autocmd FileType text setlocal textwidth=78

         " When editing a file, always jump to the last known cursor position.
         " Don't do it when the position is invalid or when inside an event handler
         " (happens when dropping a file on gvim).
         " Also don't do it when the mark is in the first line, that is the default
         " position when opening a file.
         autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

      augroup END

   endif " has("autocmd")
   " }}}
" Custom Functions {{{
   " strips trailing whitespace at the end of files. this is called on buffer write in the autogroup above.
   function! <SID>StripTrailingWhitespaces()
      " save last search & cursor position
      let _s=@/
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      let @/=_s
      call cursor(l, c)
   endfunction

   " Convenient command to see the difference between the current buffer and
   " the file it was loaded from, thus the changes you made. Only define it
   " when not defined already.
   if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
         \ | wincmd p | diffthis
   endif
   " }}}
" Vundle {{{
   filetype off                              " required

   " set the runtime path to include Vundle and initialize
   if has( "macunix" )
      set rtp+=~/.vim/bundle/Vundle.vim
      call vundle#begin()
   elseif has( "unix" )
      set rtp+=~/.vim/bundle/Vundle.vim
      call vundle#begin()
   elseif has( "win32" )
      set rtp+=C:/Program\ Files\ (x86)/Vim/vimfiles/bundle/Vundle.vim
      call vundle#begin('C:/Program\ Files\ (x86)/Vim/vimfiles')
   else
      :echo "Unhandled platform"
   endif

   " let Vundle manage Vundle, required
   Plugin 'VundleVim/Vundle.vim'
   Plugin 'kien/ctrlp.vim'
   "Plugin 'Valloric/YouCompleteMe'
   Plugin 'derekwyatt/vim-fswitch'
   Plugin 'majutsushi/tagbar'
   "Plugin 'scrooloose/syntastic'
   "Plugin 'godlygeek/tabular'
   "Plugin 'tomtom/tcomment_vim'
   "Plugin 'ton/vim-bufsurf'
   "Plugin 'tpope/vim-surround'

   " All of your Plugins must be added before the following line
   call vundle#end()                         " required
   filetype plugin indent on                 " required
   " }}}
" Custom Mappings {{{
   " New line above/below, stay in normal mode
   nnoremap <S-Enter> O<Esc>
   nnoremap <CR> o<Esc>

   " Make Y yank the rest of the line (yy yankes the line)
   nnoremap Y y$

   " Remap space to fold/unfold section
   nnoremap <space> za

   " Disable highlight
   nnoremap <silent> <leader><cr> :noh<cr>

   " History sensitive buffer jumping
   nnoremap <leader><C-o> :BufSurfBack<CR>
   nnoremap <leader><C-i> :BufSurfForward<CR>

   " File switch mappings
   nnoremap <leader>fs :FSHere<CR>

   " Navigate through buffer list
   nnoremap <leader>n :bnext<CR>
   nnoremap <leader>p :bprevious<CR>

   " Tagbar toggle for viewing organized tag list of current buffer
   nnoremap <leader>tb :TagbarToggle<CR>

   " Edit/reload .vimrc
   nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
   nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

   " Map window movement
   nnoremap <C-j> <C-w><C-j>
   nnoremap <C-k> <C-w><C-k>
   nnoremap <C-l> <C-w><C-l>
   nnoremap <C-h> <C-w><C-h>

   " Quickly change height and width
   nnoremap <leader>wi :vertical resize +20<CR>
   nnoremap <leader>wd :vertical resize -20<CR>
   nnoremap <leader>hi :resize +20<CR>
   nnoremap <leader>hd :resize -20<CR>

   " Open/close quickfix
   nnoremap <leader>qo :copen<CR>
   nnoremap <leader>qc :cclose<CR>

   " bind \ (backward slash) to grep shortcut
   if !exists(":Ag")
      command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
      nnoremap <leader>a :Ag -i<SPACE>
   endif

   " bind K to grep word under cursor
   nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

   " Open ctrlp
   let g:ctrlp_map = '<c-p>'
   let g:ctrlp_cmd = 'CtrlP'
   " }}}
" Plugins {{{
   " Syntastic
   " set statusline+=%#warningmsg#
   " set statusline+=%{SyntasticStatuslineFlag()}
   " set statusline+=%*

   " let g:syntastic_always_populate_loc_list = 1
   " let g:syntastic_auto_loc_list = 1
   " let g:syntastic_check_on_open = 1
   " let g:syntastic_check_on_wq = 0

   " CtrlP
   " Root directory will be manually set in local config
   let g:ctrlp_working_path_mode = 0
   " }}}

" *****************************************************************************

set exrc " Allow loading 'project' specific settings from working directory config files

" vim: tabstop=3 softtabstop=3 shiftwidth=3 expandtab :
" vim: foldmethod=marker foldmarker={{{,}}} foldmethod=marker foldlevel=0 :

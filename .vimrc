" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible                          " be iMproved, required

" *****************************************************************************

" VIM Functional {{{
   "set history=50                            " Keep 50 lines of command line history
   set nobackup                              " Do not keep a backup file
   set viminfo^=%                            " Remember info about open buffers on close
   set tags=tags;                            " http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
   set autoread
   set nrformats=alpha,hex                   " for incrementing with CTRL-A, CTRL-X
   " set hidden                                " hide buffers instead of closing them
   " if has( "formatoptions" )
      " set formatoptions-=cro            "set formatoptions+=j
   " endif

   "undo persistence
   if has('persistent_undo')

      if has( "win32" )
         let undopath = expand('$HOME') . 'vimfiles\undo'
      else
         let undopath = expand('$HOME') . '/.vim/undo'
      endif

      if !isdirectory(undopath)
         call mkdir(undopath)
      endif
      let &undodir=undopath      " set undodir=H:\vimfiles\undo
      set undofile
      set undolevels=1000
      set undoreload=10000
   endif

   "autocompletion
   set completeopt=longest,menuone
   inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
   inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
     \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
   inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
     \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

   "set path+=.\**                           "When not on windows: set path=$PWD/**
   " }}}
" Colors {{{
   " set t_Co=256
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
   set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<     " for :set list
   " }}}
" UI Config {{{
   set ttyfast                               " Speed redrawing by transferring more characters to redraw
   set lazyredraw                            " Don't auto redraw screen when executing macros, improves performance
   set number                                " Show line numbers
   set showcmd                               " Show command as typed in status bar
   set splitbelow                            " Split below by default
   set ruler                                 " show the cursor position all the time
   set showmatch                             " show matching brackets

   " set font based on platform
   if has( "macunix" )
      set guifont=Consolas:h9:cANSI    " not tested
   elseif has( "unix" )
      set guifont="DejaVu Sans Mono 10"
   elseif has( "win32" )
      set guifont=Consolas:h9:cANSI
   else
      set guifont=Consolas:h9:cANSI    " not tested
   endif

   " set lines=50                              " GUI 50 lines long
   " set columns=100                           " GUI 100 columns wide
   set cursorline                            " Highlight the line of the cursor
   set nowrap                                " Don't wrap lines
   set visualbell                            " don't beep
   set noerrorbells                          " don't beep
   set guioptions-=R                         " no scrollbars
   set guioptions-=L                         " no scrollbars
   set guioptions-=r                         " no scrollbars
   set guioptions-=l                         " no scrollbars
   set diffopt=vertical,filler               " When opening vimdiff always split vertical and show filler lines for missing text
   set backspace=indent,eol,start            " backspacing over everything in insert mode
   set laststatus=2                          " always show the status bar
   " }}}
" Searching, Wildmode {{{
   set smartcase                             " case-insensitive if search is lowercase, case-sensitive otherwise
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
   endif
   " }}}
" Folding {{{
   set modelines=2                           " Ensure that modeline at bottom of file will enable folding in vimrc if it is opened later for editing
   set foldenable                            " Use folding
   set foldlevelstart=0
   set foldnestmax=99

   if !exists("fold_auto_cmd")
      let fold_auto_cmd = 1
      let g:LargeFile = 5 * 1024 * 1024

      augroup LargeFile
         autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set foldmethod=indent |  else | set foldmethod=syntax | endif
      augroup END

"       if getfsize(expand("<afile>")) > 5 * 1024 * 1024
"          set foldmethod=syntax                     " Use language syntax for folding - Filetype specific fold behavior under 'AutoGroups'
"       else
"          set foldmethod=indent
      " endif
   endif

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
         autocmd Filetype json setlocal tabstop=4 softtabstop=4 shiftwidth=4

         " filetype specific folding
         autocmd Filetype python setlocal foldmethod=indent foldlevelstart=0

         " manual fold mode when editing so folds below cursor don't open
         " autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
         " autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

         " Always strip trailing whitespace when editing a file
         autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

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
      " {{{
      let g:ctrlp_working_path_mode = 0      " Root directory will be manually set in local config
      let g:ctrlp_by_filename = 1            " Search by filename by default
      let g:ctrlp_map = '<c-p>'
      let g:ctrlp_cmd = 'CtrlP'
      let g:ctrlp_extensions = ['line']
      if executable('ag')
         " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
         let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'

         " ag is fast enough that CtrlP doesn't need to cache
         let g:ctrlp_use_caching = 0
      endif
      " }}}
   Plugin 'derekwyatt/vim-fswitch'
      " {{{
      nnoremap <leader>fs :FSHere<CR>
      " }}}
   Plugin 'majutsushi/tagbar'
      " {{{
      nnoremap <leader>tb :TagbarToggle<CR>
      nnoremap <leader>tbp :TagbarTogglePause<CR>
      let g:tagbar_autofocus = 1
      " }}}
   Plugin 'thinca/vim-visualstar'
   Plugin 'davidhalter/jedi-vim'
   Plugin 'scrooloose/nerdtree'
   Plugin 'Valloric/YouCompleteMe'
      " {{{
      let g:ycm_autoclose_preview_window_after_completion = 1
      let g:ycm_complete_in_comments = 1
      let g:ycm_collect_identifiers_from_tags_files = 1
      let g:ycm_confirm_extra_conf = 0
      let g:ycm_show_diagnostics_ui = 0
      let g:ycm_server_python_interpreter = 'C:\Python35-32\python.exe'
      let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1, 'c': 1}
      " noremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
      " }}}
   Plugin 'tpope/vim-commentary'
      " {{{
      autocmd Filetype cpp setl commentstring=//%s
      " }}}
   Plugin 'tmhedberg/SimpylFold'      " Improved Python folding
   Plugin 'Konfekt/FastFold'
   Plugin 'tpope/vim-unimpaired'
   Plugin 'tpope/vim-dispatch'

   " Haven't tried these yet
   "Plugin 'mbbill/undotree'  # \u is what Joe uses to show it
   "Plugin 'godlygeek/tabular'
   "pep8
   "Plugin 'ton/vim-bufsurf'
      " {{{
      " nnoremap <leader><C-o> :BufSurfBack<CR>
      " nnoremap <leader><C-i> :BufSurfForward<CR>
      " }}}
   "Plugin 'tpope/vim-surround'
   "airline
   "Plugin 'vim-scripts/TagHighlight'
   "cross reference: opengrok or cscope

   " All of your Plugins must be added before the following line
   call vundle#end()                         " required
   filetype plugin indent on                 " required
   " }}}
" Custom Mappings {{{
   " Make Y yank the rest of the line (yy yankes the line)
   nnoremap Y y$

   " Remap space to fold/unfold section
   nnoremap <space> zA

   " find next/prev _
   nnoremap - f_
   nnoremap _ F_

   " Disable highlight
   nnoremap <silent> <leader>\ :noh<cr>

   " Edit/reload .vimrc
   nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
   nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

   " Map window movement
   nnoremap <C-j> <C-w><C-j>
   nnoremap <C-k> <C-w><C-k>
   nnoremap <C-l> <C-w><C-l>
   nnoremap <C-h> <C-w><C-h>

   " Switch to vertical or horizontal
   nnoremap <leader>wv <C-w>t<C-w>H
   nnoremap <leader>wh <C-w>t<C-w>K

   " Quickly change height and width
   nnoremap <leader>wi :vertical resize +20<CR>
   nnoremap <leader>wd :vertical resize -20<CR>
   nnoremap <leader>hi :resize +20<CR>
   nnoremap <leader>hd :resize -20<CR>

   " Open/close quickfix
   nnoremap <leader>qo :copen<CR>
   nnoremap <leader>qc :cclose<CR>
   nnoremap <leader>lo :lopen<CR>
   nnoremap <leader>lc :lclose<CR>

   " Add/delete to/from quickfix or location list
   nnoremap <leader>qa :call setqflist([{'filename':expand('%'), 'lnum':line('.'), 'text':getline('.')}], 'a')<CR>                  " add current line to quickfix list
   nnoremap <leader>la :call setloclist(winnr(), [{'filename':expand('%'), 'lnum':line('.'), 'text':getline('.')}], 'a')<CR>        " add current line to location list
   nnoremap <leader>qd :call setqflist(getloclist()[0:line('.')-2] + getloclist()[line('.'):line('$')])<CR>                         " delete cursor line from quickfix list
   nnoremap <leader>ld :call setloclist(winnr(), getloclist(winnr())[0:line('.')-2] + getloclist(winnr())[line('.'):line('$')])<CR> " delete cursor line from location list

   " Build tags
   nnoremap <leader>ct :Dispatch ctags -R .<CR>

   " Switch to directory of current file
   nnoremap <leader>cd :cd %:p:h<CR>

   " Neovim specific mappings
   if has('nvim')    " or if exists(':tnoremap')
      tnoremap <Esc> <C-\><C-n>     " allow escape to enter normal mode in terminal
   endif

   " Convert brackets: ( asdf ), [ asdf ], { asdf }, < asdf > to (asdf), [asdf], {asdf}, <asdf>
   nnoremap <leader>cb :%s/( /(/g<CR>
                     \ :%s/ )/)/g<CR>
                     \ :%s/\[ /[/g<CR>
                     \ :%s/ ]/]/g<CR>
                     \ :%s/{ /{/g<CR>
                     \ :%s/ }/}/g<CR>
                     \ :%s/< /</g<CR>
                     \ :%s/ >/>/g<CR>

   " If popup menu, make newline when enter is pressed
   inoremap <expr> <CR>       pumvisible() ? "\<C-e>\<CR>" : "\<CR>"

   " bind \ (backward slash) to grep shortcut
   if !exists(":Ag")
      command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
      nnoremap <leader>a :Ag -i<SPACE>
   endif

   " bind K to grep word under cursor
   nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

   " Nerdtree
   nnoremap <leader>nt :NERDTreeToggle<CR>


   " }}}

" *****************************************************************************

set exrc " Allow loading 'project' specific settings from working directory config files

" vim: tabstop=3 softtabstop=3 shiftwidth=3 expandtab :
" vim: foldmethod=marker foldmarker={{{,}}} foldmethod=marker foldlevel=0 :

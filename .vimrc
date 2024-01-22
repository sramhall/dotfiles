" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible                          " be iMproved, required

" *****************************************************************************

" VIM Functional {{{
   "set history=50                            " Keep 50 lines of command line history
   set nobackup                              " Do not keep a backup file
   " set viminfo^=%                            " Remember buffer list
   set tags=tags;                            " http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
   set autoread
   set nrformats=alpha,hex                   " for incrementing with CTRL-A, CTRL-X
   " set hidden                                " hide buffers instead of closing them
   set foldopen+=jump foldopen-=block foldopen-=hor   " open folds for jumps, but not for block or horizontal movement
   set virtualedit=block                     " allow cursor to go where there is no character in visual block mode
   set directory=.                           " save .swp files in same directory as edited file

   " set spell spelllang=en_us                 " turn on spell check
   " set spellfile=~/.en.utf-8.add

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
   " }}}
" Colors {{{
   " set t_Co=256
   syntax on                                 " Switch syntax highlighting on
   colorscheme desert                        " Set color scheme

   set colorcolumn=100                       " Set a margin at 100 lines
   highlight ColorColumn ctermbg=red ctermfg=white guibg=#592929
   " }}}
" Whitespace / Indentation {{{
   filetype plugin indent on                 " Enable filetype detection--specific behavior for plugins and indent
   set tabstop=4                             " Tab is equivalent to 3 spaces
   set softtabstop=4                         " Use 3 spaces when pressing tab in insert mode
   set shiftwidth=4                          " Shifting/indenting text inserts 3 spaces
   set expandtab                             " Always expand tabs to spaces
   set autoindent                            " Copy indent from current line when creating new line
   set copyindent                            " Copy indent from previous line
   set shiftround                            " Round indent value to multiples of shiftwidth
   set smarttab
   set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<     " for :set list
   " if exists('+breakindent')
   "    set breakindent showbreak=\ +          " indent when wrapping and add '+' to the front of the wrapped lines
   " endif
   " }}}
" UI Config {{{
   set ttyfast                               " Speed redrawing by transferring more characters to redraw
   set lazyredraw                            " Don't auto redraw screen when executing macros, improves performance
   set number                                " Show line numbers
   set showcmd                               " Show command as typed in status bar
   set splitbelow                            " Split below by default
   set ruler                                 " show the cursor position all the time
   set showmatch                             " show matching brackets

   if has("nvim")
      if has( "macunix" )
         " Guifont Courier New:h14
      end
      set mousemodel=extend
   elseif !has("gui_vimr")
      " set font based on platform
      if has( "macunix" )
         set guifont=Menlo-Regular:h14
      elseif has( "unix" )
         set guifont="DejaVu Sans Mono 10"
      elseif has( "win32" )
         set guifont=Consolas:h9:cANSI
      else
         set guifont=Consolas:h9:cANSI    " not tested
      endif
   endif

   " set lines=50                              " GUI 50 lines long
   " set columns=100                           " GUI 100 columns wide
   set cursorline                            " Highlight the line of the cursor - makes drawing slower
   set nowrap                                " Don't wrap lines
   set linebreak                             " uses chars in breakat when wrap is on
   set visualbell                            " don't beep
   set noerrorbells                          " don't beep
   set guioptions-=R                         " no scrollbars
   set guioptions-=L                         " no scrollbars
   set guioptions-=r                         " no scrollbars
   set guioptions-=l                         " no scrollbars
   set diffopt=vertical,filler               " When opening vimdiff always split vertical and show filler lines for missing text
   set backspace=indent,eol,start            " backspacing over everything in insert mode
   set laststatus=2                          " always show the status bar
   " set cmdheight=2                           " set command-line height. Helps avoid hit-enter prompts
   set winaltkeys=no                         " don't allow key combination for window menus
   set winminheight=0                        " reduce to 0 so a window can be shrunk to only show the filename
   " set display=lastline                      " change the way text is displayed when a long line runs off the end of the screen
   " }}}
" Searching, Wildmode {{{
   set smartcase                             " case-insensitive if search is lowercase, case-sensitive otherwise
   set ignorecase                            " ignore case when searching
   set hlsearch                              " highlight all search results
   set incsearch                             " do incremental searching
   set wildmenu                              " Use wildmenu for tab completion
   set wildmode=longest:full
   set wildignore+=tags,*.o,*.bak,*.swp,*~,*.pyc,*.pbout,*.cout   " Ignore some files
   set scrolloff=1
   set sidescrolloff=5
   if has( "wildignorecase" )
      set wildignorecase
   endif

   " Use Ag for grep
   if executable('ag')
      set grepprg=ag\ --nogroup\ --nocolor\ --column
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
      autocmd!
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
         autocmd Filetype cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype c setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype json setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype cs setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype objc setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype objcpp setlocal tabstop=4 softtabstop=4 shiftwidth=4
         autocmd Filetype swift setlocal tabstop=4 softtabstop=4 shiftwidth=4

         " filetype specific folding
         autocmd Filetype python setlocal foldmethod=indent foldlevelstart=0
         autocmd Filetype swift setlocal foldmethod=indent foldlevelstart=99

         " manual fold mode when editing so folds below cursor don't open
         " autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
         " autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

         " Always strip trailing whitespace when editing a file
         autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

         " For all text files set 'textwidth' to 98 characters.
         autocmd FileType text setlocal textwidth=98

         " Show the cursorline only in the current window
         autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
         autocmd WinLeave * setlocal nocursorline nocursorcolumn

         " When editing a file, always jump to the last known cursor position.
         " Don't do it when the position is invalid or when inside an event handler
         " (happens when dropping a file on gvim).
         " Also don't do it when the mark is in the first line, that is the default
         " position when opening a file.
         autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

         if has("nvim")
            autocmd VimEnter * :call deoplete#custom#source('_', 'smart_case', v:true)
         endif

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
   " TODO change this to have a has("nvim") specific setting
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
      let g:ctrlp_switch_buffer = 'e'        " only jump to an existing window if it's in the current tab
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
   " Plugin 'davidhalter/jedi-vim'
   Plugin 'scrooloose/nerdtree'
   if has("nvim")
      Plugin 'Shougo/deoplete.nvim'
         " {{{
         let g:deoplete#enable_at_startup = 1
         " }}}
   endif
   Plugin 'tpope/vim-commentary'
      " {{{
      augroup commentary
         autocmd!
         autocmd Filetype cpp setl commentstring=//%s
      augroup END
      " }}}
   " Plugin 'tmhedberg/SimpylFold'      " Improved Python folding
   " Plugin 'Konfekt/FastFold'
   Plugin 'tpope/vim-unimpaired'
   Plugin 'tpope/vim-dispatch'
   if has("nvim")
      " allows vim-dispatch to use neovim terminal
      Plugin 'radenling/vim-dispatch-neovim'
   endif
   Plugin 'tpope/vim-surround'
   Plugin 'vim-airline/vim-airline'
      " {{{
      let g:airline#extensions#tagbar#enabled = 0     " this integration is broken with the git commit message, so disable it
      let g:airline_section_b = ''
      let g:airline_section_x = ''
      let g:airline_section_y = ''
      let g:airline_section_error = ''
      " }}}
   Plugin 'vim-airline/vim-airline-themes'
      " {{{
      let g:airline_theme='light'
      " }}}
   Plugin 'tpope/vim-capslock'

   " The snippet engine
   " Plugin 'sirver/ultisnips'
   " The snippet contents
   Plugin 'honza/vim-snippets'
      " {{{
      let g:UltiSnipsExpandTrigger="<c-e>"
      let g:UltiSnipsJumpForwardTrigger="<c-b>"
      let g:UltiSnipsJumpBackwardTrigger="<c-z>"
      " }}}
   Plugin 'tpope/vim-repeat'
   Plugin 'nvie/vim-flake8'
   Plugin 'ervandew/supertab'
      " {{{
      " Go through completion menu from top to bottom
      let g:SuperTabDefaultCompletionType = "<c-n>"
      " }}}

   " Haven't tried these yet
   "Plugin 'mbbill/undotree'  # \u is what Joe uses to show it
   "Plugin 'godlygeek/tabular'
   "pep8
   "Plugin 'ton/vim-bufsurf'
      " {{{
      " nnoremap <leader><C-o> :BufSurfBack<CR>
      " nnoremap <leader><C-i> :BufSurfForward<CR>
      " }}}
   "Plugin 'vim-scripts/TagHighlight'
   Plugin 'tpope/vim-fugitive'
   "cross reference: opengrok or cscope

   Plugin 'keith/swift.vim'
   " Plugin 'inkarkat/vim-mark'

   " All of your Plugins must be added before the following line
   call vundle#end()                         " required
   filetype plugin indent on                 " required

   " Must be after vundle#end()
   if has("nvim")
      call deoplete#custom#source('_', 'smart_case', v:true)
   endif
   " }}}
" Custom Mappings {{{
   let mapleader = "\\"       " for <leader>
   " let maplocalleader = "-"   " for <localleader>

   " replace <esc> with jk
   inoremap jk <esc>
   inoremap JK <esc>
   " inoremap <esc> <nop>

   " Make Y yank the rest of the line (yy yankes the line)
   nnoremap Y y$

   " Remap space to fold/unfold section
   nnoremap <space> zA

   " find next/prev _
   nnoremap - f_
   nnoremap _ F_

   " Disable highlight
   nnoremap <silent> <leader>nh :noh<cr>

   " Edit/reload .vimrc
   nnoremap <silent> <leader>ev :split $MYVIMRC<CR>
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
   nnoremap <leader>qo :botright cwindow<CR>
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

   " 'Project File': change directory and source (e.g. _vimrc file)
   nnoremap <leader>pf :cd %:p:h<CR>:so %<CR>

   " Copy the current filename to the * register
   nnoremap <leader>cf :let @*=expand('%')<CR>

   " Neovim specific mappings
   if has('nvim')    " or if exists(':tnoremap')
      tnoremap jk <C-\><C-n>     " allow escape to enter normal mode in terminal
      tnoremap JK <C-\><C-n>     " allow escape to enter normal mode in terminal
      nnoremap <leader>f :split term://fish<CR>
      nnoremap <leader>fv :vsplit term://fish<CR>

      if has("win32")
         nnoremap <leader>gb :e term://git-cmd.exe --no-cd --command=usr/bin/bash.exe -l -i<CR>
      endif
   endif

   " If popup menu, make newline when enter is pressed
   inoremap <expr> <CR> pumvisible() ? "\<C-e>\<CR>" : "\<CR>"

   " bind \ (backward slash) to grep shortcut
   if !exists(":Ag")
      command -nargs=+ -complete=file -bar Ag silent! grep! <args>|botright cwindow|redraw!
      nnoremap <leader>a :Ag -sw<SPACE>
   endif

   " bind K to grep word under cursor
   nnoremap K :grep! "\b<cword>\b"<CR>:botright cwindow<CR>

   " search for whole word
   nnoremap <leader>/ /\<\><left><left>

   " Nerdtree
   nnoremap <leader>nt :NERDTreeToggle<CR>
   " nnoremap <leader>nt :Lexplore<CR>

   " commands to set up subtitute with the word or WORD under the cursor
   nnoremap <leader>sw :s/\(<c-r>=expand("<cword>")<cr>\)/
   nnoremap <leader>sW :s/\(<c-r>=expand("<cWORD>")<cr>\)/

   " Next method for "Java" like language, etc
   nnoremap ]] ]m
   nnoremap ][ ]M
   nnoremap [[ [m
   nnoremap [] [M


   " }}}

" *****************************************************************************

set exrc " Allow loading 'project' specific settings from working directory config files

" vim: tabstop=3 softtabstop=3 shiftwidth=3 expandtab :
" vim: foldmethod=marker foldmarker={{{,}}} foldmethod=marker foldlevel=0 :

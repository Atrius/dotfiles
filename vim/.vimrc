set nocompatible

call plug#begin('~/.vim/plugged')

" General YCM configuration.  Note that the specific version of YCM must be
" provided by the extension point (below).
let g:ycm_auto_trigger = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_select_completion = ['<Down>', '<Enter>']
let g:ycm_always_populate_location_list = 1

nnoremap gd :YcmCompleter GoTo<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>

" YCM formatting: these are pretty nice, but they do seem to format the
" *following* line as well as the current selection.  See if that can be fixed?
nnoremap ff :.YcmCompleter Format<CR>
vnoremap ff :YcmCompleter Format<CR>

" YCM fixit: also works for adding includes (maybe don't need include fixer).
nnoremap fi :YcmCompleter FixIt<CR>

" Function arguments as a text object.
Plug 'vim-scripts/argtextobj.vim'

" Better syntax highlighting for C++.
Plug 'octol/vim-cpp-enhanced-highlight'

" Easier session management through :Obsess.
Plug 'tpope/vim-obsession'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'

nnoremap <F3> :LspDefinition<CR>  " gd in Normal mode triggers gotodefinition
nnoremap <F4> :LspReferences<CR>  " F4 in Normal mode shows all references

" Airline.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme="powerlineish"
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#empty_message = "no .git"
let g:airline#extensions#tabline#enabled =  1
let g:airline#extensions#tabline#buffer_nr_show = 1 " tab number
let g:airline#extensions#tabline#fnamecollapse = 1 " /a/m/model.rb

" Fuzzy finder
Plug 'junegunn/fzf', {'dir': '~/fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Changes the default source for FZF to try getting files known to hg/git first,
" and only use find on the whole tree if that doesn't work.
let $FZF_DEFAULT_COMMAND="(hg files || git ls-tree -r --name-only HEAD || rg --files) 2> /dev/null"

" Display a top-down list, rather than the default bottom-up list.
let $FZF_DEFAULT_OPTS='--layout=reverse'

nnoremap gb :Buffers<CR>  " Fuzzy-finder for open buffers
nnoremap gf :Files<CR>    " Fuzzy-finder for files

" Misc. settings (alphabetized):
set autoindent smartindent nocindent
set autoread  " Automatically load external changes (eg. git).
set clipboard=unnamedplus  " Use the system clipboard for copy/paste.
set expandtab  " Substitute spaces for tabs.
set ignorecase smartcase  " Ignore case when searching (unless I type uppercase).
set incsearch  " Show seach results while typing.
set nobackup  " Don't litter the workspace with swap files.
set ruler  " Show the cursor position (line/column number) all the time.
set scrolloff=3  " Always show 3 lines above/below the cursor.
set termguicolors&  " Required magic to fix colors in tmux
set shiftwidth=2 tabstop=2 " Indent with 2 spaces instead of tabs!
set wildmenu  " Tab-completion of files when typing : commands.
set wildmode=longest:full,full

autocmd BufNewFile,BufRead hg-editor-*.txt setlocal spell textwidth=80
autocmd BufNewFile,BufRead .git/COMMIT_EDITMSG setlocal spell textwidth=72
autocmd BufNewFile,BufRead cl_description* setlocal spell textwidth=72

" Show line numbers, but only if the window is wide enough that it helps.
if &columns > 84
  set number
endif

" Trigger autoread when changing focus or windows.
au FocusGained,BufEnter * :silent! !

" Status line settings (makes airline work).
set laststatus=2  "Every window has
set noshowmode " show mode with airline instead
set background=dark " Required magic to fix colors in tmux
set t_Co=256

" Key bindings

" Change ctrl+h/l to switch windows.
" Note: <C-w>j and <C-w>k switch up and down, but I don't really use horizontal
" splits, so those are mapped to something more useful (paging up/down).
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Change ctrl+j/k to page up and down by half-pages.
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
vnoremap <C-j> <C-d>
vnoremap <C-k> <C-u>

" Change ctrl+h/j/k/l to move around in insert mode.
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-h> <left>
inoremap <c-l> <right>

" Create a :Bc command to close a buffer without closing the window.
command! Bc bp|bd #

" fix Y == yy
nnoremap Y y$

" Shortcut for getting out of insert mode
inoremap jk <Esc>

" workaround for YCM crash on exit
au VimLeave * call timer_stopall()

" Extension point.
let ext_path = $HOME . '/.vim/vimrc_ext.vim'
if filereadable( ext_path )
  exec 'source ' . ext_path
endif

call plug#end()
" Note: plug#end automatically does the following:
"   filetype plugin indent on
"   syntax on

" Note: formatoptions is reset to the Vim default when plug#end() is called.
" Auto-indent for cl descriptions.
autocmd BufNewFile,BufRead cl_description* setlocal formatoptions+=t

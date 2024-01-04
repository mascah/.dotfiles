"split directions
set splitright
set splitbelow

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set nu

"Folding
set foldmethod=indent
set foldlevel=99

"Folding with space bar
nnoremap <space> za

set nocompatible     " required
filetype off         " required?

call plug#begin()

Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'ryanoasis/vim-devicons'
Plug 'nvie/vim-flake8'
Plug 'preservim/nerdtree' 
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

set encoding=utf-8

"what is this doing?
filetype plugin indent on
syntax on

"SimpylFold
let g:SimpylFold_docstring_preview=1

au BufNewFile BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Not working?
au BufRead BufNewFile *.py, *.pyw, *.c, *.h match BadWhitespace /\s\+$/

" Powerline
set laststatus=2
let g:Powerline_symbols = "fancy"

"YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
" python3 << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate')
"   # execfile(activate_this, dict(__file__=activate_this))
"   # exec(open(activate_this).read())
"   exec(open(activate_this, "rb").read(), dict(__file__=activate_this))
" EOF

" Syntastic
let python_highlight_all=1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Nerdtree
let NERDTreeIgnore=['\.pyc$']
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree when Vim is started without file arguments.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

"map  <C-l> :tabn<CR>
"map  <C-h> :tabp<CR>
"map  <C-n> :tabnew<CR>

" - Popup window (anchored to the bottom of the current window)
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }


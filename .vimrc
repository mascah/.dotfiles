" <leader> is the prefix for custom shortcuts. Space here, so <leader>f = Space then f.
let mapleader = " "

"split directions
set splitright
set splitbelow

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set nu

"Folding (za toggle, zR open all, zM close all)
set foldmethod=indent
set foldlevel=99

" Auto install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'tmhedberg/SimpylFold'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'yegappan/lsp'

call plug#end()

set encoding=utf-8

filetype plugin indent on
syntax on

" Shipped with vim 9.2, no plugins needed
packadd comment      " gcc / gc{motion} to toggle comments
packadd hlyank       " flash yanked text
packadd matchit      " % jumps across if/else/endif, html tags
packadd editorconfig

" Basics
set hidden ignorecase smartcase incsearch hlsearch
" Space Space clears search highlight
nnoremap <silent> <leader><leader> :nohlsearch<CR>
set relativenumber scrolloff=5 mouse=a termguicolors
" Terminal is dark; vim cannot detect it. Transparent gutter, explicit sign colours, readable popup menu.
" Wrapped in a function so a :colorscheme change re-applies them.
set background=dark
function! s:Highlights() abort
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight GitGutterAdd    guifg=#5faf5f ctermfg=2
  highlight GitGutterChange guifg=#d7af5f ctermfg=3
  highlight GitGutterDelete guifg=#d75f5f ctermfg=1
  highlight Pmenu    guibg=#303030 guifg=#c7c7c7 ctermbg=236 ctermfg=251
  highlight PmenuSel guibg=#5f87af guifg=#ffffff ctermbg=67  ctermfg=15
endfunction
autocmd ColorScheme * call s:Highlights()
call s:Highlights()
set clipboard=unnamed
set wildmode=longest:full,full ttimeoutlen=10
set undofile undodir=~/.vim/undo | silent! call mkdir(expand('~/.vim/undo'), 'p')
set list | let &listchars = 'trail:·,tab:→ '
set updatetime=100 signcolumn=yes
autocmd FileType python setlocal textwidth=79

"SimpylFold
let g:SimpylFold_docstring_preview=1

" Airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" NERDTree
let NERDTreeIgnore=['\.pyc$']
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" fzf — popup window anchored to the bottom of the current window
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>o :History<CR>
nnoremap <leader>/ :BLines<CR>

" rg for :grep -> quickfix  (:grep foo, then :copen / :cn / :cp)
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob=!.git
set grepformat=%f:%l:%c:%m

" gitgutter: ]c [c next/prev hunk, <leader>hp preview, <leader>hs stage, <leader>hu undo

" LSP (yegappan/lsp). Missing server binaries are ignored.
let g:lsp_options = #{showDiagWithVirtualText: v:true, ignoreMissingServer: v:true, noNewlineInCompletion: v:true}
let g:lsp_servers = [
    \ #{name: 'pyright', filetype: ['python'], path: 'pyright-langserver', args: ['--stdio']},
    \ #{name: 'gopls', filetype: ['go', 'gomod'], path: 'gopls', args: ['serve']},
    \ #{name: 'rust-analyzer', filetype: ['rust'], path: 'rust-analyzer', args: [], syncInit: v:true},
    \ #{name: 'tsserver', filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'], path: 'typescript-language-server', args: ['--stdio']},
    \ ]

" Completion popup: Tab / Shift-Tab move through items, Enter accepts the highlighted one.
" With nothing highlighted, Enter is an ordinary newline. Ctrl-E closes the popup.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() && complete_info(['selected']).selected >= 0 ? "\<C-y>" : "\<CR>"

function! s:LspMaps() abort
  nnoremap <buffer> gd :LspGotoDefinition<CR>
  nnoremap <buffer> gr :LspShowReferences<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> <leader>rn :LspRename<CR>
  nnoremap <buffer> <leader>ca :LspCodeAction<CR>
  nnoremap <buffer> ]d :LspDiag next<CR>
  nnoremap <buffer> [d :LspDiag prev<CR>
  nnoremap <buffer> <leader>d :LspDiag current<CR>
endfunction
autocmd User LspAttached call s:LspMaps()

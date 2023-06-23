"   ____   __    ___  _____  ____    ____   __    ____  ____  __    __      __
"  (_  _) /__\  / __)(  _  )(  _ \  (  _ \ /__\  (  _ \(_  _)(  )  (  )    /__\
" .-_)(  /(__)\( (__  )(_)(  ) _ <   )___//(__)\  )(_) )_)(_  )(__  )(__  /(__)\
" \____)(__)(__)\___)(_____)(____/  (__) (__)(__)(____/(____)(____)(____)(__)(__)
"
set nocompatible
set encoding=utf-8

" Autoload vim-plug and auto-install if not present
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Load plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'preservim/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ap/vim-css-color'
Plug 'alvan/vim-closetag'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

call plug#end()

let mapleader = " "

" Use <Space> to clear search highlighting and any message already displayed.
nnoremap <silent> <leader>h :noh<Bar>:echo<CR>

" [m and ]m to jump between python definitions
nnoremap [m :call search('^\\s*\\(def\\|async def\\|class\\).*:\\s*$', 'bW')<CR>
nnoremap ]m :call search('^\\s*\\(def\\|async def\\|class\\).*:\\s*$', 'wW')<CR>

" Switch windows using ctrl + hjkl in normal mode
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Switch windows using ctrl + hjkl in terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Quit a buffer or terminal
function! QuitOrCloseTerminal()
  if &buftype ==# 'terminal'
    quit!
  else
    quit
  endif
endfunction

nnoremap <leader>q :call QuitOrCloseTerminal()<CR>
tnoremap <leader>q <C-\><C-n>:call QuitOrCloseTerminal()<CR>

" Switch buffers using Ctrl-n and Ctrl-p
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

" Quickly display registers
nnoremap <Leader>r :reg<CR>

" Toggle spell check
function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
    set spelllang=en_us
  endif
endfunction

nnoremap <Leader>s :call ToggleSpell()<CR>

" Remove trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e

" When a file is opened with vim, go to the most recent line
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Auto wrap text when it goes beyond screen length
set wrap

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Set the default tab width to 4 spaces
set tabstop=4

" Use spaces instead of tabs when the Tab key is pressed
set expandtab

" Set the amount of visual space (in columns) for tab characters.
set shiftwidth=4

" Automatically indent lines to match the surrounding lines
set autoindent

" Enable line numbers
set number relativenumber

" Ignore case when searching
set ignorecase

" Show matching brackets, parenthesis etc. when the cursor is over them
set showmatch

" The minimum number of lines to keep above and below the cursor.
set scrolloff=10

" Allows you to use the mouse on a (all) modes.
set mouse=a

" Highlight all instances of the search pattern in the file
set hlsearch
set incsearch

" Change split behavior
set splitright
set splitbelow

" Allows you to switch between buffers without having to write changes first.
set hidden

" --------------- Color Scheme ---------------
" Fix background: https://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Fix number colors
function! MyHighlights() abort
    hi LineNr ctermfg=63 ctermbg=236 cterm=NONE guifg=#6272a4 guibg=#282a36 gui=NONE
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

" Change color of misspelled words
autocmd ColorScheme * highlight SpellBad ctermfg=white ctermbg=red gui=undercurl guifg=white guibg=red

"  Make the dotted lines a tiny bit darker
let g:indentLine_color_term = 238

" Enable syntax highlighting
syntax on
colorscheme dracula

" Line cursor on insert mode
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"

" Combing Git Fugitive with Git Gutter to make one airline section for Git
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

let g:airline_section_b = '%{FugitiveStatusline()} %{GitStatus()}'

"  -------------- Nerd Tree --------------
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"  -------------- Vim Emmet --------------
let g:user_emmet_settings = {
\  'variables': {'lang': 'en', 'charset': 'UTF-8'},
\  'html': {
\    'default_attributes': {
\      'option': {'value': v:null},
\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
\    },
\    'snippets': {
\      'html:5': "<!DOCTYPE html>\n"
\               ."<html lang=\"${lang}\">\n"
\               ."<head>\n"
\               ."\t<meta charset=\"${charset}\">\n"
\               ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
\               ."\t<title>${1}</title>\n"
\               ."</head>\n"
\               ."<body>\n${1}\n</body>\n"
\               ."</html>",
\    },
\  },
\}

"  -------------- Vim Startify --------------
let uname_output = substitute(system('uname -om'), '\n', '', '')
let uname_output = substitute(uname_output, '\%x00', '', 'g')
let g:startify_custom_header = [
        \ '   ' . uname_output
        \ ]

let g:startify_lists = [
        \ { 'type': 'files', 'header': ['   Recent Files   '] },
        \ ]

" Maximum number of MRU entries to show.
let g:startify_files_number = 5

"  -------------- Git Gutter --------------
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)

" Toggle Git Gutter with leader g
nnoremap <leader>g :GitGutterSignsToggle<CR>

let g:gitgutter_signs = 0
let g:gitgutter_map_keys = 0

"  -------------- Auto Closing --------------
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js,*.tsx'
let g:closetag_filetypes = '*.html,*.xhtml,*.jsx,*.js,*.tsx'

" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = ''
let g:closetag_xhtml_filetypes = ''

" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" Disables auto-close if not in a valid region (based on file type)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

"  -------------- Fuzzy Finder --------------
nnoremap <Leader>f :FZF<CR>

"  -------------- Tagbar --------------
nmap <Leader>t :TagbarToggle<CR>

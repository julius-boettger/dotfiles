syntax enable " syntax highlighting
set encoding=utf8
set magic " use regex
set showmatch " highlight matching brackets
set ai " auto indent
set si " smart indent

" use 4 spaces instead of tab
set expandtab " use spaces instead of tabs
set smarttab " be smart idk
set tabstop=4 " display tab as X spaces
set shiftwidth=4 " insert X spaces when pressing tab

" search
set hlsearch " highlight results
set ignorecase
set smartcase " be smart idk
set incsearch " be even smarter idk

"----- key mappings
" normal mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

nnoremap K o<Esc>k

" visual mode
vnoremap <Tab> >
vnoremap <S-Tab> <

" normal and visual mode
nnoremap ß :noh<CR>
vnoremap ß :noh<CR>

nnoremap ö ^
vnoremap ö ^

nnoremap ä $
vnoremap ä $
" vimrc - e560 - avivace

set background=dark

set nocompatible              " be iMproved, required
filetype off                  " required

" If vim-plug is not found, install it and every plugin
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }
  "Plug 'vim-airline/vim-airline'
  Plug 'godlygeek/csapprox'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'itchyny/lightline.vim'
call plug#end()

" Color scheme
syntax on
set t_Co=256
colorscheme catppuccin_macchiato
 
let g:lightline = {'colorscheme': 'catppuccin_macchiato'}
let g:airline_theme = 'catppuccin_macchiato'

" Show airline
set laststatus=2

" .pl for prolog, not perl
au BufRead,BufNewFile *.pl set filetype=prolog

" jj brings you the normal mode
:imap jj <Esc>

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Code readability
set number
set colorcolumn=100

set termguicolors

set noshowmode

set shortmess=I

set clipboard=unnamedplus

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''


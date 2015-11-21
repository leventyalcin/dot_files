set nocompatible

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler					" show the cursor position all the time
"set noshowcmd				" don't display incomplete commands
set nolazyredraw			" turn off lazy redraw
set number					" line numbers

" Tab completion
" -------------------------------------
set wildmenu				" turn on wild menu
set wildmode=list:longest,list:full
set complete=.,w,t
imap <S-Tab> <C-P>
" -------------------------------------

set ch=2					" command line height
set backspace=2				" allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,]	" backspace and cursor keys wrap to
set shortmess=filtIoOA		" shorten messages
set report=0				" tell us about changes
set nostartofline			" don't jump to the start of line when scrolling
set showcmd					" display incomplete commands
set tabstop=2 shiftwidth=2 expandtab 
set autoindent				" automatic indent new lines
set smartindent				" be smart about it
set formatoptions+=n		" support for numbered/bullet lists


" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch				" brackets/braces that is
set mat=5					" duration to show matching brace (1/10 sec)
set incsearch				" do incremental searching
set laststatus=2			" always show the status line
set ignorecase				" ignore case when searching
"set nohlsearch				" don't highlight searches
set visualbell				" shut the fuck up

" Snippets are activated by Tab
let g:snippetsEmu_key = "<Tab>"

" Display extra whitespace
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\

syntax on

" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()

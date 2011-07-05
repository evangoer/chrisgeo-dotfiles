set nocompatible 
set number
set ruler
syntax on
let mapleader = ","

set t_Co=256

"encoding
set encoding=utf-8


" Whitespace stuff
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set list listchars=tab:\ \ ,trail:·
set autoindent          " always set autoindenting on
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

"Status bar
let laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

"History stuff
set history=300          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands

"search
set incsearch           " do incremental searching
set ignorecase          "ignore case
set smartcase
set hls is ic scs
"set hlsearch

"-----------------------------

"back up stuff
set noswapfile
set nobackup            " don't save backup
set writebackup         " keep backup while editing
set backupdir=/tmp


if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup           " keep a backup file
  "Create a backup folder, I like to have it in $HOME/vimbackup/date/
  let day = strftime("%Y.%m.%d")
  let backupdir = $HOME."/.vim/tmp/backup/".day
  silent! let xyz = mkdir(backupdir, "p")
  
  "Set the backup folder
  let cmd = "set backupdir=".backupdir
  execute cmd
  
  "Create an extention for backup file, useful when you are modifying the 
  ""same file multiple times in a day. I like to have an extention with
  "time hour.min.sec
  let time = strftime(".%H.%M.%S")
  let cmd = "set backupext=". time
  execute cmd
endif

colorscheme mustang

"http://www.vim.org/tips/tip.php?tip_id=696
" dont let mouse switch into selection mode
set mouse=a

"set backspace=indent,eol,start    "Make backspaces delete sensibly

"let Tlist_Use_Horiz_Window=1

"janus

" Custom Commands
map <F2> :w<CR> :!jslint % <CR>
" Make a Gist of this file..
map <S-F9> :w<CR> :!gist %<CR>
" Bufferlist
map <silent> <F3> :call BufferList()<CR>

" Taglist commands
map <Leader>tg :TlistToggle<CR>

"-----------------------------
"Custom templates/syntax highlighting
au BufRead,BufNewFile *.jinja2,*.jtmpl set filetype=htmljinja

"python specific
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
" Execute file being edited with <Shift> + e:
map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>

"Enable HTML syntax highlighting inside strings: >
let php_htmlInStrings = 1

"-----------
"Janus
"----------
" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

" Toggle highlight search
map <Leader>z :set hls!<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

"session mappings
map <leader>s :mksession! ~/.vim/sessions/session.vis

au BufRead *.vis so %

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 shiftwidth=4 softtabstop=4 textwidth=79

" make javascript type at 80 chars
au FileType javascript set tabstop=4 textwidth=80

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
"nmap <C-Up> [e
"nmap <C-Down> ]e
" Bubble multiple lines
"vmap <C-Up> [egv
"vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" MacVIM shift+arrow-keys behavior (required in .vimrc)
"let macvim_hig_shift_movement = 1

" Special function for highlighting repeats
function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
" Folding
setlocal foldcolumn=3

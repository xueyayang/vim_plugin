set nocompatible
filetype off

set rtp+=~/nvim/bundle/Vundle.vim
call vundle#begin()

"Vundle itself
"Plugin 'gmarik/vundle'

"Colorscheme package
Plugin 'flazz/vim-colorschemes'

"minibufexpl
Plugin 'https://github.com/fholgado/minibufexpl.vim'

"vim-airline
Plugin 'bling/vim-airline'

"NerdTree
Plugin 'https://github.com/scrooloose/nerdtree.git'

"ultisnips
"Plugin 'SirVer/ultisnips'

" cpp syntax
"Plugin 'octol/vim-cpp-enhanced-highlight'

"syntastic
Plugin 'https://github.com/scrooloose/syntastic.git'

"vim-markdown
"Plugin 'plasticboy/vim-markdown'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" vundle end
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


set backspace=indent,eol,start
syntax on

"1 Monokai
"2 desert
"3 solarized
let themechoose=1
if themechoose == 1
  colorscheme Monokai
elseif themechoose == 2
  colorscheme desert
else 
  colorscheme solarized8_light
endif
set nu
set tw=78
set tabstop=4
set shiftwidth=4
set cino=g0 
"set formatoptions=ron2m1Bal 
set autochdir 
set hlsearch 
set cindent
set relativenumber
set clipboard=unnamedplus

"set tags+=/home/znuser/ZienonTechnology/ThirdPartyLibrary/axis2c-src-1.6.0/tags
"set tags+=/home/znuser/ZienonTechnology/ObjDetectorFramework/tags
au BufRead,BufNewFile *.wsgi set ft=python


set guifont=Andale\ Mono\ 13

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

"call pathogen#infect()

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction


"open tag in tab
"nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
nnoremap <C-]> <C-w><C-]><C-w>T

" swap the word seprate by colon. 
" e.g.  first : second -->  second first
command -range Swap :<line1>,<line2>s/\(\w\+\)\s:\s*\(\w\+\)/\2 \1/g 


let g:vim_markdown_folding_disabled=1
"let g:UltiSnipsExpandTrigger="<c-l>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

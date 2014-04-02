set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Vundle itself
Bundle 'gmarik/vundle'

"NerdTree
Bundle 'git@github.com:scrooloose/nerdtree.git'

"minibufexpl
Bundle 'git@github.com:fholgado/minibufexpl.vim.git'

"syntastic
Bundle 'git@github.com:scrooloose/syntastic.git'

"ultisnips
Bundle 'git@github.com:SirVer/ultisnips.git'

"vim-markdown
Bundle 'plasticboy/vim-markdown'

"vim-operator highlight
Bundle 'git@github.com:Valloric/vim-operator-highlight.git'

"vim-airline
Bundle 'bling/vim-airline'

filetype plugin indent on

set backspace=indent,eol,start
syntax on
colorscheme desert
set nu
set tw=78
set tabstop=4
set shiftwidth=4
set cino=g0 
"set formatoptions=ron2m1Bal 
set autochdir 
set hlsearch 
set cindent

"set tags+=/home/znuser/ZienonTechnology/ThirdPartyLibrary/axis2c-src-1.6.0/tags
"set tags+=/home/znuser/ZienonTechnology/ObjDetectorFramework/tags

au BufNewFile,BufRead *.txt set filetype=c

set guifont=Andale\ Mono\ 12

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

let g:vim_markdown_folding_disable=1
let g:UltiSnipsExpandTrigger="<c-l>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

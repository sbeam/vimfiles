" we use a vim
set nocompatible

" we like utf-8 usually
" set encoding=utf-8

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set noshowmode    " dont show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

" set number      "add line numbers
" set showbreak=>>>>
" set wrap linebreak nolist
set nowrap linebreak nolist

"try to make possible to navigate within lines of wrapped lines
" nmap <Down> gj
" nmap <Up> gk
" set fo=l

"disable visual bell
set novisualbell

set fo=l

"   "statusline setup
"   set statusline=%f\        "tail of the filename
"   "set statusline+=%{fugitive#statusline()}]
"   set statusline+=%m      "modified flag
"   set statusline+=%r      "read only flag
"   set statusline+=%h      "help file flag
"   set statusline+=%=      "left/right separator

"   "display a warning if fileformat isnt unix
"   set statusline+=%#warningmsg#
"   set statusline+=%{&ff!='unix'?'['.&ff.']':''}
"   set statusline+=%*
"   "display a warning if file encoding isnt utf-8
"   set statusline+=%#warningmsg#
"   set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
"   set statusline+=%*


"   set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
"   set statusline+=%y\       "filetype

"   "display a warning if &et is wrong, or we have mixed-indenting
"   set statusline+=%#warningmsg#
"   set statusline+=%{StatuslineTabWarning()}
"   set statusline+=%*

"   " set statusline+=%{StatuslineTrailingSpaceWarning()}

" settings for ALE linter
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠ '
let g:ale_lint_delay = 4000
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

set statusline+=%#warningmsg#
set statusline+=%{ALEGetStatusLine()}
set statusline+=%*

"   "display a warning if &paste is set
"   set statusline+=%#error#
"   set statusline+=%{&paste?'[paste]':''}
"   set statusline+=%*

"   set statusline+=%c,     "cursor column
"   set statusline+=%l   "cursor line/total lines
"   set statusline+=\ %P    "percent through file
set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T

" use blowfish with :X and -x and such
set cryptmethod=blowfish

" for CamelCaseMotion plugin (people actually use this??)
map <silent> ;w <Plug>CamelCaseMotion_w
map <silent> ;b <Plug>CamelCaseMotion_b
map <silent> ;e <Plug>CamelCaseMotion_e


" mapping for Fuzzy Finder
nmap ,ff :FufCoverageFile<CR>
nmap ,fb :FufBuffer<CR>
nmap ,fj :FufJumpList<CR>

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

" use standard to check JS https://github.com/feross/standard

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning


"indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
set foldmethod=marker   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set foldenable          "enable folding

set wildmode=list:full   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

" read .vimrc in dir vim is started from
set exrc

"necessary on some Linux distros for pathogen to properly load bundles
filetype off

"load pathogen managed plugins
call pathogen#runtime_append_all_bundles()

" Plug.vim plugins {{{
" https://github.com/junegunn/vim-plug
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
  " Make sure you use single quotes

  " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
  Plug 'junegunn/vim-easy-align'
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
  autocmd! User goyo.vim echom 'Goyo is now loaded!'

  Plug 'zxqfl/tabnine-vim', { 'for': ['rust','ruby','javascript','go','html','css'] }
  Plug 'jamessan/vim-gnupg'
  Plug 'vim-scripts/FuzzyFinder'
  Plug 'w0rp/ale'

  Plug 'hashivim/vim-terraform'
  Plug 'reedes/vim-pencil'
call plug#end()
"}}}


"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

" nmap <silent> <Leader>p :NERDTreeToggle<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to bufexplorer
nnoremap ,b :BufExplorer<CR>

"map Q to something useful
" noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"
"bindings for ragtag
inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>

let g:ragtag_global_maps = 1

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the off#nding parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

set ignorecase
set smartcase

" set nobackup
" set dir=~/.vimbackup
" nnoremap <F2> :e ~/.vim/vimrc<cr>
" nnoremap <F3> :source ~/.vim/vimrc<cr>
" nnoremap <F5> :!ruby %<CR>
" nnoremap <F6> :Rake! <CR>
" nnoremap <F7> :nohlsearch <cr>
" nnoremap <F9> :bw <cr>


autocmd User Rails silent! Rnavcommand spm spec/models -glob=**/* -suffix=_spec.rb -default=model()
autocmd User Rails silent! Rnavcommand spi spec/integration -glob=**/* -suffix=_spec.rb -default=model()
autocmd User Rails silent! Rnavcommand spc spec/controllers -glob=**/* -suffix=_controller_spec.rb -default=controller()
autocmd User Rails silent! Rnavcommand sph spec/helpers -glob=**/* -suffix=_helper_spec.rb -default=controller()
autocmd User Rails silent! Rnavcommand spv spec/views -glob=**/* -suffix=.html.erb_spec.rb -default=controller()
autocmd User Rails silent! Rnavcommand stepdef  features/step_definitions -suffix=_steps.rb
autocmd User Rails silent! Rnavcommand feature features -suffix=.feature
autocmd User Rails silent! Rnavcommand factory spec/factories -suffix=.rb
autocmd User Rails silent! Rnavcommand mailer app/mailers -suffix=_mailer.rb
autocmd User Rails silent! Rnavcommand presenter app/presenters -suffix=_presenter.rb
autocmd User Rails silent! Rnavcommand uploader app/uploaders -suffix=_uploader.rb
autocmd User Rails silent! Rnavcommand site config/site -suffix=.yml
autocmd User Rails silent! Rnavcommand sass app/stylesheets -suffix=.scss

" this should keep surround.vim from clobbering 's'
xmap S <Plug>Vsurround
autocmd User Rails silent! Rnavcommand javascript app/javascripts -suffix=.js

" pick last command
"cmap <C-n> <Up>

autocmd FileType ruby inoremap <C-S-l> #{}<Left>

nmap ,rv :Rview
nmap ,rm :Rmodel
nmap ,rc :Rcontroller
nmap ,rh :Rhelper
nmap ,rf :Rfeature

nmap ,rh :Rhelper

" nmap <Space> :
" imap <C-Space> <C-o>:


"
" Colo(u)red or not colo(u)red
" If you want color you should set this to true
"
let color = "true"
"
if has("syntax")
    if color == "true"
        " This will switch colors ON
        set t_Co=256
        so ${VIMRUNTIME}/syntax/syntax.vim
        set termguicolors

        " no idea what this is, cargo'd from several sites incl https://github.com/lifepillar/vim-solarized8#troubleshooting
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        " colorscheme onehalfdark
        " colorscheme molokai
        set background=dark
        " from https://github.com/lifepillar/vim-solarized8
        colorscheme solarized8_flat
    else
        " this switches colors OFF
        syntax off
        set t_Co=0
    endif
endif


set sw=2
set ts=2
set expandtab

" set guifont=Andale\ Mono\ 9
" set guifont=MiscFixed\ Semi-Condensed\ 9
" set guifont=Monaco\ for\ Powerline

set formatoptions=tcql
set ruler
set smartindent
set wmh=0
set foldcolumn=1

" airline
if !has('gui_running')
    set t_Co=256
endif

let g:airline_powerline_fonts = 1
let g:airline_theme='onehalfdark'
" let g:airline_theme='kolor'

" let g:molokai_original = 1
" let g:rehash256 = 1

" an underline on the cursor line
" set cursorline
" highlights the column
set cursorcolumn

:map ,m :w<CR>
:map ,j :wa<CR>
:map ,l <C-w>n :e .<CR>
:map ,d :r! date<CR>

if version >= 600
    filetype plugin indent on
endif

runtime macros/matchit.vim


" show taglist window with ctags for the file.
map ,t :TlistToggle<CR>
"let Tlist_Auto_Open  = 1
let Tlist_Use_Right_Window = 1
"set Tlist_Show_Menu 1
let Tlist_File_Fold_Auto_Close = 1
" let Tlist_Close_On_Select = 1
let Tlist_GainFocus_On_ToggleOpen = 1

" ~/.vimrc ends here

" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fun! ToggleFold()
    if foldlevel('.') == 0
        normal! l
    else
        if foldclosed('.') < 0
            . foldclose
        else
            . foldopen
        endif
    endif
    " Clear status line
    echo
endfun

" Map this function to Space key."{{{
noremap <space> :call ToggleFold()<CR>
nmap zz V%zf
set foldmethod=marker
"}}}

" for https://github.com/jtratner/vim-flavored-markdown
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Google search
map <M-g> :sil! !/usr/bin/firefox -remote "openURL(http://www.google.com/search?q=<cword>, new-tab)"<CR>;;
vmap <M-g> y:let @g = URLencodeReg()<CR>:sil! !/usr/bin/firefox -remote "openURL(http://www.google.com/search?q=<C-R>g, new-tab)"<CR>

" tab control
nmap <C-Insert> :tabnew<CR>
nmap <C-Delete> :tabclose<CR>

" alt-n fixes newlines from Mac users
map <M-n> :%s/\r/\r/g<CR>

" mainly done to avoid Ex mode annoyance when fat fingering Q
nmap Q :reg<CR>

function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

inoremap <TAB> <C-R>=InsertTabWrapper ("forward")<CR>
inoremap <S-TAB> <C-R>=InsertTabWrapper ("backward")<CR>

map ,c E:call InsertCloseTag()<CR>
map ,r :call RepeatTag(0)<CR>
map ,R :call RepeatTag(1)<CR>


" NERDTree mappings
" http://www.vim.org/scripts/script.php?script_id=1658
" Opens a fresh NERD tree. The root of the tree depends on the argument
nmap <C-n>o :NERDTree<CR>
" Opens a fresh NERD tree with the root initialized to the dir for <bookmark>
nmap <C-n>b :NERDTreeFromBookmark
"If a NERD tree already exists for this tab, it is reopened and rendered
nmap ,n :NERDTreeToggle<CR>
" Find the current file in the tree. If no tree exists for the current tab,
nmap <C-n>f :NERDTreeFind<CR>

" make moving between windows a little quicker
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" resize <----> with _ and + in normal mode
nmap <M-+> <C-w>>
nmap <M-_> <C-w><
" and vertically with - and =
nmap <M--> <C-w>-
nmap <M-=> <C-w>+

nmap <silent> + :exe "resize " . (winheight(0) * 2)<CR>
nmap <silent> _ :exe "resize " . (winheight(0) / 2)<CR>



" highlight trailing whitespace in red
" have this highlighting not appear whilst you are typing in insert mode
" have the highlighting of whitespace apply when you open new buffers
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

autocmd BufWritePre * :%s/\s\+$//e

" \W will clear those pesky spaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" duplicate line, scite style.
inoremap <D-d> <Esc>md"dyy"dp`dja
noremap <D-d> md"dyy"dp`dj

function! GoToWip()
  :LAck -a wip
endfunction

command! Wip call GoToWip()

nmap ,gs :Gstatus<CR>
nmap ,gd :Gdiff<CR>
nmap ,gw :Gwrite<CR>
nmap ,gc :Gcommit<CR>

" shortcuts for cmd line editing
cnoremap <C-l> <Home>
cnoremap <C-h> <End>

" shortcut for Extradite plugin
nmap ,e :Extradite!<CR>

if has("gui_mac") || has("gui_macvim")
  set macmeta
  noremap <M-m> mB
  noremap <M-b> `B
endif

" I'm tired of clearing highlights by searching for /lsdnosw
nmap <silent> ,/ :nohlsearch<CR>

" switch to paste mode, so you can paste code into a window without getting all auto-indented
set pastetoggle=<F10>

" :Ag integration
set runtimepath^=~/.vim/bundle/ag

" use Ag on vis selection!!!!
:vmap ,g y:Ag <C-R>0<CR?>

" http://pig-monkey.com/2013/04/password-management-vim-gnupg/
""""""""""""""""""""
" GnuPG Extensions "
""""""""""""""""""""

" Tell the GnuPG plugin to armor new files.
let g:GPGPreferArmor=1

" Tell the GnuPG plugin to sign new files.
let g:GPGPreferSign=1
" let g:GPGDebugLevel=3
" let g:GPGDebugLog="/tmp/gpg.log"

augroup GnuPGExtra
" Set extra file options.
    autocmd BufReadCmd,FileReadCmd *.\(gpg\|asc\|pgp\) call SetGPGOptions()
" Automatically close unmodified files after inactivity.
" don't do it - CursorHold is triggering after any search, very odd
    " autocmd CursorHold *\(gpg\|asc\|pgp\) nested update | quit
augroup END

function SetGPGOptions()
" Set updatetime to 1 minute.
    set updatetime=60000
" fold
    set foldenable
" Fold at markers.
    set foldmethod=marker
" Automatically close all folds.
    set foldclose=all
" Only open folds with insert commands.
    set foldopen=insert
endfunction

augroup pencil
  autocmd FileType text     call PencilInit()
augroup END

function! PencilInit()
  call pencil#init({'wrap': 'hard', 'autoformat': 0})
  let g:airline_section_x = '%{PencilMode()}'
  nnoremap <silent> Q gqap
  xnoremap <silent> Q gq
  nnoremap <silent> <leader>Q vapJgqap
endfunction

" use silver searcher/ag if install with Ack plugin
" https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
let g:ackprg = 'ag --vimgrep'

" use tabnine https://www.tabnine.com/
" set rtp+=~/tabnine-vim

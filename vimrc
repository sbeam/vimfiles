"Fabio Kung <fabio.kung@gmail.com>
"
"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

" set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

" set number      "add line numbers
set showbreak=>>>>
set wrap linebreak nolist

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk
set fo=l

"statusline setup
set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"turn off needless toolbar on gvim/mvim
" set guioptions=c

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

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

function! GoToWip()
  :LAck -a wip features/
endfunction

command! Wip call GoToWip()

"indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:full   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

"display tabs and trailing spaces
"set list
"set listchars=tab:\ \ ,extends:>,precedes:<
" disabling list because it interferes with soft wrap

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"necessary on some Linux distros for pathogen to properly load bundles
filetype off

"load pathogen managed plugins
call pathogen#runtime_append_all_bundles()

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

"Command-T configuration
let g:CommandTMaxHeight=10
let g:CommandTMatchWindowAtTop=1

nmap <silent> <Leader>p :NERDTreeToggle<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to bufexplorer
nnoremap <leader>b :BufExplorer<cr>

"map to CommandT TextMate style finder
nnoremap <leader>t :CommandT<CR>

"map Q to something useful
" noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"bindings for ragtag
inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

"key mapping for vimgrep result navigation
map <A-o> :copen<CR>
map <A-q> :cclose<CR>
map <A-j> :cnext<CR>
map <A-k> :cprevious<CR>

"snipmate setup
try
  source ~/.vim/snippets/support_functions.vim
catch
  source ~/vimfiles/snippets/support_functions.vim
endtry
autocmd vimenter * call s:SetupSnippets()
function! s:SetupSnippets()

    "if we're in a rails env then read in the rails snippets
    if filereadable("./config/environment.rb")
        call ExtractSnips("~/.vim/snippets/ruby-rails", "ruby")
        call ExtractSnips("~/.vim/snippets/eruby-rails", "eruby")
    endif

    call ExtractSnips("~/.vim/snippets/html", "eruby")
    call ExtractSnips("~/.vim/snippets/html", "xhtml")
    call ExtractSnips("~/.vim/snippets/html", "php")
endfunction

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

set nobackup
set dir=~/.vimbackup
nnoremap <F2> :e ~/.vim/vimrc<cr>
nnoremap <F3> :source ~/.vim/vimrc<cr>
nnoremap <F5> :!ruby %<CR>
nnoremap <F6> :Rake! <CR>
nnoremap <F7> :nohlsearch <cr>
nnoremap <F9> :bw <cr>

map <F12> \be
imap <F12> <Esc>\be

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

autocmd FileType ruby inoremap <C-S-l> #{}<Left>

" surround.vim hack for terminals.
imap ß <C-G>s

" pick last command
"cmap <C-n> <Up>

nmap ,rv :Rview 
nmap ,rm :Rmodel 
nmap ,rc :Rcontroller 

" nmap <Space> :
" imap <C-Space> <C-o>:

nmap ,rh :Rhelper


"
" Colo(u)red or not colo(u)red
" If you want color you should set this to true
"
let color = "true"
"
if has("syntax")
    if color == "true"
        " This will switch colors ON
        so ${VIMRUNTIME}/syntax/syntax.vim
    else
        " this switches colors OFF
        syntax off
        set t_Co=0
    endif
endif


set sw=4
set ts=4
set expandtab

" set guifont=Andale\ Mono\ 9
set guifont=MiscFixed\ Semi-Condensed\ 9

set formatoptions=tcql
set ruler
set smartindent
set wmh=0
set foldcolumn=1

colorscheme sam
hi Cursor gui=reverse guifg=NONE guibg=NONE
hi phpSwitch guifg=#cc3333

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

" Map this function to Space key.
noremap <space> :call ToggleFold()<CR>
nmap zz V%zf
set foldmethod=marker



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


if has("autocmd")
    autocmd FileType php     call PHPmapper()
endif

function! PHPmapper()
    " PHP debug dump selected thing to stdout, with print_r
    vmap ,p yoprint '<pre>DEBUG at line '.__LINE__.' of ' . __FILE__ . "\n";<CR>print_r(<ESC>pA);<CR>print '</pre>';<ESC> 
    " PHP debug dump to error_log
    vmap ,e yo/* DEBUG */ ob_start(); print "=======\nDEBUG ".date('r')."\nline ".__LINE__." of ".__FILE__."\n";<CR>print_r(<ESC>pA);<CR>print "\n\n"; error_log(ob_get_clean(),3,'/tmp/phpdebug.log');<ESC>
    
    map <F9> :w<CR>:!/usr/bin/php -l %<CR>
   
    " load PHP on Alt-P
    map <M-p> :sil! !/usr/bin/firefox -remote "openURL(http://www.php.net/<cword>, new-tab)"<CR>;;
endfunction 

" http://www.stripey.com/vim/html.html
function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 May 3

  if &filetype == 'html'
  
    " list of tags which shouldn't be closed:
    let UnaryTags = ' Area Base Br DD DT HR Img Input LI Link Meta P Param '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous <, then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag, skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z"zp

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The InsertCloseTag() function is only intended to be used in HTML ' .
      \ 'files.'
    sleep
    echohl None
  
  endif " check on filetype

endfunction " InsertCloseTag()




function! RepeatTag(Forward)
" repeats a (non-closing) HTML tag from elsewhere in the document; call
" repeatedly until the correct tag is inserted (like with insert mode <Ctrl>+P
" and <Ctrl>+N completion), with Forward determining whether to copy forwards
" or backwards through the file; used for the \hp and \hn operations defined
" above;
" requires preservation of marks i and j;
" clobbers register z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 Apr 30

  if &filetype == 'html'

    " if the cursor is where this function left it, then continue from there:
    if line('.') == line("'i") && col('.') == col("'i")
      " delete the tag inserted last time:
      if col('.') == strlen(getline('.'))
        normal dF<x
      else
        normal dF<x
        if col('.') != 1
          normal h
        endif
      endif
      " note the cursor position, then jump to where the deleted tag was found:
      normal mi`j

    " otherwise, just store the cursor position (in mark i):
    else
      normal mi
    endif

    if a:Forward
      let SearchCmd = '/'
    else
      let SearchCmd = '?'
    endif
      
    " find the next non-closing tag (in the appropriate direction), note where
    " it is (in mark j) in case this function gets called again, then yank it
    " and paste a copy at the original cursor position, and store the final
    " cursor position (in mark i) for use next time round:
    execute "normal " . SearchCmd . "<[^/>].\\{-}>\<CR>mj\"zyf>`i\"zpmi"

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The RepeatTag() function is only intended to be used in HTML files.'
    sleep
    echohl None
  
  endif

endfunction " RepeatTag()








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


autocmd BufEnter * if &filetype == "html" | call MapHTMLKeys() | endif
function! MapHTMLKeys(...)
" sets up various insert mode key mappings suitable for typing HTML, and
" automatically removes them when switching to a non-HTML buffer

  " if no parameter, or a non-zero parameter, set up the mappings:
  if a:0 == 0 || a:1 != 0

    " require two backslashes to get one:
    inoremap \\ \

    " then use backslash followed by various symbols insert HTML characters:
    inoremap \& &amp;
    inoremap \< &lt;
    inoremap \> &gt;
    "inoremap \. &middot;
    inoremap \" &quot;

    "inoremap \} &raquo;
    "inoremap \{ &laquo;

    " em dash -- have \- always insert an em dash, and also have _ do it if
    " ever typed as a word on its own, but not in the middle of other words:
    " inoremap \- &#8212;
    " iabbrev _ &#8212;

    " hard space with <Ctrl>+Space, and \<Space> for when that doesn't work:
    inoremap \<Space> &nbsp;
    imap <C-Space> \<Space>

    " have the normal open and close single quote keys producing the character
    " codes that will produce nice curved quotes (and apostophes) on both Unix
    " and Windows:
    "inoremap ` &#8216;
    
    "inoremap ' &#8217;
    " then provide the original functionality with preceding backslashes:
    "inoremap \` `
    "inoremap \' '


    
    " when switching to a non-HTML buffer, automatically undo these mappings:
    autocmd! BufLeave * call MapHTMLKeys(0)

  " parameter of zero, so want to unmap everything:
  else
    iunmap \\
    iunmap \&
    iunmap \<
    iunmap \>
    "iunmap \-
    "iunabbrev _
    iunmap \<Space>
    iunmap <C-Space>
    "iunmap `
    "iunmap '
    "iunmap \`
    "iunmap \'
    "iunmap \"

    " once done, get rid of the autocmd that called this:
    autocmd! BufLeave *

  endif " test for mapping/unmapping

endfunction " MapHTMLKeys()



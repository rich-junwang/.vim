" ============================================
"" Table of Contents:	
""		Basic_Config 
""		Key_Mapping
""		Function_Define
"" 		FileType_Config
"" 		Plugin_Config
""		Cscope_Config
""		Plug_Config
" --------------------------------------------

" ============================================
""		Basic_Configuration
" --------------------------------------------

":> Be Vim
set nocompatible

":> Indent
set autoindent
"set cindent
set smartindent
set tabstop=4
set shiftwidth=4

":> Status
set ruler		" show the cursor position all the time in statusline
set laststatus=2
"let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1

":> LastLine
set scrolloff=3 "always away from edge
set display+=lastline

":> Auto-complete
set showcmd		" display incomplete commands
set wildmenu	" show possible command when pressing <TAB>
set sps=best,10 " only show 10 best spell suggestions

":> Search
set incsearch wrapscan  "do incremental searching
set ignorecase smartcase
set showmatch
set hlsearch

":> History
set history=500		" keep 500 lines of command line history
" keep record of editing information for cursor restore and more
set viminfo='10,\"100,:20,%,n~/.viminfo 
set backup
set backupdir=~/.vim/.backup

":> Color
set background=dark
set t_Co=256
highlight PMenu ctermbg=Red 
"" colorscheme from He Kun
"colorscheme hk
"colorscheme gruvbox
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta


":> Highlight insert mode
"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline
"set ttimeoutlen=100

":> Line number
"set rnu "use relative line number in vim 7.4
set number

":> Miscellaneous
syntax on
set synmaxcol=255 ""for slow long xml lines 
set lazyredraw "" for slow scrolling 
set autowrite
set mouse=a
set backspace=indent,eol,start
set runtimepath=./.vimlocal,~/.vim,$VIMRUNTIME
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

"display for :set list 
"set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,

"gvim
"if has('gui_running')
    "colorscheme desert
"endif

filetype plugin indent on

" ============================================
""		Key_Mapping
" --------------------------------------------

":> VIMRC 
"source $MYVIMRC 
nmap <Leader>s :source $MYVIMRC
"opens $MYVIMRC for editing
nmap <Leader>v :e $MYVIMRC	 

":> Copy-and-Paste
map \[ :set paste<CR>
map \] :set nopaste<CR>
map <C-v> \["+gp\]
imap <C-v> <ESC>\["+gp\]
vmap <C-c> "+y
""paste and replace multiple times
xnoremap p pgvy	

":> Save File
map <F4> :w<CR>
imap <F4> <ESC>:w<CR>
""force save current file
cmap w!! w !sudo tee % >/dev/null

" quick exit, also ZZ
map Q :qa<CR>

":> Replace
"For local replace
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
"For global replace 
nnoremap gR gD:%s/<C-R>///gc<left><left><left>]

":> Toggles
nmap <F2>   :TlistToggle<CR>
map <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <silent> <F10> :TagbarToggle<CR>

" indent all 
map \= migg=G'i
" search for visual-mode selected text
vmap / y/<C-R>"<CR>
map <Leader>ig :set list lcs=tab:\¦\ 

" control + vim direction key to navigate windows
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l

" ============================================
""		Function_Define
" --------------------------------------------

""""Making Parenthesis And Brackets Handling Easier 
inoremap ( ()<Esc>:call BC_AddChar(")")<CR>i
inoremap {<CR> {<CR>}<Esc>:call BC_AddChar("}")<CR><Esc>kA<CR>
inoremap {}  {}<Esc>:call BC_AddChar("}")<CR>i
inoremap [ []<Esc>:call BC_AddChar("]")<CR>i
inoremap " ""<Esc>:call BC_AddChar("\"")<CR>i
" jump out of parenthesis
inoremap <C-k> <Esc>:call search(BC_GetChar(), "W")<CR>a

function! BC_AddChar(schar)
 if exists("b:robstack")
 let b:robstack = b:robstack . a:schar
 else
 let b:robstack = a:schar
 endif
endfunction

function! BC_GetChar()
 let l:char = b:robstack[strlen(b:robstack)-1]
 let b:robstack = strpart(b:robstack, 0, strlen(b:robstack)-1)
 return l:char
endfunction

"Add brackets for selected texts
vnoremap +( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap +[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap +{ <Esc>`>a}<Esc>`<i{<Esc>
vnoremap +" <Esc>`>a"<Esc>`<i"<Esc>

"Restore cursor to file position in previous editing session
autocmd BufReadPost * 
    \if line("'\"") > 0 && line("'\"") <= line("$") 
        \|exe "normal g`\"" 
    \|endif

"tempory setting 
au BufRead,BufNewFile *.c,*.cpp,*.py 2match Underlined /.\%81v/

" ============================================
""		FileType_Config
" --------------------------------------------

":> JAVA
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
let java_comment_strings=1
let java_highlight_java_lang_ids=1
"eclim:
let g:EclimJavaSearchSingleResult="edit"
"autocmd FileType java nmap <F3> :JavaSearchContext<CR>
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd BufRead *.java set makeprg=ant\ -find\ 'build.xml'
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#]]

":> Python
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
"au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/usr/bin/env python3 % <CR>
"let g:completor_python_binary = '/Users/diwang/anaconda/bin/python3'
let python_highlight_all = 1
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif 
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
autocmd BufWritePre *.py :%s/\s\+$//e

"let g:pymode_folding = 0
"let g:pymode_lint_cwindow = 0
"let g:pymode_lint_write = 0
"let g:pymode_rope = 0
"let g:pymode_lint_on_write = 0 
"" syntax highlighting
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all

":> JFlex
augroup filetype
	  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

":> Latex
autocmd BufRead *.tex set iskeyword+=:
"autocmd BufRead *.tex :TTarget pdf
"autocmd BufRead *.tex let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -output-directory ./tmp $*'
"autocmd Filetype tex setlocal nofoldenable
let tlist_tex_settings   = 'latex;s:sections;g:graphics'
"autocmd Filetype tex :Tlist
autocmd Filetype tex vnoremap +$ <Esc>`>a$<Esc>`<i$<Esc>
autocmd Filetype tex inoremap $ $$<Esc>:call BC_AddChar("$")<CR>i
"autocmd Filetype tex set tw=79
autocmd FileType tex :NoMatchParen
" cursorline is slow on tex
au FileType tex setlocal nocursorline
let g:tex_flavor = 'latex'

"vimtex pdf viewer
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
	call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
	call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
	call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
	call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction


":> Markdown
au BufNewFile,BufRead *.md set ft=md
let g:vim_markdown_folding_disabled=1

":> YAML
au BufNewFile,BufRead *.yaml,*.yml    setf yaml

":> wsdd
au BufNewFile,BufRead *.wsdd    setf xml

":> cuda
au BufNewFile,BufRead *.cu set filetype=cuda
au BufNewFile,BufRead *.cuh set filetype=cuda

":> XML formatter
command XmlLint :exec "silent 1,$!xmllint --format --recover - 2>/dev/null"

":> json formatter
command Mjson :exec "silent 1,$!python -mjson.tool 2>/dev/null"

":> Git Gutter
""highlight clear SignColumn
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" ============================================
""		Plugin_Config
" --------------------------------------------

" minibufexpl (only for old plugin)
"let g:miniBufExplMapWindowNavVim = 1 

" nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" taglist.vim
let g:Tlist_GainFocus_On_ToggleOpen=0
let g:Tlist_Exit_OnlyWindow=1
let g:Tlist_Show_One_File=1
let g:Tlist_Enable_Fold_Column=0
let g:Tlist_Auto_Update=1
let g:tlist_ant_settings = 'ant;p:Project;t:Target'
let tlist_make_settings  = 'make;m:makros;t:targets'

" tagbar
let g:tagbar_compact = 1
highlight link TagbarHighlight Cursor
highlight TagbarSignature guifg=yellowgreen
highlight TagbarVisibilityPublic guifg=#11ee11
highlight TagbarVisibilityProtected guifg=SkyBlue
highlight TagbarVisibilityPrivate guifg=#ee1111

" supertab
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabLongestHighlight=1
let g:SuperTabRetainCompletionDuration="completion"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']

"" YCM
"map <F3> :YcmCompleter GoTo<CR>
"" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

set dictionary+=/usr/share/dict/words

":> EasyMotion
let g:EasyMotion_leader_key = '<Leader>' 

":> Bash-Support
let g:BASH_AuthorName   = 'Di Wang'
let g:BASH_Email        = 'diwang@cs.cmu.edu'
"let g:BASH_Company      = 'CMU'

"":> syntastic
"let g:syntastic_error_symbol = '✗'
"let g:syntastic_warning_symbol = '⚠'
"let g:syntastic_mode_map = { 'mode': 'passive',
						   "\ 'active_filetypes': ['lua'],
						   "\ 'passive_filetypes': [] }
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 0
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_lua_checkers = ["luac", "luacheck"]
"let g:syntastic_lua_luacheck_args = "--ignore torch nn misc"

":> gist
let g:gist_post_private = 1

":> Rainbow Parentheses Improved
"au FileType c,cpp,objc,objcpp,python call rainbow#load()

":> LanguageTool
let g:languagetool_jar='~/usr/LanguageTool-2.4/languagetool-commandline.jar'

":> Try to use The Silver Searcher if available 
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

":> EasyAlign 
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


""> completor
"" let g:completor_complete_options = 'menuone,noselect,preview'


" ============================================
""		Cscope_Config
" --------------------------------------------
if has("cscope")

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0


	let parent=1
	let local_cscope = "cscope.out"
	while !filereadable(local_cscope) && parent<=8
		let parent = parent+1
		let local_cscope = "../". local_cscope
	endwhile
	
    " add any cscope database in current directory or its parent
    if filereadable(local_cscope)
		echomsg "sourcing " . local_cscope
        cs add local_cscope 
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif

	unlet parent local_cscope

	" show msg when any other cscope db added
	set cscopeverbose  

    """"""""""""" cscope/vim key mappings
    " The following maps all invoke one of the following cscope search types:
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    
	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

	""show todo list
	command TODO cs find t TODO 
endif


" ============================================
""		Plug_Config
" --------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" let Vundle manage Vundle
"Plug 'gmarik/vundle' 

"Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
"Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'fholgado/minibufexpl.vim'

"Plug "MarcWeber/vim-addon-mw-utils"
"Plug "tomtom/tlib_vim"
"Plug "garbas/vim-snipmate"

""Plug "honza/vim-snippets"
""Plug "SirVer/ultisnips"

Plug 'scrooloose/nerdcommenter'
"Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'

Plug 'ervandew/supertab'
Plug 'vim-scripts/matchit.zip'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/LargeFile'

Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'

"Plug 'myusuf3/numbers.vim.git' "use rnu
"Plug 'Lokaltog/vim-powerline.git'
"Plug 'scrooloose/syntastic'

"Python
"Plug 'fs111/pydoc.vim.git'
"Plug 'mitechie/pyflakes-pathogen.git'
"Plug 'vim-scripts/pep8.git'
"Plug 'sontek/rope-vim.git'
""Plug 'klen/python-mode.git'
"Plug 'ivanov/vim-ipython'
"Plug 'davidhalter/jedi-vim'

"Plug 'hughbien/md-vim'
Plug 'plasticboy/vim-markdown'
Plug 'avakhov/vim-yaml'
Plug 'sukima/xmledit'
Plug 'elzr/vim-json'

Plug 'vim-scripts/taglist.vim'
"Plug 'vim-scripts/bash-support.vim'
"Plug 'airblade/vim-gitgutter.git'

"Plug 'Yggdroot/indentLine.git'
"Plug 'LaTeX-Box-Team/LaTeX-Box'
"Plug 'coot/atp_vim'
Plug 'lervag/vimtex'

"Plug 'oblitum/rainbow'
"Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'nanotech/jellybeans.vim'

"Plug 'derekwyatt/vim-scala'
"Plug 'dpelle/vim-LanguageTool'

Plug 'chrisbra/Recover.vim'
"Plug 'kovisoft/slimv'

"auto complete
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Plug 'Shougo/neocomplete.vim'
"Plug 'osyo-manga/vim-marching'
"Plug 'Shougo/vimproc.vim'
Plug 'maralla/completor.vim'


Plug 'mhinz/vim-startify'

"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-lua-ftplugin'

"Plug 'mattn/webapi-vim'
"Plug 'mattn/gist-vim'


call plug#end()

"filetype plugin indent on     " required!
"" reset from indentLine and fugitive plugins
colorscheme jellybeans
set concealcursor=nc
command! Vb normal! <C-v>

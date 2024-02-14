" MACVim load all Syntaxes
let do_syntax_sel_menu = 1
set showmode
" Bracket Matching
set showmatch
set number
"Enable search match highlighting
set hlsearch
syntax on
"Enable cursor position display
set ruler
"Enable folding
set foldmethod=indent
set foldlevel=99
set colorcolumn=80
"Copilot key maps
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Diff setting
if &diff
	set wrap
"else
"	settings for non-diff mode
endif

"Python PEP8 Indentation
au BufNewFile,BufRead *.py
	\ set tabstop=4       |
	\ set softtabstop=4   |
	\ set shiftwidth=4    |
	\ set textwidth=79    |
	\ set expandtab       |
	\ set autoindent      |
	\ set fileformat=unix |
set encoding=utf-8
"Mark bad whitespace
highlight BadWhiteSpace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhiteSpace /\s\+$/

"Automatic indentation as you type
filetype indent on 

" Status Line Set up
" ------------------
set statusline=
" show full file path
set statusline+=%F
" show current line number and Column number
set statusline+=\ %l\:%c

let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'V·Line ',
       \ "\<C-V>" : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'R ',
       \ 'Rv' : 'V·Replace ',
       \ 'c'  : 'Command ',
       \}

set statusline+=\ %{toupper(g:currentmode[mode()])}

set statusline+=%{&modified?'[+]':''}
"set statusline+=%-7([%{&fileformat}]%)

set statusline+=%= " Separation point between left and right aligned items

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

" Git Status
set statusline+=%{FugitiveStatusline()}

set laststatus=2

"new in vim 7.4.1042
"let g:word_count=wordcount().words
"function WordCount()
"    if has_key(wordcount(),'visual_words')
"        let g:word_count=wordcount().visual_words."/".wordcount().words " count selected words
"    else
"        let g:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
"    endif
"    return g:word_count
"endfunction
"
"set statusline+=\ w:%{WordCount()},
"set laststatus=2

"---------------------

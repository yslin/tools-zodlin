" SearchComplete.vim
" Author: Chris Russell
" Version: 1.1
" License: GPL v2.0 
" 
" Description:
" This script defineds functions and key mappings for Tab completion in 
" searches.
" 
" Help:
" This script catches the <Tab> character when using the '/' search 
" command.  Pressing Tab will expand the current partial word to the 
" next matching word starting with the partial word.
" 
" If you want to match a tab, use the '\t' pattern.
"
" Installation:
" Simply drop this file into your $HOME/.vim/plugin directory.
" 
" Changelog:
" 2017-01-09 
"   Zod Lin add <S-Tab> to search previous word complete
" 2002-11-08 v1.1
" 	Convert to unix eol
" 2002-11-05 v1.0
" 	Initial release
"
" TODO:
" How to get (vim don't support function to get complete word list in vim 7.0)
"   1.search string list, set complete list by myself
"   2.complete word list, use default list to count length of list
" To clear the last used search pattern:
" :let @/ = ""
"--------------------------------------------------
" Avoid multiple sourcing
"-------------------------------------------------- 
if exists( "loaded_search_complete" )
    finish
endif
let loaded_search_complete = 1


"--------------------------------------------------
" Global variables
"-------------------------------------------------- 
let g:SEARCHCOMPLETE_SEARCH_NEXT = 1
let g:SEARCHCOMPLETE_SEARCH_PREV = 0

"--------------------------------------------------
" Record environment variables
"-------------------------------------------------- 
"--------------------------------------------------
" Key mappings
"-------------------------------------------------- 
noremap / :call <sid>SearchCompleteStart()<CR>/


"--------------------------------------------------
" Set mappings for search complete
"-------------------------------------------------- 
function! s:SearchCompleteStart()
	cnoremap <Tab> <C-C>:call <sid>SearchComplete(g:SEARCHCOMPLETE_SEARCH_NEXT)<CR>/<C-R>s
	cnoremap <S-Tab> <C-C>:call <sid>SearchComplete(g:SEARCHCOMPLETE_SEARCH_PREV)<CR>/<C-R>s
	cnoremap <silent> <CR> <CR>:call <sid>SearchCompleteStop()<CR>
    " require twice <Esc>, because <S-Tab> will cause <Esc> event
	cnoremap <silent> <Esc><Esc> <C-C>:call <sid>SearchCompleteStop()<CR>
endfunction

"--------------------------------------------------
" Tab completion in / search
"-------------------------------------------------- 
" one autocomplete
let b:searchcompletedepth = "\<C-N>"
" count \<C-N> to search complete string
let b:searchcount = 1
function! s:SearchComplete(next)
    " record complete environment variable to restore
    let l:complete = &complete
    " search current window, see (h 'complete')
    let &complete = "."
	" get current cursor column position
	let l:loc = col( "." ) - 1
	" get partial search and delete
	let l:search = histget( '/', -1 )
	call histdel( '/', -1 )
	" check if new search
	if l:search == @s
        echom "l:search == @s"
        if a:next
            let b:searchcount = b:searchcount + 1
        else
            let b:searchcount = b:searchcount - 1
        endif
		" get root search string
		let l:search = b:searchcomplete
		" increase number of autocompletes
		"let b:searchcompletedepth = b:searchcompletedepth . "\<C-N>"
        if b:searchcount > 0
            let b:searchcompletedepth = repeat("\<C-N>", b:searchcount)
            echom "b:searchcount(>0):". b:searchcount . " -> " . b:searchcompletedepth
        elseif b:searchcount < 0
            let b:searchcompletedepth = "\<C-P>" . repeat("\<C-P>", - b:searchcount)
            echom "b:searchcount(<0):". b:searchcount . " -> " . b:searchcompletedepth
        else
            let b:searchcompletedepth = "\<C-P>"
            echom "b:searchcount(=0):". b:searchcount . " -> " . b:searchcompletedepth
        endif

        "TODO: replace with repeat("\<C-N", n)
	else
        echom "l:search != @s"
		" one autocomplete
		let b:searchcompletedepth = "\<C-N>"
        " count \<C-N> to search complete string
        let b:searchcount = 1
	endif
	" store origional search parameter
	let b:searchcomplete = l:search
	" set paste option to disable indent options
	let l:paste = &paste
	setlocal paste
	" on a temporary line put search string and use autocomplete
	execute "normal! A\n" . l:search . b:searchcompletedepth
	" get autocomplete result
	let @s = getline( line( "." ) )
	" undo and return to first char
	execute "normal! u0"
	" return to cursor column position
	if l:loc > 0
		execute "normal! ". l:loc . "l"
	endif
	" reset paste option
	let &paste = l:paste
    let &complete = l:complete
endfunction

"--------------------------------------------------
" Remove search complete mappings
"-------------------------------------------------- 
function! s:SearchCompleteStop()
	cunmap <Tab>
	cunmap <S-Tab>
	cunmap <CR>
	cunmap <Esc><Esc>
endfunction


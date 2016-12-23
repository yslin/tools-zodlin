let s:debug = 0
let s:debug_file = ''

" Debugging {{{1
" s:StartDebug() {{{2
function! s:StartDebug(filename) abort 
    if empty(a:filename)
        let s:debug_file = 'tagbardebug.log'
    else  
        let s:debug_file = a:filename
    endif 

    " Empty log file
    exe 'redir! > ' . s:debug_file
    redir END

    " Check whether the log file could be created
    if !filewritable(s:debug_file)
        echomsg 'Tagbar: Unable to create log file ' . s:debug_file
        let s:debug_file = ''
        return
    endif 

    let s:debug = 1
endfunction

" s:StopDebug() {{{2
function! s:StopDebug() abort
    let s:debug = 0
    let s:debug_file = ''
endfunction

" s:debug() {{{2
if has('reltime')
    function! s:gettime() abort
        let time = split(reltimestr(reltime()), '\.')
        return strftime('%Y-%m-%d %H:%M:%S.', time[0]) . time[1]
    endfunction
else
    function! s:gettime() abort
        return strftime('%Y-%m-%d %H:%M:%S')
    endfunction
endif
function! s:debug(msg) abort
    if s:debug
        execute 'redir >> ' . s:debug_file
        silent echon s:gettime() . ': ' . a:msg . "\n"
        redir END
    endif
endfunction

" Testing {{{2
call s:StartDebug('zod.debug')
call s:debug('[TEST]DEBUG MESSAGE')
call s:StopDebug()

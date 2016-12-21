" Defining a group for autocommands responding to FocusLost events
augroup Defocus
    autocmd  FocusLost  *.txt   :call Autosave()
    autocmd  FocusLost  *.p[ly] :call Checkpoint_sourcecode()
    autocmd  FocusLost  *.doc   :call Reformat_current_para()
augroup END


" Defining a group of autocommands for handling text files
augroup TextEvents 
    autocmd  FocusGained  *.txt   :call Highlight_cursor()
    autocmd  FocusLost    *.txt   :call Autosave()
augroup END

" Making sure a group is empty before adding new autocommands
augroup Unfocussed
    autocmd!

    autocmd  FocusLost  *.txt   :call Autosave()
    autocmd  FocusLost  *.p[ly] :call Checkpoint_sourcecode()
    autocmd  FocusLost  *.doc   :call Reformat_current_para()
augroup END

" Automatically quitting on simultaneous edits
augroup NoSimultaneousEdits
    autocmd!
    autocmd  SwapExists  *  :let v:swapchoice = 'q'
augroup END

" Automating read-only access to existing files
augroup NoSimultaneousEdits
    autocmd!
    autocmd  SwapExists  *  :let v:swapchoice = 'o'
augroup END

" Automating a context-sensitive response
augroup NoSimultaneousEdits
    autocmd!
    autocmd  SwapExists  ~/*            :let v:swapchoice = 'q'
    autocmd  SwapExists  /dev/shared/*  :let v:swapchoice = 'o'
augroup END

" (see :help indent.txt and :help filter). 
" reformatter to the standard = command by setting the 'equalprg' option.
" Beautiful code, on autocommand
augroup CodeFormatters
    autocmd!

    autocmd  BufReadPost,FileReadPost   *.py    :silent %!PythonTidy.py
    autocmd  BufReadPost,FileReadPost   *.p[lm] :silent %!perltidy -q
    autocmd  BufReadPost,FileReadPost   *.xml   :silent %!xmlpp –t –c –n
    autocmd  BufReadPost,FileReadPost   *.[ch]  :silent %!indent
augroup END

" Invoking PerlTidy after every edit
function! TidyAndResetCursor ()
    let cursor_pos = getpos('.')
    %!perltidy -q
    call setpos('.', cursor_pos)
endfunction

augroup PerlTidy
    autocmd!
    autocmd InsertLeave *.p[lm]  :call TidyAndResetCursor()
augroup END

" This same code pattern could be adapted to perform any appropriate action
" each time you insert text. For example, if you were working on a very
" unreliable system and wished to maximize your ability to recover files (see
" :help usr_11.txt) if something went wrong, you could arrange for Vim to
" update its swap-file every time you left Insert mode
augroup UpdateSwap
    autocmd!
    autocmd  InsertLeave  *  :preserve
augroup END

" Automatically updating an internal timestamp whenever a file is saved

let s:timestamps = {
\  'This file last updated: \zs.*'             :  'strftime("%c")',
\  'Last modification: \zs.*'                  :  'strftime("%Y%m%d.%H%M%S")',
\  'Copyright (c) .\{-}, \d\d\d\d-\zs\d\d\d\d' :  'strftime("%Y")',
\}

function! UpdateTimestamp ()
    for [signature, replacement] in items(s:timestamps)
        silent! execute "'[,']s/" . signature . '/\= ' . replacement . '/'
    endfor
endfunction

augroup TimeStamping
    autocmd!

    autocmd BufWritePre,FileWritePre,FileAppendPre  *.txt  :call UpdateTimestamp()
augroup END

" Context-sensitive timestaming for different filetypes

function! UpdateTimestamp (signature, replacement)
    silent! execute "'[,']s/" . a:signature . '/\= ' . a:replacement . '/'
endfunction

augroup Timestamping
    autocmd!

    " C header files use one timestamp format ...
    autocmd BufWritePre,FileWritePre,FileAppendPre  *.h
        \ :call UpdateTimestamp('This file last updated: \zs.*', 'strftime("%c")')

    " C code files use another ...
    autocmd BufWritePre,FileWritePre,FileAppendPre  *.c
        \ :call UpdateTimestamp('Last update: \zs.*', 'strftime("%Y%m%d.%H%M%S")')
augroup END

" Unconditionally autocreating non-existent directories
augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END
function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call mkdir(required_dir, 'p')
    endif
endfunction

" Conditionally autocreating non-existent directories

augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END
function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Directory '" . required_dir . "' doesn't exist.", "&Create it?")

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction

function! AskQuit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction

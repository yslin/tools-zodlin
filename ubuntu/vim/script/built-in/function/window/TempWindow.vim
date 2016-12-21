function! s:ParseSign(raw) 
  let attrs = split(a:raw)

  exec 'let line = ' . split(attrs[0], '=')[1]

  let id = split(attrs[1], '=')[1]
  " hack for the italian localization
  if id =~ ',$'
    let id = id[:-2]
  endif

  " hack for the swedish localization
  if attrs[2] =~ '^namn'
    let name = substitute(attrs[2], 'namn=\?', '', '')
  else
    let name = split(attrs[2], '=')[1]
  endif

  return {'id': id, 'line': line, 'name': name}
endfunction 

function! s:CompareSigns(s1, s2)
  " Used by ViewSigns to sort list of sign dictionaries.

  if a:s1.line == a:s2.line
    return 0
  endif
  if a:s1.line > a:s2.line
    return 1
  endif
  return -1
endfunction

function! s:JumpToSign()
  let winnr = bufwinnr(bufnr('^' . b:filename))
  if winnr != -1
    let line = substitute(getline('.'), '^\(\d\+\)|.*', '\1', '')
    exec winnr . "winc w"
    call cursor(line, 1)
  endif
endfunction

function! Unplace(id) 
  " Un-places a sign in the current buffer.
  exec 'sign unplace ' . a:id . ' buffer=' . bufnr('%')
endfunction 

function! Place(name, line)
  " Places a sign in the current buffer.
  if a:line > 0
    let lastline = line('$')
    let line = a:line <= lastline ? a:line : lastline
    let id = a:name == 'placeholder' ? 999999 : line
    exec "sign place " . id . " line=" . line . " name=" . a:name .
      \ " buffer=" . bufnr('%')
  endif
endfunction

function! Toggle(name, line) 
  if g:EclimSignLevel == 'off'
    echo 'Eclim signs have been disabled.'
    return
  endif

  " Toggle a sign on the current line.
  if a:line > 0
    let existing = GetExisting(a:name)
    let exists = len(filter(existing, "v:val['line'] == a:line"))
    if exists
      call Unplace(a:line)
    else
      call Place(a:name, a:line)
    endif
  endif
endfunction

"call Toggle('user', line('.')) 
map tm :call Toggle('user', line('.'))<cr>

" EscapeBufferName(name) 
" Escapes the supplied buffer name so that it can be safely used by buf*
" functions.
function! EscapeBufferName(name)
  let name = a:name
  " escaping the space in cygwin could lead to the dos path error message that
  " cygwin throws when a dos path is referenced.
  if !has('win32unix')
    let name = escape(a:name, ' ')
  endif
  return substitute(name, '\(.\{-}\)\[\(.\{-}\)\]\(.\{-}\)', '\1[[]\2[]]\3', 'g')
endfunction 

function! TempWindowClear(name) 
  " Clears the contents of the temp window with the given name.
  let name = EscapeBufferName(a:name)
  if bufwinnr(name) != -1
    let curwinnr = winnr()
    exec bufwinnr(name) . "winc w"
    setlocal modifiable
    setlocal noreadonly
    silent 1,$delete _
    exec curwinnr . "winc w"
  endif
endfunction

" GoToBufferWindowRegister(buf) 
" Registers the autocmd for returning the user to the supplied buffer when the
" current buffer is closed.
function! GoToBufferWindowRegister(buf)
  exec 'autocmd BufWinLeave <buffer> ' .
    \ 'call GoToBufferWindow("' . escape(a:buf, '\') . '") | ' .
    \ 'doautocmd BufEnter'
endfunction 

" GoToBufferWindow(buf) 
" Focuses the window containing the supplied buffer name or buffer number.
" Returns 1 if the window was found, 0 otherwise.
function! GoToBufferWindow(buf)
  if type(a:buf) == g:NUMBER_TYPE
    let winnr = bufwinnr(a:buf)
  else
    let name = EscapeBufferName(a:buf)
    let winnr = bufwinnr(bufnr('^' . name . '$'))
  endif
  if winnr != -1
    exec winnr . "winc w"
    call DelayedCommand('doautocmd WinEnter')
    return 1
  endif
  return 0
endfunction

" DelayedCommand(command, [delay])
" Executes a delayed command.  Useful in cases where one would expect an
" autocommand event (WinEnter, etc) to fire, but doesn't, or you need a
" command to execute after other autocommands have finished.
" Note: Nesting is not supported.  A delayed command cannot be invoke off
" another delayed command.
function! DelayedCommand(command, ...)
  let uid = fnamemodify(tempname(), ':t:r')
  if &updatetime > 1
    exec 'let g:eclim_updatetime_save' . uid . ' = &updatetime'
  endif
  exec 'let g:eclim_delayed_command' . uid . ' = a:command'
  let &updatetime = len(a:000) ? a:000[0] : 1
  exec 'augroup delayed_command' . uid
    exec 'autocmd CursorHold * ' .
      \ '  if exists("g:eclim_updatetime_save' . uid . '") | ' .
      \ '    let &updatetime = g:eclim_updatetime_save' . uid . ' | ' .
      \ '    unlet g:eclim_updatetime_save' . uid . ' | ' .
      \ '  endif | ' .
      \ '  exec g:eclim_delayed_command' . uid . ' | ' .
      \ '  unlet g:eclim_delayed_command' . uid . ' | ' .
      \ '  autocmd! delayed_command' . uid
  exec 'augroup END'
endfunction 


function! TempWindow(name, lines, ...) 
  " Opens a temp window w/ the given name and contents which is readonly unless
  " specified otherwise.
  let options = a:0 > 0 ? a:1 : {}
  let filename = expand('%:p')
  let winnr = winnr()

  let bufname = EscapeBufferName(a:name)
  let name = escape(a:name, ' ')
  if has('unix')
    let name = escape(name, '[]')
  endif

  let line = 1
  let col = 1

  if bufwinnr(bufname) == -1
    let height = get(options, 'height', 10)
    silent! noautocmd exec "keepalt botright " . height . "sview " . name
    setlocal nowrap
    setlocal winfixheight
    setlocal noswapfile
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    silent doautocmd WinEnter
  else
    let temp_winnr = bufwinnr(bufname)
    if temp_winnr != winnr()
      exec temp_winnr . 'winc w'
      silent doautocmd WinEnter
      if get(options, 'preserveCursor', 0)
        let line = line('.')
        let col = col('.')
      endif
    endif
  endif

  call TempWindowClear(a:name)

  setlocal modifiable
  setlocal noreadonly
  call append(1, a:lines)
  retab

  let undolevels = &undolevels
  set undolevels=-1
  silent 1,1delete _
  let &undolevels = undolevels

  call cursor(line, col)

  if get(options, 'readonly', 1)
    setlocal nomodified
    setlocal nomodifiable
    setlocal readonly
    nmap <buffer> q :q<cr>
  endif

  silent doautocmd BufEnter

  " Store filename and window number so that plugins can use it if necessary.
  if filename != expand('%:p')
    let b:filename = filename
    let b:winnr = winnr

    augroup eclim_temp_window
      autocmd! BufWinLeave <buffer>
      call GoToBufferWindowRegister(b:filename)
    augroup END
  endif
endfunction 

function! GetExisting(...) 
    " Gets a list of existing signs for the current buffer.
    " The list consists of dictionaries with the following keys:
    "   id:   The sign id.
    "   line: The line number.
    "   name: The sign name (erorr, warning, etc.)
    "
    " Optionally a sign name may be supplied to only retrieve signs of that name.

    if !has('signs') || g:EclimSignLevel == 'off'
        return []
    endif

    let bufnr = bufnr('%')

    redir => signs
    silent exec 'sign place buffer=' . bufnr
    redir END

    let existing = []
    for line in split(signs, '\n')
        if line =~ '.\{-}=.\{-}=' " only two equals to account for swedish output
            call add(existing, s:ParseSign(line))
        endif
    endfor

    if len(a:000) > 0
        call filter(existing, "v:val['name'] == a:000[0]")
    endif

    return existing
endfunction 


function! ViewSigns(name) 
    " Open a window to view all placed signs with the given name in the current
    " buffer.

    if g:EclimSignLevel == 'off'
        echo 'Eclim signs have been disabled.'
        return
    endif

    let filename = expand('%:p')
    let signs = GetExisting(a:name)
    call sort(signs, 's:CompareSigns')
    let content = map(signs, "v:val.line . '|' . getline(v:val.line)")

    call TempWindow('[Sign List]', content)

    set ft=qf
    nnoremap <silent> <buffer> <cr> :call <SID>JumpToSign()<cr>

    " Store filename so that plugins can use it if necessary.
    let b:filename = filename
    augroup temp_window
        autocmd! BufWinLeave <buffer>
        call GoToBufferWindowRegister(filename)
    augroup END
endfunction

"call ViewSigns('user')

function! UnplaceAll(list)
  " Un-places all signs in the supplied list from the current buffer.
  " The list may be a list of ids or a list of dictionaries as returned by
  " GetExisting()

  for sign in a:list
    if type(sign) == g:DICT_TYPE
      call Unplace(sign['id'])
    else
      call Unplace(sign)
    endif
  endfor
endfunction

"call UnplaceAll(GetExisting('user'))
map tc :call UnplaceAll(GetExisting('user'))<cr>
"call UnplaceAll(GetExisting())

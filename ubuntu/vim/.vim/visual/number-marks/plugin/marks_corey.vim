" marks_corey.vim : show marks using number array.
" Maintainer: Hongli Gao <left.slipper at gmail dot com>
" Last Change: 2010 August 27 
" Version: 1.4
"
" USAGE:
" Copy this file to your vim's plugin folder.
" ####  You can set marks only less 100.  ####
"
" make a mark, or delete it: 
"                            ctrl + F2
"                            mm
" move to ahead mark:          
"                            shift + F2
"                            mv
" move to next mark:                           
"                            F2
"                            mb
" moving a mark:
"                            m.
"  (press m. to mark a mark, and move the cursor to new line, 
"   press the m. again, you can moving a mark.)
"
" delete all marks:
"                            F4
"
" If you want to save the marks to a file. Do it like this:
" Add
"
" let g:marks_corey_signs_dir='c:\\'
" 
" to your gvimrc, change it to your path.
"
" press F6, input a name on command line, press ENTER.   # Save marks.
" press F5, input a name that you used, press ENTER.     # Reload marks.
"
" copyright (c) 2010 Hongli Gao; 
" Distributed under the GNU General Public License.
"
" ToDo: don't rely on quickfix list, create its own tab or window.
" ---------------------------------------------------------------------
" Load Once: {{{1
if exists('g:loaded_marks_corey')
    finish
endif
let g:loaded_marks_corey=1

if !has("signs")
  echoerr "Sorry, your vim does not support signs!"
  finish
endif

if has("win32")
  let s:win32Flag = 1
else
  let s:win32Flag = 0
endif

" ---------------------------------------------------------------------
"  Default Settings: {{{1
if !exists("g:marks_corey_XXX")
 let g:marks_corey_XXX = "sample not used now"
endif

if !exists("g:marks_corey_signs_dir")
    " If you're using a symlink to your script, but your resources are in
    " the same directory as the actual script, you'll need to do this:
    "   1: Get the absolute path of the script
    "   2: Resolve all symbolic links
    "   3: Get the folder of the resolved absolute file
    let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
    let g:marks_corey_signs_dir = resolve(s:path . "/../signs/")
endif

"[ sign id, line number, file name]
let s:markList = [["00", "0", "DO NOT CHANGE ANYTHING, THIS USING FOR A VIM PLUGIN. BY HONGLI GAO @2010/08"]]
let s:quickfixList = []
let s:MARKLIST_SIGN_ID = 0
let s:MARKLIST_LINE_NUMBER = 1
let s:MARKLIST_FILEPATH = 2

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

function! s:GetExisting(...) 
    " Gets a list of existing signs for the current buffer.
    " The list consists of dictionaries with the following keys:
    "   id:   The sign id.
    "   line: The line number.
    "   name: The sign name (erorr, warning, etc.)
    "
    " Optionally a sign name may be supplied to only retrieve signs of that name.

    if !has('signs')
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
        "echo existing
    endif

    return existing
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
    "echo "winnr:" .winnr
    let linenr = line('.')
    let b:filename = s:markList[linenr][s:MARKLIST_FILEPATH]
    exec "winc p"
    call s:Sign_jump(s:markList[linenr])
endfunction

function! s:TempWindowClear(name) 
    " Clears the contents of the temp window with the given name.
    let name = s:EscapeBufferName(a:name)
    if bufwinnr(name) != -1
        let curwinnr = winnr()
        exec bufwinnr(name) . "winc w"
        setlocal modifiable
        setlocal noreadonly
        silent 1,$delete _
        exec curwinnr . "winc w"
    endif
endfunction

function! s:TempWindow(name, lines, ...) 
    " Opens a temp window w/ the given name and contents which is readonly unless
    " specified otherwise.
    let options = a:0 > 0 ? a:1 : {}
    let filename = expand('%:p')
    let winnr = winnr()

    let bufname = s:EscapeBufferName(a:name)
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

    call s:TempWindowClear(a:name)

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
            call s:GoToBufferWindowRegister(b:filename)
        augroup END
    endif
endfunction 

" EscapeBufferName(name) 
" Escapes the supplied buffer name so that it can be safely used by buf*
" functions.
function! s:EscapeBufferName(name)
    let name = a:name
    " escaping the space in cygwin could lead to the dos path error message that
    " cygwin throws when a dos path is referenced.
    if !has('win32unix')
        let name = escape(a:name, ' ')
    endif
    return substitute(name, '\(.\{-}\)\[\(.\{-}\)\]\(.\{-}\)', '\1[[]\2[]]\3', 'g')
endfunction 

" DelayedCommand(command, [delay])
" Executes a delayed command.  Useful in cases where one would expect an
" autocommand event (WinEnter, etc) to fire, but doesn't, or you need a
" command to execute after other autocommands have finished.
" Note: Nesting is not supported.  A delayed command cannot be invoke off
" another delayed command.
function! s:DelayedCommand(command, ...)
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

" GoToBufferWindow(buf) 
" Focuses the window containing the supplied buffer name or buffer number.
" Returns 1 if the window was found, 0 otherwise.
function! GoToBufferWindow(buf)
    if type(a:buf) == g:NUMBER_TYPE
        let winnr = bufwinnr(a:buf)
    else
        let name = s:EscapeBufferName(a:buf)
        let winnr = bufwinnr(bufnr('^' . name . '$'))
    endif
    if winnr != -1
        exec winnr . "winc w"
        call s:DelayedCommand('doautocmd WinEnter')
        return 1
    endif
    return 0
endfunction

" GoToBufferWindowRegister(buf) 
" Registers the autocmd for returning the user to the supplied buffer when the
" current buffer is closed.
function! s:GoToBufferWindowRegister(buf)
    exec 'autocmd BufWinLeave <buffer> ' .
                \ 'call GoToBufferWindow("' . escape(a:buf, '\') . '") | ' .
                \ 'doautocmd BufEnter'
endfunction 

function! s:ViewSigns(name) 
    " Open a window to view all placed signs with the given name in the current
    " buffer.

    let filename = expand('%:p')
    "let signs = s:GetExisting(a:name)
    let signs = []
    "call sort(signs, 's:CompareSigns')
    for item in s:markList
        if item[s:MARKLIST_LINE_NUMBER] != 0
            call add(signs, {'line': item[s:MARKLIST_LINE_NUMBER], 'filename' : item[s:MARKLIST_FILEPATH]})
        endif
    endfor
    let content = map(signs, "v:val.filename . '|' . v:val.line . '|' . getline(v:val.line)")
    call s:TempWindow('[Sign List]', content)

    set ft=qf
    nnoremap <silent> <buffer> <cr> :call <SID>JumpToSign()<cr>

    " Store filename so that plugins can use it if necessary.
    let b:filename = filename
    augroup temp_window
        autocmd! BufWinLeave <buffer>
        call s:GoToBufferWindowRegister(filename)
    augroup END
endfunction

fun! s:Set_quickfixList()
    let s:quickfixList = []
    let tmplist = getqflist()
    let idx = 0
    for item in s:markList
        if idx > 0
            let s:quickfixList = s:quickfixList + 
                        \[{'lnum': item[s:MARKLIST_LINE_NUMBER], 'filename' : item[s:MARKLIST_FILEPATH],
                        \'col': 0, 'valid': 1, 'vcol': 0, 'nr': 0, 'type': 'L', 'pattern': '', 'text': item[s:MARKLIST_SIGN_ID] . " : " . getline(item[s:MARKLIST_LINE_NUMBER])}]
        endif
        let idx += 1
    endfor
    call setqflist(s:quickfixList)
endfun

fun! s:Show_quickfixList()
    call s:Set_quickfixList()
    botright cw
endfun


let s:markListTop = 1
let s:tmplist = ["00", "0", "corey"]
let s:deleteFlag = 0
let s:outputFileName = "DO_NOT_DELETE_IT"
let s:remarkItem = ["REMARK", "SEARCH", "FLAG"]
let s:signSuffix = ".sign"

" ----------------
"  Functions: {{{1
" ----------------

" ---------------------------------------------------------------------
" Save_signs: {{{2
fun! s:Save_signs()
    call inputsave()
    let Pname = input('Save Marks to: ')
    call inputrestore()
    if len(Pname) > 0
        if exists("g:marks_corey_signs_dir")
            let temp = g:marks_corey_signs_dir
            let g:marks_corey_signs_dir = g:marks_corey_signs_dir . "/" . Pname
            call s:Save_signs_to_file()
            let g:marks_corey_signs_dir = temp
        endif
    endif
endfun

" Load_signs: {{{2
fun! s:Load_signs()
    call inputsave()
    let Pbname = input('Load Marks from: ')
    call inputrestore()
    if len(Pbname) > 0
        if exists("g:marks_corey_signs_dir")
            let temp = g:marks_corey_signs_dir
            let g:marks_corey_signs_dir = g:marks_corey_signs_dir . "/" . Pbname
            call s:Load_signs_from_file()
            let g:marks_corey_signs_dir = temp
        endif
    endif
endfun

" Place_sign: {{{2
fun! s:Place_sign()

    if !exists("s:Cs_sign_number")
        let s:Cs_sign_number = 1
    endif

    if s:Cs_sign_number > 99
        echo "Sorry, you only can use these marks less 100!"
        return -1
    else
        let s:Cs_sign_number = (s:markList[len(s:markList) - 1][s:MARKLIST_SIGN_ID] * 1) + 1
    endif

    let vLn = "".line(".")
    let vFileName = expand("%:p")

    let vFlagNum = (s:Cs_sign_number < 10 ? "0" . s:Cs_sign_number : s:Cs_sign_number)
    let newMarkItem = [vFlagNum,vLn,vFileName]
    let vIndex = s:Check_list(newMarkItem)

    if vIndex > -1
        " already exists, then remove it.
        call s:Remove_sign(vIndex)
    else
        " sign CS01 text=01 texthl=ErrorMsg
        " sign CS02 text=02 texthl=ErrorMsg
        silent! exe 'sign define CS'. vFlagNum . ' text=' . vFlagNum . ' texthl=ErrorMsg'
        silent! exe 'sign place ' . vFlagNum . ' line=' . vLn . ' name=CS'. vFlagNum . ' file=' . vFileName
        "silent! exe 'sign place ' . vFlagNum . ' line=' . vLn . ' name=CS file=' . vFileName

        "let s:Cs_sign_number = s:Cs_sign_number + 1
        let s:markList = s:markList + [newMarkItem]
        " record the last index.
        let s:markListTop = len(s:markList) - 1
        let s:deleteFlag = 0
    endif
    "echo s:markList
endfun

" Remove_all_signs: {{{2
fun! s:Remove_all_signs()

    silent! exe 'sign unplace *'
    if len(s:markList) > 1
        let i = remove(s:markList, 1, -1)
        let s:Cs_sign_number = 1
    endif
    "echo s:markList
endfun
" Goto_prev_sign: {{{2
fun! s:Goto_prev_sign()

    if len(s:markList) > 1
        if s:deleteFlag == 0
            let s:markListTop = s:markListTop - 1
        endif
        let s:deleteFlag = 0

        if s:markListTop <= 0
            let s:markListTop = len(s:markList) - 1
        endif
        call s:Sign_jump(s:markList[s:markListTop])
    endif
endfun

" Goto_next_sign: {{{2
fun! s:Goto_next_sign()

    let s:deleteFlag = 0
    if len(s:markList) > 1
        let s:markListTop = s:markListTop + 1
        if ((s:markListTop >= len(s:markList)) || (s:markListTop == 1))
            let s:markListTop = 1
        endif
        call s:Sign_jump(s:markList[s:markListTop])
    endif
endfun

" Save_signs_to_file: {{{2
fun! s:Save_signs_to_file()

    call s:Get_signs_file_name()
    let tempList = []
    for item in s:markList
        let tempList = tempList + [item[s:MARKLIST_SIGN_ID] . "#" . item[s:MARKLIST_LINE_NUMBER]. "#" . item[s:MARKLIST_FILEPATH]]
    endfor
    if exists("g:marks_corey_signs_dir")
        let writeFlag = writefile(tempList, s:outputFileName)
    endif
endfun

" Load_signs_from_file: {{{2
fun! s:Load_signs_from_file()

    call s:Get_signs_file_name()
    if filereadable(s:outputFileName)
        let tempList = [[]]
        let iflag = 0
        for line in readfile(s:outputFileName)
            let first = stridx(line, "#", 0)
            let second = stridx(line, "#", first + 1)
            if iflag != 0
                let tempList = tempList + [[strpart(line, 0, first), strpart(line, first + 1, second - first - 1), strpart(line, second + 1)]]
            else
                let tempList = [[strpart(line, 0, first), strpart(line, first + 1, second - first - 1), strpart(line, second + 1)]]
            endif
            let iflag = 1
        endfor
        let s:markList = tempList
    endif

    call s:Flash_signs()

    "echo s:markList
endfun

" Get_signs_file_name: {{{2
fun! s:Get_signs_file_name()

    if exists("g:marks_corey_signs_dir")
        let s:outputFileName = g:marks_corey_signs_dir . s:signSuffix
    endif
endfun

" Remove_sign: {{{2
fun! s:Remove_sign(aIndex)

    if len(s:markList) > 1
        silent! exe 'sign unplace ' .s:markList[a:aIndex][s:MARKLIST_SIGN_ID] . ' file=' . s:markList[a:aIndex][s:MARKLIST_FILEPATH]

        " record the before item
        let s:tmplist = s:markList[a:aIndex - 1]

        let i = remove(s:markList, a:aIndex)

        " record the current index.
        let s:markListTop = s:Check_list(s:tmplist)
        let s:deleteFlag = 1
        "echo s:markList
    endif
endfun

" Flash_signs: {{{2
fun! s:Flash_signs()

    silent! exe 'sign unplace *'
    silent! exe 'sign undefine *'
    if len(s:markList) > 1
        for item in s:markList
            silent! exe 'sign define CS' . item[s:MARKLIST_SIGN_ID] . ' text='. item[s:MARKLIST_SIGN_ID] .' texthl=ErrorMsg'
            silent! exe 'badd ' . item[s:MARKLIST_FILEPATH]
            silent! exe 'sign place ' . item[s:MARKLIST_SIGN_ID] . ' line=' . item[s:MARKLIST_LINE_NUMBER] . ' name=CS'. item[s:MARKLIST_SIGN_ID] . ' file=' . item[s:MARKLIST_FILEPATH]
        endfor
    endif
    let s:Cs_sign_number = s:markList[len(s:markList) - 1][s:MARKLIST_SIGN_ID] * 1 + 1
    "let s:markListTop = 1 ##you don't need reset the pointer
endfun

" Check_list: {{{2
" if line number and file name both same, return the aMarkItem's index of s:markList
" else return -1
" index 0 of s:markList is the output message in the record file.
fun! s:Check_list(aMarkItem)

    let vResult = -1
    let index = 0

    for item in s:markList
        if ((s:Compare(item[s:MARKLIST_LINE_NUMBER], a:aMarkItem[s:MARKLIST_LINE_NUMBER]) == 1) && (s:Compare(item[s:MARKLIST_FILEPATH], a:aMarkItem[s:MARKLIST_FILEPATH]) == 1))
            return index
        endif
        let index = index + 1
    endfor

    return vResult
endfun

" Move_sign: {{{2
fun! s:Move_sign()

    let s:tempItem = ["","",""]
    let vRLn = "".line(".")
    let vRFileName = expand("%:p")

    let s:tempItem[1] = vRLn
    let s:tempItem[2] = vRFileName
    "echo s:tempItem
    let vRIndex = s:Check_list(s:tempItem)

    if (s:remarkItem[s:MARKLIST_SIGN_ID] ==# "REMARK" )
        if vRIndex > 0
            silent! exe 'sign define CS' . s:markList[vRIndex][s:MARKLIST_SIGN_ID] . ' text='. s:markList[vRIndex][s:MARKLIST_SIGN_ID] .' texthl=Search'
            silent! exe 'sign place ' . s:markList[vRIndex][s:MARKLIST_SIGN_ID] . ' line=' . vRLn . ' name=CS'. s:markList[vRIndex][s:MARKLIST_SIGN_ID] . ' file=' . vRFileName
            let s:remarkItem = s:markList[vRIndex]
            let s:markListTop = vRIndex
            "echo s:remarkItem
        endif
    else
        let pionter = s:Check_list(s:remarkItem)
        "echo vRIndex ."|" .pionter
        if ((vRIndex < 0) && (pionter > 0))
            silent! exe 'sign unplace ' .s:remarkItem[s:MARKLIST_SIGN_ID] . ' file=' . s:remarkItem[s:MARKLIST_FILEPATH]
            "silent! exe 'sign undefine' .s:remarkItem[s:MARKLIST_SIGN_ID]
            silent! exe 'sign define CS' . s:remarkItem[s:MARKLIST_SIGN_ID] . ' text='. s:remarkItem[s:MARKLIST_SIGN_ID] .' texthl=ErrorMsg'
            silent! exe 'sign place ' . s:remarkItem[s:MARKLIST_SIGN_ID] . ' line=' . vRLn . ' name=CS' . s:remarkItem[s:MARKLIST_SIGN_ID] . ' file=' . vRFileName
            let s:markList[pionter][s:MARKLIST_LINE_NUMBER] = vRLn
            let s:markList[pionter][s:MARKLIST_FILEPATH] = vRFileName
            "echo s:markList[pionter]
            let s:markListTop = pionter
            let s:remarkItem = ["REMARK","SEARCH","FLAG"]
        endif
    endif
endfun

" Sign_jump: {{{2
" all of them used for the jump.
fun! s:Sign_jump(aSignItem)
    let bufferExits = s:GetTabpage(a:aSignItem)

    if bufferExits > 0
        silent! exe 'tabn ' . bufferExits
        silent! exe 'sign jump '. a:aSignItem[s:MARKLIST_SIGN_ID] . ' file='. a:aSignItem[s:MARKLIST_FILEPATH]
    else
        call s:Open_file(a:aSignItem[s:MARKLIST_FILEPATH])
        silent! exe 'sign place ' . a:aSignItem[s:MARKLIST_SIGN_ID] . ' line=' . a:aSignItem[s:MARKLIST_LINE_NUMBER] . ' name=CS'. a:aSignItem[s:MARKLIST_SIGN_ID] . ' file=' . a:aSignItem[s:MARKLIST_FILEPATH]
        silent! exe 'sign jump '. a:aSignItem[s:MARKLIST_SIGN_ID] . ' file='. a:aSignItem[s:MARKLIST_FILEPATH]
    endif

endfun

" GetTabpage: {{{2
fun! s:GetTabpage(aSignItem)

    let bufname = expand("%:p")
    if s:Compare(bufname, a:aSignItem[s:MARKLIST_FILEPATH]) == 1
        return tabpagenr()
    endif

    let i = 0

    while i < tabpagenr('$')

        if i == 0
            silent! exe 'tabfirst'
        else
            silent! exe 'tabnext'
        endif
        let bufname = expand("%:p")

        if s:Compare(bufname,a:aSignItem[s:MARKLIST_FILEPATH]) == 1
            return i + 1
        endif

        let i = i + 1
    endwhile

    return -1
endfun

" Compare: {{{2
fun! s:Compare(a1,a2)
    if s:win32Flag == 1
        if a:a1 ==? a:a2
            return 1
        endif
    else
        if a:a1 ==# a:a2
            return 1
        endif
    endif
    return 0
endfun

" Open_file: {{{2
fun! s:Open_file(aFileName)
    if filereadable(a:aFileName)
        "call s:Flash_signs()
        if tabpagenr('$') > 1
            silent! exe 'tabnew '. a:aFileName
            silent! exe 'tabn ' . tabpagenr('$')
        else
            silent! exe 'e '. a:aFileName
        endif
    endif
endfun

" Seach_file: {{{2
" dummy function???????
" find the file, return the position; else return -1
fun! s:Seach_file(aFileName, aBufferList)

    let vResult = -1

    if len(a:aBufferList) > 1
        if s:win32Flag == 1
            for item in a:aBufferList
                " file name is ignoring case
                if (item[1] ==? a:aFileName)
                    return item[0]
                endif
            endfor
        else
            for item in a:aBufferList
                " file name is matching case
                if (item[1] ==# a:aFileName)
                    return item[0]
                endif
            endfor
        endif
    endif
    return vResult
endfun

" Public Interface: {{{1
com!        -nargs=0 PlaceSign :call s:Place_sign()
com!        -nargs=0 GotoNextSign :call s:Goto_next_sign()
com!        -nargs=0 GotoPrevSign :call s:Goto_prev_sign()
com!        -nargs=0 RemoveAllSigns :call s:Remove_all_signs()
com!        -nargs=0 MoveSign :call s:Move_sign()
com!        -nargs=0 SaveSigns :call s:Save_signs()
com!        -nargs=0 LoadSigns :call s:Load_signs()
com!        -nargs=0 ShowQFList :call s:Show_quickfixList()
com!        -nargs=0 ShowSignList :call s:ViewSigns('CS')

" ---------------------------------------------------------------------
"if !hasmapto('<Plug>Place_sign')
"  map <unique> <c-F2> <Plug>Place_sign
"  map <silent> <unique> mm <Plug>Place_sign
"endif
"nnoremap <silent> <script> <Plug>Place_sign :call Place_sign()<cr>
"
"if !hasmapto('<Plug>Goto_next_sign') 
"  map <unique> <F2> <Plug>Goto_next_sign
"  map <silent> <unique> mb <Plug>Goto_next_sign
"endif
"nnoremap <silent> <script> <Plug>Goto_next_sign :call Goto_next_sign()<cr>
"
"if !hasmapto('<Plug>Goto_prev_sign') 
"  map <unique> <s-F2> <Plug>Goto_prev_sign
"  map <silent> <unique> mv <Plug>Goto_prev_sign
"endif
"nnoremap <silent> <script> <Plug>Goto_prev_sign :call Goto_prev_sign()<cr>
"
"if !hasmapto('<Plug>Remove_all_signs') 
"  map <unique> <F4> <Plug>Remove_all_signs
"endif
"nnoremap <silent> <script> <Plug>Remove_all_signs :call Remove_all_signs()<cr>
"
"if !hasmapto('<Plug>Move_sign') 
"  map <silent> <unique> m. <Plug>Move_sign
"endif
"nnoremap <silent> <script> <Plug>Move_sign :call Move_sign()<cr>
"
"
"noremap <F6> :call Save_signs()<cr>
"noremap <F5> :call Load_signs()<cr>

" ---------------------------------------------------------------------
" zod: it need to show all marks and go to mark by number or copen to go

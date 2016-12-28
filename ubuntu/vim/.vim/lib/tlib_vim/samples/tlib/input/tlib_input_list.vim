" The following variable configures the way |tlib#input#ListD()| works. 
" In this example, we allow selection of multiple items (we could also 
" allow only a single choice and make |tlib#input#ListD()| work on the 
" indices, not the items).
"
" We also set a prompt that will be displayed in the command area.
"
" By default, |tlib#input#ListD()| will automatically select an item if 
" there is only one item left matching the filter. In this example, we 
" disable this feature.
"
" For demonstration purposes, we also define a key handler that prints 
" the selected items.
" key可以用:echo getchar()來取得數值, key_name毫無用處指示提醒你key是多少而已
let s:state = {
            \ 'type': 'm',
            \ 'query': 'Select lines for command output',
            \ 'pick_last_item': 0,
            \ 'key_handlers': [
                \ {'key': 16, 'agent': 'PrintMe', 'key_name': '<c-p>', 'help': 'Print line'},
                \ {'key': 14, 'agent': 'PrintMe', 'key_name': '<c-n>', 'help': 'Print line'},
            \ ],
            \ }

" 其他有許多handler可以參考tlib#agent#的函式
" A key handler takes two arguments: the current state of the list 
" display and a list of selected items/indices (depending on the type 
" parameter).
function! PrintMe(state, items) "{{{3
    echom "You selected:"
    for i in a:items
        echom i
    endfor
    call input("Press ENTER to continue")
    let a:state.state = 'redisplay'
    return a:state
endf

" In this example, we evaluate an ex-command with |:execute| and display 
" the command's output as list. The user can select certain lines by 
" typing some pattern or by pressing <a-NUMBER> to select an item by 
" number. The user can then press <c-p> to print the lines (see above) 
" or <cr> to pick the selected lines.
function! SelectOutput(ex) "{{{3
    redir => lines
    silent exec a:ex
    redir END
    let state = copy(s:state)
    let state.base = split(lines, '\n')
    let picked = tlib#input#ListD(state)
    echom "You picked: ". join(picked, ', ')
endf

"測試顯示ls的結果清單
call SelectOutput('ls')

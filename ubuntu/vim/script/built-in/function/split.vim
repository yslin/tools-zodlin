let vimList = split(globpath(".", "*.vim"), "\n")
echo vimList
" :h filename-modifiers to check :r, remove extension file name
" (eg. test.bat -> test, hello.vim -> hello, .vimrc -> .vimrc).
let vimSortedList=sort(map(vimList, 'fnamemodify(v:val, ":r")'))
echo vimSortedList

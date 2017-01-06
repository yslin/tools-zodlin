let vimList = split(globpath(".", "*.vim"), "\n")
echo vimList
" :h filename-modifiers to check :r
let vimSortedList=sort(map(vimList, 'fnamemodify(v:val, ":r")'))
echo vimSortedList

"Another example, which highlights all characters in virtual column 12 and more: >
highlight rightMargin term=bold ctermfg=blue guifg=blue
match rightMargin /.\%>12v/
"To highlight all character that are in virtual column 7: >
highlight col8 ctermbg=grey guibg=grey
match col8 /\%<8v.\%>7v/
"Remove all highlight
match none

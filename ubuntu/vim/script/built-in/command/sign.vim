" 定義名稱為piet的標號
sign define piet text=>> texthl=Search
" 在当前文件的第 2 行显示 "piet" 标号，以文字 ">>" 标明
exe ":sign place 2 line=2 name=piet file=" . expand("%:p")

" sign undefine piet
" 顯示目前place的sign
sign place
" 消除所有的sign
"sign unplace *
" 消除id為2的sign
"sign unplace 2

" Jump to id 2 sign place
sign jump 2 file=sign.vim

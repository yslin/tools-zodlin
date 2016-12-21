"  1 2 3 4 5 6 7 8 9 10
"  2 2 3 4 5 6 7 8 9 10
"  3 2 3 4 5 6 7 8 9 10
"  4 2 3 4 5 6 7 8 9 10
"  5 2 3 4 5 6 7 8 9 10
"  6 2 3 4 5 6 7 8 9 10
"  7 2 3 4 5 6 7 8 9 10
"  8 2 3 4 5 6 7 8 9 10
"  9 2 3 4 5 6 7 8 9 10
" 10 2 3 4 5 6 7 8 9 10
let qflist = [{'lnum': 2, 'bufnr': 1,                    'col': 0, 'valid': 1, 'vcol': 0, 'nr': 0, 'type': 'E', 'pattern': '', 'text': '''string'' imported but unused'},
             \{'lnum': 5, 'bufnr': 1,                    'col': 3, 'valid': 1, 'vcol': 1, 'nr': 0, 'type': 'E', 'pattern': '', 'text': 'local variable ''local'' is assigned to but never used'},
             \{'lnum': 7, 'filename' : 'setqflist.vim',  'col': 7, 'valid': 1, 'vcol': 1, 'nr': 0, 'type': 'E', 'pattern': '', 'text': 'quicklist dictionary structure without bufnr index'}]
" :cw show the qflist error message and label each errorn line with red tag '>'
call setqflist(qflist)

echo getqflist()
copen

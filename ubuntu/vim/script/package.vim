":h 41.11 Write a plugin
" This is the XXX package

if exists("XXX_loaded")
    delfun XXX_one
    delfun XXX_two
endif

function XXX_one(a)
    ... body of function ...
endfun

function XXX_two(b)
    ... body of function ...
endfun

let XXX_loaded = 1


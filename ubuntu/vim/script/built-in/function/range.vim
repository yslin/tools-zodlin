func! TestRange() range
    echo a:firstline . " " . a:lastline
    for linenum in range(a:firstline, a:lastline)
        echo linenum
    endfor
endf

1,5call TestRange()

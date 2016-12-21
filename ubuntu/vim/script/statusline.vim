func! Tsung()
    set ls=2
    set statusline=%<%f\ %m%=\ %h%r\ %-19([%p%%]\ %3l,%02c%03V%)%y
    highlight StatusLine term=bold,reverse cterm=bold,reverse
endf

func! Pct()
    set laststatus=2
    set statusline=%4*%<\ %1*[%F]
    set statusline+=%4*\ %5*[%{&encoding}, " encoding
    set statusline+=%{&fileformat}%{\"\".((exists(\"+bomb\")\ &&\ &bomb)?\",BOM\":\"\").\"\"}]%m
    set statusline+=%4*%=\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>
    highlight User1 ctermfg=red
    highlight User2 term=underline cterm=underline ctermfg=green
    highlight User3 term=underline cterm=underline ctermfg=yellow
    highlight User4 term=underline cterm=underline ctermfg=white
    highlight User5 ctermfg=cyan
    highlight User6 ctermfg=white
endf

func! Test()
    let g:var = "VAR_ARG"
    set laststatus=2
    set statusline=%1*[%F][%f][%t]
    set statusline+=%2*[%m][%M][%r][%R]
    set statusline+=%3*[%y][%Y][%l\/%L][%c]
    set statusline+=%4*[%p%%][%P]
    set statusline+=%5*[%a][%{&fileformat.\"\ \".&bomb}]
    set statusline+=%6*%{g:var}
    " %1*
    highlight User1 ctermfg=red
    " %2*
    highlight User2 term=underline cterm=underline ctermfg=green
    " %3*
    highlight User3 term=underline cterm=underline ctermfg=yellow
    " %4*
    highlight User4 term=underline cterm=underline ctermfg=white
    " %5*
    highlight User5 ctermfg=cyan
    " %6*
    highlight User6 ctermfg=white
endf
"call Tsung()
"call Pct()
call Test()

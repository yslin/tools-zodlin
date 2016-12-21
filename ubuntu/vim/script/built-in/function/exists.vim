func! SetVariable()
    let g:backup_count = exists('g:backup_count') ? !g:backup_count : 0
    echo g:backup_count
endf

call SetVariable()
call SetVariable()
call SetVariable()
call SetVariable()

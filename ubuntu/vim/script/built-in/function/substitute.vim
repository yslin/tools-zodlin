echo substitute(&path, ",\\=[^,]*$", "", "")
echo substitute("testing", ".*", "\\U\\0", "")
echo substitute("<leader>se", "<leader>", "", "")

" 普通版
func! DeAmperfy()
    "Get current line...
    let curr_line   = getline('.')

    "Replace raw ampersands... (see :help \@! for details)
    let replacement = substitute(curr_line,'&\(\w\+;\)\@!','&amp;','g')

    "Update current line...
    call setline('.', replacement)
endf

" 進階版
func! DeAmperfyAll() range
    "Step through each line in the range...
    for linenum in range(a:firstline, a:lastline)
        "Replace loose ampersands (as in DeAmperfy())...
        let curr_line   = getline(linenum)
        let replacement = substitute(curr_line,'&\(\w\+;\)\@!','&amp;','g')
        call setline(linenum, replacement)
    endfor

    "Report what was done...
    if a:lastline > a:firstline
        echo "DeAmperfied" (a:lastline - a:firstline + 1) "lines"
    endif
endf
" Move the cursor to here, and execute script & &w; &amp;
call DeAmperfy()
" & &w; &amp;
34,$call DeAmperfyAll()
" & &w; &amp;

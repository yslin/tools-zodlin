":h *41.9*	Exceptions

try
    read ~/templates/pascal.tmpl
catch /E484:/
    echo "Sorry, the Pascal template file cannot be found."
endtry

try
    read ~/templates/pascal.tmpl
catch 
    echo "Sorry, the Pascal template file cannot be found."
endtry

"let tmp = tempname()
"try
"    exe ".,$write " . tmp
"    exe "!filter " . tmp
"    .,$delete
"    exe "$read " . tmp
"finally
"    call delete(tmp)
"endtry

try  
    map <unique><unique> <leader>l   :echo "l"<CR>
catch
    func! LineNumber()
        return substitute(v:throwpoint, '.*\D\(line \d\+\).*', '\1', "")
    endf 
    echohl ErrorMsg | echo "Error detected while processing " .v:throwpoint | echohl NONE 
                \| echohl ErrorMsg | echo "E:". v:exception | echohl NONE 
    call input("Press ENTER to continue...")
endtry

":Finger1 <args><TAB>
"<args>自動補完,按tab會顯示
com! -complete=custom,ListUsers -nargs=1 Finger1 !finger <args>
fun! ListUsers(A,L,P)
    return system("cut -d: -f1 /etc/passwd")
endfun
":Finger2 <args><TAB>
"<args>不會自動補完,按tab會顯示
com! -nargs=1 Finger2 !finger <args>

"completes filenames from the directories specified in
" the 'path' option
"customlist: return type is string list
com! -nargs=1 -bang -complete=customlist,EditFileComplete1
           \ EditFile1 edit<bang> <args>

fun! EditFileComplete1(A,L,P)
    return split(globpath(&path, a:A), "\n")
endfun

"custom: return type is string
com! -nargs=1 -bang -complete=custom,EditFileComplete2
           \ EditFile2 edit<bang> <args>

fun! EditFileComplete2(A,L,P)
    return globpath(&path, a:A)
endfun


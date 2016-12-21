" Relative path of script file:
let s:path = expand('<sfile>')
echo s:path

" Absolute path of script file:
let s:path = expand('<sfile>:p')
echo s:path

" Absolute path of script file with symbolic links resolved:
let s:path = resolve(expand('<sfile>:p'))
echo s:path

" Folder in which script resides: (not safe for symlinks)
let s:path = expand('<sfile>:p:h')
echo s:path

" If you're using a symlink to your script, but your resources are in
" the same directory as the actual script, you'll need to do this:
"   1: Get the absolute path of the script
"   2: Resolve all symbolic links
"   3: Get the folder of the resolved absolute file
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
echo s:path

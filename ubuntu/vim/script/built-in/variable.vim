"vim version
echo v:version
echo version

"tab stop
echo &ts

echo &term

echo &path

echo $HOME

echo &fileformat

echo &foldcolumn

set foldcolumn=1
func! SetFold()
    if &foldcolumn == 0
        echo "foldcolumn is 0"
    else 
        echo "foldcolumn is 1"
    endif
endf
call SetFold()

let fname = expand('%')
" current file name is variables.vim
echo fname

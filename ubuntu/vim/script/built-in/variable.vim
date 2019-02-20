echo "vim version:" . v:version
echo "vim version:" . version

echo "vim directory:" . $VIM
echo "vim runtime path:" . $VIMRUNTIME
echo "vim rc:" . $MYVIMRC
echo "gvim rc:" . $MYGVIMRC
echo "HOME:" . $HOME
echo "PATH:" . $PATH

echo "tab stop:" . &ts
echo "terminal:" . &term
echo "PATH:" . &path
echo "file format:" . &fileformat
echo "fold column:" . &foldcolumn

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
echo "file name:" . fname

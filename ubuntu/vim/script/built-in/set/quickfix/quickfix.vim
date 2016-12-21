" See |error-file-format|
" See |compiler-select| 
func! Python_sh()
    set cpo-=C

    set makeprg=bash\ %

    "the last line: \%-G%.%# is meant to suppress some
    "late error messages that I found could occur e.g.
    "with wxPython and that prevent one from using :clast
    "to go to the relevant file and line of the traceback.
    set errorformat=
                \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
                \%C\ \ \ \ %.%#,
                \%+Z%.%#Error\:\ %.%#,
                \%A\ \ File\ \"%f\"\\\,\ line\ %l,
                \%+C\ \ %.%#,
                \%-C%p^,
                \%Z%m,
                \%-G%.%#
endf

"call Python_sh()

" :nmap <F3> :comp javac<CR>:mak -d . %<CR>
"      此命令用 javac 编译 java 文件, 它会自动将光标定位到出错点. 不过这需要定
"      义一个 javac.vim 文件在 $VIM/compiler 下, 在 javac.vim 里面只有两行字:
"         setlocal makeprg=javac
"         setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
"
" :nmap <F4> :comp ant<CR>:mak<CR>
"      此命令用 ant 编译 java 文件, 它会自动将光标定位到出错点. 一般来说, 安装
"      vim 后已经有了compiler/ant.vim文件, 因此这个命令可以直接使用. 但是需要
"      在当前目录下有 build.xml 文件, 当然还必须安装 ant 才行.
"
" :nmap <F5> :cl<CR>                 此命令用于查看所有的编译错误.
" :imap <F5> <ESC><F5>
"
" :nmap <F6> :cc<CR>                 此命令用于查看当前的编译错误.
" :imap <F6> <ESC><F6>
"
" :nmap <F7> :cn<CR>                 此命令用于跳到下一个出错位置.
" :imap <F7> <ESC><F7>
"
" :nmap <F8> :cp<CR>                 此命令用于跳到上一个出错位置.
" :imap <F8> <ESC><F8>
func! Java()
    set makeprg=javac\ %
    "set makeprg=javac\ %\ 2>&1\ \\\|\ vim-javac-filter
    "set efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
    set efm=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
    "set errorformat=%Z%f:%l:\ %m,%A%p^,%-G%*[^sl]%.%#
endf

call Java()

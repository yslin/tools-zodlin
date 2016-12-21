":h 41.5, The :execute" command allows executing the result of an expression.
"跳到頁尾
execute "normal " . "G"

let optname = "path"
let optval = eval('&' . optname)
echo optval
echo &path
"同上面運算&path的值
exe 'let oval = &' . optname
echo oval

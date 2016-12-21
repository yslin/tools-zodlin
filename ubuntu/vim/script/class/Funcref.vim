" h Funcref
func! MyFunc(list)
    let str = ""
    for item in a:list
        let str = str . "," . item
    endfor
    return str
endf

let FunRef = function("MyFunc")

echo FunRef([1,2,3])
  
"The name of the referenced function can be obtained with |string()|.
echo string(FunRef)
let mylist = [[5,6,7]]
let ret = call(FunRef, mylist)
echo ret

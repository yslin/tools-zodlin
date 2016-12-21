" https://groups.yahoo.com/neo/groups/vimdev/conversations/topics/26788
" s : string is parsed by delim
" delim : parse s to be tokens by delim
" n : get the nth token
fun! Strntok(s, delim, n)
    "[^a:delim] : all are accepted except a:delim
    "\zs: get right matched string as result
    "\ze: get left matched string as result
    "\zsREG\ze... : get REG as result
    return matchstr(a:s.a:delim[0],
                \'\v(\zs([^'.a:delim.']*)\ze['.a:delim.']){'.a:n.'}')
endfun
" I have a string like 'a,b,c,d' and I need to get the third token
" out...
" For example x = function('a,b,c,d', 3) would return 'c'
echo "1. Only one delim ','"
let x= Strntok( 'a1,b2,c3,d4', ',', 0)
echo  "Strntok( 'a1,b2,c3,d4', ',', 0) = " . x
let x= Strntok( 'a1,b2,c3,d4', ',', 1)
echo  "Strntok( 'a1,b2,c3,d4', ',', 1) = " . x
let x= Strntok( 'a1,b2,c3,d4', ',', 2)
echo  "Strntok( 'a1,b2,c3,d4', ',', 2) = " . x
let x= Strntok( 'a1,b2,c3,d4', ',', 3)
echo  "Strntok( 'a1,b2,c3,d4', ',', 3) = " . x
let x= Strntok( 'a1,b2,c3,d4', ',', 4)
echo  "Strntok( 'a1,b2,c3,d4', ',', 4) = " . x
echo "----------------------------------"
echo "2. Multiple delim ',:'"
let x= Strntok( 'a1:b2,c3:d4', ',:', 0)
echo  "Strntok( 'a1:b2,c3:d4', ',:', 0) = " . x
let x= Strntok( 'a1:b2,c3:d4', ',:', 1)
echo  "Strntok( 'a1:b2,c3:d4', ',:', 1) = " . x
let x= Strntok( 'a1:b2,c3:d4', ',:', 2)
echo  "Strntok( 'a1:b2,c3:d4', ',:', 2) = " . x
let x= Strntok( 'a1:b2,c3:d4', ',:', 3)
echo  "Strntok( 'a1:b2,c3:d4', ',:', 3) = " . x
let x= Strntok( 'a1:b2,c3:d4', ',:', 4)
echo  "Strntok( 'a1:b2,c3:d4', ',:', 4) = " . x

"CLASS: HelloClass
unlet! s:HelloClass
unlet! g:GlobalHelloClass
"class的主體,一定要是dict
let s:HelloClass = {}
let g:GlobalHelloClass = s:HelloClass

"FUNCTION: HelloClass.All() {{{1
function! s:HelloClass.All()
    return "test"
endfunction

echo g:GlobalHelloClass.All()

"FUNCTION: HelloClass.testf() {{{1
function! s:HelloClass.testf()
    return "test"
endfunction

echo g:GlobalHelloClass.testf()

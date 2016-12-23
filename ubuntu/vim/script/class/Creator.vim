let s:Creator = {} 
let g:NERDTreeCreator = s:Creator

"FUNCTION: s:Creator.New() {{{1
function! s:Creator.New()
    let newCreator = copy(self)
    return newCreator
endfunction


"FUNCTION: s:Creator._privateFunction() {{{1
function! s:Creator._privateFunction(str)
	echo a:str
endfunction


echo s:Creator
echo g:NERDTreeCreator
call g:NERDTreeCreator._privateFunction('hello')

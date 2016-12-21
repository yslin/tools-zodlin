" h bufwinnr()
ls | " list buffer window name 
echo bufwinnr(1) | " 1
echo bufwinnr('bufwinnr.vim') | " 1
echo bufwinnr('bufwinnr') | " 1
echo bufwinnr('*.vim') | " 1

let tagbarwinnr = bufwinnr('__Tagbar__')

if tagbarwinnr != -1
    if winnr() != tagbarwinnr 
        "jump to __Tagbar__ buffer window
        execute tagbarwinnr . 'wincmd w'
    endif
endif

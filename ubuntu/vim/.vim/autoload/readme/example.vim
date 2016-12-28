echom "Loading..."

" "readme" is a directory
" "example" is a vim script
" "Hello" is a function
"path: .vim/autoload + readme/example.vim + Hello()
"Try :call readme#example#Hello()
"Called at first time, get "Loading", "Hello, world", "Done loading"
"Called at second time, get only "Hello, world"
function! readme#example#Hello()
    echom "Hello, world!"
endfunction

echom "Done loading."

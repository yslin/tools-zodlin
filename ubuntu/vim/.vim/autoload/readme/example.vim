":h autoload 
"
"When you run this command, Vim will behave a bit differently than a normal
"function call.
"
"If this function has already been loaded, Vim will simply call it normally.
"
"Otherwise Vim will look for a file called autoload/somefile.vim in your
"~/.vim directory (and any Pathogen bundles).
"
"If this file exists, Vim will load/source the file. It will then try to call
"the function normally.
"
":call myplugin#somefile#Hello()
"This will look for the autoloaded file at autoload/myplugin/somefile.vim. The
"function inside it needs to be defined with the full autoload path:
"
"function myplugin#somefile#Hello()
"   ...
"endfunction

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

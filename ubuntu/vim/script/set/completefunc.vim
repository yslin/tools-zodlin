function! FufonComplete(findstart, base)
    " On the first invocation the arguments are:
    "   a:findstart  1
    "   a:base	empty
    if a:findstart
        "The function must return the column where the completion starts.
        echo "(1st)[col:" . col('.') . ", findstart:" . a:findstart . ", base:" . a:base . "]"
        call getchar()
        let text_before_cursor = strpart(getline('.'), 0, col('.') - 1)
        let completion_prefix = matchstr(text_before_cursor, '\w\+\.\?\w*$')
        echo "Matched completion prefix: " . string(completion_prefix)
        call getchar()
        return col('.') - len(completion_prefix) - 1        
    endif

    " On the second invocation the arguments are:
    "   a:findstart  0
    "   a:base	the text with which matches should match; the text that was
	"	located in the first call (can be empty)
    echo "(2nd)[col:" . col('.') . ", findstart:" . a:findstart . ", base:" . a:base . "]"
    call getchar()
    let matches = [{'word' : 'first'}, {'word' : 'fish'}, {'word' : 'focus'}]
    call filter(matches, 'v:val.word =~ a:base')
    return {'words': matches, 'refresh': 'always'}
endfunction
set completefunc=FufonComplete
"try the input like below:
"nothing just announing words before matching str f<c-x><c-u>

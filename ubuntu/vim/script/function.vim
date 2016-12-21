":h 41.7	Defining a function

":h verbose ,Debug
"set verbose=2

func! LogFunc()
    let repl = substitute(expand("<sfile>"), '..LogFunc', "():", "g")
    echohl MoreMsg | echo repl | echohl None
endf

"! means "Override"
"A function name must start with an uppercase letter
func! ReturnVal()
    call LogFunc()
    return 3
endf

call ReturnVal() " no return value

let ret = ReturnVal()
echo ret

"Function arguments
func! Argument(arg1)
    call LogFunc()
    echo a:arg1
endf

call Argument('test')

":h a:0 Function argc, argv, variable number of arguments
func! VariableArgument1(...)
    call LogFunc()
    echo "argv: " a:000
    echo "argc: " a:0
    echo "argv[0]: " a:1 "==" a:000[0] "==" a:{1}
endf

call VariableArgument1('ok', 'a01')

func! VariableArgument2(start, ...)
    call LogFunc()
    echohl Title
    echo "start is " . a:start
    echohl None
    let index = 1
    while index <= a:0
        echo "  Arg " . index . " is " . a:{index}
        let index = index + 1
    endwhile
    echo ""
endf

call VariableArgument2('hi', 'abc', 123)

func! Average(...)
    call LogFunc()
    let sum = 0.0

    for nextval in a:000        "a:000 is the list of arguments
        let sum += nextval
    endfor

    return sum / a:0            "a:0 is the number of arguments
endf

echo Average(1,2,3,4,5)

"測試傳遞參數為dictionary
func! DictionaryParameter(d)
    call LogFunc()
    echo "name: ". a:d.name
    echo "description: ". a:d.desc
endf

call DictionaryParameter({'name': 'hello', 'desc' : 'test dictionary'})

func! ListParameter(l)
    call LogFunc()
    echo "name: ". a:l[0]
    echo "description: ". a:l[1]
endf

call ListParameter(['hello', 'test dictionary'])

func! ContinuingLinesDictionaryParameter(d)
    call LogFunc()
    echo "name: ". a:d.name
    echo "description: ". a:d.desc
endf

call ContinuingLinesDictionaryParameter({
            \ 'name': 'hello', 
            \ 'desc' : 'test dictionary'})


func! ContinuingLinesListParameter(l)
    call LogFunc()
    echo "name: ". a:l[0]
    echo "description: ". a:l[1]
endf

call ContinuingLinesListParameter([
            \'hello', 
            \'test dictionary'])

"Using a range
func! RangeCountWords() range
    call LogFunc()
    let lnum = a:firstline
    let n = 0
    while lnum <= a:lastline
        let n = n + len(split(getline(lnum)))
        let lnum = lnum + 1
    endwhile
    echo "found " . n . " words"
endf

10,30call RangeCountWords()

func!  RangeLine()
    call LogFunc()
    echo "line " . line(".") . " contains: " . getline(".")
endf

"The function will be called two times.
110,111call RangeLine()

"Script Scope
func! s:Foo() 
endf 

"Global Scope
func! g:Foo() 
endf 

"Buffer Scope
func! b:Foo() 
endf 


"substitute/\a/*/g
" 上面等同於下面的code
"let line = getline(".")
"let repl = substitute(line, '\a', "*", "g")
"call setline(".", repl)


"del function
delfunc VariableArgument2
try
    call VariableArgument2('hi', 'abc', 123)
catch
    echohl WarningMsg | echo "Can't find function, because it is deleted!" | echohl None
endtry


"function references (Java Reflection)
let result = 0		" or 1
func! FunctionReference1(arg1)
    call LogFunc()
    return 'Right! ' . a:arg1
endf
func! FunctionReference2(arg1)
    call LogFunc()
    return 'Wrong! ' . a:arg1
endf

if result == 1
    let Afunc = function('FunctionReference1')
else
    let Afunc = function('FunctionReference2')
endif

echo Afunc
echo call(Afunc, ["hello function reference"])

" script_name#function_name
func! function#func_call()
    call LogFunc()
endf

call function#func_call()
